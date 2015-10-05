/**
 * Copyright (c) 2012-2015 Magnet Systems, Inc. All rights reserved.
 */

#import <Kiwi/Kiwi.h>
#import "MMX.h"

#define DEFAULT_TEST_TIMEOUT 5.0

SPEC_BEGIN(MMXUserSpec)

    describe(@"MMXUser", ^{

        NSString *janeDoeUsername = @"jane.doe";
        NSString *janeDoePassword = @"magnet";
        NSString *janeDoeName = @"Jane Doe";
        NSURLCredential *janeDoeCredential = [NSURLCredential credentialWithUser:janeDoeUsername
                                                                 password:janeDoePassword
                                                              persistence:NSURLCredentialPersistenceNone];

        NSString *johnDoeUsername = @"john.doe";
        NSString *johnDoePassword = @"magnet";
        NSString *johnDoeName = @"John Doe";
        NSURLCredential *johnDoeCredential = [NSURLCredential credentialWithUser:johnDoeUsername
                                                                        password:johnDoePassword
                                                                     persistence:NSURLCredentialPersistenceNone];

        beforeAll(^{
            [MMX setupWithConfiguration:@"default"];
        });

        context(@"when registering", ^{

            it(@"should return success for new user", ^{
                __block BOOL _isSuccess = NO;

                MMXUser *user = [[MMXUser alloc] init];
                user.displayName = janeDoeName;
                [user registerWithCredential:janeDoeCredential success:^{
                    _isSuccess = YES;
                }                    failure:^(NSError *error) {
                    _isSuccess = NO;
                }];

                // Assert
                [[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
            });

            it(@"should return failure for existing user", ^{
                __block BOOL _isSuccess = NO;
                __block NSInteger _code;

                MMXUser *user = [[MMXUser alloc] init];
                user.displayName = janeDoeName;
                [user registerWithCredential:janeDoeCredential success:^{
                    _isSuccess = NO;
                }                    failure:^(NSError *error) {
                    _code = error.code;
                    _isSuccess = YES;
                }];

                // Assert
                [[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
                [[expectFutureValue(theValue(_code)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:theValue(409)];
            });
        });

        context(@"when logging in", ^{

            it(@"should return success for valid credentials", ^{
                __block BOOL _isSuccess = NO;
                __block NSString *_username;
                __block NSString *_displayName;

                [MMXUser logInWithCredential:janeDoeCredential success:^(MMXUser *user) {
                    _isSuccess = YES;
                    _username = user.username;
                    _displayName = user.displayName;
                }                    failure:^(NSError *error) {
                    _isSuccess = NO;
                }];

                // Assert
                [[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
                [[expectFutureValue(_username) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:janeDoeUsername];
                [[expectFutureValue(_displayName) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:janeDoeName];
            });

            it(@"should should set the current user on successful login", ^{
                __block NSString *_username;
                __block NSString *_displayName;

                [MMXUser logInWithCredential:janeDoeCredential success:^(MMXUser *user) {
                    MMXUser *currentUser = [MMXUser currentUser];
                    _username = currentUser.username;
                    _displayName = currentUser.displayName;
                }                    failure:^(NSError *error) {

                }];

                // Assert
                [[expectFutureValue(_username) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:janeDoeUsername];
                [[expectFutureValue(_displayName) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:janeDoeName];
            });

            it(@"should return failure for invalid credentials", ^{
                __block BOOL _isSuccess = NO;

                NSURLCredential *invalidJaneDoeCredential = [NSURLCredential credentialWithUser:janeDoeUsername
                                                                                       password:@"wrongpassword"
                                                                                    persistence:NSURLCredentialPersistenceNone];

                [MMXUser logInWithCredential:invalidJaneDoeCredential success:^(MMXUser *user) {
                    _isSuccess = NO;
                }                    failure:^(NSError *error) {
                    _isSuccess = YES;
                }];

                // Assert
                [[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
            });
        });

        context(@"when logging out", ^{

            it(@"should terminate the session", ^{
                __block BOOL _isSuccess = NO;

                [MMXUser logInWithCredential:janeDoeCredential success:^(MMXUser *user) {
                    [MMXUser logOutWithSuccess:^{
                        [MMXUser userForUsername:janeDoeUsername success:^(MMXUser *fetchedUser) {
                            _isSuccess = NO;
                        }                failure:^(NSError *error) {
                            _isSuccess = YES;
                        }];
                    }                  failure:^(NSError *error) {
                        _isSuccess = NO;
                    }];
                }                    failure:^(NSError *error) {
                    _isSuccess = NO;
                }];

                // Assert
                [[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
            });

            it(@"should should unset the current user on successful logout", ^{
                __block MMXUser *_currentUser = [[MMXUser alloc] init]; // Set to a non-nil value

                [MMXUser logInWithCredential:janeDoeCredential success:^(MMXUser *user) {
                    _currentUser = [MMXUser currentUser];
                    [MMXUser logOutWithSuccess:^{
                        _currentUser = [MMXUser currentUser];
                    }                  failure:^(NSError *error) {
                    }];
                }                    failure:^(NSError *error) {
                }];

                // Assert
                [[expectFutureValue(_currentUser) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beNil];
            });
        });

        context(@"when fetching by username", ^{

            it(@"should return the user if it exists", ^{
                __block NSString *_username;
                __block NSString *_displayName;

                [MMXUser logInWithCredential:janeDoeCredential success:^(MMXUser *user) {
                    [MMXUser userForUsername:janeDoeUsername success:^(MMXUser *fetchedUser) {
                        _username = fetchedUser.username;
                        _displayName = fetchedUser.displayName;
                    }                failure:^(NSError *error) {
                    }];
                }                    failure:^(NSError *error) {
                }];

                // Assert
                [[expectFutureValue(_username) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:janeDoeUsername];
                [[expectFutureValue(_displayName) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:janeDoeName];
            });

            it(@"should fail if the user doesn't exist", ^{
                __block BOOL _isSuccess = NO;

                [MMXUser logInWithCredential:janeDoeCredential success:^(MMXUser *user) {
                    [MMXUser userForUsername:@"userdoesnotexist" success:^(MMXUser *fetchedUser) {
                        _isSuccess = NO;
                    }                failure:^(NSError *error) {
                        _isSuccess = YES;
                    }];
                }                    failure:^(NSError *error) {
                }];

                // Assert
                [[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
            });
        });

        context(@"when fetching by name", ^{

            // Create more users
            beforeAll(^{
                __block BOOL _isSuccess = NO;

                MMXUser *user = [[MMXUser alloc] init];
                user.displayName = johnDoeName;

                [MMXUser logOutWithSuccess:^{
                    [user registerWithCredential:johnDoeCredential success:^{
                        _isSuccess = YES;
                    }                    failure:^(NSError *error) {
                        _isSuccess = NO;
                    }];
                }                  failure:^(NSError *error) {
                }];

                [[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
            });

            it(@"should return the matching users", ^{
                __block NSArray *_fetchedUsers;
                __block int _totalCount;

                [MMXUser logInWithCredential:janeDoeCredential success:^(MMXUser *user) {
					[MMXUser findByDisplayName:@"j" limit:100 offset:0 success:^(int totalCount, NSArray *users) {
                        _fetchedUsers = users;
                        _totalCount = totalCount;
                    } failure:^(NSError *error) {

                    }];
                }                    failure:^(NSError *error) {
                }];

                // Assert
                [[expectFutureValue(_fetchedUsers) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] haveCountOf:2];
                [[expectFutureValue(theValue(_totalCount)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:(theValue(2))];
            });

            it(@"should return 0 users on no matches", ^{
                __block NSArray *_fetchedUsers = @[@""]; // Set to have a non-zero count
                __block int _totalCount = 1; // Set to have a non-zero value

                [MMXUser logInWithCredential:janeDoeCredential success:^(MMXUser *user) {
                    [MMXUser findByDisplayName:@"p" limit:100 offset:0 success:^(int totalCount, NSArray *users) {
                        _fetchedUsers = users;
                        _totalCount = totalCount;
                    } failure:^(NSError *error) {

                    }];
                }                    failure:^(NSError *error) {
                }];

                // Assert
                [[expectFutureValue(_fetchedUsers) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] haveCountOf:0];
                [[expectFutureValue(theValue(_totalCount)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:(theValue(0))];
            });

            it(@"should honor the limit and return the correct totalCount", ^{
                __block NSArray *_fetchedUsers;
                __block int _totalCount;

                [MMXUser logInWithCredential:janeDoeCredential success:^(MMXUser *user) {
                    [MMXUser findByDisplayName:@"j" limit:1 offset:0 success:^(int totalCount, NSArray *users) {
                        _fetchedUsers = users;
                        _totalCount = totalCount;
                    } failure:^(NSError *error) {

                    }];
                }                    failure:^(NSError *error) {
                }];

                // Assert
                [[expectFutureValue(_fetchedUsers) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] haveCountOf:1];
                [[expectFutureValue(theValue(_totalCount)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] equal:(theValue(2))];
            });
			
			it(@"should have the same user for offset 0 user 1 as offset 1 user 0", ^{
				__block BOOL _isSuccess = NO;
				
				[MMXUser logInWithCredential:janeDoeCredential success:^(MMXUser *user) {
					[MMXUser findByDisplayName:@"j" limit:2 offset:0 success:^(int totalCount, NSArray *users) {
						MMXUser *userAtOffset0Position1 = users[1];
						[MMXUser findByDisplayName:@"j" limit:1 offset:1 success:^(int totalCount, NSArray *users) {
							MMXUser *userAtOffset1Position0 = users[0];
							[[theValue([userAtOffset0Position1 isEqual:userAtOffset1Position0]) should] beYes];
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
				
				// Assert
				[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
			});

        });
		
		context(@"when fetching all users", ^{
			it(@"should return more than one user", ^{
				__block NSArray *_fetchedUsers = @[]; // Set should start empty
				__block int _totalCount = 0; // Start value at zero
				
				[MMXUser logInWithCredential:janeDoeCredential success:^(MMXUser *user) {
					[MMXUser allUsersWithLimit:100 offset:0 success:^(int totalCount, NSArray *users) {
						_fetchedUsers = users;
						_totalCount = totalCount;
					} failure:^(NSError *error) {
						
					}];
				}                    failure:^(NSError *error) {
				}];
				
				// Assert
				[[expectFutureValue(_fetchedUsers) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] haveCountOfAtLeast:1];
				[[expectFutureValue(theValue(_totalCount)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beBetween:theValue(3) and:theValue(15)];
			});
			
			it(@"should have the same user for offset 0 user 1 as offset 1 user 0", ^{
				__block BOOL _isSuccess = NO;
				
				[MMXUser logInWithCredential:janeDoeCredential success:^(MMXUser *user) {
					[MMXUser allUsersWithLimit:100 offset:0 success:^(int totalCount, NSArray *users) {
						MMXUser *userAtOffset0Position1 = users[1];
						[MMXUser allUsersWithLimit:100 offset:1 success:^(int totalCount, NSArray *users) {
							MMXUser *userAtOffset1Position0 = users[0];
							[[theValue([userAtOffset0Position1 isEqual:userAtOffset1Position0]) should] beYes];
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
				
				// Assert
				[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
			});
		});
		
		context(@"when creating a user without setting the displayName", ^{
			
			it(@"should have the same value for username and displayName after login", ^{
				__block BOOL _isSuccess = NO;
				
				MMXUser *testUser = [MMXUser new];
				NSString *testUsername = @"testingusername";
				NSString *testPassword = @"magnet";
				NSURLCredential *testCredential = [NSURLCredential credentialWithUser:testUsername
																				password:testPassword
																			 persistence:NSURLCredentialPersistenceNone];
				
				testUser.username = testUsername;
				
				[testUser registerWithCredential:testCredential success:^{
					[MMXUser logInWithCredential:testCredential success:^(MMXUser *user) {
						[[theValue([user.username isEqualToString:user.displayName]) should] beYes];
						_isSuccess = YES;
					} failure:^(NSError *error) {
						_isSuccess = NO;
					}];
				} failure:^(NSError *error) {
					_isSuccess = NO;
				}];
				
				// Assert
				[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
				
			});
		});
		
		context(@"when getting user for username", ^{
			
			it(@"should return a fully hydrated user object", ^{
				__block BOOL _isSuccess = NO;
				
				NSString *testUsername = @"testuser";
				NSString *testPassword = @"testuser";
				NSURLCredential *testCredential = [NSURLCredential credentialWithUser:testUsername
																				password:testPassword
																			 persistence:NSURLCredentialPersistenceNone];
				
				[MMXUser logInWithCredential:testCredential success:^(MMXUser *user) {
					[MMXUser userForUsername:testUsername success:^(MMXUser *user2) {
						[[theValue([user2.username isEqualToString:testUsername]) should] beYes];
						[[theValue(![user2.displayName isEqualToString:@""]) should] beYes];
						_isSuccess = YES;
					} failure:^(NSError *error) {
						_isSuccess = NO;
					}];
				} failure:^(NSError *error) {
					_isSuccess = NO;
				}];
				
				// Assert
				[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
				
			});
		});
		
		context(@"when updating a user displayName", ^{
			it(@"should have a new value when calling currentUser", ^{
				__block BOOL _isSuccess = NO;
				
				MMXUser *testUser = [MMXUser new];
				NSString *testUsername = @"testingusername2";
				NSString *testPassword = @"magnet";
				NSURLCredential *testCredential = [NSURLCredential credentialWithUser:testUsername
																				password:testPassword
																			 persistence:NSURLCredentialPersistenceNone];
				
				testUser.username = testUsername;
				
				[testUser registerWithCredential:testCredential success:^{
					[MMXUser logInWithCredential:testCredential success:^(MMXUser *user) {
						// assert
						[[theValue([user.username isEqualToString:user.displayName]) should] beYes];
						__block NSString *newDisplayName = @"newDisplayName";
						[user changeDisplayName:newDisplayName success:^{
							MMXUser *currentUser = [MMXUser currentUser];
							// assert
							[[theValue([newDisplayName isEqualToString:currentUser.displayName]) should] beYes];
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
				
				// Assert
				[[expectFutureValue(theValue(_isSuccess)) shouldEventuallyBeforeTimingOutAfter(DEFAULT_TEST_TIMEOUT)] beYes];
				
			});
		});
		
    });

SPEC_END