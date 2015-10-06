//
//  MMUser.h
//
//  File generated by Magnet Lang Tool 2.3.0 on Aug 18, 2015 3:42:47 PM
//  @See Also: http://developer.magnet.com
//

#import "MMModel.h"
#import "MMUserRealm.h"
#import "MMUserStatus.h"

@interface MMUser : MMModel


@property (nonatomic, copy) NSString *lastName;

@property (nonatomic, copy) NSDictionary *challengePreferences;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *userIdentifier;

@property (nonatomic, copy) NSArray *roles;

@property (nonatomic, copy) NSString *otpCode;

@property (nonatomic, assign) MMUserStatus  userStatus;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, assign) MMUserRealm  userRealm;

@property (nonatomic, copy) NSString *firstName;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *clientId;

@property (nonatomic, copy) NSDictionary *userAccountData;

@end
