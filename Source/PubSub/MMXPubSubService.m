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

#import "MMXPubSubService.h"
#import "MMXChannel.h"
#import "MMXChannelSummaryRequest.h"
#import "MMXQueryChannelRequest.h"

@implementation MMXPubSubService

+ (NSDictionary *)metaData {
    static NSDictionary *__metaData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary *serviceMetaData = [NSMutableDictionary dictionary];
        
        // schema for service method queryChannels:success:failure:
        MMServiceMethod *queryChannelsSuccessFailure = [[MMServiceMethod alloc] init];
        queryChannelsSuccessFailure.clazz = [self class];
        queryChannelsSuccessFailure.selector = @selector(queryChannels:success:failure:);
        queryChannelsSuccessFailure.path = @"com.magnet.server/channel/query";
        queryChannelsSuccessFailure.requestMethod = MMRequestMethodPOST;
        queryChannelsSuccessFailure.consumes = [NSSet setWithObjects:@"application/json", nil];
        queryChannelsSuccessFailure.produces = [NSSet setWithObjects:@"application/json", nil];

        NSMutableArray *queryChannelsSuccessFailureParams = [NSMutableArray array];
        MMServiceMethodParameter *queryChannelsSuccessFailureParam0 = [[MMServiceMethodParameter alloc] init];
        queryChannelsSuccessFailureParam0.name = @"body";
        queryChannelsSuccessFailureParam0.requestParameterType = MMServiceMethodParameterTypeBody;
        queryChannelsSuccessFailureParam0.type = MMServiceIOTypeMagnetNode;
        queryChannelsSuccessFailureParam0.typeClass = MMXQueryChannelRequest.class;
        queryChannelsSuccessFailureParam0.isOptional = NO;
        [queryChannelsSuccessFailureParams addObject:queryChannelsSuccessFailureParam0];

        queryChannelsSuccessFailure.parameters = queryChannelsSuccessFailureParams;
        queryChannelsSuccessFailure.returnType = MMServiceIOTypeString;
        serviceMetaData[NSStringFromSelector(queryChannelsSuccessFailure.selector)] = queryChannelsSuccessFailure;
        
        // schema for service method getSummary:success:failure:
        MMServiceMethod *getSummarySuccessFailure = [[MMServiceMethod alloc] init];
        getSummarySuccessFailure.clazz = [self class];
        getSummarySuccessFailure.selector = @selector(getSummary:success:failure:);
        getSummarySuccessFailure.path = @"com.magnet.server/channel/summary";
        getSummarySuccessFailure.requestMethod = MMRequestMethodPOST;
        getSummarySuccessFailure.consumes = [NSSet setWithObjects:@"application/json", nil];
        getSummarySuccessFailure.produces = [NSSet setWithObjects:@"application/json", nil];

        NSMutableArray *getSummarySuccessFailureParams = [NSMutableArray array];
        MMServiceMethodParameter *getSummarySuccessFailureParam0 = [[MMServiceMethodParameter alloc] init];
        getSummarySuccessFailureParam0.name = @"body";
        getSummarySuccessFailureParam0.requestParameterType = MMServiceMethodParameterTypeBody;
        getSummarySuccessFailureParam0.type = MMServiceIOTypeMagnetNode;
        getSummarySuccessFailureParam0.typeClass = MMXChannelSummaryRequest.class;
        getSummarySuccessFailureParam0.isOptional = NO;
        [getSummarySuccessFailureParams addObject:getSummarySuccessFailureParam0];

        getSummarySuccessFailure.parameters = getSummarySuccessFailureParams;
        getSummarySuccessFailure.returnType = MMServiceIOTypeString;
        serviceMetaData[NSStringFromSelector(getSummarySuccessFailure.selector)] = getSummarySuccessFailure;

        // schema for service method addSubscriberToChannel:body:success:failure:
        MMServiceMethod *addSubscriberToChannelBodySuccessFailure = [[MMServiceMethod alloc] init];
        addSubscriberToChannelBodySuccessFailure.clazz = [self class];
        addSubscriberToChannelBodySuccessFailure.selector = @selector(addSubscriberToChannel:body:success:failure:);
        addSubscriberToChannelBodySuccessFailure.path = @"com.magnet.server/channel/{channelName}/subscribers/add";
        addSubscriberToChannelBodySuccessFailure.requestMethod = MMRequestMethodPOST;
        addSubscriberToChannelBodySuccessFailure.consumes = [NSSet setWithObjects:@"application/json", nil];
        addSubscriberToChannelBodySuccessFailure.produces = [NSSet setWithObjects:@"application/json", nil];

        NSMutableArray *addSubscriberToChannelBodySuccessFailureParams = [NSMutableArray array];
        MMServiceMethodParameter *addSubscriberToChannelBodySuccessFailureParam0 = [[MMServiceMethodParameter alloc] init];
        addSubscriberToChannelBodySuccessFailureParam0.name = @"channelName";
        addSubscriberToChannelBodySuccessFailureParam0.requestParameterType = MMServiceMethodParameterTypePath;
        addSubscriberToChannelBodySuccessFailureParam0.type = MMServiceIOTypeString;
        addSubscriberToChannelBodySuccessFailureParam0.isOptional = NO;
        [addSubscriberToChannelBodySuccessFailureParams addObject:addSubscriberToChannelBodySuccessFailureParam0];

        MMServiceMethodParameter *addSubscriberToChannelBodySuccessFailureParam1 = [[MMServiceMethodParameter alloc] init];
        addSubscriberToChannelBodySuccessFailureParam1.name = @"body";
        addSubscriberToChannelBodySuccessFailureParam1.requestParameterType = MMServiceMethodParameterTypeBody;
        addSubscriberToChannelBodySuccessFailureParam1.type = MMServiceIOTypeMagnetNode;
        addSubscriberToChannelBodySuccessFailureParam1.typeClass = MMXChannel.class;
        addSubscriberToChannelBodySuccessFailureParam1.isOptional = NO;
        [addSubscriberToChannelBodySuccessFailureParams addObject:addSubscriberToChannelBodySuccessFailureParam1];

        addSubscriberToChannelBodySuccessFailure.parameters = addSubscriberToChannelBodySuccessFailureParams;
        addSubscriberToChannelBodySuccessFailure.returnType = MMServiceIOTypeString;
        serviceMetaData[NSStringFromSelector(addSubscriberToChannelBodySuccessFailure.selector)] = addSubscriberToChannelBodySuccessFailure;

        // schema for service method createChannel:success:failure:
        MMServiceMethod *createChannelSuccessFailure = [[MMServiceMethod alloc] init];
        createChannelSuccessFailure.clazz = [self class];
        createChannelSuccessFailure.selector = @selector(createChannel:success:failure:);
        createChannelSuccessFailure.path = @"com.magnet.server/channel/create";
        createChannelSuccessFailure.requestMethod = MMRequestMethodPOST;
        createChannelSuccessFailure.consumes = [NSSet setWithObjects:@"application/json", nil];
        createChannelSuccessFailure.produces = [NSSet setWithObjects:@"application/json", nil];

        NSMutableArray *createChannelSuccessFailureParams = [NSMutableArray array];
        MMServiceMethodParameter *createChannelSuccessFailureParam0 = [[MMServiceMethodParameter alloc] init];
        createChannelSuccessFailureParam0.name = @"body";
        createChannelSuccessFailureParam0.requestParameterType = MMServiceMethodParameterTypeBody;
        createChannelSuccessFailureParam0.type = MMServiceIOTypeMagnetNode;
        createChannelSuccessFailureParam0.typeClass = MMXChannel.class;
        createChannelSuccessFailureParam0.isOptional = NO;
        [createChannelSuccessFailureParams addObject:createChannelSuccessFailureParam0];

        createChannelSuccessFailure.parameters = createChannelSuccessFailureParams;
        createChannelSuccessFailure.returnType = MMServiceIOTypeString;
        serviceMetaData[NSStringFromSelector(createChannelSuccessFailure.selector)] = createChannelSuccessFailure;

        // schema for service method removeSubscriberFromChannel:body:success:failure:
        MMServiceMethod *removeSubscriberFromChannelBodySuccessFailure = [[MMServiceMethod alloc] init];
        removeSubscriberFromChannelBodySuccessFailure.clazz = [self class];
        removeSubscriberFromChannelBodySuccessFailure.selector = @selector(removeSubscriberFromChannel:body:success:failure:);
        removeSubscriberFromChannelBodySuccessFailure.path = @"com.magnet.server/channel/{channelName}/subscribers/remove";
        removeSubscriberFromChannelBodySuccessFailure.requestMethod = MMRequestMethodPOST;
        removeSubscriberFromChannelBodySuccessFailure.consumes = [NSSet setWithObjects:@"application/json", nil];
        removeSubscriberFromChannelBodySuccessFailure.produces = [NSSet setWithObjects:@"application/json", nil];

        NSMutableArray *removeSubscriberFromChannelBodySuccessFailureParams = [NSMutableArray array];
        MMServiceMethodParameter *removeSubscriberFromChannelBodySuccessFailureParam0 = [[MMServiceMethodParameter alloc] init];
        removeSubscriberFromChannelBodySuccessFailureParam0.name = @"channelName";
        removeSubscriberFromChannelBodySuccessFailureParam0.requestParameterType = MMServiceMethodParameterTypePath;
        removeSubscriberFromChannelBodySuccessFailureParam0.type = MMServiceIOTypeString;
        removeSubscriberFromChannelBodySuccessFailureParam0.isOptional = NO;
        [removeSubscriberFromChannelBodySuccessFailureParams addObject:removeSubscriberFromChannelBodySuccessFailureParam0];

        MMServiceMethodParameter *removeSubscriberFromChannelBodySuccessFailureParam1 = [[MMServiceMethodParameter alloc] init];
        removeSubscriberFromChannelBodySuccessFailureParam1.name = @"body";
        removeSubscriberFromChannelBodySuccessFailureParam1.requestParameterType = MMServiceMethodParameterTypeBody;
        removeSubscriberFromChannelBodySuccessFailureParam1.type = MMServiceIOTypeMagnetNode;
        removeSubscriberFromChannelBodySuccessFailureParam1.typeClass = MMXChannel.class;
        removeSubscriberFromChannelBodySuccessFailureParam1.isOptional = NO;
        [removeSubscriberFromChannelBodySuccessFailureParams addObject:removeSubscriberFromChannelBodySuccessFailureParam1];

        removeSubscriberFromChannelBodySuccessFailure.parameters = removeSubscriberFromChannelBodySuccessFailureParams;
        removeSubscriberFromChannelBodySuccessFailure.returnType = MMServiceIOTypeString;
        serviceMetaData[NSStringFromSelector(removeSubscriberFromChannelBodySuccessFailure.selector)] = removeSubscriberFromChannelBodySuccessFailure;


        __metaData = serviceMetaData;
    });

    return __metaData;
}

@end
