/**
 * Copyright (c) 2012-2015 Magnet Systems, Inc. All rights reserved.
 */

import Foundation

@objc public protocol MMModule : class {
    static var sharedInstance: MMModule { get }
    var name: String { get }
    
    optional var configurationHandler : ((configuration: [NSObject: AnyObject]) -> NSError?)? { get }
    optional var appTokenHandler : ((appID: String, deviceID: String, appToken: String) -> NSError?)? { get }
    optional var userTokenHandler : ((userID: String, deviceID: String, userToken: String) -> NSError?)? { get }
}
