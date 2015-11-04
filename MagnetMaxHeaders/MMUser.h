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

#import "MMModel.h"
#import "MMUserRealm.h"

@class MMCall;

/**
 The MMUser class is a local representation of a user in the MagnetMax platform. This class provides various user specific methods, like authentication, signing up, and search.
 */
@interface MMUser : MMModel

/**
 The unique identifer for the user.
 */
@property (nonatomic, copy) NSString *userID;

/**
 The username for the user.
 */
@property (nonatomic, copy) NSString *userName;

/**
 The password for the user.
 */
@property (nonatomic, copy) NSString *password;

/**
 The firstName for the user.
 */
@property (nonatomic, copy) NSString *firstName;

/**
 The lastName for the user.
 */
@property (nonatomic, copy) NSString *lastName;

/**
 The email for the user.
 */
@property (nonatomic, copy) NSString *email;

/**
 The roles assigned to the user.
 */
@property (nonatomic, copy) NSArray <NSString *>*roles;

/**
 The realm for the user.
 */
@property (nonatomic, assign) MMUserRealm userRealm;

/**
 The additional key-value pairs associated with the user.
 */
@property (nonatomic, copy) NSDictionary <NSString *, NSString *>*extras;

/**
 The tags associated with the user.
 */
@property (nonatomic, copy) NSArray <NSString *>*tags;


/**
 *  Registers a new user.
 *
 *  @param success  A block object to be executed when the registration finishes successfully. This block has no return value and takes one argument: the newly created user.
 *  @param failure  A block object to be executed when the registration finishes with an error. This block has no return value and takes one argument: the error object.
 */
- (void)register:(void (^ __nullable)(MMUser * __nonnull))success failure:(void (^ __nullable)(NSError * __nonnull))failure;

/**
 *  Logs in as an user.
 *
 *  @param credential  A credential object containing the user's userName and password.
 *  @param success A block object to be executed when the login finishes successfully. This block has no return value and takes no arguments.
 *  @param param failure A block object to be executed when the login finishes with an error. This block has no return value and takes one argument: the error object.
 */
+ (void)login:(NSURLCredential * __nonnull)credential success:(void (^ __nullable)(void))success failure:(void (^ __nullable)(NSError * __nonnull))failure;

/**
 *  Logs out a currently logged-in user.
 *
 *  @param success  A block object to be executed when the logout finishes successfully. This block has no return value and takes no arguments.
 *  @param failure  A block object to be executed when the logout finishes with an error. This block has no return value and takes one argument: the error object.
 */
+ (void)logout:(void (^ __nullable)(void))success failure:(void (^ __nullable)(NSError * __nonnull))failure;

/**
 *  Get the currently logged-in user.
 *
 *  @returns  The currently logged-in user or nil.
 */
+ (MMUser * __nullable)currentUser;

/**
 *  Search for users based on some criteria.
 *  
 *  @param query The DSL can be found here: https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html#query-string-syntax
 *  @param limit The number of records to retrieve.
 *  @param offset The offset to start from.
 *  @param sort The sort criteria.
 *  @param success A block object to be executed when the call finishes successfully. This block has no return value and takes one argument: the list of users that match the specified criteria.
 *  @param failure A block object to be executed when the call finishes with an error. This block has no return value and takes one argument: the error object.
 */
+ (void)searchUsers:(NSString * __nonnull)query limit:(NSInteger)limit offset:(NSInteger)offset sort:(NSString * __nonnull)sort success:(void (^ __nullable)(NSArray<MMUser *> * __nonnull))success failure:(void (^ __nullable)(NSError * __nonnull))failure;

/**
 *  Get users with userNames.
 *  
 *  @param userNames A list of userNames to fetch users for.
 *  @param success A block object to be executed when the logout finishes successfully. This block has no return value and takes one argument: the list of users for the specified userNames.
 *  @param failure A block object to be executed when the logout finishes with an error. This block has no return value and takes one argument: the error object.
 */
+ (void)usersWithUserNames:(NSArray<NSString *> * __nonnull)userNames success:(void (^ __nullable)(NSArray<MMUser *> * __nonnull))success failure:(void (^ __nullable)(NSError * __nonnull))failure;

/**
 *  Get users with userIDs.
 *  
 *  @param userNames A list of userIDs to fetch users for.
 *  @param success A block object to be executed when the logout finishes successfully. This block has no return value and takes one argument: the list of users for the specified userIDs.
 *  @param failure A block object to be executed when the logout finishes with an error. This block has no return value and takes one argument: the error object.
 */
+ (void)usersWithUserIDs:(NSArray<NSString *> * __nonnull)userIDs success:(void (^ __nullable)(NSArray<MMUser *> * __nonnull))success failure:(void (^ __nullable)(NSError * __nonnull))failure;

@end
