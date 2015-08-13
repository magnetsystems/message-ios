//
//  MMXLogInOperation.m
//  MMX
//
//  Created by Jason Ferguson on 8/13/15.
//  Copyright (c) 2015 Magnet Systems, Inc. All rights reserved.
//

#import "MMXLogInOperation.h"
#import "MagnetDelegate.h"

@implementation MMXLogInOperation

- (void)execute {
	[[MagnetDelegate sharedDelegate] privateLogInWithCredential:self.creds success:^(MMXUser *user) {
		if (self.logInSuccessBlock) {
			self.logInSuccessBlock(user);
		}
		[self finish];
	} failure:^(NSError *error) {
		if (self.logInFailureBlock) {
			self.logInFailureBlock(error);
		}
		[self finish];
	}];
}

@end
