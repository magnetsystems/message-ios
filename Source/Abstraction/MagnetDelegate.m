/*
 * Copyright (c) 2015 Magnet Systems, Inc.
 * All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you
 * may not use this file except in compliance with the License. You
 * may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import "MagnetDelegate.h"
#import "MMXNotificationConstants.h"
#import "MMXMessageTypes.h"
#import "MMXChannel_Private.h"
#import "MMXConfiguration.h"
#import "MMXAccountManager_Private.h"
#import "MMXConnectionOperation.h"
#import "MMXClient_Private.h"
#import "MMXAddressable.h"
#import "MMXInternalMessageAdaptor.h"
#import "MMXInboundMessage_Private.h"
#import "MMXPubSubMessage.h"
#import "MMXClient_Private.h"
#import "MMXUserID_Private.h"
#import "MMXEndpoint.h"
#import "MMXUserProfile.h"
#import "MMXTopic_Private.h"
#import "MMXOutboundMessage_Private.h"
#import "MMXMessage_Private.h"
@import MagnetMobileServer;

typedef void(^MessageSuccessBlock)(void);
typedef void(^MessageFailureBlock)(NSError *);

NSString  * const MMXMessageSuccessBlockKey = @"MMXMessageSuccessBlockKey";
NSString  * const MMXMessageFailureBlockKey = @"MMXMessageFailureBlockKey";

@interface MagnetDelegate () <MMXClientDelegate>

@property (nonatomic, copy) void (^connectSuccessBlock)(void);

@property (nonatomic, copy) void (^connectFailureBlock)(NSError *);

@property (nonatomic, copy) void (^logInSuccessBlock)(MMUser *);

@property (nonatomic, copy) void (^logInFailureBlock)(NSError *);

@property (nonatomic, copy) void (^logOutSuccessBlock)(void);

@property (nonatomic, copy) void (^logOutFailureBlock)(NSError *);

@property (nonatomic, strong) NSMutableDictionary *messageBlockQueue;

@property(nonatomic, strong) NSOperationQueue *internalQueue;

@property (nonatomic, readwrite) NSError * __nullable (^ __nullable configurationHandler)(NSDictionary * __nonnull);
@property (nonatomic, readwrite) NSError * __nullable (^ __nullable appTokenHandler)(NSString * __nonnull, NSString * __nonnull, NSString * __nonnull);
@property (nonatomic, readwrite) NSError * __nullable (^ __nullable userTokenHandler)(NSString * __nonnull, NSString * __nonnull, NSString * __nonnull);

@end

@implementation MagnetDelegate

+ (instancetype)sharedDelegate {
	
	static MagnetDelegate *_sharedClient = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedClient = [[MagnetDelegate alloc] init];
		_sharedClient.messageBlockQueue = [NSMutableDictionary dictionary];
		_sharedClient.configurationHandler = ^ NSError *(NSDictionary * config) {
			[[MMXClient sharedClient] updateConfiguration:config];
			return nil;
		};
		_sharedClient.appTokenHandler = ^ NSError *(NSString *appID, NSString *deviceID, NSString *appToken) {
			[[MMXClient sharedClient] updateAppID:appID deviceID:deviceID appToken:appToken];
			return nil;
		};
		_sharedClient.userTokenHandler = ^ NSError *(NSString *username, NSString *deviceID, NSString *userToken) {
			[[MMXClient sharedClient] updateUsername:username deviceID:deviceID userToken:userToken];
			[[MMXClient sharedClient] connect];
			return nil;
		};
		[MMXClient sharedClient].delegate = _sharedClient;
	});
	return _sharedClient;
}

- (void)startMMXClientWithConfiguration:(NSString *)name {
	if ([MMXClient sharedClient].connectionStatus != MMXConnectionStatusAuthenticated &&
		[MMXClient sharedClient].connectionStatus != MMXConnectionStatusConnected) {
		[MMXClient sharedClient].shouldSuspendIncomingMessages = YES;
		MMXConfiguration * config = [MMXConfiguration configurationWithName:name];
		[MMXClient sharedClient].configuration = config;
		[MMXClient sharedClient].delegate = self;
	}
}

- (void)connect {
	MMXConnectionOperation *op = [MMXConnectionOperation new];
	[self.internalQueue addOperation:op];
}

- (void)connectWithSuccess:(void (^)(void))success
				   failure:(void (^)(NSError *error))failure {
	
	self.connectSuccessBlock = success;
	self.connectFailureBlock = failure;
	[[MMXClient sharedClient] connectAnonymous];
	
}


//- (void)logInWithCredential:(NSURLCredential *)credential
//					success:(void (^)(MMUser *))success
//					failure:(void (^)(NSError *error))failure {
//
//	MMXLogInOperation *op = [MMXLogInOperation new];
//	op.creds = credential.copy;
//	op.logInSuccessBlock = success;
//	op.logInFailureBlock = failure;
//	[self.internalQueue addOperation:op];
//
//}
//
//- (void)privateLogInWithCredential:(NSURLCredential *)credential
//						   success:(void (^)(MMUser *))success
//						   failure:(void (^)(NSError *error))failure {
//	
//	[MMXClient sharedClient].configuration.credential = credential;
//	self.logInSuccessBlock = success;
//	self.logInFailureBlock = failure;
//	[[MMXClient sharedClient] connectWithCredentials];
//}


//- (void)logOutWithSuccess:(void (^)(void))success
//				  failure:(void (^)(NSError *error))failure {
//	self.logOutSuccessBlock = success;
//	self.logOutFailureBlock = failure;
//	[[MMXClient sharedClient] disconnect];
//}

- (NSString *)sendMessage:(MMXMessage *)message
				  success:(void (^)(void))success
				  failure:(void (^)(NSError *error))failure {
	//FIXME: Needs to properly handle failure and success blocks
	MMXOutboundMessage *msg = [MMXOutboundMessage messageTo:[message.recipients allObjects] withContent:nil metaData:message.messageContent];
	msg.messageID = message.messageID;
	
	if (success || failure) {
		NSMutableDictionary *blockDict = [NSMutableDictionary dictionary];
		if (success) {
			[blockDict setObject:success forKey:MMXMessageSuccessBlockKey];
		}
		if (failure) {
			[blockDict setObject:failure forKey:MMXMessageFailureBlockKey];
		}
		[self.messageBlockQueue setObject:blockDict forKey:msg.messageID];
	}
	
	NSString *messageID = [[MMXClient sharedClient] sendMessage:msg];

	return messageID;
}

- (NSString *)sendInternalMessageFormat:(MMXInternalMessageAdaptor *)message
								success:(void (^)(void))success
								failure:(void (^)(NSError *error))failure {

	NSString *messageID = [[MMXClient sharedClient] sendMMXMessage:message withOptions:nil shouldValidate:NO];
	if (messageID) {
		if (success || failure) {
			NSMutableDictionary *blockDict = [NSMutableDictionary dictionary];
			if (success) {
				[blockDict setObject:success forKey:MMXMessageSuccessBlockKey];
			}
			if (failure) {
				[blockDict setObject:failure forKey:MMXMessageFailureBlockKey];
			}
			[self.messageBlockQueue setObject:blockDict forKey:messageID];
		}
	}
	return messageID;
}

#pragma mark - MMXClientDelegate Callbacks

- (void)client:(MMXClient *)client didReceiveConnectionStatusChange:(MMXConnectionStatus)connectionStatus error:(NSError *)error {
	switch (connectionStatus) {
		case MMXConnectionStatusAuthenticated: {
			[[MMXClient sharedClient].accountManager userProfileWithSuccess:^(MMXUserProfile *userProfile) {
				[MMXClient sharedClient].currentProfile = userProfile;
				MMUser *user = [MMUser new];
				user.userName = userProfile.userID.username;
				if (self.logInSuccessBlock) {
					self.logInSuccessBlock(user);
					self.logInSuccessBlock = nil;
					self.logInFailureBlock = nil;
				}
			} failure:^(NSError *error) {
				if (self.logInSuccessBlock) {
					self.logInSuccessBlock(nil);
					self.logInSuccessBlock = nil;
					self.logInFailureBlock = nil;
				}
			}];
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
			if (self.connectSuccessBlock) {
				self.connectSuccessBlock();
			}
			self.connectSuccessBlock = nil;
			self.connectFailureBlock = nil;
			}
			break;
		case MMXConnectionStatusDisconnected: {
			if (self.logOutSuccessBlock) {
				self.logOutSuccessBlock();
			}
			if (self.connectFailureBlock) {
				self.connectFailureBlock(error);
			}
			self.connectSuccessBlock = nil;
			self.connectFailureBlock = nil;
			self.logOutSuccessBlock = nil;
			self.logOutFailureBlock = nil;
			if (error) {
				[[NSNotificationCenter defaultCenter] postNotificationName:MMXDidDisconnectNotification object:nil userInfo:@{MMXDisconnectErrorKey:error}];
			}
			}
			break;
		case MMXConnectionStatusFailed: {
			if (self.connectFailureBlock) {
				self.connectFailureBlock(error);
			}
			if (self.logInFailureBlock) {
				self.logInFailureBlock(error);
			}
			self.connectSuccessBlock = nil;
			self.connectFailureBlock = nil;
			self.logInSuccessBlock = nil;
			self.logInFailureBlock = nil;

			}
			break;
		case MMXConnectionStatusReconnecting: {
		}
			break;
		case MMXConnectionStatusAnonReady: {
		}
			break;
		case MMXConnectionStatusUserReady: {
		}
			break;
	}
}



- (void)client:(MMXClient *)client didReceiveMessage:(MMXInboundMessage *)message deliveryReceiptRequested:(BOOL)receiptRequested {

	NSMutableArray *recipients = [NSMutableArray arrayWithArray:message.otherRecipients ?: @[]];
	if (message.targetUserID) {
		[recipients addObject:message.targetUserID];
	}
	MMXMessage *msg = [MMXMessage messageToRecipients:[self usersFromInboundRecipients:recipients.copy]
									   messageContent:message.metaData];

	msg.messageType = MMXMessageTypeDefault;
	MMUser *user = [MMUser new];
	user.userName = message.senderUserID.username;
	msg.sender = user;
	msg.timestamp = message.timestamp;
	msg.messageID = message.messageID;
	msg.senderDeviceID = message.senderEndpoint.deviceID;
	[[NSNotificationCenter defaultCenter] postNotificationName:MMXDidReceiveMessageNotification
														object:nil
													  userInfo:@{MMXMessageKey:msg}];
}

- (void)client:(MMXClient *)client didReceivePubSubMessage:(MMXPubSubMessage *)message {
	MMXMessage *msg = [MMXMessage new];
	msg.messageType = MMXMessageTypeChannel;
	MMXChannel *channel = [MMXChannel channelWithName:message.topic.topicName summary:nil isPublic:YES];
	if (message.topic.inUserNameSpace) {
		channel.isPublic = NO;
		channel.ownerUsername = message.topic.nameSpace;
	} else {
		channel.isPublic = YES;
	}
	msg.channel = channel;
	msg.messageContent = message.metaData;
	msg.timestamp = message.timestamp;
	msg.messageID = message.messageID;
	MMUser *user = [MMUser new];
	user.userName = message.senderUserID.username;
	msg.sender = user;
	[[NSNotificationCenter defaultCenter] postNotificationName:MMXDidReceiveMessageNotification
														object:nil
													  userInfo:@{MMXMessageKey:msg}];
}

- (void)client:(MMXClient *)client didReceiveServerAckForMessageID:(NSString *)messageID recipient:(MMXUserID *)recipient {
	NSDictionary *messageBlockDict = [self.messageBlockQueue objectForKey:messageID];
	if (messageBlockDict) {
		MessageSuccessBlock success = messageBlockDict[MMXMessageSuccessBlockKey];
		if (success) {
			success();
		}
		[self.messageBlockQueue removeObjectForKey:messageID];
	}
}

- (void)client:(MMXClient *)client didFailToSendMessage:(NSString *)messageID recipients:(NSArray *)recipients error:(NSError *)error {
	NSDictionary *messageBlockDict = [self.messageBlockQueue objectForKey:messageID];
	if (messageBlockDict) {
		MessageFailureBlock failure = messageBlockDict[MMXMessageFailureBlockKey];
		if (failure) {
			failure(error);
		}
		[self.messageBlockQueue removeObjectForKey:messageID];
	}
}

- (void)client:(MMXClient *)client didDeliverMessage:(NSString *)messageID recipient:(id<MMXAddressable>)recipient {
	MMUser *user = [MMUser new];
	MMXInternalAddress *address = recipient.address;
	if (address) {
		//Converting to MMXUserID will handle any exscaping needed
		MMXUserID *userID = [MMXUserID userIDFromAddress:address];
		user.userName = userID.username;
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:MMXDidReceiveDeliveryConfirmationNotification
														object:nil
													  userInfo:@{MMXRecipientKey:user,
																 MMXMessageIDKey:messageID}];
}

+ (NSError *)notNotLoggedInError {
	NSError * error = [MMXClient errorWithTitle:@"Forbidden" message:@"You must log in to use this API." code:403];
	return error;
}

#pragma mark - Recipient conversion

- (NSSet *)usersFromInboundRecipients:(NSArray *)recipients {
	NSMutableSet *set = [NSMutableSet setWithCapacity:recipients.count];
	for (id<MMXAddressable> recipient in recipients) {
		MMXInternalAddress *address = recipient.address;
		MMUser *user = [MMUser new];
		//Converting to MMXUserID will handle any exscaping needed
		MMXUserID *userID = [MMXUserID userIDFromAddress:address];
		user.userName = userID.username;
		[set addObject:user];
	}
	return set.copy;
}

#pragma mark - Overriden getters

- (NSOperationQueue *)internalQueue {
	
	if (!_internalQueue) {
		_internalQueue = [[NSOperationQueue alloc] init];
		_internalQueue.maxConcurrentOperationCount = 1;
	}
	
	return _internalQueue;
}

@end
