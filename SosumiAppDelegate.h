//
//  SosumiAppDelegate.h
//  Sosumi
//
//  Created by Tyler Hall on 12/9/10.
//  Copyright 2010 Click On Tyler, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SSMSosumi.h"

@class SSMManager;

@interface SosumiAppDelegate : NSObject <NSApplicationDelegate, Sosumi> {
    NSWindow *window;
	SSMManager *ssm;
}

@property (assign) IBOutlet NSWindow *window;

@end
