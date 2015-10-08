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

#import <Kiwi/Kiwi.h>
#import "MMXInternal_Private.h"
#import "MMXClientDelegateSpy.h"
#import "MMXTestingUtils.h"

#define DEFAULT_TEST_TIMEOUT 15.0

SPEC_BEGIN(MMXPubSubManagerSpec)

describe(@"MMXPubSubManager", ^{
    
    __block id clientDelegateMock;
    __block MMXClient *mmxClient;
    __block MMXConfiguration *mmxConfiguration;
	__block NSString * _randomTopicName;
    beforeAll(^{
		_randomTopicName = [MMXTestingUtils randomStringWithLength:15];
        [[MMXLogger sharedLogger] startLogging];
    });
    
    afterAll(^{
		[[MMXLogger sharedLogger] stopLogging];
    });
	
    beforeEach(^{
        clientDelegateMock = [KWMock nullMockForProtocol:@protocol(MMXClientDelegate)];
        mmxConfiguration = [MMXConfiguration configurationWithName:@"default"];
        mmxClient = [[MMXClient alloc] initWithConfiguration:mmxConfiguration delegate:clientDelegateMock];
    });
	
    afterEach(^{
        clientDelegateMock = nil;
        mmxClient = nil;
    });
	
    context(@"when calling createTopic", ^{
        it(@"should receive a success response when passing a valid topic that does not already exist", ^{
            __block BOOL _testFinished = NO;
			
            __block BOOL _result;
            MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
            spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
                switch (connectionEvent) {
					case MMXConnectionStatusAnonReady:
						break;
					case MMXConnectionStatusUserReady:
						break;
					case MMXConnectionStatusConnected:
						break;
                    case MMXConnectionStatusNotConnected:
                        break;
                    case MMXConnectionStatusDisconnected:
                        break;
                    case MMXConnectionStatusAuthenticated:{
                        MMXTopic * topic = [MMXTopic topicWithName:_randomTopicName maxItemsToPersist:-1 permissionsLevel:MMXPublishPermissionsLevelAnyone];
                        [mmxClient.pubsubManager createTopic:topic success:^(BOOL success) {
                            _result = YES;
                            NSLog(@"pubsubManager createTopic Success!!!!");
                            _testFinished = YES;
                        } failure:^(NSError *error) {
                            NSLog(@"pubsubManager createTopic Error = %@",error);
                            _testFinished = YES;
                        }];
                        break;
                    }
                    case MMXConnectionStatusAuthenticationFailure:break;
					case MMXConnectionStatusFailed:break;
					case MMXConnectionStatusReconnecting:break;
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

    context(@"when calling createTopic", ^{
        it(@"should receive a failure response when passing a valid topic that already exists", ^{
            __block BOOL _testFinished = NO;
            
			__block BOOL _failed;
			__block NSInteger _errorCode;
            MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
            spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
                switch (connectionEvent) {
					case MMXConnectionStatusAnonReady:
						break;
					case MMXConnectionStatusUserReady:
						break;
                    case MMXConnectionStatusConnected:
                        break;
                    case MMXConnectionStatusNotConnected:
                        break;
                    case MMXConnectionStatusDisconnected:
                        break;
                    case MMXConnectionStatusAuthenticated:{
						[mmxClient.pubsubManager listTopics:1 success:^(int totalCount, NSArray *topics) {
							MMXTopic *topic = topics.count ? topics[0] : nil;
							if (topic) {
								[mmxClient.pubsubManager createTopic:topic success:^(BOOL success) {
									_testFinished = YES;
								} failure:^(NSError *error) {
									_errorCode = error.code;
									_failed = YES;
									_testFinished = YES;
								}];
							} else {
								_failed = YES;
								_testFinished = YES;
							}
						} failure:^(NSError *error) {
							_errorCode = error.code;
							_failed = YES;
							_testFinished = YES;
						}];
                        break;
                    }
                    case MMXConnectionStatusAuthenticationFailure:break;
                    case MMXConnectionStatusFailed:break;
					case MMXConnectionStatusReconnecting:break;
                };
            };
            [clientDelegateMock addMessageSpy:spy
                            forMessagePattern:[KWMessagePattern messagePatternWithSelector:@selector(client:didReceiveConnectionStatusChange:error:)]];
            mmxClient.configuration.credential = [NSURLCredential credentialWithUser:@"testuser" password:@"testuser" persistence:NSURLCredentialPersistenceNone];
            [mmxClient connectWithCredentials];
            
			[[expectFutureValue(theValue(_failed)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
			[[expectFutureValue(theValue(_errorCode)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:theValue(409)];
            [[expectFutureValue(theValue(_testFinished)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
        });
    });
    
    context(@"when calling subscribeToTopic and unsubscribeFromTopic", ^{
        it(@"should receive a success response when the topic exists", ^{
            __block BOOL _testFinished = NO;
            
            __block BOOL _subscribeSuccess;
            __block BOOL _unSubscribeSuccess;
            MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
            spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
                switch (connectionEvent) {
					case MMXConnectionStatusAnonReady:
						break;
					case MMXConnectionStatusUserReady:
						break;
                    case MMXConnectionStatusConnected:
                        break;
                    case MMXConnectionStatusNotConnected:
                        break;
                    case MMXConnectionStatusDisconnected:
                        break;
                    case MMXConnectionStatusAuthenticated:{
                        MMXTopic * topic = [MMXTopic topicWithName:@"test_topic" maxItemsToPersist:-1 permissionsLevel:MMXPublishPermissionsLevelAnyone];
                        [mmxClient.pubsubManager subscribeToTopic:topic device:nil success:^(MMXTopicSubscription *subscription) {
                            NSLog(@"pubsubManager subscribeToTopic Success!!!!");
                            _subscribeSuccess = YES;
                            [mmxClient.pubsubManager unsubscribeFromTopic:topic subscriptionID:nil success:^(BOOL success) {
                                NSLog(@"pubsubManager unsubscribeFromTopic Success!!!!");
                                _unSubscribeSuccess = YES;
                                _testFinished = YES;
                            } failure:^(NSError * error) {
                                NSLog(@"pubsubManager unsubscribeFromTopic Error = %@",error);
                                _testFinished = YES;
                            }];
                        } failure:^(NSError * error) {
                            NSLog(@"pubsubManager subscribeToTopic Error = %@",error);
                            _testFinished = YES;
                        }];
                        break;
                    }
                    case MMXConnectionStatusAuthenticationFailure:break;
					case MMXConnectionStatusFailed:break;
					case MMXConnectionStatusReconnecting:break;
                };
            };
            [clientDelegateMock addMessageSpy:spy
                            forMessagePattern:[KWMessagePattern messagePatternWithSelector:@selector(client:didReceiveConnectionStatusChange:error:)]];
            mmxClient.configuration.credential = [NSURLCredential credentialWithUser:@"testuser" password:@"testuser" persistence:NSURLCredentialPersistenceNone];
            [mmxClient connectWithCredentials];
            
            [[expectFutureValue(theValue(_subscribeSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
            [[expectFutureValue(theValue(_unSubscribeSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
            [[expectFutureValue(theValue(_testFinished)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
        });
    });
	
	context(@"when calling tagsForTopic:", ^{
		it(@"should receive a success response", ^{
			__block BOOL _testFinished = NO;
			
			__block BOOL _result;
			MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
			spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
				switch (connectionEvent) {
					case MMXConnectionStatusAnonReady:
						break;
					case MMXConnectionStatusUserReady:
						break;
					case MMXConnectionStatusConnected:
						break;
					case MMXConnectionStatusNotConnected:
						break;
					case MMXConnectionStatusDisconnected:
						break;
					case MMXConnectionStatusAuthenticated:{
						MMXTopic * topic = [MMXTopic topicWithName:_randomTopicName maxItemsToPersist:-1 permissionsLevel:MMXPublishPermissionsLevelAnyone];
						[mmxClient.pubsubManager tagsForTopic:topic success:^(NSDate *lastModified, NSArray *tags) {
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
					case MMXConnectionStatusReconnecting:break;
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
	
	context(@"when calling addTags:topic:", ^{
		it(@"should receive a success response and the new tags should be on the list when calling tagsForTopic:", ^{
			__block BOOL _testFinished = NO;
			
			__block BOOL _result;
			__block NSString * _randomTag = [MMXTestingUtils randomStringWithLength:10];
			MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
			spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
				switch (connectionEvent) {
					case MMXConnectionStatusAnonReady:
						break;
					case MMXConnectionStatusUserReady:
						break;
					case MMXConnectionStatusConnected:
						break;
					case MMXConnectionStatusNotConnected:
						break;
					case MMXConnectionStatusDisconnected:
						break;
					case MMXConnectionStatusAuthenticated:{
						MMXTopic * topic = [MMXTopic topicWithName:_randomTopicName maxItemsToPersist:-1 permissionsLevel:MMXPublishPermissionsLevelAnyone];
						[mmxClient.pubsubManager addTags:@[_randomTag] topic:topic success:^(BOOL success) {
							[mmxClient.pubsubManager tagsForTopic:topic success:^(NSDate *lastModified, NSArray *tags) {
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
					case MMXConnectionStatusReconnecting:break;
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
	
	context(@"when calling publishPubSubMessage:", ^{
		it(@"should receive a success response and a valid messageID", ^{
			__block BOOL _testFinished = NO;
			
			__block BOOL _result;
			MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
			spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
				switch (connectionEvent) {
					case MMXConnectionStatusAnonReady:
						break;
					case MMXConnectionStatusUserReady:
						break;
					case MMXConnectionStatusConnected:
						break;
					case MMXConnectionStatusNotConnected:
						break;
					case MMXConnectionStatusDisconnected:
						break;
					case MMXConnectionStatusAuthenticated:{
						MMXTopic * topic = [MMXTopic topicWithName:@"test_topic" maxItemsToPersist:-1 permissionsLevel:MMXPublishPermissionsLevelAnyone];
						MMXPubSubMessage * message = [MMXPubSubMessage pubSubMessageToTopic:topic content:@"My content" metaData:nil];
						[mmxClient.pubsubManager publishPubSubMessage:message success:^(BOOL success, NSString *messageID) {
							if (success && messageID.length > 10) {
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
					}
					case MMXConnectionStatusAuthenticationFailure:break;
					case MMXConnectionStatusFailed:break;
					case MMXConnectionStatusReconnecting:break;
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

	context(@"when calling listSubscriptionsWithSuccess:", ^{
		it(@"should receive a success callback", ^{
			__block BOOL _testFinished = NO;
			
			__block BOOL _result;
			MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
			spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
				switch (connectionEvent) {
					case MMXConnectionStatusAnonReady:
						break;
					case MMXConnectionStatusUserReady:
						break;
					case MMXConnectionStatusConnected:
						break;
					case MMXConnectionStatusNotConnected:
						break;
					case MMXConnectionStatusDisconnected:
						break;
					case MMXConnectionStatusAuthenticated:{
						[mmxClient.pubsubManager listSubscriptionsWithSuccess:^(NSArray *subscriptions) {
							_result = YES;
							_testFinished = YES;
						} failure:^(NSError *error) {
							_result = NO;
							_testFinished = YES;
						}];
					}
					case MMXConnectionStatusAuthenticationFailure:break;
					case MMXConnectionStatusFailed:break;
					case MMXConnectionStatusReconnecting:break;
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
	
	context(@"when calling listSubscriptionsWithSuccess: and the user has at least one subscription", ^{
		it(@"should receive a success callback and the subscriptions.count > 0", ^{
			__block BOOL _testFinished = NO;
			
			__block BOOL _result;
			MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
			spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
				switch (connectionEvent) {
					case MMXConnectionStatusAnonReady:
						break;
					case MMXConnectionStatusUserReady:
						break;
					case MMXConnectionStatusConnected:
						break;
					case MMXConnectionStatusNotConnected:
						break;
					case MMXConnectionStatusDisconnected:
						break;
					case MMXConnectionStatusAuthenticated:{
						MMXTopic * topic = [MMXTopic topicWithName:_randomTopicName maxItemsToPersist:-1 permissionsLevel:MMXPublishPermissionsLevelAnyone];
						[mmxClient.pubsubManager subscribeToTopic:topic device:nil success:^(MMXTopicSubscription *subscription) {
							[mmxClient.pubsubManager listSubscriptionsWithSuccess:^(NSArray *subscriptions) {
								if (subscriptions.count > 0) {
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
						} failure:^(NSError *error) {
							if (error.code == 409) {
								[mmxClient.pubsubManager listSubscriptionsWithSuccess:^(NSArray *subscriptions) {
									if (subscriptions.count > 0) {
										_result = YES;
										_testFinished = YES;
									}
									_result = NO;
									_testFinished = YES;
								} failure:^(NSError *error) {
									_result = NO;
									_testFinished = YES;
								}];
							}
						}];
					}
					case MMXConnectionStatusAuthenticationFailure:break;
					case MMXConnectionStatusFailed:break;
					case MMXConnectionStatusReconnecting:break;
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
