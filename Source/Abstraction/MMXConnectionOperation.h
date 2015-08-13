//
//  MMXConnectionOperation.h
//  MMX
//
//  Created by Jason Ferguson on 8/13/15.
//  Copyright (c) 2015 Magnet Systems, Inc. All rights reserved.
//

#import "MMXAsyncOperation.h"

@interface MMXConnectionOperation : MMXAsyncOperation

@property (nonatomic, copy) void (^connectSuccessBlock)(void);

@property (nonatomic, copy) void (^connectFailureBlock)(NSError *);

@end
