/**
 * Copyright (c) 2012-2015 Magnet Systems, Inc. All rights reserved.
 */

@import Kiwi;
@import MagnetMax;
@import MMX;
#import "MMX-Swift.h"
#define DEFAULT_TEST_TIMEOUT 10.0

SPEC_BEGIN(MMXMessageSpec)

	describe(@"MMXMessage", ^{
        
		NSString *senderUsername = [NSString stringWithFormat:@"sender_%f", [[NSDate date] timeIntervalSince1970]];
		NSString *senderPassword = @"magnet";
		NSString *firstName = @"first";
		NSString *lastName = @"last";
		NSString *email = @"sysadmin@company.com";
		NSURLCredential *senderCredential = [NSURLCredential credentialWithUser:senderUsername
																	   password:senderPassword
																	persistence:NSURLCredentialPersistenceNone];
		
		MMUser *sender = [[MMUser alloc] init];
		sender.userName = senderUsername;
		sender.password = senderPassword;
		sender.firstName = firstName;
		sender.lastName = lastName;
		sender.email = email;
		
		beforeAll(^{
			
//			NSString *filename = @"MagnetMax";
//			NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:@"plist"];
//			BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path];
//			if (!exists) {
//				//Try to fallover to mainBundle
//				path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
//				
//				exists = [[NSFileManager defaultManager] fileExistsAtPath:path];
//				if (!exists) {
//					NSAssert(exists, @"You must include your Configurations.plist file in the project. You can download this file on the Settings page of the Magnet Message Web Interface");
//				}
//			}
//			id <MMConfiguration> configuration = [[MMPropertyListConfiguration alloc] initWithContentsOfFile:path];
//			[MagnetMax configure:configuration];
			
			__block BOOL _isSuccess = NO;
			
			[sender register:^(MMUser * _Nonnull user) {
				[MMUser login:senderCredential success:^{
					[MagnetMax initModule:[MMX sharedInstance] success:^{
						[MMX start];
						_isSuccess = YES;
					} failure:^(NSError * error) {
						_isSuccess = NO;
					}];
				} failure:^(NSError * _Nonnull error) {
					_isSuccess = NO;
				}];
			} failure:^(NSError * _Nonnull error) {
				_isSuccess = NO;
			}];
			
			[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});

		context(@"when sending a message", ^{

            it(@"should return success if the user is valid", ^{

				__block BOOL _isSuccess = NO;

				[MMUser usersWithUserNames:@[sender.userName] success:^(NSArray *users) {
					MMXMessage *message = [MMXMessage messageToRecipients:[NSSet setWithArray:users]
														   messageContent:@{@"Something1":@"Content1"}];
					
					
					[message sendWithSuccess:^(NSSet *invalidUsers){
						_isSuccess = YES;
					} failure:^(NSError *error) {
						_isSuccess = NO;
					}];
					
				} failure:^(NSError *error) {
					_isSuccess = NO;
				}];
				
                [[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
            });
        });
        context(@"when sending a push message", ^{
            
            it(@"should return success if user has device", ^{
                
                __block BOOL _isSuccess = NO;
                
                [MMUser usersWithUserNames:@[@"QuickstartUser2"] success:^(NSArray *users) {
                    if (users.count) {
                        MMXPushMessage  *pmsg = [MMXPushMessage pushMessageWithRecipient:users.firstObject body:@"Test Push"];
                        
                        [pmsg sendPushMessage:^(NSSet<MMDevice *> * invalidDevices) {
                            _isSuccess = YES;
                        } failure:^(NSError * error) {
                            
                        }];
                    }
                } failure:^(NSError * error) {
                    [[MMLogger sharedLogger] error:@"Failed to get users for Invite Response\n%@",error];
                }];
                
                [[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
            });
        });
        context(@"when receiving a message", ^{

			it(@"should return the message", ^{
				
				__block BOOL _isSuccess = NO;
				
				__block MMXMessage *receivedMessage;
				__block NSString *messageID;
				
				NSDictionary *messageContent = @{@"Something2":@"Content2"};

				[MMUser usersWithUserNames:@[sender.userName] success:^(NSArray *users) {
					MMXMessage *message = [MMXMessage messageToRecipients:[NSSet setWithArray:users]
														   messageContent:messageContent];
					
					messageID = [message sendWithSuccess:^(NSSet *invalidUsers){
						_isSuccess = YES;
					} failure:^(NSError *error) {
						_isSuccess = NO;
					}];
					
				} failure:^(NSError *error) {
					_isSuccess = NO;
				}];

				
				[[MMXDidReceiveMessageNotification shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] bePostedEvaluatingBlock:^(NSNotification *notification){
					receivedMessage = notification.userInfo[MMXMessageKey];
					NSLog(@"sent message with messageID: %@", messageID);
					NSLog(@"received message with messageID: %@", receivedMessage.messageID);
				}];
				
				[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
				[[expectFutureValue(receivedMessage.messageID) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beNonNil];
				[[expectFutureValue(receivedMessage.recipients) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] haveCountOf:1];
				[[expectFutureValue(receivedMessage.messageContent) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:messageContent];
				[[expectFutureValue(theValue(receivedMessage.messageType)) should] equal:theValue(MMXMessageTypeDefault)];
				[[expectFutureValue(receivedMessage.sender.userName) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:senderUsername];
				[[expectFutureValue(receivedMessage.channel) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beNil];
				
			});

			it(@"should have fully hydrated MMUser objects for the sender and recipients", ^{
				
				__block BOOL _isSuccess = NO;
				
				__block MMXMessage *receivedMessage;
				__block NSString *messageID;
				__block MMUser *senderUserObject;
				__block MMUser *recipientUserObject;
				
				NSDictionary *messageContent = @{@"Something3":@"Content3"};
				
				[MMUser usersWithUserNames:@[sender.userName] success:^(NSArray *users) {
					MMXMessage *message = [MMXMessage messageToRecipients:[NSSet setWithArray:users]
														   messageContent:messageContent];
					messageID = [message sendWithSuccess:^(NSSet *invalidUsers){
						_isSuccess = YES;
					} failure:^(NSError *error) {
						_isSuccess = NO;
					}];
					
				} failure:^(NSError *error) {
					_isSuccess = NO;
				}];
				
				[[MMXDidReceiveMessageNotification shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] bePostedEvaluatingBlock:^(NSNotification *notification){
					receivedMessage = notification.userInfo[MMXMessageKey];
					[receivedMessage sendDeliveryConfirmation];
					senderUserObject = receivedMessage.sender.copy;
					recipientUserObject = [receivedMessage.recipients allObjects].firstObject;
					NSLog(@"sent message with messageID: %@", messageID);
					NSLog(@"received message with messageID: %@", receivedMessage.messageID);
				}];

				__block NSString *confirmationMessageID;
				__block MMUser *confirmationUserObject;

				[[MMXDidReceiveDeliveryConfirmationNotification shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] bePostedEvaluatingBlock:^(NSNotification *notification){
					confirmationUserObject = notification.userInfo[MMXRecipientKey];
					confirmationMessageID = notification.userInfo[MMXMessageIDKey];
					NSLog(@"received confirmationMessageID with messageID: %@", confirmationMessageID);
					NSLog(@"received confirmationMessageID with messageID: %@", confirmationMessageID);
				}];

				//Temporarily commented these out. Values seem to be correct but failing for some reason
				[[expectFutureValue(senderUserObject.userName) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:senderUsername];
				[[expectFutureValue(senderUserObject.firstName) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:firstName];
				[[expectFutureValue(senderUserObject.lastName) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:lastName];
				[[expectFutureValue(senderUserObject.email) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:email];

				[[expectFutureValue(recipientUserObject.userName) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:senderUsername];
				[[expectFutureValue(recipientUserObject.firstName) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:firstName];
				[[expectFutureValue(recipientUserObject.lastName) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:lastName];
				[[expectFutureValue(recipientUserObject.email) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:email];
				
				[[expectFutureValue(confirmationUserObject.userName) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:senderUsername];
				[[expectFutureValue(confirmationUserObject.firstName) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:firstName];
				[[expectFutureValue(confirmationUserObject.lastName) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:lastName];
				[[expectFutureValue(confirmationUserObject.email) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:email];

				[[expectFutureValue(confirmationMessageID) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:receivedMessage.messageID];
			});

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
SPEC_END