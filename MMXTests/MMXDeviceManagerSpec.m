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
#import "MMX.h"
#import "MMXClientDelegateSpy.h"
#import "MMXUtils.h"
#import "MMXTestingUtils.h"

#define DEFAULT_TEST_TIMEOUT 15.0

SPEC_BEGIN(MMXDeviceManagerSpec)

describe(@"MMXDeviceManager", ^{
    
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

	context(@"when calling currentDeviceWithSuccess:", ^{
		it(@"should receive a success response and return a valid MMXDevice", ^{
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
						[mmxClient.deviceManager currentDeviceProfileWithSuccess:^(MMXDeviceProfile *device) {
							if (device &&
								[MMXUtils objectIsValidString:device.endpoint.deviceID] &&
								[MMXUtils objectIsValidString:device.displayName] &&
								[MMXUtils objectIsValidString:device.osType]) {
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
	
	//FIXME: Rewrite this test or figure out why it fails when run via Xcode and passes with rake test
	context(@"when calling setDeviceName:", ^{
		it(@"should receive a success response and the deviceName should be different", ^{
			__block BOOL _testFinished = NO;
			
			__block BOOL _result;
			NSString * _randomDeviceName = [NSString stringWithFormat:@"device%f",[[NSDate date] timeIntervalSince1970]];
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
						[mmxClient.deviceManager setCurrentDeviceName:_randomDeviceName success:^(BOOL success) {
							[mmxClient.deviceManager currentDeviceProfileWithSuccess:^(MMXDeviceProfile *device) {
								if (device &&
									[MMXUtils objectIsValidString:device.endpoint.deviceID] &&
									[MMXUtils objectIsValidString:device.displayName] &&
									[MMXUtils objectIsValidString:device.osType] &&
									[device.displayName isEqualToString:_randomDeviceName]) {
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
	
	context(@"when calling deregisterCurrentDeviceWithSuccess:", ^{
		it(@"should receive a success response and should disconnect", ^{
			__block BOOL _testFinished = NO;
			
			__block BOOL _deregisterResult;
			__block BOOL _disconnectResult;
			MMXClientDelegateSpy *spy = [MMXClientDelegateSpy spy];
			spy.receivedConnectionEventBlock = ^(MMXClient *client, MMXConnectionStatus connectionEvent, NSError * error) {
				switch (connectionEvent) {
					case MMXConnectionStatusConnected:
						break;
					case MMXConnectionStatusNotConnected:
						break;
					case MMXConnectionStatusDisconnected:
						_disconnectResult = YES;
						_testFinished = YES;
						break;
					case MMXConnectionStatusAuthenticated:{
						[mmxClient.deviceManager deregisterCurrentDeviceWithSuccess:^(BOOL success) {
							_deregisterResult = YES;
						} failure:^(NSError *error) {
							_deregisterResult = NO;
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
			
			[[expectFutureValue(theValue(_deregisterResult)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
			[[expectFutureValue(theValue(_disconnectResult)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
			[[expectFutureValue(theValue(_testFinished)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
	});
	
	context(@"when calling setDevicePhoneNumber:", ^{
		it(@"should receive a success response and the phoneNumber should be updated", ^{
			__block BOOL _testFinished = NO;
			
			__block BOOL _result;
			__block NSString * _randomPhoneNumber = [NSString stringWithFormat:@"%lu",(unsigned long)arc4random_uniform(100000)+1000000000];
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
						[mmxClient.deviceManager setCurrentDevicePhoneNumber:_randomPhoneNumber success:^(BOOL success) {
							[mmxClient.deviceManager currentDeviceProfileWithSuccess:^(MMXDeviceProfile *device) {
								if (device &&
									[MMXUtils objectIsValidString:device.endpoint.deviceID] &&
									[MMXUtils objectIsValidString:device.displayName] &&
									[MMXUtils objectIsValidString:device.osType] &&
									[device.phoneNumber isEqualToString:_randomPhoneNumber]) {
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

	context(@"when calling tagsForDevice:", ^{
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
						[mmxClient.deviceManager currentDeviceProfileWithSuccess:^(MMXDeviceProfile *device) {
							[mmxClient.deviceManager tagsForDevice:device success:^(NSDate *lastModified, NSArray *tags) {
								if (tags) {
									_result = YES;
									_testFinished = YES;
								}
							} failure:^(NSError *error) {
								_result = NO;
								_testFinished = YES;
							}];
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

	context(@"when calling addTags:forDevice:", ^{
		it(@"should receive a success response and the new tags should be on the list when calling tagsForDevice:", ^{
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
						[mmxClient.deviceManager currentDeviceProfileWithSuccess:^(MMXDeviceProfile *device) {
							[mmxClient.deviceManager addTags:@[_randomTag] forDevice:device success:^(BOOL success) {
								[mmxClient.deviceManager tagsForDevice:device success:^(NSDate *lastModified, NSArray *tags) {
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


});
SPEC_END
