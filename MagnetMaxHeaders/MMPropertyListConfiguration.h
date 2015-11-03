
@interface MMPropertyListConfiguration : NSObject <MMConfiguration>
/**
 *  The baseURL for the configuration.
 */
@property (nonatomic, strong) NSURL * __nonnull baseURL;

/**
 *  The clientID for the configuration.
 */
@property (nonatomic, copy) NSString * __nonnull clientID;

/**
 *  The clientSecret for the configuration.
 */
@property (nonatomic, copy) NSString * __nonnull clientSecret;

/**
 *  Initializes a new configuration with the provided dictionary.
 * 
 *  @param dictionary A dictionary withe BaseURL, ClientID and ClientSecret keys.
 * 
 *  @returns  A configuration object.
 */
- (nonnull instancetype)initWithDictionary:(NSDictionary * __nullable)dictionary OBJC_DESIGNATED_INITIALIZER;

/**
 *  Initializes a new configuration with the provided URL.
 * 
 *  @param url A URL for the plist file.
 * 
 *  @returns  A configuration object.
 */
- (nullable instancetype)initWithContentsOfURL:(NSURL * __nonnull)url;

/**
 *  Initializes a new configuration with the provided file path.
 * 
 *  @param path A file path for the plist file.
 * 
 *  @returns  A configuration object.
 */
- (nullable instancetype)initWithContentsOfFile:(NSString * __nonnull)path;

@end
