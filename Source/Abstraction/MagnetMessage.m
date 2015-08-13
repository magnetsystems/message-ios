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

#import "MagnetMessage.h"
#import "MagnetDelegate.h"
#import "MMX.h"

@implementation MagnetMessage

+ (void)startSession {
	[[MagnetDelegate sharedDelegate] startMMXClient];
}

+ (void)endSession {
	if ([MMXClient sharedClient].connectionStatus == MMXConnectionStatusAuthenticated ||
		[MMXClient sharedClient].connectionStatus == MMXConnectionStatusConnected) {
		[[MMXClient sharedClient] disconnect];
	}
}

@end
