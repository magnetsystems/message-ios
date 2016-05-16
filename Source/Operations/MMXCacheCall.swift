public enum MMXCachePolicy {
    case None
    case Some
}

protocol MMXCacheable: class {
    var cachePolicy: MMXCachePolicy{get}
    func executeInBackground(cachePolicy: MMXCachePolicy)
    func executeInBackground(cachePolicy: MMXCachePolicy, dependencies:[MMXCall])
    func asCall() -> MMXCall
}

public class MMXCacheCall: MMXCall, MMXCacheable {
    
    //MARK: Public variables
    
    public private(set) var cachePolicy: MMXCachePolicy = .None
    
    //MARK: Public Methods
    
    public final func executeInBackground(cachePolicy: MMXCachePolicy) {
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