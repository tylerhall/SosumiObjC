//
//  SSMAccount.m
//  Sosumi
//
//  Created by Tyler Hall on 12/9/10.
//  Copyright 2010 Click On Tyler, LLC. All rights reserved.
//

#import "SSMAccount.h"


@implementation SSMAccount

@synthesize username=username_;
@synthesize password=password_;
@synthesize partition=partition_;
@synthesize devices=devices_;
@synthesize serverContext=serverContext_;
@synthesize refreshTimer=refreshTimer_;

- (id)init {
	self = [super init];
	self.devices = [[NSMutableDictionary alloc] init];
	return self;
}

- (void)dealloc {
	[username_ release];
	[password_ release];
	[partition_ release];
	[devices_ release];
	[serverContext_ release];
	[refreshTimer_ release];
	[super dealloc];
}

@end
