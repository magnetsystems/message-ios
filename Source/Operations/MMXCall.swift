import MagnetMaxCore


@objc public class MMXCall: Operation  {
    //queue for operation
    public private(set) var queue = {
        return NSOperationQueue()
    }()
    
    
    //MARK: Private variables
    
    //completion blocks to be run after operation
    private var completionBlocks:[(call: MMXCall) -> Void] = []
    
    //MARK: Init
    
    override init() {
        super.init()
    }
    
    public init(queue: NSOperationQueue) {
        super.init()
        self.queue = queue
    }
    
    public override func execute() {
     //call finish after executing
        finish()
    }
    
    //MARK: Public Methods
    
    public final func addCallback(completionBlock: (call: MMXCall) -> Void) {
        objc_sync_enter(self)
        guard !cancelled && !finished else {
            objc_sync_exit(self)
            return
        }
        
        guard !ready && !executing else {
            //if ready or executing
            addCompletionBlockDependency(completionBlock)
            objc_sync_exit(self)
            return
        }
        
        //if not ready or executing add array of blocks
        completionBlocks.append(completionBlock)
        objc_sync_exit(self)
    }
    
    public func executeInBackground(dependencies:[MMXCall]) {
        executeInBackground()
    }
    
    public func executeInBackground() {
        objc_sync_enter(self)
        for block in completionBlocks {
            addCompletionBlockDependency(block)
        }
        completionBlocks.removeAll()
        queue.addOperation(self)
        objc_sync_exit(self)
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
        operation.addDependency(self)
        queue.addOperation(operation)
    }
}
