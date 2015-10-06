/**
 * Copyright (c) 2012-2015 Magnet Systems, Inc. All rights reserved.
 */

import Foundation

public class MMServiceAdapterPropertyListConfiguration: NSObject, MMServiceAdapterConfiguration {

    public var baseURL: NSURL
    public var clientID: String
    public var clientSecret: String
    
    // An URL that identifies a resource containing a string representation of a property list whose root object is a dictionary.
    public init(contentsOfURL url: NSURL) {
        let dictionary = NSDictionary(contentsOfURL: url)
        self.baseURL = dictionary?["baseURL"] as! NSURL
        self.clientID = dictionary?["clientId"] as! String
        self.clientSecret = dictionary?["clientSecret"] as! String
    }
}
