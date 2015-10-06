/**
 * Copyright (c) 2012-2015 Magnet Systems, Inc. All rights reserved.
 */

import Foundation

//@objc(MMCall)
@objc public class Call : Operation {
    
    var useMock: Bool
    private(set) var callId: String
    var underlyingOperation: NSOperation
    
    init(useMock: Bool, callId: String, underlyingOperation: NSOperation) {
        self.useMock = useMock
        self.callId = callId
        self.underlyingOperation = underlyingOperation
    }
    
    lazy var internalQueue: NSOperationQueue = {
        return NSOperationQueue()
    }()
    
    override public func execute() {
        self.internalQueue.suspended = true
        finish()
        self.internalQueue.suspended = false
    }
}