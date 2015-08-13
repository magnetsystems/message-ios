//
//  MMXLogInOperation.h
//  MMX
//
//  Created by Jason Ferguson on 8/13/15.
//  Copyright (c) 2015 Magnet Systems, Inc. All rights reserved.
//

#import "MMXAsyncOperation.h"
@class MMXUser;

@interface MMXLogInOperation : MMXAsyncOperation

@property (nonatomic, strong) NSURLCredential *creds;

@property (nonatomic, strong) void (^logInSuccessBlock)(MMXUser *);

@property (nonatomic, strong) void (^logInFailureBlock)(NSError *);


@end
