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
@class MMXMessage;

@interface MMXChannel : NSObject

/**
 *  The unique name of the topic.
 */
@property (nonatomic, copy) NSString *name;

/**
 *  An optional summary of the topic.
 */
@property (nonatomic, copy) NSString *summary;

/**
 *  The owner/creator of the topic.
 */
@property (nonatomic, readonly) MMXUser *owner;

/**
 *  The total number of messages that have been posted to the topic.
 */
@property (nonatomic, readonly) int numberOfMessages;

/**
 *  The timestamp of the most recent message published to the topic.
 */
@property (nonatomic, readonly) NSDate *lastTimeActive;

/**
 *  Tags currently set on the topic.
 */
@property (nonatomic, readonly) NSSet *tags;

/**
 *  BOOL letting you know if the current user is subscribed to the topic.
 */
@property (nonatomic, readonly) BOOL isSubscribed;

/**
 *  Method used to discover existing topics by name
 *
 *  @param name    The exact name of the tpic you are searching for.
 *  @param success  Block with the number of topics that match the query and a NSArray of MMXTopics that match the criteria.
 *  @param failure  Block with an NSError with details about the call failure.
 */
+ (void)findByName:(NSString *)name
		   success:(void (^)(int totalCount, NSArray *topics))success
		   failure:(void (^)(NSError *error))failure;

/**
 *  Method used to discover existing topics by tags
 *
 *  @param tags		A set of unique tags
 *  @param success  Block with the number of topics that match the query and a NSArray of MMXTopics that match the criteria.
 *  @param failure  Block with an NSError with details about the call failure.
 */
+ (void)findByTags:(NSSet *)tags
		   success:(void (^)(int totalCount, NSArray *topics))success
		   failure:(void (^)(NSError *error))failure;

/**
 *  Set tags for a specific topic. This will overwrite ALL existing tags for the topic.
 *	This can be used to delete tags by passing in the sub-set of existing tags that you want to keep.
 *
 *  @param tags    - NSSet of tags(NSStrings).
 *  @param success - Block called if operation is successful.
 *  @param failure - Block with an NSError with details about the call failure.
 */
- (void)setTags:(NSSet *)tags
		success:(void (^)(void))success
		failure:(void (^)(NSError *error))failure;

/**
 *  Method to create a new topic.
 *
 *  @param success - Block called if operation is successful.
 *  @param failure - Block with an NSError with details about the call failure.
 */
- (void)createWithSuccess:(void (^)(void))success
				  failure:(void (^)(NSError * error))failure;

/**
 *  Method to delete an existing new topic.
 * Current user must be the owner of the topic to delete it.
 *
 *  @param success - Block called if operation is successful.
 *  @param failure - Block with an NSError with details about the call failure.
 */
- (void)deleteWithSuccess:(void (^)(void))success
				  failure:(void (^)(NSError * error))failure;

/**
 *  Method to subscribe to an existing topic.
 *
 *  @param success - Block called if operation is successful.
 *  @param failure - Block with an NSError with details about the call failure.
 */
- (void)subscribeWithSuccess:(void (^)(void))success
					 failure:(void (^)(NSError * error))failure;

/**
 *  Method to unsubscribe to an existing topic.
 *
 *  @param success - Block called if operation is successful.
 *  @param failure - Block with an NSError with details about the call failure.
 */
- (void)unSubscribeWithSuccess:(void (^)(void))success
					   failure:(void (^)(NSError * error))failure;

/**
 *  Method to publish to a topic.
 *	If the topic does not exist it will be created.
 *
 *  @param message MMXMessage with the content you want to publish
 *  @param success Block with the published message
 *  @param failure - Block with an NSError with details about the call failure.
 */
- (void)publish:(MMXMessage *)message
		success:(void (^)(MMXMessage *message))success
		failure:(void (^)(NSError *error))failure;

@end
