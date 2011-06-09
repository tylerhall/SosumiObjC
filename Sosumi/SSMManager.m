//
//  SSMManager.m
//  Sosumi
//
//  Created by Tyler Hall on 12/9/10.
//  Copyright 2010 Click On Tyler, LLC. All rights reserved.
//

#import "SSMManager.h"
#import "SSMAccount.h"
#import "SSMDevice.h"
#import "GTMHTTPFetcher.h"
#import "NSData+Base64.h"
#import "JSON.h"

@implementation SSMManager

@synthesize delegate=delegate_;
@synthesize accounts=accounts_;

- (id)init {
	self = [super init];
	self.accounts = [NSMutableArray array];
	return self;
}

- (void)dealloc {
	[accounts_ release];
	[delegate_ release];
	[super dealloc];
}

+ (SSMManager *)sosumiWithDelegate:(id)delegate {
	SSMManager *ssm = [[[SSMManager alloc] init] autorelease];
	ssm.delegate = delegate;
	return ssm;
}

- (void)addAccountWithUsername:(NSString *)username password:(NSString *)password {
	SSMAccount *acct = [[[SSMAccount alloc] init] autorelease];
	acct.username = username;
	acct.password = password;
	[self.accounts addObject:acct];
	[self getAccountPartition:acct];
}

- (BOOL)removeAccountWithUsername:(NSString *)username {
	for(NSUInteger i = 0; i < [self.accounts count]; i++) {
		SSMAccount *acct = [self.accounts objectAtIndex:i];
		if([acct.username isEqualToString:username]) {
			[self.accounts removeObjectAtIndex:i];
			return YES;
		}
	}
	
	return NO;
}

#pragma mark -
#pragma mark FMIP API Methods
#pragma mark -

- (void)getAccountPartition:(SSMAccount *)acct {
	NSString *urlStr = [NSString stringWithFormat:@"https://fmipmobile.icloud.com/fmipservice/device/%@/initClient", acct.username];
	NSURL *url = [NSURL URLWithString:urlStr];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	GTMHTTPFetcher *fetcher = [self getPreparedFMIPRequest:request forAccount:acct];

	NSMutableDictionary *postDict = [[[NSMutableDictionary alloc] init] autorelease];
	NSDictionary *clientContext = [NSDictionary dictionaryWithObjectsAndKeys:@"FindMyiPhone", @"appName",
								   @"1.2", @"appVersion",
								   @"145", @"buildVersion",
								   @"0000000000000000000000000000000000000000", @"deviceUDID",
								   @"109541", @"inactiveTime",
								   @"4.2.1", @"osVersion",
								   [NSNumber numberWithInt:0], @"personID",
								   @"iPhone3,1", @"productType", nil];
	[postDict setValue:clientContext forKey:@"clientContext"];
	NSString *postStr = [postDict JSONRepresentation];
	[fetcher setPostData:[postStr dataUsingEncoding:NSUTF8StringEncoding]];

	[fetcher beginFetchWithCompletionHandler:^(NSData *retrievedData, NSError *error) {
		if([[fetcher responseHeaders] valueForKey:@"X-Apple-MMe-Host"]) {
			acct.partition = [[fetcher responseHeaders] valueForKey:@"X-Apple-MMe-Host"];
			NSLog(@"got partition = %@", acct.partition);
			[self initClient:acct];
		} else {
			NSLog(@"SSMError: getPartition");
			if([self.delegate respondsToSelector:@selector(sosumiDidFail:)]) {
				[self.delegate performSelector:@selector(sosumiDidFail:) withObject:acct];
			}
		}
	}];
}

- (void)initClient:(SSMAccount *)acct {
	NSString *urlStr = [NSString stringWithFormat:@"https://%@/fmipservice/device/%@/initClient", acct.partition, acct.username];
	NSURL *url = [NSURL URLWithString:urlStr];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	GTMHTTPFetcher *fetcher = [self getPreparedFMIPRequest:request forAccount:acct];

	NSMutableDictionary *postDict = [[[NSMutableDictionary alloc] init] autorelease];
	NSDictionary *clientContext = [NSDictionary dictionaryWithObjectsAndKeys:@"FindMyiPhone", @"appName",
								   @"1.2", @"appVersion",
								   @"145", @"buildVersion",
								   @"0000000000000000000000000000000000000000", @"deviceUDID",
								   @"109541", @"inactiveTime",
								   @"4.2.1", @"osVersion",
								   [NSNumber numberWithInt:0], @"personID",
								   @"iPhone3,1", @"productType", nil];
	[postDict setValue:clientContext forKey:@"clientContext"];
	NSString *postStr = [postDict JSONRepresentation];
	[fetcher setPostData:[postStr dataUsingEncoding:NSUTF8StringEncoding]];

	[fetcher beginFetchWithCompletionHandler:^(NSData *retrievedData, NSError *error) {
		if(error != nil) {
			NSLog(@"SSMError: initClient");
			if([self.delegate respondsToSelector:@selector(sosumiDidFail:)]) {
				[self.delegate performSelector:@selector(sosumiDidFail:) withObject:acct];
			}			
		} else {
			NSString *response = [[[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding] autorelease];
			NSDictionary *json = [response JSONValue];
			acct.serverContext = [json valueForKey:@"serverContext"];
			for(NSDictionary *dict in [json valueForKey:@"content"]) {
				SSMDevice *device = [SSMDevice deviceWithDictionary:dict];
				[acct.devices setValue:device forKey:device.id];
			}
			if([self.delegate respondsToSelector:@selector(sosumiGotDevices:)]) {
				[self.delegate performSelector:@selector(sosumiGotDevices:) withObject:acct];
			}
			acct.refreshTimer = [NSTimer timerWithTimeInterval:10.0 target:self selector:@selector(refreshTimer:) userInfo:acct repeats:NO];
			[[NSRunLoop mainRunLoop] addTimer:acct.refreshTimer forMode:NSDefaultRunLoopMode];
		}
	}];
}

- (void)refreshTimer:(NSTimer*)theTimer {
	[self refreshClient:[theTimer userInfo]];
}

- (void)refreshClient:(SSMAccount *)acct {
	NSString *urlStr = [NSString stringWithFormat:@"https://%@/fmipservice/device/%@/initClient", acct.partition, acct.username];
	NSURL *url = [NSURL URLWithString:urlStr];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	GTMHTTPFetcher *fetcher = [self getPreparedFMIPRequest:request forAccount:acct];
	
	NSMutableDictionary *postDict = [[[NSMutableDictionary alloc] init] autorelease];
	NSDictionary *clientContext = [NSDictionary dictionaryWithObjectsAndKeys:@"FindMyiPhone", @"appName",
								   @"1.2", @"appVersion",
								   @"145", @"buildVersion",
								   @"0000000000000000000000000000000000000000", @"deviceUDID",
								   @"109541", @"inactiveTime",
								   @"4.2.1", @"osVersion",
								   [NSNumber numberWithInt:0], @"personID",
								   @"iPhone3,1", @"productType", nil];
	[postDict setValue:clientContext forKey:@"clientContext"];
	[postDict setValue:acct.serverContext forKey:@"serverContext"];
	NSString *postStr = [postDict JSONRepresentation];
	[fetcher setPostData:[postStr dataUsingEncoding:NSUTF8StringEncoding]];

	[fetcher beginFetchWithCompletionHandler:^(NSData *retrievedData, NSError *error) {
		if(error != nil) {
			NSLog(@"SSMError: refreshClient");
			if([self.delegate respondsToSelector:@selector(sosumiDidFail:)]) {
				[self.delegate performSelector:@selector(sosumiDidFail:) withObject:acct];
			}
		} else {
			NSString *response = [[[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding] autorelease];
			NSDictionary *json = [response JSONValue];
			acct.serverContext = [json valueForKey:@"serverContext"];

			double refreshInterval = [[acct.serverContext valueForKey:@"callbackIntervalInMS"] doubleValue] / 1000.0;
			acct.refreshTimer = [NSTimer timerWithTimeInterval:refreshInterval target:self selector:@selector(refreshTimer:) userInfo:acct repeats:NO];
			[[NSRunLoop mainRunLoop] addTimer:acct.refreshTimer forMode:NSDefaultRunLoopMode];
			
			for(NSDictionary *dict in [json valueForKey:@"content"]) {
				SSMDevice *device = [acct.devices objectForKey:[dict valueForKey:@"id"]];
				if(device) {
					[device updateWithDictionary:dict];
				} else {
					device = [SSMDevice deviceWithDictionary:dict];
					[acct.devices setValue:device forKey:device.id];
				}
			}
			if([self.delegate respondsToSelector:@selector(sosumiUpdatedDevices:)]) {
				[self.delegate performSelector:@selector(sosumiUpdatedDevices:) withObject:acct];
			}
		}
	}];
}

- (void)sendMessage:(NSString *)message withSubject:(NSString *)subject andAlarm:(BOOL)alarm toDeviceId:(NSString *)deviceId {
	
	SSMAccount *acct = [self accountWithDeviceId:deviceId];
	if(acct == nil) {
		return;
	}
	SSMDevice *device = [acct.devices objectForKey:deviceId];

	NSString *urlStr = [NSString stringWithFormat:@"https://%@/fmipservice/device/%@/sendMessage", acct.partition, acct.username];
	NSURL *url = [NSURL URLWithString:urlStr];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	GTMHTTPFetcher *fetcher = [self getPreparedFMIPRequest:request forAccount:acct];
	
	NSMutableDictionary *postDict = [[[NSMutableDictionary alloc] init] autorelease];
	NSDictionary *clientContext = [NSDictionary dictionaryWithObjectsAndKeys:@"FindMyiPhone", @"appName",
								   @"1.2", @"appVersion",
								   @"145", @"buildVersion",
								   @"0000000000000000000000000000000000000000", @"deviceUDID",
								   @"109541", @"inactiveTime",
								   @"4.2.1", @"osVersion",
								   [NSNumber numberWithInt:0], @"personID",
								   @"iPhone3,1", @"productType", nil];
	[postDict setValue:clientContext forKey:@"clientContext"];
	[postDict setValue:acct.serverContext forKey:@"serverContext"];
	[postDict setValue:device.id forKey:@"device"];
	[postDict setValue:[NSNumber numberWithBool:alarm] forKey:@"sound"];
	[postDict setValue:message forKey:@"text"];
	[postDict setValue:subject forKey:@"subject"];
	
	NSString *postStr = [postDict JSONRepresentation];
	[fetcher setPostData:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
	
	[fetcher beginFetchWithCompletionHandler:^(NSData *retrievedData, NSError *error) {
		if(error != nil) {
			NSLog(@"SSMError: sendMessage");
			if([self.delegate respondsToSelector:@selector(sosumiDidFail:)]) {
				[self.delegate performSelector:@selector(sosumiDidFail:) withObject:acct];
			}			
		} else {
			if([self.delegate respondsToSelector:@selector(sosumiDidSendMessageToDeviceId:)]) {
				[self.delegate performSelector:@selector(sosumiDidSendMessageToDeviceId:) withObject:deviceId];
			}			
		}
	}];
}

- (void)remoteLockDevice:(NSString *)deviceId withPasscode:(NSString *)passcode {
	SSMAccount *acct = [self accountWithDeviceId:deviceId];
	if(acct == nil) {
		return;
	}
	SSMDevice *device = [acct.devices objectForKey:deviceId];
	
	NSString *urlStr = [NSString stringWithFormat:@"https://%@/fmipservice/device/%@/remoteLock", acct.partition, acct.username];
	NSURL *url = [NSURL URLWithString:urlStr];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	GTMHTTPFetcher *fetcher = [self getPreparedFMIPRequest:request forAccount:acct];
	
	NSMutableDictionary *postDict = [[[NSMutableDictionary alloc] init] autorelease];
	NSDictionary *clientContext = [NSDictionary dictionaryWithObjectsAndKeys:@"FindMyiPhone", @"appName",
								   @"1.2", @"appVersion",
								   @"145", @"buildVersion",
								   @"0000000000000000000000000000000000000000", @"deviceUDID",
								   @"109541", @"inactiveTime",
								   @"4.2.1", @"osVersion",
								   [NSNumber numberWithInt:0], @"personID",
								   @"iPhone3,1", @"productType", nil];
	[postDict setValue:clientContext forKey:@"clientContext"];
	[postDict setValue:acct.serverContext forKey:@"serverContext"];
	[postDict setValue:device.id forKey:@"device"];
	[postDict setValue:@"" forKey:@"oldPasscode"];
	[postDict setValue:passcode forKey:@"passcode"];
	
	NSString *postStr = [postDict JSONRepresentation];
	[fetcher setPostData:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
	
	[fetcher beginFetchWithCompletionHandler:^(NSData *retrievedData, NSError *error) {
		if(error != nil) {
			NSLog(@"SSMError: remoteLock");
			if([self.delegate respondsToSelector:@selector(sosumiDidFail:)]) {
				[self.delegate performSelector:@selector(sosumiDidFail:) withObject:acct];
			}			
		} else {
			if([self.delegate respondsToSelector:@selector(sosumiDidSendRemoteLockDeviceId:)]) {
				[self.delegate performSelector:@selector(sosumiDidSendRemoteLockDeviceId:) withObject:deviceId];
			}			
		}		
	}];
}

#pragma mark -
#pragma mark Misc Helpers
#pragma mark -

- (GTMHTTPFetcher *)getPreparedFMIPRequest:(NSMutableURLRequest *)request forAccount:(SSMAccount *)acct {
	[request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"2.0" forHTTPHeaderField:@"X-Apple-Find-Api-Ver"];
	[request addValue:@"UserIdGuest" forHTTPHeaderField:@"X-Apple-Authscheme"];
	[request addValue:@"1.0" forHTTPHeaderField:@"X-Apple-Realm-Support"];
	[request addValue:@"Find iPhone/1.2 MeKit (iPad: iPhone OS/4.2.1)" forHTTPHeaderField:@"User-agent"];
	[request addValue:@"iPad" forHTTPHeaderField:@"X-Client-Name"];
	[request addValue:@"5b9f404f56b585cf58d2bf178f6068cb4b930000" forHTTPHeaderField:@"X-Client-UUID"];
	[request addValue:@"en-us" forHTTPHeaderField:@"Accept-Language"];
	
	NSData *credentials64 = [[NSString stringWithFormat:@"%@:%@", acct.username, acct.password] dataUsingEncoding:NSASCIIStringEncoding];
	[request addValue:[NSString stringWithFormat:@"Basic %@", [credentials64 base64EncodedString]] forHTTPHeaderField:@"Authorization"];
	
	return [GTMHTTPFetcher fetcherWithRequest:request];
}

- (SSMAccount *)accountWithDeviceId:(NSString *)deviceId {
	SSMAccount *acct;
	SSMDevice *device;
	for(NSUInteger i = 0; i < [self.accounts count]; i++) {
		acct = [self.accounts objectAtIndex:i];
		device = [acct.devices objectForKey:deviceId];
		if(device != nil) {
			return acct;
		}
		device = nil;
	}

	return nil;
}

@end
