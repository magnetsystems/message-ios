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
#import <Mantle/Mantle.h>

@interface MMXUser : MTLModel

/**
 *  Unique username the user.
 */
@property(nonatomic, copy) NSString *username;

/**
 *  The name you want to have publicly displayed for the user.
 *  The valid character set is alphanumeric plus period, dash and underscore. .-_
 */
@property  (nonatomic, copy) NSString *displayName;

/**
 *  The email for the user.
 */
@property  (nonatomic, copy) NSString *email;

/**
 *  Get the currently logged in user
 *
 *  @return MMXUser object for the current user.
 */
+ (MMXUser *)currentUser;

/**
 *  Method to register a new user with Magnet Message
 *
 *  @param credential - NSURLCredential object containing the user's username and password.
 *  @param success 	  - Block called if operation is successful.
 *  @param failure    - Block with an NSError with details about the call failure.
 */
- (void)registerWithCredentials:(NSURLCredential *)credential
						success:(void (^)(void))success
						failure:(void (^)(NSError * error))failure;

/**
 *  Method to log in to Magnet Message
 *
 *  @param credential - NSURLCredential object containing the user's username and password.
 *  @param success 	  - Block with the MMXUser object for the newly logged in user.
 *  @param failure    - Block with an NSError with details about the call failure.
 */
+ (void)logInWithCredentials:(NSURLCredential *)credential
					 success:(void (^)(MMXUser *user))success
					 failure:(void (^)(NSError * error))failure;


/**
 *  Log out the currently logged in user.
 *
 *  @param success - Block called if operation is successful.
 *  @param failure - Block with an NSError with details about the call failure.
 */
+ (void)logOutWithSuccess:(void (^)(void))success
				  failure:(void (^)(NSError *error))failure;

/**
 *  Method to change the user's password if the user is currently logged in.
 *
 *  @param credential - NSURLCredential object containing the user's username and password.
 *  @param success    - Block called if operation is successful.
 *  @param failure    - Block with an NSError with details about the call failure.
 */
- (void)changePasswordWithCredentials:(NSURLCredential *)credential
							  success:(void (^)(void))success
							  failure:(void (^)(NSError * error))failure;

/**
 *  Method used to discover existing users by name
 *
 *  @param name		The exact name of the tpic you are searching for.
 *  @param limit	The max number of results you want returned. Defaults to 20.
 *  @param success  Block with the number of users that match the query and a NSArray of MMXUsers that match the criteria.
 *  @param failure  Block with an NSError with details about the call failure.
 */
+ (void)findByName:(NSString *)name
			 limit:(int)limit
		   success:(void (^)(int totalCount, NSArray *users))success
		   failure:(void (^)(NSError *error))failure;

@end
