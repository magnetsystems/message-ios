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

#import "MMModel.h"


@interface MMLogEvent : MMModel


@property (nonatomic, copy) NSArray *tags;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *correlationId;

@property (nonatomic, assign) long long utctime;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSString *subcategory;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSDictionary *payload;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *identifier;

@end
