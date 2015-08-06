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


#import <Foundation/Foundation.h>
@class MMXUser;
@class MMXTopic;

@interface MMXMessage : NSObject

/**
 *  Unique UUID for the message to allow tracking.
 */
@property(nonatomic, copy, readonly) NSString *messageID;

/**
 *  The timestamp for when the message was originally sent.
 */
@property(nonatomic, strong, readonly) NSDate *timestamp;

/**
 *  The MMXUserID for the user that sent the message.
 */
@property(nonatomic, strong, readonly) MMXUser *sender;

/**
 *  The topic the message was published to. See MMXTopic.h for more details.
 */
@property (nonatomic, readonly) MMXTopic *topic;

/**
 *  The list of users the message was sent to.
 */
@property(nonatomic, copy, readonly) NSSet *recipients;

/**
 *  The content you want to send.
 *	NSDictionary can only contain objects that are JSON serializable.
 */
@property(nonatomic, copy, readonly) NSDictionary *messageContent;

/**
 *  Initializer for creating a new MMXMessage object
 *
 *  @param recipients     Set of unique recipients to send the message to
 *  @param messageContent NSDictionary of content to send. Must contain only objects that are JSON serializable.
 *
 *  @return New MMXMessage
 */
+ (instancetype)messageTo:(NSSet *)recipients
		   messageContent:(NSDictionary *)messageContent;

/**
 *  Method to send the message
 *
 *  @param success - Block with the message ID for the sent message.
 *  @param failure - Block with an NSError with details about the call failure.
 */
- (void)sendWithSuccess:(void (^)(NSString *messageID))success
				failure:(void (^)(NSError *error))failure;

/**
 *  Method to send a message in reply to the received message
 *
 *  @param content NSDictionary of content to send. Must contain only objects that are JSON serializable.
 *  @param success - Block with the message ID for the sent message.
 *  @param failure - Block with an NSError with details about the call failure.
 */
- (void)replyWithContent:(NSDictionary *)content
				 success:(void (^)(NSString *messageID))success
				 failure:(void (^)(NSError * error))failure;

/**
 *  Method to send a message to all recipients of the received message including the sender
 *
 *  @param content NSDictionary of content to send. Must contain only objects that are JSON serializable.
 *  @param success - Block with the message ID for the sent message.
 *  @param failure - Block with an NSError with details about the call failure.
 */
- (void)replyAllWithContent:(NSDictionary *)content
					success:(void (^)(NSString *messageID))success
					failure:(void (^)(NSError * error))failure;


@end