
public class MMXBlockCall: MMXCall, MMXCallHandler {
    
    //MARK: Public variables
    
    private var error: NSError?
    private var success: AnyObject?
    
    //MARK: Private variables
    
    private var block: ((call: MMXBlockCall) -> Void)
    
    //MARK: Init
    
    public required init(dependencies: [MMXCall], block: ((call: MMXBlockCall) -> Void)) {
        self.block = block
        super.init(dependencies: dependencies)
    }
    
    public required init(dependencies: [MMXCall], queue: NSOperationQueue, block: ((call: MMXBlockCall) -> Void)) {
        self.block = block
        super.init(dependencies: dependencies, queue: queue)
    }
    
    //MARK: Completion Handling
    
    //Completion
    public func setCompletion(errorObject error: NSError?, successObject success: AnyObject?) {
        self.error = error
        self.success = success
    }
    
    //Failure data
    public override func errorObject() -> NSError? {
        return error
    }
    
    //Success data
    public override func successObject() -> AnyObject? {
        return success
    }
    
    //Mark: MMXCallHandler
    
    func operationForMMXCall() -> MMAsynchronousOperation {
        return  MMAsyncBlockOperation(with: { operation in
            { [weak self] in
                if let weakSelf = self where !operation.cancelled {
                    weakSelf.block(call: weakSelf)
                    if !weakSelf.isAync {
                        weakSelf.finish()
                    }
                } else {
                    operation.finish()
                }
                }()
        })
    }
    
    //MARK: Overrides
    
    override public final func execute() {
        assertionFailure("Should not be called directly")
    }
}