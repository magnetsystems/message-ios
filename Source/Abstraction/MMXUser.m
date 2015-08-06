//
//  MMXUser.m
//  QuickStart
//
//  Created by Jason Ferguson on 8/5/15.
//  Copyright (c) 2015 Magnet Systems, Inc. All rights reserved.
//

#import "MMXUser.h"
#import "MagnetDelegate.h"
#import <MMX.h>

@implementation MMXUser

- (void)registerWithCredentials:(NSURLCredential *)credential
						success:(void (^)(void))success
						failure:(void (^)(NSError *))failure {
	[[MMXClient sharedClient].accountManager createAccountForUsername:self.username displayName:self.displayName email:self.email password:credential.password success:^(MMXUserProfile *userProfile) {
		if (success) {
			success();
		}
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
}

+ (void)logInWithCredentials:(NSURLCredential *)credential
					 success:(void (^)(MMXUser *))success
					 failure:(void (^)(NSError *))failure {
	[[MagnetDelegate sharedDelegate] logInWithCredential:credential success:^(MMXUser *user) {
		if (success) {
			success(user);
		}
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
}

+ (void)logOutWithSuccess:(void (^)(void))success
				  failure:(void (^)(NSError *))failure {
	if ([MMXClient sharedClient].connectionStatus != MMXConnectionStatusAuthenticated) {
		if (success) {
			success();
		}
	} else {
		[[MagnetDelegate sharedDelegate] logOutWithSuccess:^{
			if (success) {
				success();
			}
		} failure:^(NSError *error) {
			if (failure) {
				failure(error);
			}
		}];
	}
}

- (void)changePasswordWithCredentials:(NSURLCredential *)credential
							  success:(void (^)(void))success
							  failure:(void (^)(NSError *))failure {
	//FIXME: This is not correct. Must be logged in, etc. Think through the cases.
	[[MMXClient sharedClient].accountManager updatePassword:credential.password success:^(BOOL successful) {
		if (success) {
			success();
		}
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
}

@end
