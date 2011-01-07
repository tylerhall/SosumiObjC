//
//  SSMDevice.h
//  Sosumi
//
//  Created by Tyler Hall on 1/6/11.
//  Copyright 2011 Click On Tyler, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SSMDevice : NSObject {
	NSString *id_;
	BOOL isCharging_;
	float batteryLevel_;
	NSString *deviceClass_;
	NSString *deviceDisplayName_;
	NSString *deviceModel_;
	NSUInteger deviceStatus_;
	BOOL isLocating_;
	BOOL locationEnabled_;
	NSString *name_;
	float horizontalAccuracy_;
	BOOL locationIsOld_;
	double latitude_;
	double longitude_;
	BOOL locationFinished_;
	NSString *positionType_;
	NSDate *locationTimestamp_;
}

@property (nonatomic, retain) NSString *id;
@property (assign) BOOL isCharging;
@property (assign) float batteryLevel;
@property (nonatomic, retain) NSString *deviceClass;
@property (nonatomic, retain) NSString *deviceDisplayName;
@property (nonatomic, retain) NSString *deviceModel;
@property (assign) NSUInteger deviceStatus;
@property (assign) BOOL isLocating;
@property (assign) BOOL locationEnabled;
@property (nonatomic, retain) NSString *name;
@property (assign) float horizontalAccuracy;
@property (assign) BOOL locationIsOld;
@property (assign) double latitude;
@property (assign) double longitude;
@property (assign) BOOL locationFinished;
@property (nonatomic, retain) NSString *positionType;
@property (nonatomic, retain) NSDate *locationTimestamp;

+ (SSMDevice *)deviceWithDictionary:(NSDictionary *)dict;
- (void)updateWithDictionary:(NSDictionary *)dict;

@end
