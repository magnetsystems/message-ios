//
//  MMXMessage.m
//  QuickStart
//
//  Created by Jason Ferguson on 8/4/15.
//  Copyright (c) 2015 Magnet Systems, Inc. All rights reserved.
//

#import "MMXMessage_Private.h"
#import "MagnetDelegate.h"
#import "MMXUser.h"
#import "MMX.h"

@implementation MMXMessage

+ (instancetype)messageTo:(NSSet *)recipients messageContent:(NSDictionary *)messageContent {
	MMXMessage *msg = [MMXMessage new];
	msg.recipients = recipients;
	msg.messageContent = messageContent;
	return msg;
};

- (NSString *)sendWithSuccess:(void (^)(void))success
					  failure:(void (^)(NSError *))failure {
	//FIXME: Handle case that user is not logged in
	NSString * messageID = [[MagnetDelegate sharedDelegate] sendMessage:self.copy success:^(void) {
		self.messageID = messageID;
		if (success) {
			success();
		}
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
	
	return messageID;
}

- (NSString *)replyWithContent:(NSDictionary *)content
				 success:(void (^)(void))success
				 failure:(void (^)(NSError *))failure {
	//FIXME: Handle case that user is not logged in
	MMXMessage *msg = [MMXMessage messageTo:[NSSet setWithObjects:self.sender, nil] messageContent:content];
	NSString * messageID = [[MagnetDelegate sharedDelegate] sendMessage:msg success:^() {
		if (success) {
			success();
		}
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
	return messageID;
}

- (NSString *)replyAllWithContent:(NSDictionary *)content
					success:(void (^)(void))success
					failure:(void (^)(NSError *))failure {
	//FIXME: Handle case that user is not logged in
	NSMutableSet *newSet = [NSMutableSet setWithSet:self.recipients];
	[newSet addObject:self.sender];
	MMXMessage *msg = [MMXMessage messageTo:newSet messageContent:content];
	NSString * messageID = [[MagnetDelegate sharedDelegate] sendMessage:msg success:^() {
		if (success) {
			success();
		}
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
	return messageID;
}

#pragma mark - Conversion Helpers
- (NSArray *)recipientsForOutboundMessage {
	return [self converArrayOfUsersToUserIDs:[self.recipients allObjects]];
}

- (NSArray *)converArrayOfUsersToUserIDs:(NSArray *)users {
	NSMutableArray *recipientArray = [[NSMutableArray alloc] initWithCapacity:users.count];
	for (MMXUser *user in users) {
		MMXUserID *userID = [MMXUserID userIDWithUsername:user.username];
		[recipientArray addObject:userID];
	}
	return recipientArray.copy;
}

- (NSArray *)replyAllArray {
	NSMutableArray *recipients = [NSMutableArray arrayWithCapacity:self.recipients.count + 1];
	[recipients addObject:self.sender];
	[recipients addObjectsFromArray:[self.recipients allObjects]];
	return recipients.copy;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder {
	self = [super init];
	if (self) {
		_messageID = [coder decodeObjectForKey:@"_messageID"];
		_timestamp = [coder decodeObjectForKey:@"_timestamp"];
		_sender = [coder decodeObjectForKey:@"_sender"];
		_topic = [coder decodeObjectForKey:@"_topic"];
		_recipients = [coder decodeObjectForKey:@"_recipients"];
		_messageContent = [coder decodeObjectForKey:@"_messageContent"];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:self.messageID forKey:@"_messageID"];
	[coder encodeObject:self.timestamp forKey:@"_timestamp"];
	[coder encodeObject:self.sender forKey:@"_sender"];
	[coder encodeObject:self.topic forKey:@"_topic"];
	[coder encodeObject:self.recipients forKey:@"_recipients"];
	[coder encodeObject:self.messageContent forKey:@"_messageContent"];
}

- (id)copyWithZone:(NSZone *)zone {
	MMXMessage *copy = [[[self class] allocWithZone:zone] init];
	
	if (copy != nil) {
		copy.messageID = self.messageID;
		copy.timestamp = self.timestamp;
		copy.sender = self.sender;
		copy.topic = self.topic;
		copy.recipients = self.recipients;
		copy.messageContent = self.messageContent;
	}
	
	return copy;
}

@end
