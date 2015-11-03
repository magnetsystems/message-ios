@protocol MMConfiguration;
@protocol MMModule;
@class NSError;

@interface MagnetMax : NSObject
/**
 *  Configure MagnetMax with specified configuration.
 * 
 *  @param configuration The configuration to be used.
 */
+ (void)configure:(id <MMConfiguration> __nonnull)configuration;

/**
 *  Initialize a module.
 * 
 *  @param module The module to be initialized.
 * 
 *  @param success A block object to be executed when the initialization finishes successfully. This block has no return value and takes no arguments.
 * 
 *  @param failure A block object to be executed when the initialization finishes with an error. This block has no return value and takes one argument: the error object.
 */
+ (void)initModule:(id <MMModule> __nonnull)module success:(void (^ __nonnull)(void))success failure:(void (^ __nonnull)(NSError * __nonnull))failure;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
