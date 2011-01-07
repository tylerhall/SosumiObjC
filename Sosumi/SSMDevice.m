//
//  SSMDevice.m
//  Sosumi
//
//  Created by Tyler Hall on 1/6/11.
//  Copyright 2011 Click On Tyler, LLC. All rights reserved.
//

#import "SSMDevice.h"

@implementation SSMDevice

@synthesize id=id_;
@synthesize isCharging=isCharging_;
@synthesize batteryLevel=batteryLevel_;
@synthesize deviceClass=deviceClass_;
@synthesize deviceDisplayName=deviceDisplayName_;
@synthesize deviceModel=deviceModel_;
@synthesize deviceStatus=deviceStatus_;
@synthesize isLocating=isLocating_;
@synthesize locationEnabled=locationEnabled_;
@synthesize name=name_;
@synthesize horizontalAccuracy=horizontalAccuracy_;
@synthesize locationIsOld=locationIsOld_;
@synthesize latitude=latitude_;
@synthesize longitude=longitude_;
@synthesize locationFinished=locationFinished_;
@synthesize positionType=positionType_;
@synthesize locationTimestamp=locationTimestamp_;

- (void)dealloc {
	[id_ release];
	[deviceClass_ release];
	[deviceDisplayName_ release];
	[deviceModel_ release];
	[name_ release];
	[positionType_ release];
	[locationTimestamp_ release];
	[super dealloc];
}

+ (SSMDevice *)deviceWithDictionary:(NSDictionary *)dict {
	SSMDevice *device = [[[SSMDevice alloc] init] autorelease];
	NSLog(@"creating device");
	device.id = [dict valueForKey:@"id"];
	device.isCharging = [(NSString *)[dict valueForKey:@"a"] isEqualToString:@"NotCharging"] ? NO : YES;
	device.batteryLevel = [[dict valueForKey:@"b"] floatValue];
	device.deviceClass = [dict valueForKey:@"deviceClass"];
	device.deviceDisplayName = [dict valueForKey:@"deviceDisplayName"];
	device.deviceModel = [dict valueForKey:@"deviceModel"];
	device.deviceStatus = [[dict valueForKey:@"deviceStatus"] intValue];
	device.isLocating = ([[dict valueForKey:@"isLocating"] intValue] == 1) ? YES : NO;
	device.locationEnabled = ([[dict valueForKey:@"locationEnabled"] intValue] == 1) ? YES : NO;
	device.name = [dict valueForKey:@"name"];
	device.horizontalAccuracy = [[dict valueForKeyPath:@"location.horizontalAccuracy"] floatValue];
	device.locationIsOld = ([[dict valueForKeyPath:@"location.isOld"] intValue] == 1) ? YES : NO;
	device.latitude = [[dict valueForKeyPath:@"location.latitude"] doubleValue];
	device.longitude = [[dict valueForKeyPath:@"location.longitude"] doubleValue];
	device.locationFinished = ([[dict valueForKeyPath:@"location.locationFinished"] intValue] == 1) ? YES : NO;
	device.positionType = [dict valueForKeyPath:@"location.positionType"];
	device.locationTimestamp = [NSDate dateWithTimeIntervalSince1970:[[dict valueForKeyPath:@"location.timeStamp"] doubleValue] / 100];

	NSLog(@"%@", device);
	
	return device;
}

- (void)updateWithDictionary:(NSDictionary *)dict {
	NSLog(@"updating device");
	self.isCharging = [(NSString *)[dict valueForKey:@"a"] isEqualToString:@"NotCharging"] ? NO : YES;
	self.batteryLevel = [[dict valueForKey:@"b"] floatValue];
	self.deviceClass = [dict valueForKey:@"deviceClass"];
	self.deviceDisplayName = [dict valueForKey:@"deviceDisplayName"];
	self.deviceModel = [dict valueForKey:@"deviceModel"];
	self.deviceStatus = [[dict valueForKey:@"deviceStatus"] intValue];
	self.isLocating = ([[dict valueForKey:@"isLocating"] intValue] == 1) ? YES : NO;
	self.locationEnabled = ([[dict valueForKey:@"locationEnabled"] intValue] == 1) ? YES : NO;
	self.name = [dict valueForKey:@"name"];
	self.horizontalAccuracy = [[dict valueForKeyPath:@"location.horizontalAccuracy"] floatValue];
	self.locationIsOld = ([[dict valueForKeyPath:@"location.isOld"] intValue] == 1) ? YES : NO;
	self.latitude = [[dict valueForKeyPath:@"location.latitude"] doubleValue];
	self.longitude = [[dict valueForKeyPath:@"location.longitude"] doubleValue];
	self.locationFinished = ([[dict valueForKeyPath:@"location.locationFinished"] intValue] == 1) ? YES : NO;
	self.positionType = [dict valueForKeyPath:@"location.positionType"];
	self.locationTimestamp = [NSDate dateWithTimeIntervalSince1970:[[dict valueForKeyPath:@"location.timeStamp"] doubleValue] / 1000];	
}

- (NSString *)description {
	NSMutableString *str = [[[NSMutableString alloc] init] autorelease];
	[str appendFormat:@"self.id = %@\n", self.id];
	[str appendFormat:@"self.isCharging = %d\n", self.isCharging];
	[str appendFormat:@"self.batteryLevel = %f\n", self.batteryLevel];
	[str appendFormat:@"self.deviceClass = %@\n", self.deviceClass];
	[str appendFormat:@"self.deviceDisplayName = %@\n", self.deviceDisplayName];
	[str appendFormat:@"self.deviceModel = %@\n", self.deviceModel];
	[str appendFormat:@"self.deviceStatus = %d\n", self.deviceStatus];
	[str appendFormat:@"self.isLocating = %d\n", self.isLocating];
	[str appendFormat:@"self.locationEnabled = %d\n", self.locationEnabled];
	[str appendFormat:@"self.name = %@\n", self.name];
	[str appendFormat:@"self.horizontalAccuracy = %f\n", self.horizontalAccuracy];
	[str appendFormat:@"self.locationIsOld = %d\n", self.locationIsOld];
	[str appendFormat:@"self.latitude = %f\n", self.latitude];
	[str appendFormat:@"self.longitude = %f\n", self.longitude];
	[str appendFormat:@"self.locationFinished = %d\n", self.locationFinished];
	[str appendFormat:@"self.positionType = %@\n", self.positionType];
	[str appendFormat:@"self.locationTimestamp = %@\n", self.locationTimestamp];	
	return str;	
}

@end
