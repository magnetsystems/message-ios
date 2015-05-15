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
#import "MMXDataModel.h"
#import "MMXMessage_Private.h"
#import "MMXOutboxEntry.h"
#import "MMXMessageOptions.h"
#import "MMXUtils.h"
#import "MMXUserID.h"

SPEC_BEGIN(MMXDataModelSpec)

describe(@"MMXDataModel", ^{

    context(@"sharedDataModel", ^{
        it(@"should return a singleton", ^{
            MMXDataModel *dataModel = [MMXDataModel sharedDataModel];
            MMXDataModel *anotherDataModel = [MMXDataModel sharedDataModel];
            [[dataModel should] beIdenticalTo:anotherDataModel];
        });

    });

    context(@"addOutboxEntryWithMessage", ^{

        __block MMXMessage *_message;
        __block MMXMessageOptions *_messageOptions;
        __block MMXUserID *_testuser;

        beforeEach(^{
			_testuser = [MMXUserID userIDWithUsername:@"testuser"];
            _message = [MMXMessage messageTo:_testuser
                                 withContent:@"Hello World"
                                 messageType:@"text/plain"
                                    metaData:@{@"foo" : @"bar"}];
			_message.messageID = [MMXUtils generateUUID];
            _messageOptions = [[MMXMessageOptions alloc] init];
            // Defaults to NO
//            _messageOptions.shouldRequestDeliveryReceipt = NO;
        });

        context(@"should throw an exception", ^{
            it(@"when message is missing", ^{
                [[theBlock(^{
                    [[MMXDataModel sharedDataModel] addOutboxEntryWithMessage:nil options:nil username:@"testuser"];
                }) should] raiseWithName:NSInternalInconsistencyException];
            });

            it(@"when username is missing", ^{
                [[theBlock(^{
                    [[MMXDataModel sharedDataModel] addOutboxEntryWithMessage:_message options:nil username:nil];
                }) should] raiseWithName:NSInternalInconsistencyException];
            });
        });

        context(@"should not return nil", ^{
            it(@"when all required parameters are passed", ^{
                MMXOutboxEntry *outboxEntry = [[MMXDataModel sharedDataModel] addOutboxEntryWithMessage:_message options:nil username:_testuser.username];
                [[outboxEntry should] beNonNil];
                MMXMessage *message = [[MMXDataModel sharedDataModel] extractMessageFromOutboxEntry:outboxEntry];
                [[message shouldNot] beNil];
                MMXMessageOptions *messageOptions = [[MMXDataModel sharedDataModel] extractMessageOptionsFromOutboxEntry:outboxEntry];
                [[messageOptions should] beNil];
                NSArray *outboxEntries = [[MMXDataModel sharedDataModel] outboxEntriesForUser:_testuser.username outboxEntryMessageType:MMXOutboxEntryMessageTypeDefault];
                [[outboxEntries should] haveCountOf:1];
                // Cleanup
                [[MMXDataModel sharedDataModel] deleteOutboxEntryForMessage:outboxEntry.messageID];
            });

            it(@"when all parameters are passed", ^{
                MMXOutboxEntry *outboxEntry = [[MMXDataModel sharedDataModel] addOutboxEntryWithMessage:_message
                                                                                                options:_messageOptions
                                                                                               username:_testuser.username];
                [[outboxEntry should] beNonNil];
                MMXMessage *message = [[MMXDataModel sharedDataModel] extractMessageFromOutboxEntry:outboxEntry];
                [[message shouldNot] beNil];
                MMXMessageOptions *messageOptions = [[MMXDataModel sharedDataModel] extractMessageOptionsFromOutboxEntry:outboxEntry];
                [[messageOptions shouldNot] beNil];
                NSArray *outboxEntries = [[MMXDataModel sharedDataModel] outboxEntriesForUser:_testuser.username outboxEntryMessageType:MMXOutboxEntryMessageTypeDefault];
                [[outboxEntries should] haveCountOf:1];
                // Cleanup
                [[MMXDataModel sharedDataModel] deleteOutboxEntryForMessage:outboxEntry.messageID];
            });
        });
    });

    context(@"outboxEntriesForUser", ^{

        __block MMXMessage *_message;
        __block MMXUserID *_testuser;

        beforeEach(^{
			_testuser = [MMXUserID userIDWithUsername:@"testuser"];
            _message = [MMXMessage messageTo:_testuser
                                 withContent:@"Hello World"
                                 messageType:@"text/plain"
                                    metaData:@{@"foo" : @"bar"}];
			_message.messageID = [MMXUtils generateUUID];
        });

        context(@"should return 0 items", ^{
            it(@"when the user does not have any messages", ^{
                NSArray *outboxEntries = [[MMXDataModel sharedDataModel] outboxEntriesForUser:@"nomessagesforme" outboxEntryMessageType:MMXOutboxEntryMessageTypeDefault];
                [[outboxEntries should] haveCountOf:0];
            });
        });

        context(@"should not return 0 items", ^{
            it(@"when the user has messages", ^{
                MMXOutboxEntry *outboxEntry = [[MMXDataModel sharedDataModel] addOutboxEntryWithMessage:_message options:nil username:_testuser.username];
                NSArray *outboxEntries = [[MMXDataModel sharedDataModel] outboxEntriesForUser:_testuser.username outboxEntryMessageType:MMXOutboxEntryMessageTypeDefault];
                [[outboxEntries should] haveCountOf:1];
                // Cleanup
                [[MMXDataModel sharedDataModel] deleteOutboxEntryForMessage:outboxEntry.messageID];
            });
        });
    });

    context(@"deleteOutboxEntryForMessage", ^{

        __block MMXMessage *_message;
        __block MMXUserID *_testuser;

        beforeEach(^{
			_testuser = [MMXUserID userIDWithUsername:@"testuser"];
            _message = [MMXMessage messageTo:_testuser
                                 withContent:@"Hello World"
                                 messageType:@"text/plain"
                                    metaData:@{@"foo" : @"bar"}];
			_message.messageID = [MMXUtils generateUUID];
        });

        context(@"should return 0 items", ^{
            it(@"when the entry is deleted", ^{
                MMXOutboxEntry *outboxEntry = [[MMXDataModel sharedDataModel] addOutboxEntryWithMessage:_message options:nil username:_testuser.username];
                NSArray *outboxEntries = [[MMXDataModel sharedDataModel] outboxEntriesForUser:_testuser.username outboxEntryMessageType:MMXOutboxEntryMessageTypeDefault];
                [[outboxEntries should] haveCountOf:1];
                [[MMXDataModel sharedDataModel] deleteOutboxEntryForMessage:outboxEntry.messageID];
                NSArray *outboxEntriesAfterDelete = [[MMXDataModel sharedDataModel] outboxEntriesForUser:_testuser.username outboxEntryMessageType:MMXOutboxEntryMessageTypeDefault];
                [[outboxEntriesAfterDelete should] haveCountOf:0];
            });
        });
    });

    context(@"extractMessageFromOutboxEntry", ^{

        __block MMXMessage *_message;
        __block MMXUserID *_testuser;

        beforeEach(^{
			_testuser = [MMXUserID userIDWithUsername:@"testuser"];
            _message = [MMXMessage messageTo:_testuser
                                 withContent:@"Hello World"
                                 messageType:@"text/plain"
                                    metaData:@{@"foo" : @"bar"}];
			_message.messageID = [MMXUtils generateUUID];
        });

        context(@"should return 0 items", ^{
            it(@"when the entry is deleted", ^{
                MMXOutboxEntry *outboxEntry = [[MMXDataModel sharedDataModel] addOutboxEntryWithMessage:_message options:nil username:_testuser.username];
                MMXMessage *message = [[MMXDataModel sharedDataModel] extractMessageFromOutboxEntry:outboxEntry];
                [[message.messageID shouldNot] beNil];
                [[message.messageContent should] equal:@"Hello World"];
                [[message.metaData should] equal:@{@"foo" : @"bar"}];
                // Cleanup
                [[MMXDataModel sharedDataModel] deleteOutboxEntryForMessage:outboxEntry.messageID];
            });
        });
    });

    context(@"extractMessageOptionsFromOutboxEntry", ^{

        __block MMXMessage *_message;
        __block MMXMessageOptions *_messageOptions;
        __block MMXUserID *_testuser;

        beforeEach(^{
			_testuser = [MMXUserID userIDWithUsername:@"testuser"];
            _message = [MMXMessage messageTo:_testuser
                                 withContent:@"Hello World"
                                 messageType:@"text/plain"
                                    metaData:@{@"foo" : @"bar"}];

			_message.messageID = [MMXUtils generateUUID];
            _messageOptions = [[MMXMessageOptions alloc] init];
            // Defaults to NO
//            _messageOptions.shouldRequestDeliveryReceipt = NO;
        });

        context(@"should return 0 items", ^{
            it(@"when the entry is deleted", ^{
                MMXOutboxEntry *outboxEntry = [[MMXDataModel sharedDataModel] addOutboxEntryWithMessage:_message options:_messageOptions username:_testuser.username];
                MMXMessageOptions *messageOptions = [[MMXDataModel sharedDataModel] extractMessageOptionsFromOutboxEntry:outboxEntry];
                [[theValue(messageOptions.shouldRequestDeliveryReceipt) should] beNo];
                // Cleanup
                [[MMXDataModel sharedDataModel] deleteOutboxEntryForMessage:outboxEntry.messageID];
            });
        });
    });
});
SPEC_END
