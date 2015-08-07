//
//  MagnetDelegate.m
//  QuickStart
//
//  Created by Jason Ferguson on 8/5/15.
//  Copyright (c) 2015 Magnet Systems, Inc. All rights reserved.
//

#import "MagnetDelegate.h"
#import "MMXMessage_Private.h"
#import "MagnetConstants.h"
#import "MMXUser.h"
#import "MMX.h"

@interface MagnetDelegate () <MMXClientDelegate>

//@property (nonatomic, strong) MMXClient *client;

@property (nonatomic, copy) void (^logInSuccessBlock)(MMXUser *);

@property (nonatomic, copy) void (^logInFailureBlock)(NSError *);

@property (nonatomic, copy) void (^logOutSuccessBlock)(void);

@property (nonatomic, copy) void (^logOutFailureBlock)(NSError *);

@property (nonatomic, copy) NSDictionary *messageBlockQueue;

@end

@implementation MagnetDelegate

+ (instancetype)sharedDelegate {
	
	static MagnetDelegate *_sharedClient = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedClient = [[MagnetDelegate alloc] init];
	});
	return _sharedClient;
}

- (void)startMMXClient {
	MMXConfiguration * config = [MMXConfiguration configurationWithName:@"default"];
	[MMXClient sharedClient].configuration = config;
	[MMXClient sharedClient].delegate = self;
	[[MMXClient sharedClient] connectAnonymous];
}

- (void)registerUser:(MMXUser *)user
		 credentials:(NSURLCredential *)credential
			 success:(void (^)(void))success
			 failure:(void (^)(NSError *))failure {
	[[MMXClient sharedClient].accountManager createAccountForUsername:user.username displayName:user.displayName email:user.email password:credential.password success:^(MMXUserProfile *userProfile) {
		if (success) {
			success();
		}
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
}

- (void)logInWithCredential:(NSURLCredential *)credential
					success:(void (^)(MMXUser *))success
					failure:(void (^)(NSError *error))failure {
	[MMXClient sharedClient].configuration.credential = credential;
	self.logInSuccessBlock = ^ (MMXUser *user) {
		success(user);
	};
	self.logInFailureBlock = failure;
	[[MMXClient sharedClient] connectWithCredentials];
	
}

- (void)logOutWithSuccess:(void (^)(void))success
				  failure:(void (^)(NSError *error))failure {
	self.logOutSuccessBlock = success;
	self.logOutFailureBlock = failure;
	[[MMXClient sharedClient] disconnect];
}

- (void)sendMessage:(MMXMessage *)message
			success:(void (^)(NSString *messageID))success
			failure:(void (^)(NSError *error))failure {
	//FIXME: Needs to properly handle failure and success blocks
	MMXOutboundMessage *msg = [MMXOutboundMessage messageTo:[message recipientsForOutboundMessage] withContent:nil metaData:message.messageContent];
	NSString *messageID = [[MMXClient sharedClient] sendMessage:msg];
	if (success) {
		success(messageID);
	}
	
}

#pragma mark - MMXClientDelegate Callbacks

- (void)client:(MMXClient *)client didReceiveConnectionStatusChange:(MMXConnectionStatus)connectionStatus error:(NSError *)error {
	switch (connectionStatus) {
		case MMXConnectionStatusAuthenticated: {
			if (self.logInSuccessBlock) {
				[[MMXClient sharedClient].accountManager userProfileWithSuccess:^(MMXUserProfile *userProfile) {
					MMXUser *user = [MMXUser new];
					user.username = userProfile.userID.username;
					user.displayName = userProfile.displayName;
					user.email = userProfile.email;
					self.logInSuccessBlock(user);
					self.logInSuccessBlock = nil;
					self.logInFailureBlock = nil;
				} failure:^(NSError *error) {
					self.logInSuccessBlock(nil);
					self.logInSuccessBlock = nil;
					self.logInFailureBlock = nil;
				}];
			}
			}
			break;
		case MMXConnectionStatusAuthenticationFailure: {
			if (self.logInFailureBlock) {
				self.logInFailureBlock(error);
			}
			self.logInSuccessBlock = nil;
			self.logInFailureBlock = nil;
			}
			break;
		case MMXConnectionStatusNotConnected: {
			}
			break;
		case MMXConnectionStatusConnected: {
			}
			break;
		case MMXConnectionStatusDisconnected: {
			if (self.logOutSuccessBlock) {
				self.logOutSuccessBlock();
			}
			self.logOutSuccessBlock = nil;
			self.logOutFailureBlock = nil;
		}
			break;
		case MMXConnectionStatusFailed: {
			}
			break;
		case MMXConnectionStatusReconnecting: {
			}
			break;
	}
}

- (void)client:(MMXClient *)client didReceiveMessage:(MMXInboundMessage *)message deliveryReceiptRequested:(BOOL)receiptRequested {
	//FIXME: remove the receiver/current user from the list of recipients.
	MMXMessage *msg = [MMXMessage messageTo:[NSSet setWithArray:message.recipients]
							 messageContent:message.metaData];
	MMXUser *user = [MMXUser new];
	user.username = message.senderUserID.username;
	msg.sender = user;
	msg.timestamp = message.timestamp;
	msg.messageID = message.messageID;
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReceivedMessage
														object:nil
													  userInfo:@{kMMXMessageKey:msg}];
}

- (void)client:(MMXClient *)client didReceivePubSubMessage:(MMXPubSubMessage *)message {
	MMXMessage *msg = [MMXMessage new];
	msg.topic = message.topic;
	msg.messageContent = message.metaData;
	msg.timestamp = message.timestamp;
	msg.messageID = message.messageID;
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReceivedPubSubMessage
														object:nil
													  userInfo:@{kMMXMessageKey:msg}];
}

@end
