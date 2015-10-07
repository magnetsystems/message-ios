//
//  MMUserInfoService.h
//
//  File generated by Magnet Lang Tool 2.3.0 on Aug 18, 2015 3:42:47 PM
//  @See Also: http://developer.magnet.com
//

#import <Foundation/Foundation.h>
#import "MMService.h"

@class MMCall;
@class MMUser;


@protocol MMUserInfoServiceProtocol <NSObject>

@optional
/**
 
 GET /api/com.magnet.server/userinfo
 @return A 'MMCall' object.
 */
- (MMCall *)getUserInfoWithSuccess:(void (^)(MMUser *response))success
                           failure:(void (^)(NSError *error))failure;

@end

@interface MMUserInfoService : MMService<MMUserInfoServiceProtocol>

@end