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
@class MMXMessage;
@class MMXInternalMessageAdaptor;

@interface MagnetDelegate : NSObject

+ (instancetype)sharedDelegate;

- (void)startMMXClientWithConfiguration:(NSString *)name;

- (void)connectWithSuccess:(void (^)(void))success
				   failure:(void (^)(NSError *error))failure;

/**
 *  Method to send the message
 *
 *  @param message - MMXOutboundMessage to send
 *  @param success 	  - Block called if operation is successful.
 *  @param failure - Block with an NSError with details about the call failure.
 */
- (NSString *)sendMessage:(MMXMessage *)message
				  success:(void (^)(void))success
				  failure:(void (^)(NSError *error))failure;

- (NSString *)sendInternalMessageFormat:(MMXInternalMessageAdaptor *)message
								success:(void (^)(void))success
								failure:(void (^)(NSError *error))failure;

+ (NSError *)notNotLoggedInError;

@property (nonatomic, readonly, copy) NSError * __nullable (^ __nullable configurationHandler)(NSDictionary * __nonnull);
@property (nonatomic, readonly, copy) NSError * __nullable (^ __nullable appTokenHandler)(NSString * __nonnull, NSString * __nonnull, NSString * __nonnull);
@property (nonatomic, readonly, copy) NSError * __nullable (^ __nullable userTokenHandler)(NSString * __nonnull, NSString * __nonnull, NSString * __nonnull);

@end
