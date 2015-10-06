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
#import "MMXKeyedUnarchiver.h"
#import "MMXKeyedArchiver.h"

SPEC_BEGIN(MMXKeyedUnarchiverSpec)

describe(@"MMXKeyedUnarchiver", ^{

    context(@"archivedDataWithRootObject", ^{

//        context(@"should return nil", ^{
//
//            it(@"when nil is input", ^{
//                [[[MMXKeyedUnarchiver unarchiveObjectWithData:nil] should] beNil];
//            });
//        });

        context(@"should unarchive the object", ^{
            it(@"when valid data is input", ^{
                NSData *archivedData = [MMXKeyedArchiver archivedDataWithRootObject:@"Hello Magnet"];
                id unarchivedData = [MMXKeyedUnarchiver unarchiveObjectWithData:archivedData];
                [[unarchivedData should] beNonNil];
                [[unarchivedData should] beKindOfClass:[NSString class]];
                [[unarchivedData should] equal:@"Hello Magnet"];
            });
        });

    });
});
SPEC_END
