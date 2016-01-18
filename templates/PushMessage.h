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


/**
 The MMXPushMessage class is used for sending push notifications to a recipient(s), all of a recepient's devices will recieve a push notification.
 */
@interface MMXPushMessage : NSObject

/**
 @name Properties
 */

/**
 The recipients of a push message *MMUsers*.
 */
@property (nonatomic, copy) NSSet<MMUser *> * __nullable recipients;

/**
 The content to be pushed to recipients.
 */
@property (nonatomic, readonly, copy) NSDictionary<NSString *, NSString *> * __nullable messageContent;

/**
 The body of notification.
 */
@property (nonatomic, readonly, copy) NSString * __nullable body;

/**
 The title of notification.
 */
@property (nonatomic, readonly, copy) NSString * __nullable title;

/**
 A badge/number to be displayed on the apps icon.
 */
@property (nonatomic, readonly, copy) NSString * __nullable badge;

/**
The notifications alert sound.
 */
@property (nonatomic, readonly, copy) NSString * __nullable sound;

/**
Arbitrarily defined objects to be sent along with push.
 */
@property (nonatomic, readonly, copy) NSDictionary<NSString *, NSString *> * __nullable userDefinedObjects;


/**
 @name Initializers
 */

/**
 *  Initializes a pushMessage object with the content of a dictionary. This dictionary is returned in the AppDelegate as userInfo. This method can be used to regenerate any incoming push messages.
 *
 *  @param pushUserInfo A dictionary containing a push message's contents.
 *
 *
 *  @return MMXPushMessage
 */
- (nonnull instancetype)initWithPushUserInfo:(NSDictionary * __nonnull)pushUserInfo;


/**
 @name Factory Methods - for multiple recipients
 */


/**
 *  Creates a new MMXPushMessage.
 *
 *  @param recipients A set of *MMUsers*.
 *
 *  @param body A body to send as the message's content.
 *
 *  @return MMXPushMessage
 */
+ (MMXPushMessage * __nonnull)pushMessageWithRecipients:(NSSet<MMUser *> * __nonnull)recipients body:(NSString * __nonnull)body;

/**
 *  Creates a new MMXPushMessage.
 *
 *  @param recipients A set of *MMUsers*.
 *
 *  @param body A to send as the message's content.
 *
 *  @param title A title to send as the message's title.
 *
 *  @param sound A sound for the notification.
 *
 *  @param badge A badge for the notification.
 *
 *  @return MMXPushMessage
 */
+ (MMXPushMessage * __nonnull)pushMessageWithRecipients:(NSSet<MMUser *> * __nonnull)recipients body:(NSString * __nonnull)body title:(NSString * __nullable)title sound:(NSString * __nullable)sound badge:(NSNumber * __nullable)badge;

/**
 *  Creates a new MMXPushMessage.
 *
 *  @param recipients A set of *MMUsers*.
 *
 *  @param body A to send as the message's content.
 *
 *  @param title A title to send as the message's title.
 *
 *  @param sound A sound for the notification.
 *
 *  @param badge A badge for the notification.
 *
 *  @param userDefinedObjects A dicionary of arbitrary data to send with the notification.
 *
 *  @return MMXPushMessage
 */
+ (MMXPushMessage * __nonnull)pushMessageWithRecipients:(NSSet<MMUser *> * __nonnull)recipients body:(NSString * __nonnull)body title:(NSString * __nullable)title sound:(NSString * __nullable)sound badge:(NSNumber * __nullable)badge userDefinedObjects:(NSDictionary<NSString *, NSString *> * __nullable)userDefinedObjects;


/**
 @name Factory Methods - for single recipients
 */


/**
 *  Creates a new MMXPushMessage.
 *
 *  @param recipient A  *MMUser*.
 *
 *  @param body A body to send as the message's content.
 *
 *  @return MMXPushMessage
 */
+ (MMXPushMessage * __nonnull)pushMessageWithRecipient:(MMUser * __nonnull)recipient body:(NSString * __nonnull)body;

/**
 *  Creates a new MMXPushMessage.
 *
 *  @param recipient A  *MMUser*.
 *
 *  @param body A to send as the message's content.
 *
 *  @param title A title to send as the message's title.
 *
 *  @param sound A sound for the notification.
 *
 *  @param badge A badge for the notification.
 *
 *  @return MMXPushMessage
 */
+ (MMXPushMessage * __nonnull)pushMessageWithRecipient:(MMUser * __nonnull)recipient body:(NSString * __nonnull)body title:(NSString * __nonnull)title sound:(NSString * __nullable)sound badge:(NSNumber * __nullable)badge;

/**
 *  Creates a new MMXPushMessage.
 *
 *  @param recipient A  *MMUser*.
 *
 *  @param body A to send as the message's content.
 *
 *  @param title A title to send as the message's title.
 *
 *  @param sound A sound for the notification.
 *
 *  @param badge A badge for the notification.
 *
 *  @param userDefinedObjects A dicionary of arbitrary data to send with the notification.
 *
 *  @return MMXPushMessage
 */
+ (MMXPushMessage * __nonnull)pushMessageWithRecipient:(MMUser * __nonnull)recipient body:(NSString * __nonnull)body title:(NSString * __nonnull)title sound:(NSString * __nullable)sound badge:(NSNumber * __nullable)badge userDefinedObjects:(NSDictionary<NSString *, NSString *> * __nullable)userDefinedObjects;


/**
 @name Sending methods
 */

/**
 *  Sends the MMXPushMessage.
 *
 *  @param success A closure to trigger upon success.
 *
 *  @param failure A closure to trigger upon errors.
 *
 */
- (void)sendPushMessage:(void (^ __nullable)(void))success failure:(void (^ __nullable)(NSError * __nonnull))failure;
@end

