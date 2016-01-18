/** 
* *MMAttachment* is used for downloading attachments.
*/
@interface MMAttachment : NSObject


/**
 @name Properties
 */

/**
 The file URL for the attachment.
 
 While sending attachments, this is automatically populated by init(fileURL:mimeType:) and init(fileURL:mimeType:name:description:).
 On received attachments, this is automatically populated by downloadFileWithSuccess(_:failure:).
 */
@property (nonatomic, readonly, strong) NSURL * __nullable fileURL;

/**
 The data for the attachment.
 
 While sending attachments, this is automatically populated by init(data:mimeType:) and init(data:mimeType:name:description:).
 On received attachments, this is automatically populated by downloadDataWithSuccess(_:failure:).
 */
@property (nonatomic, readonly, strong) NSData * __nullable data;

/**
 The input stream for the attachment.
 
 While sending attachments, this is automatically populated by init(inputStream:length:mimeType:) and init(inputStream:length:mimeType:name:description:).
 On received attachments, this is automatically populated by downloadInputStreamWithSuccess(_:failure:).
 */
@property (nonatomic, readonly, strong) NSInputStream * __nullable inputStream;

/**
 The string content for the attachment.
 
 While sending attachments, this is automatically populated by init(content:mimeType:) and init(content:mimeType:).
 On received attachments, this is automatically populated by downloadStringWithSuccess(_:failure:).
 */
@property (nonatomic, readonly, copy) NSString * __nullable content;

/**
 The unique identifer for the attachment.
 */
@property (nonatomic, readonly, copy) NSString * __nullable attachmentID;

/**
 The name for the attachment.
 */
@property (nonatomic, readonly, copy) NSString * __nullable name;

/** 
 The summary for the attachment.
 */
@property (nonatomic, readonly, copy) NSString * __nullable summary;

/**
 The attachmentID's hash value.
 */
@property (nonatomic, readonly) NSUInteger hash;

/** 
 The mime type for the attachment.
 */
@property (nonatomic, readonly, copy) NSString * __nonnull mimeType;

/** 
 The download URL for the attachment.
 */
@property (nonatomic, strong) NSURL * __nullable downloadURL;


/**
 @name Initializers
 */

/**
 Initialize attachment.
 
 @param fileURL The file URL.
 @param mimeType The mime type.
 
 @return *MMAttachment*
 */
- (nonnull instancetype)initWithFileURL:(NSURL * __nonnull)fileURL mimeType:(NSString * __nonnull)mimeType;

/**
 Initialize attachment.
 
 @param fileURL The file URL.
 @param mimeType The mime type.
 @param name The name.
 @param description The description.
 
 @return *MMAttachment*
 */
- (nonnull instancetype)initWithFileURL:(NSURL * __nonnull)fileURL mimeType:(NSString * __nonnull)mimeType name:(NSString * __nullable)name description:(NSString * __nullable)description;

/**
 Initialize attachment.
 
 @param data The data.
 @param mimeType The mime type.
 
 @return *MMAttachment*
 */
- (nonnull instancetype)initWithData:(NSData * __nonnull)data mimeType:(NSString * __nonnull)mimeType;

/**
 Initialize attachment.
 
 @param data The data.
 @param mimeType The mime type.
 @param name The name.
 @param description The description.
 
 @return *MMAttachment*
 */
- (nonnull instancetype)initWithData:(NSData * __nonnull)data mimeType:(NSString * __nonnull)mimeType name:(NSString * __nullable)name description:(NSString * __nullable)description;

/**
 Initialize attachment.
 
 @param inputStream The inputStream.
 @param length The length.
 @param mimeType The mime type.
 
 @return *MMAttachment*
 */
- (nonnull instancetype)initWithInputStream:(NSInputStream * __nonnull)inputStream length:(int64_t)length mimeType:(NSString * __nonnull)mimeType;

/**
 Initialize attachment.
 
 @param inputStream The inputStream.
 @param length The length.
 @param mimeType The mime type.
 @param name The name.
 @param description The description.
 
 @return *MMAttachment*
 */
- (nonnull instancetype)initWithInputStream:(NSInputStream * __nonnull)inputStream length:(int64_t)length mimeType:(NSString * __nonnull)mimeType name:(NSString * __nullable)name description:(NSString * __nullable)description;

/**
 Initialize attachment.
 
 @param content The string content.
 @param mimeType The mime type.
 
 @return *MMAttachment*
 */
- (nonnull instancetype)initWithContent:(NSString * __nonnull)content mimeType:(NSString * __nonnull)mimeType;

/**
 Initialize attachment.
 
 @param content The string content.
 @param mimeType The mime type.
 @param name The name.
 @param description The description.
 
 @return *MMAttachment*
 */
- (nonnull instancetype)initWithContent:(NSString * __nonnull)content mimeType:(NSString * __nonnull)mimeType name:(NSString * __nullable)name description:(NSString * __nullable)description;

/**
 Default Initializer.
 
 @param mimeType The mime type.
 @param name The name.
 @param description The description.
 
 @return *MMAttachment*
 */
- (nonnull instancetype)initWithMimeType:(NSString * __nonnull)mimeType name:(NSString * __nullable)name description:(NSString * __nullable)description OBJC_DESIGNATED_INITIALIZER;


/**
 @name Factory Methods
 */

/** Create an attachment instance given a JSON string.
 
 @param jsonString The JSON string representation.
 
 @return An attachment instance.
 */
+ (nullable instancetype)fromJSONString:(NSString * __nonnull)jsonString;


/**
 @name Other Methods
 */

/** Get JSON string representation of the attachment.
 @return The JSON string representation of the attachment.
 */
- (NSString * __nonnull)toJSONString;

/** Compare equality.
 
 @param object An object to compare to current instance.
 
 @return true or false based on equality.
 */
- (BOOL)isEqual:(id __nullable)object;


/**
 @name Methods for Downloading
 */

/** Download the attachment to a specified file.

 @param fileURL The file URL where the attachment should be downloaded to.

 @param success A block object to be executed when the download finishes successfully. This block has no return value and takes no arguments.

 @param failure A block object to be executed when the logout finishes with an error. This block has no return value and takes one argument: the error object.
 */
- (void)downloadToFile:(NSURL * __nonnull)fileURL success:(void (^ __nullable)(void))success failure:(void (^ __nullable)(NSError * __nonnull))failure;

/** Download the attachment to a file.

 @param success A block object to be executed when the download finishes successfully. This block has no return value and takes one argument: the downloaded file URL.

 @param failure A block object to be executed when the logout finishes with an error. This block has no return value and takes one argument: the error object.
 */
- (void)downloadFileWithSuccess:(void (^ __nullable)(NSURL * __nonnull))success failure:(void (^ __nullable)(NSError * __nonnull))failure;

/** Download the attachment as data.

@param success A block object to be executed when the download finishes successfully. This block has no return value and takes one argument: the downloaded data.

@param failure A block object to be executed when the logout finishes with an error. This block has no return value and takes one argument: the error object.
 */
- (void)downloadDataWithSuccess:(void (^ __nullable)(NSData * __nonnull))success failure:(void (^ __nullable)(NSError * __nonnull))failure;

/** Download the attachment as an input stream.

 @param success A block object to be executed when the download finishes successfully. This block has no return value and takes one argument: the input stream for the downloaded data.

 @param failure A block object to be executed when the logout finishes with an error. This block has no return value and takes one argument: the error object.
 */
- (void)downloadInputStreamWithSuccess:(void (^ __nullable)(NSInputStream * __nonnull, int64_t))success failure:(void (^ __nullable)(NSError * __nonnull))failure;

/** Download the attachment as a string.

 @param success A block object to be executed when the download finishes successfully. This block has no return value and takes one argument: the string representation of the downloaded data.

 @param failure A block object to be executed when the logout finishes with an error. This block has no return value and takes one argument: the error object.
 */
- (void)downloadStringWithSuccess:(void (^ __nullable)(NSString * __nonnull))success failure:(void (^ __nullable)(NSError * __nonnull))failure;


@end
