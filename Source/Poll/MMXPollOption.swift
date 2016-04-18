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

@objc public class MMXPollOption: MMModel {
    
    public private(set) var pollID: String = ""
    
    public private(set) var value: String = ""
    
    public var count: Int64 = 0
    
//    // TODO: Should we expose this?
//    
//    public private(set) var voters: [MMUser]?
//    
    public private(set) var optionID: String = ""
    
    public override init!() {
        super.init()
    }
    
    public init(pollID: String, optionID: String, value: String, count: Int64?) {
        self.pollID = pollID
        self.optionID = optionID
        self.value = value
        self.count = count ?? 0
        super.init()
    }
    
    required public init(dictionary dictionaryValue: [NSObject : AnyObject]!) throws {
        try super.init(dictionary: dictionaryValue)
    }
    
    required public init!(coder: NSCoder!) {
        super.init(coder: coder)
    }
}

// MARK: MMXPollOption Equality

extension MMXPollOption {
    
    override public func isEqual(object: AnyObject?) -> Bool {
        if let rhs = object as? MMXPollOption {
            return pollID == rhs.pollID && optionID == rhs.optionID
        }
        
        return false
        
    }
    
    override public var hash: Int {
        return pollID.hashValue ^ optionID.hashValue
    }
}
