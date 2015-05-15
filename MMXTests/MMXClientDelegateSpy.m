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

#import <objc/runtime.h>
#import "MMXClientDelegateSpy.h"

@implementation MMXClientDelegateSpy

#pragma mark -
#pragma mark Initializing

+ (id)spy {
    return [[self alloc] init];
}

#pragma mark -
#pragma mark Checking Delegate callbacks

- (void)object:(id)anObject didReceiveInvocation:(NSInvocation *)anInvocation {
    if (sel_isEqual(anInvocation.selector, @selector(client:didReceiveConnectionStatusChange:error:))) {
        __unsafe_unretained id firstArgument;
        [anInvocation getArgument:&firstArgument atIndex:2];
        MMXConnectionStatus secondArgument;
        [anInvocation getArgument:&secondArgument atIndex:3];
        __unsafe_unretained id thirdArgument;
        [anInvocation getArgument:&thirdArgument atIndex:4];

        if (self.receivedConnectionEventBlock) {
            self.receivedConnectionEventBlock(firstArgument, secondArgument, thirdArgument);
        }
    }
}

@end
