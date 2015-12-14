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
@import MagnetMax;
@import MMX;

#define DEFAULT_TEST_TIMEOUT 10.0

SPEC_BEGIN(MMXServerOfflineSpec)

describe(@"MMXServerOfflineSpec", ^{
    
    context(@"Sending a push", ^{
        
        it(@"should fail if user not logged in", ^{
            __block BOOL _isSuccess = YES;
            
            MMUser *badUser = [[MMUser alloc] init];
            badUser.userName = @"badUserName";
            badUser.password = @"badPassword";
            
            MMXPushMessage  *pmsg = [MMXPushMessage pushMessageWithRecipient:badUser
                                                                        body:@"Test Push"];
            
            [pmsg sendPushMessage:^{
                _isSuccess = YES;
            } failure:^(NSError * error) {
                _isSuccess = NO;
            }];
            
            [[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beNo];
        });
        
        it(@"should return a completion block if server is offline", ^{
            __block BOOL _isSuccess = NO;
            
            NSString *senderUsername = [NSString stringWithFormat:@"sender_%f", [[NSDate date] timeIntervalSince1970]];
            NSString *senderPassword = @"magnet";
            NSURLCredential *senderCredential = [NSURLCredential credentialWithUser:senderUsername
                                                                           password:senderPassword
                                                                        persistence:NSURLCredentialPersistenceNone];
            
            MMUser *sender = [[MMUser alloc] init];
            sender.userName = senderUsername;
            sender.password = senderPassword;
            
            [sender register:^(MMUser * _Nonnull user) {
                [MMUser login:senderCredential success:^{
                    [MagnetMax initModule:[MMX sharedInstance] success:^{
                        [MMX start];
                        MMXPushMessage  *pmsg = [MMXPushMessage pushMessageWithRecipient:sender
                                                                                    body:@"Test Push"];
                        
                        [pmsg sendPushMessage:^{
                            _isSuccess = YES;
                        } failure:^(NSError * error) {
                            _isSuccess = YES;
                        }];
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
    });
});

SPEC_END