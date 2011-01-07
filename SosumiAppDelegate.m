//
//  SosumiAppDelegate.m
//  Sosumi
//
//  Created by Tyler Hall on 12/9/10.
//  Copyright 2010 Click On Tyler, LLC. All rights reserved.
//

#import "SosumiAppDelegate.h"

@implementation SosumiAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	ssm = [SSMManager sosumiWithDelegate:self];
	[ssm addAccountWithUsername:@"username@me.com" password:@"secret"];
}

- (void)sosumiDidFail:(SSMAccount *)account {
	
}

- (void)sosumiGotDevices:(SSMAccount *)account {
	
}

- (void)sosumiUpdatedDevices:(SSMAccount *)account {
	
}

- (void)sosumiDidSendMessageToDeviceId:(NSString *)deviceId {
	
}

- (void)sosumiDidSendRemoteLockToDeviceId:(NSString *)deviceId {
	
}

@end
