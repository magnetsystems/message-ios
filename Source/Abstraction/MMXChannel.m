//
//  MMXTopic2.m
//  QuickStart
//
//  Created by Jason Ferguson on 8/5/15.
//  Copyright (c) 2015 Magnet Systems, Inc. All rights reserved.
//

#import "MMXChannel.h"
#import "MMXMessage_Private.h"
#import "MMX.h"

@implementation MMXChannel

+ (void)findByName:(NSString *)name
			success:(void (^)(int, NSArray *))success
			failure:(void (^)(NSError *))failure {
	//FIXME: Handle case that user is not logged in
	MMXTopicQueryFilter *tFilter = [[MMXTopicQueryFilter alloc] init];
	tFilter.topicName = name;
	tFilter.predicateOperatorType = MMXBeginsWithPredicateOperatorType;
	
	MMXQuery * query =  [[MMXQuery alloc] init];
	query.queryFilters = @[tFilter];
	query.compoundPredicateType = MMXAndPredicateType;
	[[MMXClient sharedClient].pubsubManager queryTopics:query success:^(int totalCount, NSArray *topics) {
		if (success) {
			//FIXME: convert topics to channels
			success(totalCount, topics);
		}
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
}

+ (void)findByTags:(NSSet *)tags
			success:(void (^)(int, NSArray *))success
			failure:(void (^)(NSError *))failure {
	//FIXME: Handle case that user is not logged in
	MMXQuery * query =  [[MMXQuery alloc] init];
	query.tags = [tags allObjects];;
	[[MMXClient sharedClient].pubsubManager queryTopics:query success:^(int totalCount, NSArray *topics) {
		if (success) {
			//FIXME: convert topics to channels
			success(totalCount, topics);
		}
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
}

- (void)setTags:(NSSet *)tags
		success:(void (^)(void))success
		failure:(void (^)(NSError *))failure {
	//FIXME: Handle case that user is not logged in
	[[MMXClient sharedClient].pubsubManager setTags:[tags allObjects]
											  topic:[self topic]
											success:^(BOOL successful) {
												if (success) {
													success();
												}
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
}

- (void)createWithSuccess:(void (^)(void))success
				  failure:(void (^)(NSError *))failure {
	//FIXME: Handle case that user is not logged in
	[[MMXClient sharedClient].pubsubManager createTopic:[self topic] success:^(BOOL successful) {
		if (success) {
			success();
		}
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
}

- (void)deleteWithSuccess:(void (^)(void))success
				 failure:(void (^)(NSError *))failure {
	//FIXME: Handle case that user is not logged in
	[[MMXClient sharedClient].pubsubManager deleteTopic:[self topic] success:^(BOOL successful) {
		if (success) {
			success();
		}
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
}

- (void)subscribeWithSuccess:(void (^)(void))success
					 failure:(void (^)(NSError *))failure {
	//FIXME: Handle case that user is not logged in
	[[MMXClient sharedClient].pubsubManager subscribeToTopic:[self topic] device:nil success:^(MMXTopicSubscription *subscription) {
		if (success) {
			success();
		}
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
}

- (void)unSubscribeWithSuccess:(void (^)(void))success
					   failure:(void (^)(NSError *))failure {
	//FIXME: Handle case that user is not logged in
	[[MMXClient sharedClient].pubsubManager unsubscribeFromTopic:[self topic] subscriptionID:nil success:^(BOOL successful) {
		if (success) {
			success();
		}
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
}

- (void)publish:(MMXMessage *)message
		success:(void (^)(MMXMessage *))success
		failure:(void (^)(NSError *))failure {
	//FIXME: Handle case that user is not logged in
	MMXPubSubMessage *msg = [MMXPubSubMessage pubSubMessageToTopic:[self topic] content:nil metaData:message.messageContent];
	[[MMXClient sharedClient].pubsubManager publishPubSubMessage:msg success:^(BOOL successful, NSString *messageID) {
		if (success) {
			//FIXME: not sure that this is the best way to handle this
			message.messageID = messageID;
			message.topic = [self topic];
			success(message);
		}
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
}

#pragma mark - Conversion Helpers
- (MMXTopic *)topic {
	return [MMXTopic topicWithName:self.name];
}

@end
