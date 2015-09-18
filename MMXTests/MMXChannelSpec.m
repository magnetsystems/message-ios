//
//  MMXChannelSpec.m
//  MMX
//
//  Created by Jason Ferguson on 8/26/15.
//  Copyright (c) 2015 Magnet Systems, Inc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "MMX.h"
#import "MMXDeviceManager.h"
#import "MMXDeviceManager_Private.h"
#import "MMXUtils.h"

#define DEFAULT_TEST_TIMEOUT 10.0

SPEC_BEGIN(MMXChannelSpec)

describe(@"MMXMessage", ^{
	
	NSString *senderUsername = [NSString stringWithFormat:@"sender_%f", [[NSDate date] timeIntervalSince1970]];
	NSString *senderPassword = @"magnet";
	NSString *senderName = senderUsername;
	NSURLCredential *senderCredential = [NSURLCredential credentialWithUser:senderUsername
																   password:senderPassword
																persistence:NSURLCredentialPersistenceNone];
	
	NSString *receiverUsername = [NSString stringWithFormat:@"receiver_%f", [[NSDate date] timeIntervalSince1970]];
	NSString *receiverPassword = @"magnet";
	NSString *receiverName = receiverUsername;
	NSURLCredential *receiverCredential = [NSURLCredential credentialWithUser:receiverUsername
																	 password:receiverPassword
																  persistence:NSURLCredentialPersistenceNone];
	
	MMXUser *sender = [[MMXUser alloc] init];
	sender.username = senderUsername;
	sender.displayName = senderName;
	
	MMXUser *receiver = [[MMXUser alloc] init];
	receiver.username = receiverUsername;
	receiver.displayName = receiverName;
	
	NSString *receiverDeviceID = [[NSUUID UUID] UUIDString];
		
	beforeAll(^{
		[MMXLogger sharedLogger].level = MMXLoggerLevelVerbose;
		[[MMXLogger sharedLogger] startLogging];
		
		[MMX setupWithConfiguration:@"default"];
		[MMX start];
		
		__block BOOL _isSuccess = NO;
		
		[MMXUser logOutWithSuccess:^{
			_isSuccess = YES;
		} failure:^(NSError *error) {
			_isSuccess = NO;
		}];
		
		[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
	});
	
	context(@"when pre-registering the users", ^{
		
		it(@"should return success for sender", ^{
			
			// Create some users
			__block BOOL _isSuccess = NO;
			
			[sender registerWithCredential:senderCredential success:^{
				[MMXUser logInWithCredential:senderCredential success:^(MMXUser *user) {
					_isSuccess = YES;
				} failure:^(NSError *error) {
					_isSuccess = NO;
				}];
			} failure:^(NSError *error) {
				_isSuccess = NO;
			}];
			
			[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
		
		it(@"should return success for receiver", ^{
			
			// Create some users
			__block BOOL _isSuccess = NO;
			
			NSString *originalDeviceID = [MMXDeviceManager deviceUUID];
			
			[MMXDeviceManager stub:@selector(deviceUUID) andReturn:receiverDeviceID];
			
			[receiver registerWithCredential:receiverCredential success:^{
				[MMXUser logInWithCredential:receiverCredential success:^(MMXUser *user) {
					[MMXDeviceManager stub:@selector(deviceUUID) andReturn:originalDeviceID];
					_isSuccess = YES;
				} failure:^(NSError *error) {
					_isSuccess = NO;
				}];
			} failure:^(NSError *error) {
				_isSuccess = NO;
			}];
			
			[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
		
		afterEach(^{
			
			__block BOOL _isSuccess = NO;
			
			[MMXUser logOutWithSuccess:^{
				_isSuccess = YES;
			} failure:^(NSError *error) {
				_isSuccess = NO;
			}];
			
			[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
	});
	
	context(@"when creating a channel", ^{
		
		it(@"should return success if the channel is valid", ^{
			
			NSString *channelName = [NSString stringWithFormat:@"channelName_%f", [[NSDate date] timeIntervalSince1970]];
			NSString *channelSummary = [NSString stringWithFormat:@"channelSummary_%f", [[NSDate date] timeIntervalSince1970]];
			__block BOOL _isSuccess = NO;
			
			[MMXUser logInWithCredential:senderCredential success:^(MMXUser *user) {
				[MMXChannel createWithName:channelName summary:channelSummary isPublic:NO success:^(MMXChannel *channel) {
					[[channel.name shouldNot] beNil];
					[[channel.summary shouldNot] beNil];
					[[channel.creationDate shouldNot] beNil];
					[[channel.ownerUsername shouldNot] beNil];
					_isSuccess = YES;
				} failure:^(NSError *error) {
					_isSuccess = NO;
				}];
			} failure:^(NSError *error) {
				_isSuccess = NO;
			}];
			
			[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
		
		it(@"should return the information used to create it", ^{
			
			NSString *channelName = [NSString stringWithFormat:@"channelName_%f", [[NSDate date] timeIntervalSince1970]];
			NSString *channelSummary = [NSString stringWithFormat:@"channelSummary_%f", [[NSDate date] timeIntervalSince1970]];
			__block BOOL _isSuccess = NO;
			
			[MMXUser logInWithCredential:senderCredential success:^(MMXUser *user) {
				[MMXChannel createWithName:channelName summary:channelSummary isPublic:YES success:^(MMXChannel *channel) {
					[MMXChannel channelsStartingWith:channelName limit:10 offset:0 success:^(int totalCount, NSArray *channels) {
						MMXChannel *returnedChannel = channels.count ? channels[0] : nil;
						[[returnedChannel.creationDate shouldNot] beNil];
						[[theValue(totalCount) should] equal:theValue(1)];
						[[returnedChannel shouldNot] beNil];
						[[theValue([channelSummary isEqualToString:returnedChannel.summary]) should] beYes];
						[[theValue([returnedChannel.ownerUsername isEqualToString:[MMXUser currentUser].username]) should] beYes];
						_isSuccess = YES;
					} failure:^(NSError *error) {
						_isSuccess = NO;
					}];
				} failure:^(NSError *error) {
					_isSuccess = NO;
				}];
			} failure:^(NSError *error) {
				_isSuccess = NO;
			}];
			
			[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
		
		afterEach(^{
			
			__block BOOL _isSuccess = NO;
			
			[MMXUser logOutWithSuccess:^{
				_isSuccess = YES;
			} failure:^(NSError *error) {
				_isSuccess = NO;
			}];
			
			[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
	});
	
	context(@"when finding a channel by name", ^{
		it(@"should only return one valid channel", ^{
			__block BOOL _isSuccess = NO;
			[MMXUser logInWithCredential:senderCredential success:^(MMXUser *user) {
				[MMXChannel channelForChannelName:@"test_topic" success:^(MMXChannel *channel) {
					[[theValue([MMXUtils objectIsValidString:channel.name]) should] beYes];
					[[theValue([MMXUtils objectIsValidString:channel.summary]) should] beYes];
					[[theValue([MMXUtils objectIsValidString:channel.ownerUsername]) should] beYes];
					[[theValue(channel.isPublic) should] beYes];
					[[channel.creationDate shouldNot] beNil];
					_isSuccess = YES;
				} failure:^(NSError *error) {
					_isSuccess = NO;
				}];
			} failure:^(NSError *error) {
				_isSuccess = NO;
			}];
			[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
	});
	
	context(@"when finding a channel by tag", ^{
		it(@"should only return one valid channel for the test tag", ^{
			__block BOOL _isSuccess = NO;
			[MMXUser logInWithCredential:senderCredential success:^(MMXUser *user) {
				[MMXChannel findByTags:[NSSet setWithObject:@"test_topic_tag"] limit:100 offset:0 success:^(int totalCount, NSArray *channels) {
					MMXChannel *returnedChannel = channels.count ? channels[0] : nil;
					[[returnedChannel.creationDate shouldNot] beNil];
					[[theValue(totalCount) should] equal:theValue(1)];
					[[returnedChannel shouldNot] beNil];
					[[theValue([MMXUtils objectIsValidString:returnedChannel.name]) should] beYes];
					[[theValue([MMXUtils objectIsValidString:returnedChannel.summary]) should] beYes];
					[[theValue([MMXUtils objectIsValidString:returnedChannel.ownerUsername]) should] beYes];
					[[theValue(returnedChannel.isPublic) should] beYes];
					[[returnedChannel.creationDate shouldNot] beNil];
					_isSuccess = YES;
				} failure:^(NSError *error) {
					_isSuccess = NO;
				}];
			} failure:^(NSError *error) {
				_isSuccess = NO;
			}];
			[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
	});
	
	context(@"when sending an invite", ^{

		it(@"should succeed if trying to send from a channel object that is fully hydrated", ^{
			__block BOOL _isSuccess = NO;
			[MMXUser logInWithCredential:senderCredential success:^(MMXUser *user) {
				[MMXChannel channelForChannelName:@"test_topic" success:^(MMXChannel *channel) {
					[channel inviteUser:[MMXUser currentUser] comments:@"No commment" success:^(MMXInvite *invite) {
						[[invite shouldNot] beNil];
						[[theValue([channel isEqual:invite.channel]) should] beYes];
						[[theValue([[MMXUser currentUser] isEqual:invite.sender]) should] beYes];
						[[theValue([invite.comments isEqualToString:@""]) should] beNo];
						_isSuccess = YES;
					} failure:^(NSError *error) {
						_isSuccess = NO;
					}];
				} failure:^(NSError *error) {
					_isSuccess = NO;
				}];
			} failure:^(NSError *error) {
				_isSuccess = NO;
			}];
			[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
		
		afterEach(^{
			
			__block BOOL _isSuccess = NO;
			
			[MMXUser logOutWithSuccess:^{
				_isSuccess = YES;
			} failure:^(NSError *error) {
				_isSuccess = NO;
			}];
			
			[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});

	});
	
	context(@"when fetching all public channels", ^{
		it(@"should return more than one channel", ^{
			__block NSArray *_fetchedChannels = @[]; // Set should start empty
			__block int _totalCount = 0; // Start value at zero
			
			[MMXUser logInWithCredential:senderCredential success:^(MMXUser *user) {
				[MMXChannel allPublicChannelsWithLimit:100 offset:0 success:^(int totalCount, NSArray *channels) {
					_fetchedChannels = channels;
					_totalCount = totalCount;
				} failure:^(NSError * error) {
				}];
			} failure:^(NSError * error) {
			}];
			
			// Assert
			[[expectFutureValue(_fetchedChannels) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] haveCountOfAtLeast:1];
			[[expectFutureValue(theValue(_totalCount)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beBetween:theValue(1) and:theValue(15)];
		});
		
		it(@"should have the same channel for offset 0 channel 1 as offset 1 channel 0", ^{
			__block BOOL _isSuccess = NO;
			
			[MMXUser logInWithCredential:senderCredential success:^(MMXUser *user) {
				[MMXChannel allPublicChannelsWithLimit:100 offset:0 success:^(int totalCount, NSArray *channels1) {
					MMXChannel *channelAtOffset0Position1 = channels1[1];
					[MMXChannel allPublicChannelsWithLimit:100 offset:1 success:^(int totalCount, NSArray *channels2) {
						MMXChannel *channelAtOffset1Position0 = channels2[0];
						[[theValue([channelAtOffset0Position1 isEqual:channelAtOffset1Position0]) should] beYes];
						_isSuccess = YES;
					} failure:^(NSError * error) {
						_isSuccess = NO;
					}];
				} failure:^(NSError * error) {
					_isSuccess = NO;
				}];
			} failure:^(NSError *error) {
				_isSuccess = NO;
			}];
			
			// Assert
			[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
	});

	context(@"when fetching all private channels", ^{
		it(@"should return more than one channel", ^{
			__block NSArray *_fetchedChannels = @[]; // Set should start empty
			__block int _totalCount = 0; // Start value at zero
			
			NSString *channelName = [NSString stringWithFormat:@"privateChannelName_%f", [[NSDate date] timeIntervalSince1970]];
			NSString *channelSummary = [NSString stringWithFormat:@"privateChannelSummary_%f", [[NSDate date] timeIntervalSince1970]];

			NSString *channelName2 = [NSString stringWithFormat:@"privateChannelName_%f", [[NSDate date] timeIntervalSince1970]];
			NSString *channelSummary2 = [NSString stringWithFormat:@"privateChannelSummary_%f", [[NSDate date] timeIntervalSince1970]];

			[MMXChannel createWithName:channelName summary:channelSummary isPublic:NO success:^(MMXChannel *channel) {
				[MMXChannel createWithName:channelName2 summary:channelSummary2 isPublic:NO success:^(MMXChannel *channel) {
					[MMXUser logInWithCredential:senderCredential success:^(MMXUser *user) {
						[MMXChannel allPrivateChannelsWithLimit:100 offset:0 success:^(int totalCount, NSArray *channels) {
							_fetchedChannels = channels;
							_totalCount = totalCount;
						} failure:^(NSError * error) {
						}];
					} failure:^(NSError * error) {
					}];
				} failure:^(NSError * error) {
				}];
			} failure:^(NSError * error) {
			}];
			
			// Assert
			[[expectFutureValue(_fetchedChannels) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] haveCountOfAtLeast:1];
			[[expectFutureValue(theValue(_totalCount)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beBetween:theValue(1) and:theValue(15)];
		});
		
		it(@"should have the same channel for offset 0 channel 1 as offset 1 channel 0", ^{
			__block BOOL _isSuccess = NO;
			
			[MMXUser logInWithCredential:senderCredential success:^(MMXUser *user) {
				[MMXChannel allPrivateChannelsWithLimit:100 offset:0 success:^(int totalCount, NSArray *channels1) {
					MMXChannel *channelAtOffset0Position1 = channels1[1];
					[MMXChannel allPrivateChannelsWithLimit:100 offset:1 success:^(int totalCount, NSArray *channels2) {
						MMXChannel *channelAtOffset1Position0 = channels2[0];
						[[theValue([channelAtOffset0Position1 isEqual:channelAtOffset1Position0]) should] beYes];
						_isSuccess = YES;
					} failure:^(NSError * error) {
						_isSuccess = NO;
					}];
				} failure:^(NSError * error) {
					_isSuccess = NO;
				}];
			} failure:^(NSError *error) {
				_isSuccess = NO;
			}];
			
			// Assert
			[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
	});
	
	context(@"when fetching messages from a channel", ^{
		
		it(@"should return success if the fetch returns valid messages(Public Channel)", ^{
			
			NSString *channelName = [NSString stringWithFormat:@"publicChannelName_%f", [[NSDate date] timeIntervalSince1970]];
			NSString *channelSummary = [NSString stringWithFormat:@"publicChannelSummary_%f", [[NSDate date] timeIntervalSince1970]];
			__block BOOL _isSuccess = NO;
			
			[MMXUser logInWithCredential:senderCredential success:^(MMXUser *user) {
				[MMXChannel createWithName:channelName summary:channelSummary isPublic:NO success:^(MMXChannel *channel) {
					[channel publish:@{@"key":@"value"} success:^(MMXMessage *message) {
						[channel messagesBetweenStartDate:nil endDate:nil limit:100 offset:0 ascending:YES success:^(int totalCount, NSArray *messages) {
							MMXMessage *msg = messages[0];
							[[msg should] beNonNil];
							[[theValue(totalCount > 0) should] beYes];
							_isSuccess = YES;
						} failure:^(NSError *error) {
							_isSuccess = NO;
						}];
					} failure:^(NSError *error) {
						_isSuccess = NO;
					}];
				} failure:^(NSError *error) {
					_isSuccess = NO;
				}];
			} failure:^(NSError *error) {
				_isSuccess = NO;
			}];
			
			[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
		
		it(@"should return success if the fetch returns valid messages(Private Channel)", ^{
			__block BOOL _isSuccess = NO;
			
			NSString *channelName = [NSString stringWithFormat:@"privateChannelName_%f", [[NSDate date] timeIntervalSince1970]];
			NSString *channelSummary = [NSString stringWithFormat:@"privateChannelSummary_%f", [[NSDate date] timeIntervalSince1970]];
			
			[MMXUser logInWithCredential:senderCredential success:^(MMXUser *user) {
				[MMXChannel createWithName:channelName summary:channelSummary isPublic:NO success:^(MMXChannel *channel) {
					[channel publish:@{@"key":@"value"} success:^(MMXMessage *message) {
						[channel messagesBetweenStartDate:nil endDate:nil limit:100 offset:0 ascending:YES success:^(int totalCount, NSArray *messages) {
							MMXMessage *msg = messages[0];
							[[msg should] beNonNil];
							[[theValue(totalCount > 0) should] beYes];
							_isSuccess = YES;
						} failure:^(NSError *error) {
							_isSuccess = NO;
						}];
					} failure:^(NSError *error) {
						_isSuccess = NO;
					}];
				} failure:^(NSError *error) {
					_isSuccess = NO;
				}];
			} failure:^(NSError *error) {
				_isSuccess = NO;
			}];
			
			[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
	});
	
	context(@"when getting subscribers to a channel", ^{
		it(@"should return at least one user", ^{
			__block BOOL _isSuccess = NO;
			
			[MMXUser logInWithCredential:senderCredential success:^(MMXUser *user) {
				[MMXChannel subscribedChannelsWithSuccess:^(NSArray *channels) {
					MMXChannel *myChannel = channels[0];
					[[myChannel should] beNonNil];
					[myChannel subscribersWithLimit:100 offset:0 success:^(int totalCount, NSArray *subscribers) {
						MMXUser *usr = subscribers[0];
						[[usr should] beNonNil];
						[[theValue(totalCount > 0) should] beYes];
						_isSuccess = YES;
					} failure:^(NSError *error) {
					}];
				} failure:^(NSError *error) {
				}];
			} failure:^(NSError * error) {
			}];
			
			// Assert
			[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
		});
	});
	
});

SPEC_END