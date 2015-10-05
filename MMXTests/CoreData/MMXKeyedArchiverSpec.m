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
#import "MMXKeyedArchiver.h"
#import "MMXKeyedUnarchiver.h"

SPEC_BEGIN(MMXKeyedArchiverSpec)

    describe(@"MMXKeyedArchiver", ^{

        context(@"archivedDataWithRootObject", ^{

//            context(@"should return nil", ^{
//
//                it(@"when nil is input", ^{
//                    [[[MMXKeyedArchiver archivedDataWithRootObject:nil] should] beNil];
//                });
//
//                it(@"when [NSNull null] is input", ^{
//                    [[[MMXKeyedArchiver archivedDataWithRootObject:[NSNull null]] should] beNil];
//                });
//            });

            context(@"should archive the object", ^{
                it(@"when string is input", ^{
                    id archivedData = [MMXKeyedArchiver archivedDataWithRootObject:@"Hello Magnet"];
                    id __unused unarchivedData = [MMXKeyedUnarchiver unarchiveObjectWithData:archivedData];
                    [[archivedData should] beNonNil];
                    [[archivedData should] beKindOfClass:[NSData class]];
                    [[archivedData should] equal:archivedData];
                });
            });

        });
    });
SPEC_END
