public class MMXPersistentConnectionCall: MMXCall {
    //MARK: Private variables
    
    private var connected:Bool?
    
    //MARK: Init
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: Notifications
    
    func registerForNotifications() {
        //MMXUserDidLogInNotification
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(MMXPersistentConnectionCall.connectionStatusChanged(_:)),
                                                         name: MMXConnectionStatusChangedNotification,
                                                         object: nil)
    }
    
    func connectionStatusChanged(notification: NSNotification) {
        let userInfo = notification.userInfo
        if let status = userInfo?[MMXConnectionStatusKey] as? Int where MMXConnectionStatus.init(rawValue: status)  == .Connected {
            finishSuccessfully()
        }
    }
    
    //MARK: Execution
    
    public override func execute() {
        if MMXClient.sharedClient().connectionStatus == .Connected {
            finishSuccessfully()
        } else {
            connected = false
            registerForNotifications()
        }
    }
    
    func finishSuccessfully() {
        connected = true
        finish()
    }
    
    public override func successObject() -> AnyObject? {
        return connected
    }
}
