/**
 * Copyright (c) 2012-2015 Magnet Systems, Inc. All rights reserved.
 */

#import <Kiwi/Kiwi.h>
#import "MMX.h"
#import "MMXDeviceManager.h"
#import "MMXDeviceManager_Private.h"
@import MagnetMobileServer;

#define DEFAULT_TEST_TIMEOUT 10.0

SPEC_BEGIN(MMXMessageSpec)

    describe(@"MMXMessage", ^{

        NSString *senderUsername = [NSString stringWithFormat:@"sender_%f", [[NSDate date] timeIntervalSince1970]];
        NSString *senderPassword = @"magnet";
        NSURLCredential *senderCredential = [NSURLCredential credentialWithUser:senderUsername
                                                                       password:senderPassword
                                                                    persistence:NSURLCredentialPersistenceNone];

        NSString *receiverUsername = [NSString stringWithFormat:@"receiver_%f", [[NSDate date] timeIntervalSince1970]];
        NSString *receiverPassword = @"magnet";
        NSURLCredential *receiverCredential = [NSURLCredential credentialWithUser:receiverUsername
                                                                         password:receiverPassword
                                                                      persistence:NSURLCredentialPersistenceNone];

        MMUser *sender = [[MMUser alloc] init];
        sender.userName = senderUsername;

        MMUser *receiver = [[MMUser alloc] init];
        receiver.userName = receiverUsername;

        NSString *receiverDeviceID = [[NSUUID UUID] UUIDString];

        NSDictionary *messageContent = @{
                @"message": @"Hello Magnet"
        };

        __block NSString *_messageID;

        beforeAll(^{
            [MMXLogger sharedLogger].level = MMXLoggerLevelVerbose;
            [[MMXLogger sharedLogger] startLogging];

            [MMX setupWithConfiguration:@"default"];
            [MMX start];

            __block BOOL _isSuccess = NO;

			[MMUser logout:^{
                _isSuccess = YES;
            } failure:^(NSError *error) {
                _isSuccess = NO;
            }];

            [[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
        });

		context(@"when sending a message", ^{

            it(@"should return success if the user is valid", ^{

                MMXMessage *message = [MMXMessage messageToRecipients:[NSSet setWithArray:@[receiver]]
                                                       messageContent:messageContent];

                __block BOOL _isSuccess = NO;
				
				[MMUser login:senderCredential success:^{
                    _messageID = [message sendWithSuccess:^{
                        _isSuccess = YES;
                    }                             failure:^(NSError *error) {
                        _isSuccess = NO;
                    }];
                }                    failure:^(NSError *error) {
                    _isSuccess = NO;
                }];

                [[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
            });

            afterAll(^{

                __block BOOL _isSuccess = NO;

				[MMUser logout:^{
					_isSuccess = YES;
				} failure:^(NSError *error) {
					_isSuccess = NO;
				}];

                [[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
            });
        });

        context(@"when receiving a message", ^{

            it(@"should return the message", ^{

                __block BOOL _isSuccess = NO;

                NSString *originalDeviceID = [MMXDeviceManager deviceUUID];

                [MMXDeviceManager stub:@selector(deviceUUID) andReturn:receiverDeviceID];

				[MMUser login:receiverCredential success:^{
                    [MMXDeviceManager stub:@selector(deviceUUID) andReturn:originalDeviceID];
                    _isSuccess = YES;
                }                    failure:^(NSError *error) {
                    _isSuccess = NO;
                }];

                __block MMXMessage *receivedMessage;

                [[MMXDidReceiveMessageNotification shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] bePostedEvaluatingBlock:^(NSNotification *notification){
                    receivedMessage = notification.userInfo[MMXMessageKey];
                    NSLog(@"sent message with messageID: %@", _messageID);
                    NSLog(@"received message with messageID: %@", receivedMessage.messageID);
                }];

                // FIXME: Below two issues need to be fixed!
//                [[expectFutureValue(receivedMessage.messageID) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:_messageID];
                [[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
                [[expectFutureValue(receivedMessage.messageID) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beNonNil];
                [[expectFutureValue(receivedMessage.recipients) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] haveCountOf:1];
                [[expectFutureValue(receivedMessage.messageContent) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:messageContent];
                [[expectFutureValue(theValue(receivedMessage.messageType)) should] equal:theValue(MMXMessageTypeDefault)];
                [[expectFutureValue(receivedMessage.sender.userName) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:senderUsername];
                [[expectFutureValue(receivedMessage.channel) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beNil];

            });

            afterAll(^{

                __block BOOL _isSuccess = NO;

				[MMUser logout:^{
                    _isSuccess = YES;
                } failure:^(NSError *error) {
                    _isSuccess = NO;
                }];

                [[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
            });
        });
    });

SPEC_END