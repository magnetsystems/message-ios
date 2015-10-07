/**
 * Copyright (c) 2012-2015 Magnet Systems, Inc. All rights reserved.
 */

import Foundation

public extension MMUser {
    
    static private var currentlyLoggedInUser: MMUser?
    
    // TODO: Revisit!
    public func register(success: ((user: MMUser) -> Void)?, failure: ((error: NSError) -> Void)?) {
        MMCoreConfiguration.serviceAdapter.registerUser(self, success: { (user) -> Void in
            success?(user: user)
        }) { (error) -> Void in
            failure?(error: error)
        }.executeInBackground(nil)
    }
    
    static public func login(credential: NSURLCredential, success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        MMCoreConfiguration.serviceAdapter.loginWithUsername(credential.user, password: credential.password, success: { _ in
            // Get current user now
            MMCoreConfiguration.serviceAdapter.getCurrentUserWithSuccess({ (user) -> Void in
                currentlyLoggedInUser = user
                let userInfo = ["userID": user.userName, "deviceID": MMServiceAdapter.deviceUUID(), "token": MMCoreConfiguration.serviceAdapter.HATToken]
                NSNotificationCenter.defaultCenter().postNotificationName(MMServiceAdapterDidReceiveHATTokenNotification, object: self, userInfo: userInfo)
                success?()
            }, failure: { (error) -> Void in
                failure?(error: error)
            }).executeInBackground(nil)
            
        }) { (error) -> Void in
            failure?(error: error)
        }.executeInBackground(nil)
    }
    
    static public func logout(success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {
        MMCoreConfiguration.serviceAdapter.logoutWithSuccess({ _ in
            currentlyLoggedInUser = nil
            success?()
        }) { (error) -> Void in
            failure?(error: error)
        }.executeInBackground(nil)
    }
    
    static public func currentUser() -> MMUser? {
        return currentlyLoggedInUser
    }
}
