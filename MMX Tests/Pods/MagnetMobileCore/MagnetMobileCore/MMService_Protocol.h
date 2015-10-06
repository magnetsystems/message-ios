/**
 * Copyright (c) 2012-2015 Magnet Systems, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

typedef void (^MMServiceAdapterDidSendConfigurationBlock)(NSDictionary *configuration);
typedef void (^MMServiceAdapterDidSendAppTokenBlock)(NSString *appId, NSString *deviceId, NSString *appToken);
typedef void (^MMServiceAdapterDidSendUserTokenBlock)(NSString *userName, NSString *deviceId, NSString *userToken);
typedef void (^MMServiceAdapterDidCloseBlock)(BOOL shouldCloseGracefully);

@protocol MMService <NSObject>

@required

- (NSString *)name;

- (BOOL)allowsMultipleInstances;

@optional

@property(nonatomic, copy) MMServiceAdapterDidSendConfigurationBlock serviceAdapterDidSendConfiguration;

@property(nonatomic, copy) MMServiceAdapterDidSendAppTokenBlock serviceAdapterDidSendAppToken;

@property(nonatomic, copy) MMServiceAdapterDidSendUserTokenBlock serviceAdapterDidSendUserToken;

@property(nonatomic, copy) MMServiceAdapterDidCloseBlock serviceAdapterDidClose;

@end

