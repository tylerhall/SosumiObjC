//
//  SSMSosumi.h
//  Sosumi
//
//  Created by Tyler Hall on 1/6/11.
//  Copyright 2011 Click On Tyler, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSMManager.h"
#import "SSMAccount.h"

@protocol Sosumi

- (void)sosumiDidFail:(SSMAccount *)account;
- (void)sosumiGotDevices:(SSMAccount *)account;
- (void)sosumiUpdatedDevices:(SSMAccount *)account;
- (void)sosumiDidSendMessageToDeviceId:(NSString *)deviceId;
- (void)sosumiDidSendRemoteLockToDeviceId:(NSString *)deviceId;

@end