public class MMXBlockCacheCall: MMXBlockCall, MMXCacheable {
    
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
}
