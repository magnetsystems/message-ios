//
//  File generated by Magnet Lang Tool 2.3.0 on Jul 10, 2015 2:24:31 PM
//  @See Also: http://developer.magnet.com
//
#import <Foundation/Foundation.h>
#import "MMEnumAttributeContainer.h"

typedef NS_ENUM(NSUInteger, MMUserRealm){
  MMUserRealmAD = 0,
  MMUserRealmDB,
  MMUserRealmFACEBOOK,
  MMUserRealmGOOGLEPLUS,
  MMUserRealmLDAP,
  MMUserRealmOTHER,
  MMUserRealmTWITTER,
};

@interface MMUserRealmContainer : NSObject <MMEnumAttributeContainer>

@end