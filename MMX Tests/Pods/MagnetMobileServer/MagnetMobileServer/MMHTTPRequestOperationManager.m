/**
 * Copyright (c) 2012-2015 Magnet Systems, Inc. All rights reserved.
 */

#import "MMHTTPRequestOperationManager.h"
#import "MMURLSessionDataTaskOperation.h"
#import <AFNetworking/AFHTTPSessionManager.h>


@interface MMHTTPRequestOperationManager ()

@property(nonatomic, strong) NSURL *URL;

@property(nonatomic, readwrite) NSOperationQueue *operationQueue;

@property(nonatomic, readwrite) NSOperationQueue *reliableOperationQueue;

@end

@implementation MMHTTPRequestOperationManager

@synthesize securityPolicy = _securityPolicy;

- (id<MMRequestOperationManager>)initWithBaseURL:(NSURL *)theURL {
    self = [super init];
    if (self) {
        self.URL = theURL;
    }

    return self;
}

- (NSOperation *)requestOperationWithRequest:(NSURLRequest *)request
                                     success:(void (^)(NSURLResponse *response, id responseObject))success
                                     failure:(void (^)(NSError *error))failure {

    MMURLSessionDataTaskOperation *operation = [[MMURLSessionDataTaskOperation alloc] initWithManager:self.manager
                                                                                              request:request
                                                                                    completionHandler:^(NSURLResponse *response, id responseObject, NSError *responseError) {
        if (responseError) {
            if (failure) {
                failure(responseError);
            }
        } else {
            if (success) {
                success(response, responseObject);
            }
        }
    }];

    return operation;
}

#pragma mark - Overriden getters

- (NSOperationQueue *)operationQueue {
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    
    return _operationQueue;
}

- (NSOperationQueue *)reliableOperationQueue {
    if (!_reliableOperationQueue) {
        _reliableOperationQueue = [[NSOperationQueue alloc] init];
    }
    
    return _reliableOperationQueue;
}

@end