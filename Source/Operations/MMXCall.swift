import MagnetMaxCore

@objc protocol MMXCallHandler {
    func operationForMMXCall() -> MMAsynchronousOperation
}

@objc public protocol MMXCallOperation {
    var cancelled: Bool{get}
    var executing: Bool{get}
    var finished: Bool{get}
    
    func cancel()
    func execute()
    func finish()
    //success failure
    func errorObject() -> NSError?
    func successObject() -> AnyObject?
}

@objc public class MMXCall: NSObject, MMAsynchronousOperationDelegate, MMXCallOperation  {
    
    //MARK: Public variables
    
    public var isAync = true
    final public private(set) var isOnQueue = false
    //queue for operation
    public private(set) var queue = {
        return NSOperationQueue()
    }()
    
    public lazy var cancelled: Bool = {
        return self.underlyingOperation.cancelled
    }()
    public lazy var executing: Bool = {
        return self.underlyingOperation.executing
    }()
    public lazy var finished: Bool = {
        return self.underlyingOperation.finished
    }()
    
    //MARK: Private variables
    
    //completion blocks to be run after operation
    private var completionBlocks:[(call: MMXCall) -> Void] = []
    private var dependencies = [MMXCall]()
    public var underlyingOperation:MMAsynchronousOperation = MMAsynchronousOperation()
    
    //MARK: Init
    
    override init() {
        super.init()
        if let handler = self as? MMXCallHandler {
            underlyingOperation = handler.operationForMMXCall()
        }
        underlyingOperation.delegate = self
    }
    
    public init(dependencies: [MMXCall]) {
        super.init()
        
        if let handler = self as? MMXCallHandler {
            underlyingOperation = handler.operationForMMXCall()
        }
        underlyingOperation.delegate = self
        for call in dependencies {
            self.dependencies.append(call)
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
            self.dependencies.append(call)
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
    
    public func executeInBackground(dependencies:[MMXCall]) {
        objc_sync_enter(self)
        self.dependencies.appendContentsOf(dependencies)
        objc_sync_exit(self)
        executeInBackground()
    }
    
    public func executeInBackground() {
        objc_sync_enter(self)
        guard !isOnQueue else {
            objc_sync_exit(self)
            return
        }
        //add depenencies to queue
        for call in dependencies {
            addCallAsDependency(call)
            call.executeInBackground()
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
        //if cancelled or finished ignore dependency
        guard !call.cancelled && !call.finished else {
            return
        }
        underlyingOperation.addDependency(call.underlyingOperation)
    }
}
