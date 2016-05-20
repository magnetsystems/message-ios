
public class MMXBlockCall: MMXCall {
    
    //MARK: Private variables
    
    private var block: ((call: MMXBlockCall) -> Void)
    
    //MARK: Init
    
    public required init(block: ((call: MMXBlockCall) -> Void)) {
        self.block = block
        super.init()
    }
    
    public required init(queue: NSOperationQueue, block: ((call: MMXBlockCall) -> Void)) {
        self.block = block
        super.init(queue: queue)
    }

    
    //MARK: Overrides
    
    override public final func execute() {
        assertionFailure("Should not be called directly")
    }
}