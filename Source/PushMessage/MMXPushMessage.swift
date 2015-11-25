/*
* Copyright (c) 2015 Magnet Systems, Inc.
* All rights reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License"); you
* may not use this file except in compliance with the License. You
* may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
* implied. See the License for the specific language governing
* permissions and limitations under the License.
*/



import MagnetMaxCore
import MMX
import UIKit


@objc public class MMXPushMessage: MMXMessage {
    
    public class func pushMessageWithRecipients(recipients : Set <MMUser>, body : String) -> MMXPushMessage {
        return pushMessageWithRecipients(recipients, body: body, title : nil, icon: nil, sound: nil, badge: nil, userDefinedObjects: nil)
    }
    
    public class func pushMessageWithRecipients(recipients : Set <MMUser>, body : String, title : String?, icon : String?, sound : String?, badge : NSNumber?) -> MMXPushMessage {
        return pushMessageWithRecipients(recipients, body: body, title : title, icon: icon, sound: sound, badge: badge, userDefinedObjects: nil)
    }
    
    public class func pushMessageWithRecipients(recipients : Set <MMUser>, body : String, title : String?, icon : String?, sound : String?, badge : NSNumber?, userDefinedObjects : Dictionary<String, String>?) -> MMXPushMessage {
        
        var messageContent : Dictionary = [String : String]()
        
        if let userObjects = userDefinedObjects {
            for ( key, value ) in userObjects {
                messageContent[key] = value
            }
        }
        
        messageContent["body"] = body
        
        if let _ = title {
            messageContent["title"] = title
        }
        
        if let _ = icon {
            messageContent["icon"] = icon
        }
        
        if let _ = sound {
            messageContent["sound"] = sound
        }
        
        if let _ = badge {
            messageContent["badge"] = badge?.stringValue
        }
        
        let msg: MMXPushMessage = MMXPushMessage.init()
        msg.messageContent = messageContent
        msg.recipients = recipients
        
        return msg
    }
    
    public class func pushMessageWithRecipient(recipient : MMUser, body : String) -> MMXPushMessage {
        return pushMessageWithRecipients([recipient], body: body)
    }
    
    public class func pushMessageWithRecipient(recipient : MMUser, body : String, title : String, icon : String?, sound : String?, badge : NSNumber?) -> MMXPushMessage {
        return pushMessageWithRecipients([recipient], body: body, title : title, icon: icon, sound: sound, badge: badge)
    }
    
    public class func pushMessageWithRecipient(recipient : MMUser, body : String, title : String, icon : String?, sound : String?, badge : NSNumber?, userDefinedObjects : Dictionary<String, String>?) -> MMXPushMessage {
        return pushMessageWithRecipients([recipient], body: body, title : title, icon: icon, sound: sound, badge: badge, userDefinedObjects: userDefinedObjects)
    }
    
    public func sendPushMessage(success : ((invalidDevices : Set<MMDevice>?) -> Void)?, failure : ((error : NSError) -> Void)?) {
        if MMXMessageUtils.isValidMetaData(self.messageContent) == false {
            let error : NSError = MMXClient.errorWithTitle("Not Valid", message: "All values must be strings.", code: 401)
            if let _ = failure {
                failure!(error : error)
            }
        }
        
        if MMUser.currentUser() == nil {
            let error : NSError = MMXClient.errorWithTitle("Not Logged In", message: "You must be logged in to send a message.", code: 401)
            if let _ = failure {
                failure!(error : error)
            }
        }
        
        MagnetDelegate.sharedDelegate().sendPushMessage(self, success: { (invalidDevices : Set<NSObject>!) -> Void in
            if let _ = success {
                success!(invalidDevices : invalidDevices.count == 0 ? nil : invalidDevices as? Set<MMDevice>)
            }
            }, failure: { (error) -> Void in
                if let _ = failure {
                    failure!(error: error)
                }
        });
    }
    
}
