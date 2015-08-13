//
//  MMXConnectionOperation.m
//  MMX
//
//  Created by Jason Ferguson on 8/13/15.
//  Copyright (c) 2015 Magnet Systems, Inc. All rights reserved.
//

#import "MMXConnectionOperation.h"
#import "MagnetDelegate.h"

@implementation MMXConnectionOperation


- (void)execute {
	[[MagnetDelegate sharedDelegate] connectWithSuccess:^{
		if (self.connectSuccessBlock) {
			self.connectSuccessBlock();
		}
		[self finish];
	} failure:^(NSError *error) {
		if (self.connectFailureBlock) {
			self.connectFailureBlock(error);
		}
		[self finish];
	}];
}

@end
