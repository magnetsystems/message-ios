/**
 * Copyright (c) 2012-2015 Magnet Systems, Inc. All rights reserved.
 */

import Foundation

public extension MMDevice {
    
    public func updateDeviceToken(data: NSData, success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        
    }
    
    static public func currentDevice() -> Self? {
        return self.init()
    }
}

