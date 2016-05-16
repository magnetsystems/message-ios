import MagnetMaxCore

@objc protocol MMXCallHandler {
    func operationForMMXCall() -> MMAsynchronousOperation
}

@objc public protocol MMXCallOperation {
    func cancel()
    func execute()
    func finish()
    //success failure
    func errorObject() -> NSError?
    func successObject() -> AnyObject?
}

public class MMXCall: NSObject, MMAsynchronousOperationDelegate, MMXCallOperation  {
    
    //MARK: Public variables
    
    public var isAync = true
    final public private(set) var isOnQueue = false
    //queue for operation
    public private(set) var queue = {
        return NSOperationQueue()
    }()
    
    //MARK: Private variables
    
    //completion blocks to be run after operation
    private var completionBlocks:[(call: MMXCall) -> Void] = []
    private var underlyingOperation:MMAsynchronousOperation = MMAsynchronousOperation()
    
    //MARK: Init
    
    public init(dependencies: [MMXCall]) {
        super.init()
        
        let m = MMXMessage()
        
        if let handler = self as? MMXCallHandler {
            underlyingOperation = handler.operationForMMXCall()
        }
        underlyingOperation.delegate = self
        for call in dependencies {
            addCallAsDependency(call)
        }
    }
    
    public init(dependencies: [MMXCall], queue: NSOperationQueue) {
        super.init()
        
        if let handler = self as? MMXCallHandler {
            underlyingOperation = handler.operationForMMXCall()
        }
        underlyingOperation.delegate = self
        self.queue = queue
        for call in dependencies {
            addCallAsDependency(call)
        }
    }
    
    //MARK: MMXCallOperation - for executing operations
    
    public func cancel() -> Void {
        objc_sync_enter(self)
        underlyingOperation.cancel()
        objc_sync_exit(self)
    }
    
    public func execute() -> Void {
        assertionFailure("Subclass and implement execution here")
    }
    
    public func finish() -> Void {
        objc_sync_enter(self)
        guard !underlyingOperation.finished else {
            objc_sync_exit(self)
            return
        }
        underlyingOperation.finish()
        objc_sync_exit(self)
    }
    
    //Failure data
    public func errorObject() -> NSError? {
        return nil
    }
    
    //Success data
    public func successObject() -> AnyObject? {
        return nil
    }
    
    //MARK: Public Methods
    
    public final func addCallback(completionBlock: (call: MMXCall) -> Void) {
        objc_sync_enter(self)
        guard !underlyingOperation.cancelled && !underlyingOperation.finished else {
            objc_sync_exit(self)
            return
        }
        
        guard !underlyingOperation.ready && !underlyingOperation.executing else {
            //if ready of executing
            addCompletionBlockDependency(completionBlock)
            objc_sync_exit(self)
            return
        }
        
        //if not ready or executing add array of blocks
        completionBlocks.append(completionBlock)
        objc_sync_exit(self)
    }
    
    public func executeInBackground() {
        objc_sync_enter(self)
        guard !isOnQueue else {
            objc_sync_exit(self)
            return
        }
        for block in completionBlocks {
            addCompletionBlockDependency(block)
        }
        completionBlocks.removeAll()
        
        queue.addOperation(underlyingOperation)
        isOnQueue = true
        objc_sync_exit(self)
    }
    
    //MARK: Delegate
    
    public final func operationDidBeginExecuting(operation: MMAsynchronousOperation!) {
        guard !underlyingOperation.finished else {
            return
        }
        guard !underlyingOperation.cancelled else {
            finish()
            return
        }
        execute()
        if !isAync {
            finish()
        }
    }
    
    //MARK: Private Methods
    
    private func addCompletionBlockDependency(completionBlock: (call: MMXCall) -> Void) {
        let operation = NSBlockOperation(block: {
            {[weak self] in
                if let weakSelf = self {
                    completionBlock(call: weakSelf)
                }
                }()
        })
        operation.addDependency(underlyingOperation)
        queue.addOperation(operation)
    }
    
    private func addCallAsDependency(call: MMXCall) {
        objc_sync_enter(call)
        if !call.isOnQueue {
            call.isOnQueue = true
            queue.addOperation(call.underlyingOperation)
        }
        underlyingOperation.addDependency(call.underlyingOperation)
        objc_sync_exit(call)
    }
}
