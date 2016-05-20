public class MMXPersistentConnectionCall: MMXCall {
    //MARK: Private variables
    
    lazy public private(set) var connectionStatus:MMXConnectionStatus = MMXClient.sharedClient().connectionStatus
    private var context = UInt8()
    
    
    static func connectionStatusKey() -> String {
        return "connectionStatus"
    }
    
    //MARK: Init
    
    deinit {
        do {
            try MMXClient.sharedClient().removeObserver(self, forKeyPath: MMXPersistentConnectionCall.connectionStatusKey())
        } catch  { }
    }
    
    //MARK: Notifications
    
    func register() {
        connectionStatus = MMXClient.sharedClient().connectionStatus
        MMXClient.sharedClient().addObserver(self, forKeyPath: MMXPersistentConnectionCall.connectionStatusKey(), options: .New, context: &context)
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &self.context && keyPath == MMXPersistentConnectionCall.connectionStatusKey() {
            if let raw = change?[NSKeyValueChangeNewKey] as? Int {
                if let status = MMXConnectionStatus(rawValue: raw) {
                    connectionStatus = status
                    if status  == .Authenticated {
                        print("Authenticated connection!")
                        finishSuccessfully()
                    }
                }
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func connectionStatusChanged(notification: NSNotification) {
        let userInfo = notification.userInfo
        if let status = userInfo?[MMXConnectionStatusKey] as? Int where MMXConnectionStatus.init(rawValue: status)  == .Authenticated {
            print("Authenticated connection!")
            finishSuccessfully()
        }
    }
    
    //MARK: Execution
    
    public override func execute() {
        if MMXClient.sharedClient().connectionStatus == .Authenticated {
            finishSuccessfully()
        } else {
            print("No authenticated TCP connection, will wait...")
            register()
        }
    }
    
    func finishSuccessfully() {
        finish()
    }
}
