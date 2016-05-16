

@objc public enum MMXCachePolicy: Int {
    case Test
    case Value
}

@objc protocol MMXCacheable: class {
    var cachePolicy: MMXCachePolicy{get}
    func executeInBackground(cachePolicy cachePolicy: MMXCachePolicy)
    func executeInBackground(cachePolicy: MMXCachePolicy, dependencies:[MMXCall])
    func asCall() -> MMXCall
}

@objc public class MMXCacheCall: MMXCall, MMXCacheable {
    
    //MARK: Public variables
    
    public private(set) var cachePolicy: MMXCachePolicy = .Test
    
    //MARK: Public Methods
    
    public final func executeInBackground(cachePolicy cachePolicy: MMXCachePolicy) {
        self.cachePolicy = cachePolicy
        self.executeInBackground()
    }
    
    public func executeInBackground(cachePolicy: MMXCachePolicy, dependencies:[MMXCall]) {
        self.cachePolicy = cachePolicy
        self.executeInBackground(dependencies)
    }
    
    func asCall() -> MMXCall {
        return self
    }
    
    //MARK: Overrides
    
    override public func execute() {
        assertionFailure("Subclass and implement execution here")
    }
}