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
#import "MMXRemoteNotification.h"

#define DEFAULT_TEST_TIMEOUT 5.0

SPEC_BEGIN(MMXRemoteNotificationSpec)

    describe(@"MMXRemoteNotification", ^{

        context(@"isWakeupRemoteNotification", ^{

            context(@"should return YES", ^{

                it(@"when the remote notification is sent by MMX", ^{
                    NSDictionary *userInfo = @{
                            @"_mmx" : @{
                                    @"ty" : @"mmx:w:retrieve",
                            }
                    };
                    [[theValue([MMXRemoteNotification isMMXRemoteNotification:userInfo]) should] beYes];
                });
            });

            context(@"should return NO", ^{
                it(@"when the remote notification is not sent by MMX", ^{
                    NSDictionary *userInfo = @{
                            @"foo" : @"bar"
                    };
                    [[theValue([MMXRemoteNotification isMMXRemoteNotification:userInfo]) should] beNo];
                });
            });
        });

        context(@"isWakeupRemoteNotification", ^{

            context(@"should return YES", ^{

                it(@"when the remote notification is pubsub", ^{
                    NSDictionary *userInfo = @{
                            @"_mmx" : @{
                                    @"ty" : @"pubsub",
                            }
                    };
                    [[theValue([MMXRemoteNotification isWakeupRemoteNotification:userInfo]) should] beYes];
                });
                
                it(@"when the remote notification is from direct message", ^{
                    NSDictionary *userInfo = @{
                                               @"_mmx" : @{
                                                       @"ty" : @"retrieve",
                                                       }
                                               };
                    [[theValue([MMXRemoteNotification isWakeupRemoteNotification:userInfo]) should] beYes];
                });

            });

            context(@"should return NO", ^{
                it(@"when the remote notification has no type", ^{
                    NSDictionary *userInfo = @{
                            @"_mmx" : @{
                            }
                    };
                    [[theValue([MMXRemoteNotification isWakeupRemoteNotification:userInfo]) should] beNo];
                });

                it(@"when the remote notification is of the incorrect type", ^{
                    NSDictionary *userInfo = @{
                            @"_mmx" : @{
                                    @"ty" : @"mmx:w:foobar",
                            }
                    };
                    [[theValue([MMXRemoteNotification isWakeupRemoteNotification:userInfo]) should] beNo];
                });
            });
        });

        context(@"acknowledgeRemoteNotification", ^{

            context(@"should return NO in the completion block", ^{

                it(@"when the remote notification is of the incorrect type", ^{
                    NSDictionary *userInfo = @{
                            @"_mmx" : @{
                                    @"ty" : @"mmx:p:foobar",
                            }
                    };
                    __block BOOL _success = YES;
                    [MMXRemoteNotification acknowledgeRemoteNotification:userInfo completion:^(BOOL success) {
                        _success = NO;
                    }];
                    [[expectFutureValue(theValue(_success)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beNo];
                });

                it(@"when the remote notification does not have a callback URL", ^{
                    NSDictionary *userInfo = @{
                            @"_mmx" : @{
                                    @"ty" : @"mmx:p:",
                            }
                    };
                    __block BOOL _success = YES;
                    [MMXRemoteNotification acknowledgeRemoteNotification:userInfo completion:^(BOOL success) {
                        _success = NO;
                    }];
                    [[expectFutureValue(theValue(_success)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beNo];
                });
            });

            context(@"should return YES in the completion block", ^{

                it(@"when the remote notification is of the correct type and has a valid callback URL", ^{
                    KWCaptureSpy *requestSpy = [NSURLConnection captureArgument:@selector(sendAsynchronousRequest:queue:completionHandler:) atIndex:0];
                    KWCaptureSpy *queueSpy = [NSURLConnection captureArgument:@selector(sendAsynchronousRequest:queue:completionHandler:) atIndex:1];
//                    KWCaptureSpy *completionSpy = [NSURLConnection captureArgument:@selector(sendAsynchronousRequest:queue:completionHandler:) atIndex:2];
                            NSDictionary *userInfo = @{
                            @"_mmx" : @{
                                    @"ty" : @"mmx:p:",
                                    @"cu" : @"https://github.com"
                            }
                    };
                    __block BOOL _success = NO;
                    [MMXRemoteNotification acknowledgeRemoteNotification:userInfo completion:^(BOOL success) {
                        _success = success;
                    }];
                    NSMutableURLRequest *request = requestSpy.argument;
                    [[request.HTTPMethod should] equal:@"POST"];
                    [[request.URL should] equal:[NSURL URLWithString:userInfo[@"_mmx"][@"cu"]]];

                    NSOperationQueue *queue = queueSpy.argument;
                    [[queue should] equal:[NSOperationQueue mainQueue]];

//                    void (^block)(BOOL) = completionSpy.argument;
                    [[expectFutureValue(theValue(_success)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
                });
            });
        });
    });
SPEC_END