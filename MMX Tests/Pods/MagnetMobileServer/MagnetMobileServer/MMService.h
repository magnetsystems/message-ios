/**
 * Copyright (c) 2012-2015 Magnet Systems, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class MMServiceAdapter;


@interface MMService : NSObject

@property(nonatomic, readonly) MMServiceAdapter *serviceAdapter;

+ (NSDictionary *)metaData;

+ (instancetype)serviceWithServiceAdapter:(MMServiceAdapter *)serviceAdapter;

- (instancetype)initWithServiceAdapter:(MMServiceAdapter *)serviceAdapter;

@end
