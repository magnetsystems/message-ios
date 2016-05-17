public class MMXLogInCall: MMXCall {
    
    //MARK: Private variables
    
    private var user: MMUser?
    
    //MARK: Init
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: Notifications
    
    func registerForNotifications() {
        //MMXUserDidLogInNotification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MMXLogInCall.userDidLogIn(_:)), name: MMXUserDidLogInNotification, object: nil)
    }
    
    func userDidLogIn(notification: NSNotification) {
        print("Logged in!")
        finishSuccessfully()
    }
    
    //MARK: Execution
    
    public override func execute() {
        if MMUser.currentUser() != nil {
            finishSuccessfully()
        } else {
            print("Not logged in, will wait...")
            registerForNotifications()
        }
    }
    
    func finishSuccessfully() {
        user = MMUser.currentUser()
        finish()
    }
    
    public override func successObject() -> AnyObject? {
        return user
    }
}
