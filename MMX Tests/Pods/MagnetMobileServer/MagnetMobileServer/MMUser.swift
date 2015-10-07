/**
 * Copyright (c) 2012-2015 Magnet Systems, Inc. All rights reserved.
 */

import Foundation

public extension MMUser {
    
    // TODO: Revisit!
    public func register(success: ((user: MMUser) -> Void)?, failure: ((error: NSError) -> Void)?) {
        
    }
    
    static public func login(credential: NSURLCredential, success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
//        MMUser.currentUser()
    }
    
    static public func logout(success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        
    }
    
    static public func currentUser() -> Self? {
        return self.init()
    }
}
