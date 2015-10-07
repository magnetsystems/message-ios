/**
 * Copyright (c) 2012-2015 Magnet Systems, Inc. All rights reserved.
 */

import Foundation

public class MMServiceAdapterPropertyListConfiguration: NSObject, MMServiceAdapterConfiguration {

    public var baseURL: NSURL
    public var clientID: String = ""
    public var clientSecret: String = ""
    
    public init(dictionary: NSDictionary?) {
        self.baseURL = NSURL(string: (dictionary?["baseURL"] as! String))!
        self.clientID = dictionary?["clientID"] as! String
        self.clientSecret = dictionary?["clientSecret"] as! String
    }
    
    // An URL that identifies a resource containing a string representation of a property list whose root object is a dictionary.
    public convenience init?(contentsOfURL url: NSURL) {
        let dictionary = NSDictionary(contentsOfURL: url)
        self.init(dictionary: dictionary)
    }
    
    // An URL that identifies a resource containing a string representation of a property list whose root object is a dictionary.
    public convenience init?(contentsOfFile path: String) {
        let dictionary = NSDictionary(contentsOfFile: path)
        self.init(dictionary: dictionary)
    }
}
