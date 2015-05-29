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

#import <UIKit/UIKit.h>
#import <Kiwi/Kiwi.h>
#import "MMX.h"
#import "MMXClientDelegateSpy.h"
#import "MMXUtils.h"
#import "MMXTestingUtils.h"

#define DEFAULT_TEST_TIMEOUT 15.0

SPEC_BEGIN(MMXAccountManagerSpec)

describe(@"MMXAccountManager", ^{
	
	__block id clientDelegateMock;
	__block MMXClient *mmxClient;
	__block MMXConfiguration *mmxConfiguration;
	
	beforeEach(^{
		clientDelegateMock = [KWMock nullMockForProtocol:@protocol(MMXClientDelegate)];
		mmxConfiguration = [MMXConfiguration configurationWithName:@"default"];
		mmxClient = [[MMXClient alloc] initWithConfiguration:mmxConfiguration delegate:clientDelegateMock];
	});
	
	afterEach(^{
		clientDelegateMock = nil;
		mmxClient = nil;
	});
	
	context(@"when calling currentUserWithSuccess:", ^{
		it(@"should receive a success response and return a valid MMXUserProfile where user.userID.username = mmxClient.configuration.credential.user", ^{
			__block BOOL _testFinished = NO;
			
			__block BOOL _result;
			MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
			spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
				switch (connectionEvent) {
					case MMXConnectionStatusConnected:
						break;
					case MMXConnectionStatusNotConnected:
						break;
					case MMXConnectionStatusDisconnected:
						break;
					case MMXConnectionStatusAuthenticated:{
						[mmxClient.accountManager userProfileWithSuccess:^(MMXUserProfile *user) {
							if (user.userID.username && [user.userID.username isEqualToString:mmxClient.configuration.credential.user]) {
								_result = YES;
								_testFinished = YES;
							}
						} failure:^(NSError *error) {
							_result = NO;
							_testFinished = YES;
						}];
					}
					case MMXConnectionStatusAuthenticationFailure:break;
					case MMXConnectionStatusFailed:break;
				};
			};
			[clientDelegateMock addMessageSpy:spy
							forMessagePattern:[KWMessagePattern messagePatternWithSelector:@selector(client:didReceiveConnectionStatusChange:error:)]];
			mmxClient.configuration.credential = [NSURLCredential credentialWithUser:@"testuser" password:@"testuser" persistence:NSURLCredentialPersistenceNone];
			[mmxClient connectWithCredentials];
			
			[[expectFutureValue(theValue(_result)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
			[[expectFutureValue(theValue(_testFinished)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
	});

	context(@"when calling updateEmail:", ^{
		it(@"you should receive a success and the call to currentUserWithSuccess: should contain that email", ^{
			__block BOOL _testFinished = NO;
			
			__block BOOL _result;
			__block NSString * _randomEmail = [MMXTestingUtils randomStringWithLength:10];
			MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
			spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
				switch (connectionEvent) {
					case MMXConnectionStatusConnected:
						break;
					case MMXConnectionStatusNotConnected:
						break;
					case MMXConnectionStatusDisconnected:
						break;
					case MMXConnectionStatusAuthenticated:{
						[mmxClient.accountManager updateEmail:_randomEmail success:^(BOOL success) {
							[mmxClient.accountManager userProfileWithSuccess:^(MMXUserProfile *user) {
								if (user && user.email && [user.email isEqualToString:_randomEmail]) {
									_result = YES;
									_testFinished = YES;
								} else {
									_result = NO;
									_testFinished = YES;
								}
							} failure:^(NSError *error) {
								_result = NO;
								_testFinished = YES;
							}];
						} failure:^(NSError * error) {
							_result = NO;
							_testFinished = YES;
						}];
					}
					case MMXConnectionStatusAuthenticationFailure:break;
					case MMXConnectionStatusFailed:break;
				};
			};
			[clientDelegateMock addMessageSpy:spy
							forMessagePattern:[KWMessagePattern messagePatternWithSelector:@selector(client:didReceiveConnectionStatusChange:error:)]];
			mmxClient.configuration.credential = [NSURLCredential credentialWithUser:@"testuser" password:@"testuser" persistence:NSURLCredentialPersistenceNone];
			[mmxClient connectWithCredentials];
			
			[[expectFutureValue(theValue(_result)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
			[[expectFutureValue(theValue(_testFinished)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
	});
	
	context(@"when calling updateDisplayName:", ^{
		it(@"you should receive a success and the call to currentUserWithSuccess: should contain that email", ^{
			__block BOOL _testFinished = NO;
			
			__block BOOL _result;
			__block NSString * _randomName = [MMXTestingUtils randomStringWithLength:10];
			MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
			spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
				switch (connectionEvent) {
					case MMXConnectionStatusConnected:
						break;
					case MMXConnectionStatusNotConnected:
						break;
					case MMXConnectionStatusDisconnected:
						break;
					case MMXConnectionStatusAuthenticated:{
						[mmxClient.accountManager updateDisplayName:_randomName success:^(BOOL success) {
							[mmxClient.accountManager userProfileWithSuccess:^(MMXUserProfile *user) {
								if (user && user.displayName && [user.displayName isEqualToString:_randomName]) {
									_result = YES;
									_testFinished = YES;
								} else {
									_result = NO;
									_testFinished = YES;
								}
							} failure:^(NSError *error) {
								_result = NO;
								_testFinished = YES;
							}];
						} failure:^(NSError * error) {
							_result = NO;
							_testFinished = YES;
						}];
					}
					case MMXConnectionStatusAuthenticationFailure:break;
					case MMXConnectionStatusFailed:break;
				};
			};
			[clientDelegateMock addMessageSpy:spy
							forMessagePattern:[KWMessagePattern messagePatternWithSelector:@selector(client:didReceiveConnectionStatusChange:error:)]];
			mmxClient.configuration.credential = [NSURLCredential credentialWithUser:@"testuser" password:@"testuser" persistence:NSURLCredentialPersistenceNone];
			[mmxClient connectWithCredentials];
			
			[[expectFutureValue(theValue(_result)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
			[[expectFutureValue(theValue(_testFinished)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
	});
	

	
	context(@"when calling tagsForCurrentUserWithSuccess:", ^{
		it(@"should receive a success response", ^{
			__block BOOL _testFinished = NO;
			
			__block BOOL _result;
			MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
			spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
				switch (connectionEvent) {
					case MMXConnectionStatusConnected:
						break;
					case MMXConnectionStatusNotConnected:
						break;
					case MMXConnectionStatusDisconnected:
						break;
					case MMXConnectionStatusAuthenticated:{
						[mmxClient.accountManager tagsWithSuccess:^(NSArray *tags) {
							if (tags) {
								_result = YES;
								_testFinished = YES;
							}
						} failure:^(NSError *error) {
							_result = NO;
							_testFinished = YES;
						}];
					}
					case MMXConnectionStatusAuthenticationFailure:break;
					case MMXConnectionStatusFailed:break;
				};
			};
			[clientDelegateMock addMessageSpy:spy
							forMessagePattern:[KWMessagePattern messagePatternWithSelector:@selector(client:didReceiveConnectionStatusChange:error:)]];
			mmxClient.configuration.credential = [NSURLCredential credentialWithUser:@"testuser" password:@"testuser" persistence:NSURLCredentialPersistenceNone];
			[mmxClient connectWithCredentials];
			
			[[expectFutureValue(theValue(_result)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
			[[expectFutureValue(theValue(_testFinished)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
	});
	
	context(@"when calling addTagsForCurrentUser", ^{
		it(@"should receive a success response and the new tags should be on the list when calling addTagsForCurrentUser:", ^{
			__block BOOL _testFinished = NO;
			
			__block BOOL _result;
			__block NSString * _randomTag = [MMXTestingUtils randomStringWithLength:10];
			MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
			spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
				switch (connectionEvent) {
					case MMXConnectionStatusConnected:
						break;
					case MMXConnectionStatusNotConnected:
						break;
					case MMXConnectionStatusDisconnected:
						break;
					case MMXConnectionStatusAuthenticated:{
						[mmxClient.accountManager addTags:@[_randomTag] success:^(BOOL success) {
							[mmxClient.accountManager tagsWithSuccess:^(NSArray *tags) {
								if (tags && tags.count && [tags indexOfObject:_randomTag] != NSNotFound) {
									_result = YES;
									_testFinished = YES;
								} else {
									_result = NO;
									_testFinished = YES;
								}
							} failure:^(NSError *error) {
								_result = NO;
								_testFinished = YES;
							}];
						} failure:^(NSError * error) {
							_result = NO;
							_testFinished = YES;
						}];
					}
					case MMXConnectionStatusAuthenticationFailure:break;
					case MMXConnectionStatusFailed:break;
				};
			};
			[clientDelegateMock addMessageSpy:spy
							forMessagePattern:[KWMessagePattern messagePatternWithSelector:@selector(client:didReceiveConnectionStatusChange:error:)]];
			mmxClient.configuration.credential = [NSURLCredential credentialWithUser:@"testuser" password:@"testuser" persistence:NSURLCredentialPersistenceNone];
			[mmxClient connectWithCredentials];
			
			[[expectFutureValue(theValue(_result)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
			[[expectFutureValue(theValue(_testFinished)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
	});
	
});
SPEC_END
