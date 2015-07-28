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
#import "MMXClient.h"
#import "MMXClientDelegateSpy.h"
#import "MMXConstants.h"
#import "MMXLogger.h"
#import "MMXConfiguration.h"
#import "MMXTestingUtils.h"

#define DEFAULT_TEST_TIMEOUT 15.0

SPEC_BEGIN(MMXClientSpec)

describe(@"MMXClient", ^{

    __block id clientDelegateMock;
    __block MMXClient *mmxClient;
    __block MMXConfiguration *mmxConfiguration;

    beforeAll(^{
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

    context(@"when calling sharedClient", ^{

        it(@"should return a singleton", ^{
            MMXClient *client = [MMXClient sharedClient];
            MMXClient *anotherClient = [MMXClient sharedClient];
            [[client should] beIdenticalTo:anotherClient];
        });
    });
    
    context(@"when connecting anonymously for the first time", ^{
        it(@"should receive the delegate callback", ^{
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMMXDeviceUUID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [mmxClient connectAnonymous];
            
            [[clientDelegateMock shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] receive:@selector(client:didReceiveConnectionStatusChange:error:) withArguments:mmxClient, theValue(MMXConnectionStatusConnected), nil];
            
            
            //            [[[[NSUserDefaults standardUserDefaults] objectForKey:kMMXDeviceUUID] should] beMemberOfClass:[NSString class]];
        });
    });
    
    context(@"when connecting anonymously with a previously saved device UUID", ^{
        it(@"should receive the delegate callback", ^{
            
			[[NSUserDefaults standardUserDefaults] setObject:@"47296A01-4F65-4801-B7F1-B815F6DF911F" forKey:kMMXDeviceUUID];
			[[NSUserDefaults standardUserDefaults] setObject:@"_anon-47296A01-4F65-4801-B7F1-B815F6DF911F" forKey:kMMXAnonPassword];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [mmxClient connectAnonymous];
            
            [[clientDelegateMock shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] receive:@selector(client:didReceiveConnectionStatusChange:error:) withArguments:mmxClient, theValue(MMXConnectionStatusConnected),nil];
            
        });
    });

    context(@"when connecting with a username and password that are valid for the server", ^{
        it(@"should receive the delegate callback", ^{
            
            mmxClient.configuration.credential = [NSURLCredential credentialWithUser:@"testuser" password:@"testuser" persistence:NSURLCredentialPersistenceNone];
            [mmxClient connectWithCredentials];
            
            [[clientDelegateMock shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] receive:@selector(client:didReceiveConnectionStatusChange:error:) withArguments:mmxClient, theValue(MMXConnectionStatusAuthenticated),nil];
            
        });
    });
    
    context(@"when connecting with a username and password that are not valid because the username is too short", ^{
        it(@"should receive the delegate callback", ^{
            
            __block BOOL _testFinished = NO;
            
            MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
            spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
                [[error should] beNonNil];
                [[theValue(error.code) should] equal:theValue(400)];
                [[error.domain should] equal:MMXErrorDomain];
                _testFinished = YES;
            };
            [clientDelegateMock addMessageSpy:spy
                            forMessagePattern:[KWMessagePattern messagePatternWithSelector:@selector(client:didReceiveConnectionStatusChange:error:)]];
            mmxClient.configuration.credential = [NSURLCredential credentialWithUser:@"test" password:@"testuser" persistence:NSURLCredentialPersistenceNone];
            [mmxClient connectWithCredentials];
            
            [[expectFutureValue(theValue(_testFinished)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
            
        });
    });
    
    context(@"when connecting with a username and password that are not valid because the username is too long", ^{
        it(@"should receive the delegate callback", ^{
            
            __block BOOL _testFinished = NO;
            
            MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
            spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
                [[error should] beNonNil];
                [[theValue(error.code) should] equal:theValue(400)];
                [[error.domain should] equal:MMXErrorDomain];
                _testFinished = YES;
            };
            [clientDelegateMock addMessageSpy:spy
                            forMessagePattern:[KWMessagePattern messagePatternWithSelector:@selector(client:didReceiveConnectionStatusChange:error:)]];
            mmxClient.configuration.credential = [NSURLCredential credentialWithUser:[MMXTestingUtils randomStringWithLength:43] password:@"testuser" persistence:NSURLCredentialPersistenceNone];
            [mmxClient connectWithCredentials];
            
            [[expectFutureValue(theValue(_testFinished)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
            
        });
    });
    
    context(@"when connecting with a username and password that are not valid because the password is too short", ^{
        it(@"should receive the delegate callback", ^{
            
            __block BOOL _testFinished = NO;
            
            MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
            spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
                [[error should] beNonNil];
                [[theValue(error.code) should] equal:theValue(400)];
                [[error.domain should] equal:MMXErrorDomain];
                _testFinished = YES;
            };
            [clientDelegateMock addMessageSpy:spy
                            forMessagePattern:[KWMessagePattern messagePatternWithSelector:@selector(client:didReceiveConnectionStatusChange:error:)]];
            mmxClient.configuration.credential = [NSURLCredential credentialWithUser:@"json" password:[MMXTestingUtils randomStringWithLength:0] persistence:NSURLCredentialPersistenceNone];
            [mmxClient connectWithCredentials];
            
            [[expectFutureValue(theValue(_testFinished)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
            
        });
    });
    
    context(@"when connecting with a username and password that are not valid because the password is too long", ^{
        it(@"should receive the delegate callback", ^{
            
            __block BOOL _testFinished = NO;
            
            MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
            spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
                [[error should] beNonNil];
                [[theValue(error.code) should] equal:theValue(400)];
                [[error.domain should] equal:MMXErrorDomain];
                _testFinished = YES;
            };
            [clientDelegateMock addMessageSpy:spy
                            forMessagePattern:[KWMessagePattern messagePatternWithSelector:@selector(client:didReceiveConnectionStatusChange:error:)]];
            mmxClient.configuration.credential = [NSURLCredential credentialWithUser:@"json" password:[MMXTestingUtils randomStringWithLength:33] persistence:NSURLCredentialPersistenceNone];
            [mmxClient connectWithCredentials];
            
            [[expectFutureValue(theValue(_testFinished)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
            
        });
    });
    
    context(@"when connecting with a username and password that are not valid because the username contains invalid characters", ^{
        it(@"should receive the delegate callback", ^{
            
            __block BOOL _testFinished = NO;
            
            MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
            spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
                [[error should] beNonNil];
                [[theValue(error.code) should] equal:theValue(400)];
                [[error.domain should] equal:MMXErrorDomain];
                _testFinished = YES;
            };
            [clientDelegateMock addMessageSpy:spy
                            forMessagePattern:[KWMessagePattern messagePatternWithSelector:@selector(client:didReceiveConnectionStatusChange:error:)]];
            NSString * username = [NSString stringWithFormat:@"testuser%@",[MMXTestingUtils randomInvalidCharacter]];
            mmxClient.configuration.credential = [NSURLCredential credentialWithUser:username password:@"testuser" persistence:NSURLCredentialPersistenceNone];
            [mmxClient connectWithCredentials];
            
            [[expectFutureValue(theValue(_testFinished)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
            
        });
    });
    
    context(@"when connecting with a username and password that do not exist", ^{
        it(@"should autocreate a user when shouldAutoCreateUser is set to yes", ^{
            
            NSString * username = [NSString stringWithFormat:@"random%d",(int)[[NSDate date] timeIntervalSince1970]];
            mmxClient.configuration.credential = [NSURLCredential credentialWithUser:username password:username persistence:NSURLCredentialPersistenceNone];
            mmxClient.shouldAutoCreateUser = YES;
            [mmxClient connectWithCredentials];
            
            [[clientDelegateMock shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] receive:@selector(client:didReceiveConnectionStatusChange:error:) withArguments:mmxClient, theValue(MMXConnectionStatusAuthenticated),nil];
            
        });
    });

    context(@"when closing the stream with the server by using the disconnect method", ^{
        it(@"should receive the delegate callback", ^{
            __block BOOL _testFinished = NO;
            
            MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
            spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
                switch (connectionEvent) {
                    case MMXConnectionStatusConnected:
                        break;
                    case MMXConnectionStatusNotConnected:
                        break;
                    case MMXConnectionStatusDisconnected:
                        _testFinished = YES;
                        break;
                    case MMXConnectionStatusAuthenticated:{
                        [mmxClient disconnect];
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
            
            [[clientDelegateMock shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] receive:@selector(client:didReceiveConnectionStatusChange:error:) withArguments:mmxClient, theValue(MMXConnectionStatusDisconnected),nil];
            [[expectFutureValue(theValue(_testFinished)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
        });
    });

    context(@"when authenticating and going anonymous", ^{
        it(@"should receive the delegate callback", ^{
            __block BOOL _testFinished = NO;

            MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
            spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
                switch (connectionEvent) {
                    case MMXConnectionStatusConnected:{
                        _testFinished = YES;
                        break;
                    }
                    case MMXConnectionStatusNotConnected:
                        break;
                    case MMXConnectionStatusDisconnected:break;
                    case MMXConnectionStatusAuthenticated:{
                        [mmxClient goAnonymous];
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

            [[clientDelegateMock shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] receive:@selector(client:didReceiveConnectionStatusChange:error:) withArguments:mmxClient, theValue(MMXConnectionStatusAuthenticated),nil];
            [[clientDelegateMock shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] receive:@selector(client:didReceiveConnectionStatusChange:error:) withArguments:mmxClient, theValue(MMXConnectionStatusConnected),nil];
            [[expectFutureValue(theValue(_testFinished)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
        });
    });
});

SPEC_END
