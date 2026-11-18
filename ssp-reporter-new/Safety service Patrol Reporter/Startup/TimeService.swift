

import UIKit
import Foundation
import AutoLogout

class TimeService{
    static let instance = TimeService()//creating a instance
    
    //MARK: USER DEFAULTS
    let defaults = UserDefaults.standard
    
    let IS_TABBAR_CLICK = "isTabbarClick"
    let TIMER = "timer"
    let SHIFTSHOW = "shiftShow"
    let VEHICLEID = "vehicleId"


    //MARK: Set and get the value
    var isTabbarClick:Bool?{
        get{
            return (defaults.value(forKey: IS_TABBAR_CLICK) as? Bool)
        }set{
            defaults.set(newValue, forKey: IS_TABBAR_CLICK)
        }
    }
    
    var didShiftShow:Bool?{
        get{
            return (defaults.value(forKey: SHIFTSHOW) as? Bool)
        }set{
            defaults.set(newValue, forKey: SHIFTSHOW)
        }
    }
    
    var timer:Int?{
        get{
            return (defaults.value(forKey: TIMER) as? Int)
        }set{
            defaults.set(newValue, forKey: TIMER)
        }
    }
    
    var vechileId:String?{
        get{
            return (defaults.value(forKey: VEHICLEID) as? String)
        }set{
            defaults.set(newValue, forKey: VEHICLEID)
        }
    }
    
    func coundown(){
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
          if TimeService.instance.timer! > 0 {
                TimeService.instance.timer! -= 1
                }
            else {
                    Timer.invalidate()

                }
            }
    }
    
    
    private var inactivityAlertTimer: WatchTimer?
    private var sessionTimeoutTimer: WatchTimer?
    private weak var inactivityAlertController: InactivityAlertController?
    
    private var inactivityEndDate: Date?
    private var sessionTimeoutEndDate: Date?
    
    private var inactivityAlertShowAfterMinutes = 14.0/// Time after which pop up will appear for remaining time
    private var sessionTimeoutAfterMinutes = 15.0 /// Total Session Time Out Time
   
    
    func setupInactivityTimers() {
        guard inactivityAlertTimer == nil else { return }
        inactivityAlertTimer = WatchTimer(duration: .minutes(inactivityAlertShowAfterMinutes)) { [weak self] in
            self?.showInactivityAlert()
            self?.inactivityAlertTimer = nil
        }
        sessionTimeoutTimer = WatchTimer(duration: .minutes(sessionTimeoutAfterMinutes)) { [weak self] in
            self?.logout()
        }
    }
    
    func showInactivityAlert(animated: Bool = true) {
        
        guard let sessionTimeoutTimer = sessionTimeoutTimer else { return }
        
        let inactivityAlertController = InactivityAlertController(timer: sessionTimeoutTimer)
        inactivityAlertController.delegate = self

        /// Handle your logic here regarding current view controller
//        var topViewController: UIViewController = rootViewController
//        while let presentedViewController = topViewController.presentedViewController {
//            topViewController = presentedViewController
//        }
//        topViewController.present(inactivityAlertController, animated: animated)
        
        inactivityAlertController.modalPresentationStyle = .custom
       // self.present(inactivityAlertController, animated: animated)
        
        self.inactivityAlertController = inactivityAlertController
        
    }
    
    func resetInactivityTimer() {
        print("resetInactivityTimer")
        inactivityAlertTimer = nil
        sessionTimeoutTimer = nil
        setupInactivityTimers()
    }
    
    func pauseTimerOnbackground() {
        print("pauseTimerOnbackground")
        let inactivityRemainingSeconds = inactivityAlertTimer?.remainingTime?.in(.seconds) ?? 0
        inactivityEndDate = Calendar.current.date(byAdding: .second, value: Int(inactivityRemainingSeconds), to: Date())
        
        let sessionTimoutRemainingSeconds = sessionTimeoutTimer?.remainingTime?.in(.seconds) ?? 0
        sessionTimeoutEndDate = Calendar.current.date(byAdding: .second, value: Int(sessionTimoutRemainingSeconds), to: Date())
        
        inactivityAlertTimer?.stop()
        sessionTimeoutTimer?.stop()
    }
    
    func resumeTimerOnForeground() {
        print("resumeTimerOnForeground")
        if let sessionTimeOutDate = sessionTimeoutEndDate{
            if Date() > sessionTimeOutDate{
                self.logout()
            }else{
                let differenceInSeconds = sessionTimeOutDate.timeIntervalSince(Date())
                sessionTimeoutTimer = WatchTimer(duration: .seconds(differenceInSeconds)) { [weak self] in
                    self?.logout()
                }
            }
        }
        
        if let inactivityDate = inactivityEndDate{
            if Date() > inactivityDate{
                if inactivityAlertController != nil{
                    inactivityAlertController?.dismiss(animated: false, completion: {
                        self.showInactivityAlert(animated: false)
                        self.inactivityAlertTimer = nil
                    })
                }else{
                    self.showInactivityAlert(animated: true)
                    self.inactivityAlertTimer = nil
                }
            }else{
                let differenceInSeconds = inactivityDate.timeIntervalSince(Date())
                inactivityAlertTimer = WatchTimer(duration: .seconds(differenceInSeconds)) { [weak self] in
                    self?.showInactivityAlert()
                    self?.inactivityAlertTimer = nil
                }
            }
        }
    }
    
    // MARK: - Logout
    func logout() {
        
        /// Handle here to move on required screen
        inactivityAlertTimer = nil
        sessionTimeoutTimer = nil
        self.inactivityAlertController?.dismiss(animated: true, completion: nil)
        print("Logout function call")
        NotificationCenter.default.post(name: Notification.Name("appTimeout"), object: nil)
    }
    
    func applicationDidEnterBackground() {
        //pauseTimerOnbackground()
    }
    
    func applicationWillEnterForeground() {
        //resumeTimerOnForeground()
    }

    
    func logoutApiCall(){
        if Connectivity.isConnectedToInternet {
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
                var param:[String:AnyObject] = [String:AnyObject]()
                param["companyId"] = companyID as AnyObject
                param["user_id"] = userId as AnyObject
                param["source"] = "MOB" as AnyObject
                
                print(param)
                let opt = WebServiceOperation.init((API.logout.getURL()?.absoluteString ?? ""), param)
                opt.completionBlock = {
                    DispatchQueue.main.async {
                        
                        guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                            return
                        }
                        if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                            if errorCode.intValue == 0 {
                                DispatchQueue.main.async {
                                    self.afterLogout()
                                }
                            }else{
                                
                                PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                            }
                        }
                    }
                }
                appDel.operationQueue.addOperation(opt)
            }
            
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
        }
    }
    
    func afterLogout()  {
        PopupCustomView.sharedInstance.hide()
               let SID: String = UserDefaults.standard.value(forKey: "SHIFTID") as? String ?? ""
                if SID.count > 0 {
                    self.endShiftApicall(isLogout: true)
                }else{
        self.popToLogin()
        }
    }
    
    func popToLogin()  {
        self.resetDefaults()
        UserDefaults.standard.set("", forKey: "SHIFTID")
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key == "FCM" || key == "PREOPSSAVED"{
                print("all keys==%@",key)
            }else{
                defaults.removeObject(forKey: key)
                //print("all keys==%@",key)
            }
        }
    }
    
    func endShiftApicall(isLogout:Bool) {
        if Connectivity.isConnectedToInternet {
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String, let shiftID:String = UserDefaults.standard.value(forKey: "SHIFTID") as? String{
                
                var param:[String:AnyObject] = [String:AnyObject]()
                param["user_id"] = userId as AnyObject
                param["source"] = "MOB" as AnyObject
                if shiftID != ""{
                    param["operator_shift_time_details_id"] = shiftID as AnyObject
                }else{
                    param["operator_shift_time_details_id"] = "1" as AnyObject
                }
                param["companyId"] = companyID as AnyObject
                param["status"] = "1" as AnyObject
                let formatter = DateFormatter()
                //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            
                //let defaultTimeZoneStr = formatter.string(from: date)
                //formatter.timeZone = NSTimeZone.local
                let getdate = Date()
                let utcTimeZoneStr = formatter.string(from: getdate)
                print(utcTimeZoneStr)
                param["timeUTC"] = utcTimeZoneStr as AnyObject
                print(param)
                let opt = WebServiceOperation.init((API.EndShift.getURL()?.absoluteString ?? ""), param)
                opt.completionBlock = {
                    DispatchQueue.main.async {
                        
                        guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                            return
                        }
                        if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                            if errorCode.intValue == 0 {
                                UserDefaults.standard.removeObject(forKey: "SHIFTID")
                                UserDefaults.standard.set("", forKey: "SHIFTID")
                                DispatchQueue.main.async {
                                    if isLogout{
                                        self.popToLogin()
                                    }
                                }
                                
                            }else{
                                PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                            }
                        }
                    }
                }
                appDel.operationQueue.addOperation(opt)
            }
            
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
        }
    }


}


// MARK: - Inactivity Alert delegate
extension TimeService: InactivityAlertControllerDelegate {
    func inactivityAlertControllerDidSelectLogout(_ inactivityAlertController: InactivityAlertController) {
        logout()
    }
    
    func inactivityAlertControllerDidSelectContinue(_ inactivityAlertController: InactivityAlertController) {
        setupInactivityTimers()
        inactivityAlertController.presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - Window delegate
extension TimeService: WindowDelegate {
    func window(_ window: Window, touchDetectedIn event: UIEvent) {
        resetInactivityTimer()
    }
}

