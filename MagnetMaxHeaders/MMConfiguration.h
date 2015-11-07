@class NSURL;

@protocol MMConfiguration

/**
 *  The baseURL for the configuration.
 */
@property (nonatomic, readonly, strong) NSURL * __nonnull baseURL;

/**
 *  The clientID for the configuration.
 */
@property (nonatomic, readonly, copy) NSString * __nonnull clientID;

/**
 *  The clientSecret for the configuration.
 */
@property (nonatomic, readonly, copy) NSString * __nonnull clientSecret;

@optional

/**
 *  The scope for the configuration.
 */
@property (nonatomic, readonly, copy) NSString * __nonnull scope;

/**
 *  The additional key-value pairs associated with the configuration.
 */
@property (nonatomic, readonly, copy) NSDictionary<NSString *, NSString *> * __nonnull addtionalConfiguration;

@end
