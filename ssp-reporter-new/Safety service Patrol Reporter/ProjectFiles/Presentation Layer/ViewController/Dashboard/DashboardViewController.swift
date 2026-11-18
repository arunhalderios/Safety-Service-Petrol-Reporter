//
//  DashboardViewController.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 11/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit
import Kingfisher
import CoreLocation
import Alamofire
import SwiftyJSON
import AutoLogout

class DashboardViewController: BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate {
    @IBOutlet var viewRoundedCorner: ViewX!
    var modelUser : Userdetails?
    
    @IBOutlet weak var headerVw: UIView!
    @IBOutlet var viewRound: CustomView!
    @IBOutlet weak var imgviewQR: UIImageView!
    @IBOutlet weak var viewScan: ViewX!
    @IBOutlet weak var viewVehicleListShow: ViewX!
    @IBOutlet weak var txtFieldVehcle: TextFieldX!
    @IBOutlet weak var viewChooseServey: UIView!
    @IBOutlet weak var txtFieldChooseServey: TextFieldX!
    @IBOutlet weak var heightSurvey: NSLayoutConstraint!
    @IBOutlet weak var lblSecond2: UILabel!
    @IBOutlet weak var lblfirst: UILabel!
    @IBOutlet weak var downarrow2: UIImageView!
    @IBOutlet weak var downarrow1: UIImageView!
    @IBOutlet weak var txtDescriptionStatus: TextFieldX!
    @IBOutlet weak var txtDirection: TextFieldX!
    @IBOutlet weak var viewOnsceneStatus: ViewX!
    @IBOutlet weak var floating: UIButton!
    @IBOutlet weak var labelState: UILabel!
    @IBOutlet weak var labelVechielID: UILabel!
    @IBOutlet weak var firstLetter: UILabel!
    @IBOutlet weak var viewImageBackground: UIView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var viewTabbar: UIView!
    @IBOutlet weak var DashboardCollectionView: UICollectionView!
    @IBOutlet weak var transperentBlackView: UIView!
    @IBOutlet weak var BreakTimeView: UIView!
    @IBOutlet weak var breakTimeConstent: NSLayoutConstraint!
    @IBOutlet weak var connectedViewConstent: NSLayoutConstraint!
    @IBOutlet weak var lblNotify: UILabel!
    @IBOutlet weak var lbl_AppVersion: UILabel!
    
    @IBOutlet weak var tblevw_OpenIncident: UITableView!
    @IBOutlet weak var transparentShowIncident: UIView!
    @IBOutlet weak var transparentBugReportView: UIView!
    @IBOutlet weak var txtvw_BugReport: UITextView!
    
    @IBOutlet weak var lbl_TimerOnStartBreak: UILabel!
    @IBOutlet weak var constantCustomVwTop: NSLayoutConstraint!
    
    //=======LOGOUT============
    private var inactivityAlertTimer: WatchTimer?
    private var sessionTimeoutTimer: WatchTimer?
    private weak var inactivityAlertController: InactivityAlertController?
    
    private var inactivityEndDate: Date?
    private var sessionTimeoutEndDate: Date?
    
    private var inactivityAlertShowAfterMinutes = 14.0 /// Time after which pop up will appear for remaining time
    private var sessionTimeoutAfterMinutes = 15.0 /// Total Session Time Out Time
    
    //=========================
    
    var timer: Timer!
    var count = 9
    
    var locationManager: CLLocationManager = CLLocationManager()
    var lat :String = " "
    var long :String = " "
    
    var selectedArray = NSMutableArray()
    var selectedIndexArray = NSMutableArray()
    var openIncidentArray = [JSON]()
    var isIndicateLogout  = false
    var convertedArrayString = ""
    
    var convertedArr: String = ""

    var isSurvey :Bool = false
    var stringVehicle:String = ""
    var isPetrolling: Bool = false // on car image status 1 to make on Secne 2
    var arrayshift2 = [Dictionary<String,String>]()
    var shiftStatus: Bool = false
    var showShiftScreen :Bool = false
    var arrayshift = ["Incidents","Start Shift","Fuel","Pre-Ops","Extra Time","Crash Report","SOS","Help","Maintenance Report","Inspection","Send Survey","Admin"]
    
    var arrayImage = ["Incidents","Start Shift","Fuel","Pre-Ops","Extra Time","Crash Report","SOS","Help","Maintenance","Inspection","Group 501","admin"]
    
    var arrayDescription = ["Motor Vehicle Accident", "Safety Service Operator-Roadside Assistance","Debris in Road","Disabled Vehicle"]
    var arrayDirection = ["One Direction", "Both Directions"]
    var arrayChooseServey = ["Mobile", "Email","QR Code"]
    var serveyVia = ""
    var isManager:Bool = false
    var menuIDNumber:Int  = 0
    var vehileList : [ShiftVehileList] = []
    var selectedVehicle:ShiftVehileList?
    var model = IncidentModel()
    var isShare_linkAvailable :String = ""
    var isbecomactive:Bool = false
    
    @IBOutlet weak var btnCloseIncident: UIButton!
    
    //===========LOGOUT==================
    
    private func setupInactivityTimers() {
        guard inactivityAlertTimer == nil else { return }
        inactivityAlertTimer = WatchTimer(duration: .minutes(inactivityAlertShowAfterMinutes)) { [weak self] in
            self?.showInactivityAlert()
            self?.inactivityAlertTimer = nil
        }
        sessionTimeoutTimer = WatchTimer(duration: .minutes(sessionTimeoutAfterMinutes)) { [weak self] in
            self?.logout()
        }
    }
    
    private func showInactivityAlert(animated: Bool = true) {
        
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
        self.present(inactivityAlertController, animated: animated)
        
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
        self.logoutApiCall()
    }
    
    func applicationDidEnterBackground() {
        //pauseTimerOnbackground()
    }
    
    func applicationWillEnterForeground() {
        //resumeTimerOnForeground()
    }

    
    //===================================
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TimeService.instance.setupInactivityTimers()

        
        txtFieldVehcle.tag = 300
        self.viewOnsceneStatus.isHidden = true
        heightSurvey.constant = 280
        
//        if TimeService.instance.isTabbarClick == true{
//            self.transperentBlackView.isHidden = true
//            self.BreakTimeView.isHidden = true
//            print("Arun")
//            if UserDefaults.standard.value(forKey: "BREAKTIME") != nil{
//                 self.floating.setTitle("END BREAK", for: .normal)
//                 self.constantCustomVwTop.constant = 30.0
//                 self.lbl_TimerOnStartBreak.isHidden = false
//
//            } else {
//                self.floating.setTitle("START BREAK", for: .normal)
//                self.constantCustomVwTop.constant = 16.0
//                self.lbl_TimerOnStartBreak.isHidden = true
//            }
//
//        }else{
//
//            self.showBreakTimePopup()
//        }
        self.showBreakTimePopup()
        self.DashboardCollectionView.delegate = self
        self.DashboardCollectionView.dataSource = self
        DashboardCollectionView.isHidden =  true
        self.lblNotify.isHidden = true
        self.createPickerView(textField: txtFieldChooseServey)
        txtFieldChooseServey.addLeftViewPadding(padding: 9, placeholderText: "Select")
        txtFieldVehcle.addLeftViewPadding(padding: 9, placeholderText: "Select")
        viewVehicleListShow.isHidden = true
        MyLocationManager.share.requestForLocation()
        MyLocationManager.share.configManager()
        self.createPickerView(textField: txtFieldVehcle)
        //self.statartLocationUpdate(isStartUpdate: true)
        self.callVehicleListListApi()
      //  self.()
       
            // let notificationCenter = NotificationCenter.default
         //   notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
            
//            notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        if UserDefaults.standard.value(forKey: "SHIFTID") as? String == ""{
            print("==============================Don't Have Shift ID==============================")
            if TimeService.instance.didShiftShow == true{
                PopupCustomView.sharedInstance.reSetPopUp()
                PopupCustomView.sharedInstance.textView?.text = "Do you want to Start the shift ?"
                PopupCustomView.sharedInstance.btnLeft.addTarget(self, action: #selector(btnPressStartShift(_:)), for: .touchUpInside)
                PopupCustomView.sharedInstance.btnRight.addTarget(self, action: #selector(self.btnShiftNoPressed(_:)), for: .touchUpInside)
                PopupCustomView.sharedInstance.display(onView: UIApplication.shared.keyWindow) {
                }
            }

        }
        else{
            print("==============================Have Shift ID==============================")
        }
        
    }
    
//    @objc func appMovedToBackground() {
//       print("app enters background")
//        NotificationCenter.default.addObserver(self, selector: #selector(functionLogout), name: Notification.Name("appTimeout"), object: nil)
//
//   }
//
//   @objc func appCameToForeground() {
//       print("app enters foreground")
//       NotificationCenter.default.addObserver(self, selector: #selector(functionLogout), name: Notification.Name("appTimeout"), object: nil)
//
//   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        lbl_AppVersion.text = "Build Version: \(UIApplication.versionBuild())"
        print("=================================viewWillAppear=================================")
        NotificationCenter.default.addObserver(self, selector: #selector(functionLogout), name: Notification.Name("appTimeout"), object: nil)

        
        if let childVC = self.children.first as? TabbarVC {
            childVC.selectedIndex = 0
            childVC.tabBarCollectionView.reloadData()
        }
        dashBoardApiCall()
        self.viewScan.isHidden = true
        //viewTabbar.addShadow(location: .top)
        
        self.setUpPreview()
        if let _ = UserDefaults.standard.value(forKey: "VEHICLEID") as? String {
             //self.callIncidentListApi()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        if isbecomactive == false{

        self.callVersionChecking()
        }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            locationManager.startUpdatingLocation()
        }else{
            locationManager.startUpdatingLocation()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        transparentBugReportView.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap2(_:)))
        self.headerVw.addGestureRecognizer(tap2)
        
//       NotificationCenter.default.addObserver(self, selector: #selector(functionLogout), name: Notification.Name("appTimeout"), object: nil)
//
//
//        let notificationCenter = NotificationCenter.default
//            notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
//
//            notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
//        if UserDefaults.standard.value(forKey: "SHIFTID") as? String == ""{
//            print("==============================Don't Have Shift ID==============================")
//            PopupCustomView.sharedInstance.reSetPopUp()
//            PopupCustomView.sharedInstance.textView?.text = "Do you want to Start the shift ?"
//            PopupCustomView.sharedInstance.btnLeft.addTarget(self, action: #selector(btnPressStartShift(_:)), for: .touchUpInside)
//            PopupCustomView.sharedInstance.btnRight.addTarget(self, action: #selector(self.btnNoPressed(_:)), for: .touchUpInside)
//            PopupCustomView.sharedInstance.display(onView: UIApplication.shared.keyWindow) {
//            }
//        }
//        else{
//            print("==============================Have Shift ID==============================")
//        }
        TimeService.instance.isTabbarClick = false
    }
    
    @objc func btnPressStartShift(_ sender: UIButton){
        PopupCustomView.sharedInstance.hide()
        TimeService.instance.didShiftShow = false
        let vc = storyboard?.instantiateViewController(identifier: "StartShiftVC") as! StartShiftVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.transparentBugReportView.isHidden = true
    }
    @objc func handleTap2(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("============================Screen has been tapped============================")
        TimeService.instance.resetInactivityTimer()
    }
    
    @objc func functionLogout (notification: NSNotification){
        //handling code
        print("======================Inavtive Timer Logout Is Fire======================")
        self.logoutApiCall()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.viewImageBackground.layer.cornerRadius = self.viewImageBackground.frame.size.height / 2
        self.viewImageBackground.layer.masksToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.viewRoundedCorner.frame
        rectShape.position = self.viewRoundedCorner.center
        rectShape.path = UIBezierPath(roundedRect: self.viewRoundedCorner.bounds, byRoundingCorners: [.bottomRight , .bottomLeft], cornerRadii: CGSize(width: 40, height: 40)).cgPath
        //self.viewRoundedCorner.layer.backgroundColor = UIColor.green.cgColor
        self.viewRoundedCorner.layer.mask = rectShape
        
        
//        let rectShape1 = CAShapeLayer()
//        rectShape1.bounds = self.viewRound.frame
//        rectShape1.position = self.viewRound.center
//        rectShape1.path = UIBezierPath(roundedRect: self.viewRound.bounds, byRoundingCorners: [.topRight , .topLeft], cornerRadii: CGSize(width: 40, height: 40)).cgPath
//        self.viewRound.layer.mask = rectShape1
        
        
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    func setUpPreview(){
        self.labelVechielID.text = "Vehicle Id: "
        self.labelState.text = "State Name:"
        if let _ = UserDefaults.standard.value(forKey: "VEHICLEID") as? String {
            self.labelVechielID.text = "Vehicle Id: \(stringVehicle)"
        }
        
        if let user = UserDefaults.standard.value(forKey: "USER") as? [String:Any]{
            do{
                self.modelUser = try JSONDecoder().decode(Userdetails.self,from:(user.data)!)
                self.nameLabel.text =  self.modelUser?.name ?? " "
                if  let imageLink = self.modelUser?.profile_image {
                    if let url = URL(string:imageLink ) {
                        self.imageProfile.kf.setImage(with: url)
                    }
                }else{
                    self.imageProfile.isHidden = true
                    self.firstLetter.isHidden = false
                    let character =  self.modelUser?.first_name?.character(at: 0)
                    self.firstLetter.text =  "\(character ?? "A")"
                    
                }
            }
            catch{
                print(error)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            self.lat = String(location.coordinate.latitude)
            self.long = String(location.coordinate.longitude)
        }
    }
    
    @IBAction func btnSubmitBugReport(_ sender: UIButton) {
        self.callSubmitBugReportAPI()
    }
    
    @IBAction func btnCloseIncident(_ sender: UIButton) {
        if isIndicateLogout == false{
            self.transparentShowIncident.isHidden = true
            DispatchQueue.main.async {
                if self.selectedArray.count > 0{
                    self.callForceCloseIncident()
                }
                self.endShiftApicall(isLogout: false)
            }
        }else{
            self.transparentShowIncident.isHidden = true
            DispatchQueue.main.async {
                if self.selectedArray.count > 0{
                    self.callForceCloseIncident()
                }
                self.logoutApiCall()
            }
        }
    }
    @IBAction func btnCancelCloseIncident(_ sender: UIButton) {
        self.transparentShowIncident.isHidden = true
        
    }
    
    func callOpenIncidentApi(){
        if Connectivity.isConnectedToInternet {
            let headers: HTTPHeaders = [
                        "Content-Type":"application/json",
                        "Accept": "application/json"]
            

            let url = "https://atims.sspreporter.com/api/open-incident"
            let userId: String = (UserDefaults.standard.value(forKey: "USERID") as? String)!
            let companyID:String = (UserDefaults.standard.value(forKey: "COMPANYID") as? String)!
            
            let params : [String:Any]  = ["source":"MOB","companyId":"\(companyID)","user_id":"\(userId)"]
           
            print("============HEADERS=================")
            print(headers)
            print("============PARAMS=================")
            print(params)
            print("============URL=================")
            print(url)
            Alamofire.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    
                    let resultValue = SwiftyJSON.JSON(value)
                    print("=============RESPONSE DATA==================")
                    print(resultValue)

                    let statusStr = resultValue["status"]["error_code"].boolValue
                    if statusStr == false{
                        let listArray = resultValue["result"]["data"].arrayValue
                        print(":::::::::::::::::::::LIST ARRAY:::::::::::::::::::::")
                        print(listArray)
                        self.openIncidentArray = listArray
                        self.tblevw_OpenIncident.reloadData()
                        self.transparentShowIncident.isHidden = false
                    }
                    else{
                        //errors
                        let message = resultValue["message"].stringValue
                        self.logoutApiCall()
                        if self.isIndicateLogout == false{
                            DispatchQueue.main.async {
                                self.endShiftApicall(isLogout: false)
                            }
                        }else{
                            DispatchQueue.main.async {
                                self.logoutApiCall()
                            }
                        }
                    }
                    
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
        }
        
    }
    
//    func callCloseIncidentApi(){
//        if Connectivity.isConnectedToInternet {
//            let headers: HTTPHeaders = [
//                        "Content-Type":"application/json",
//                        "Accept": "application/json"]
//
//
//            let url = "https://atims.sspreporter.com/api/close-incident-force"
//            let companyID:String = (UserDefaults.standard.value(forKey: "COMPANYID") as? String)!
//            let formatter = DateFormatter()
//            //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
//            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
//
//            //let defaultTimeZoneStr = formatter.string(from: date)
//            //formatter.timeZone = NSTimeZone.local
//            let getdate = Date()
//            let utcTimeZoneStr = formatter.string(from: getdate)
//            print(utcTimeZoneStr)
//
//            convertedArrayString = selectedArray.componentsJoined(by:",")
//
//            let params : [String:Any]  = ["source":"MOB","timeUTC":"\(utcTimeZoneStr)","companyId":"\(companyID)","Incidents_report_data_id":"\(convertedArrayString)"]
//
//            print("============HEADERS=================")
//            print(headers)
//            print("============PARAMS=================")
//            print(params)
//            print("============URL=================")
//            print(url)
//            Alamofire.request(url, method: .post, parameters: params, encoding:JSONEncoding.prettyPrinted, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
//                switch response.result{
//                case .success(let value):
//
//                    let resultValue = SwiftyJSON.JSON(value)
//                    print("=============RESPONSE DATA==================")
//                    print(resultValue)
//
//                    let statusStr = resultValue["status"]["error_code"].boolValue
//                    if statusStr == false{
//
//                    }
//                    else{
//                        //errors
//                        let message = resultValue["message"].stringValue
//
//                    }
//
//                case .failure(let err):
//                    print(err.localizedDescription)
//                }
//            }
//
//        }else{
//            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
//        }
//    }
    
    func callForceCloseIncident(){
        if Connectivity.isConnectedToInternet {
            var finalArray = NSMutableArray()
            var final_formate = [String:Any]()
            for i in 0...selectedArray.count - 1{
                final_formate["Incidents_report_data_id"] = selectedArray[i]
                finalArray.add(final_formate)
            }
            
            convertedArrayString = selectedArray.componentsJoined(by:",")
            convertedArrayString = "Incidents_report_data_id : \(convertedArrayString)"
            var param:[String:AnyObject] = [String:AnyObject]()
            var param2:[String:AnyObject] = [String:AnyObject]()

            let companyID:String = (UserDefaults.standard.value(forKey: "COMPANYID") as? String)!
            
            let formatter = DateFormatter()
                //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            
                //let defaultTimeZoneStr = formatter.string(from: date)
                //formatter.timeZone = NSTimeZone.local
            
            let obj:[String:AnyObject] = [:]
             let date = Date()
                let utcTimeZoneStr = formatter.string(from: date)
                print(utcTimeZoneStr)
            
                param["timeUTC"] = utcTimeZoneStr as AnyObject
                param["source"] = "MOB" as AnyObject
                param["companyId"] = companyID as AnyObject
                param2["Incidents_report_data_id"] = convertedArrayString as AnyObject
                param["list"] = finalArray as AnyObject
                print("force close incident: \(param)")
            let opt = WebServiceOperation.init(API.CloseForceIncident.getURL()?.description ?? "", param, .WEB_SERVICE_POST, nil)
            opt.completionBlock = {
                DispatchQueue.main.async {
                    print(opt.responseData!)
                    guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                        return
                    }
                    print(dictResponse)
                    if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                        if errorCode.intValue == 0 {
                            
                                    let okclause = PROJECT_CONSTANT.CLOUS{
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    
                                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Your request submitted successfully.", AllActions: ["OK":okclause], Style: .alert)
                                
                            
                        }else{
                            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)

                        }
                    }

                }
                self.selectedArray.removeAllObjects()
                self.selectedIndexArray.removeAllObjects()
            }
            appDel.operationQueue.addOperation(opt)
            
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
        }
    }
//    {
//
//        convertedArrayString = selectedArray.componentsJoined(by:",")
//        var param:[String:AnyObject] = [String:AnyObject]()
//        param["source"] = "MOB" as AnyObject
//        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
//
//            param["companyId"] = companyID as AnyObject
//
//
//        }
//        param["Incidents_report_data_id"] = convertedArrayString as AnyObject
//        let formatter = DateFormatter()
//            //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
//            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
//
//            //let defaultTimeZoneStr = formatter.string(from: date)
//            //formatter.timeZone = NSTimeZone.local
//         let date = Date()
//            let utcTimeZoneStr = formatter.string(from: date)
//            print(utcTimeZoneStr)
//            param["timeUTC"] = utcTimeZoneStr as AnyObject
//        param["timeUTC"] = utcTimeZoneStr as AnyObject
//
//        let opt = WebServiceOperation.init((API.CloseForceIncident.getURL()?.absoluteString ?? ""), param, .WEB_SERVICE_POST, nil)
//        opt.completionBlock = {
//            DispatchQueue.main.async {
//
//                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
//                    return
//                }
//                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber {
//                    if errorCode.intValue == 0 {
//
//                    }else{
//
//                        //PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
//                    }
//                }
//            }
//        }
//        appDel.operationQueue.addOperation(opt)
//
//    }
    
    
    
    func callSubmitBugReportAPI(){
           if Connectivity.isConnectedToInternet {
               var param:[String:AnyObject] = [String:AnyObject]()
               
               
                   if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                       param["user_id"] = userId as AnyObject
                       param["bugdetails"] = txtvw_BugReport.text as AnyObject
                       param["lat"] = lat as AnyObject
                       param["lang"] = long as AnyObject
                   }

               print(param)
               let opt = WebServiceOperation.init(API.SubmitBugReport.getURL()?.absoluteString ?? "", param, .WEB_SERVICE_POST, nil)
               opt.completionBlock = {
                   DispatchQueue.main.async {
                       print(opt.responseData!)
                       guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                           return
                       }
                       if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                           if errorCode.intValue == 0 {
                               
                                       let okclause = PROJECT_CONSTANT.CLOUS{
                                           self.navigationController?.popViewController(animated: true)
                                       }
                                       
                                       PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Your request submitted successfully.", AllActions: ["OK":okclause], Style: .alert)
                               self.transparentBugReportView.isHidden = true
                                   
                               
                           }else{
                               PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                               self.transparentBugReportView.isHidden = true

                           }
                       }

                   }
               }
               appDel.operationQueue.addOperation(opt)
               
           }else{
               PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
           }
       }
    
    @IBAction func btnCloseScan(_ sender: Any) {
        self.viewScan.isHidden = true
        self.transperentBlackView.isHidden = true
        self.imgviewQR.image = nil
    }
    @IBAction func btnSubmitOnscene(_ sender: ButtionX) {
        self.view.endEditing(true)
        if serveyVia != "mobile"{
            
            if txtDirection.text?.count ?? 0 < 1  {
                var message = "Please select direction"
                if isSurvey{
                    message = "Please enter name"
                }else{
                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody:message , AllActions: ["OK":nil], Style: .alert)
                    return
                }
                
            }
            
            
            guard txtDescriptionStatus.text?.count ?? 0 > 0 else {
                var message = "Please select description"
                if isSurvey{
                    message = "Please enter email"
                }
                PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: message, AllActions: ["OK":nil], Style: .alert)
                return
            }
        }else{
           
            guard txtDescriptionStatus.text?.count ?? 0 > 0 else {
                var message = "Please select description"
                if isSurvey{
                    message = "Please enter email"
                }
                PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: message, AllActions: ["OK":nil], Style: .alert)
                return
            }
            
        }
        if isManager == false{
        if self.shiftStatus{
            //1 << petrolling
            // 2 << on scene
            
            self.transperentBlackView.isHidden = true
            self.viewOnsceneStatus.isHidden = true
            if isSurvey{
                self.callSurvey()
            }else{
                //self.statusIndicatorApiCall(status: self.isPetrolling)
            }
            
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoShift, AllActions: ["OK":nil], Style: .alert)
        }
        }else{
            self.transperentBlackView.isHidden = true
            self.viewOnsceneStatus.isHidden = true
            if isSurvey{
                self.callSurvey()
            }else{
                //self.statusIndicatorApiCall(status: self.isPetrolling)
            }
        }
    }
    @IBAction func btnCancelOnscene(_ sender: ButtionX) {
        self.transperentBlackView.isHidden = true
        self.viewOnsceneStatus.isHidden = true
        self.view.endEditing(true)
    }
    
    @IBAction func buttonNotification(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "NotificationListVC") as! NotificationListVC
        self.navigationController?.pushViewController(vc, animated: true)
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func buttonLogOut(_ sender: Any) {
        self.view.endEditing(true)
        PopupCustomView.sharedInstance.reSetPopUp()
        PopupCustomView.sharedInstance.textView?.text = "Are you sure you want to logout?"
        PopupCustomView.sharedInstance.btnLeft.addTarget(self, action: #selector(btnYesPressed(_:)), for: .touchUpInside)
        PopupCustomView.sharedInstance.btnRight.addTarget(self, action: #selector(self.btnNoPressed(_:)), for: .touchUpInside)
        PopupCustomView.sharedInstance.display(onView: UIApplication.shared.keyWindow) {
            
            
        }
    }
    
    @objc func btnShiftNoPressed(_ sender: UIButton){
        PopupCustomView.sharedInstance.hide()
        TimeService.instance.didShiftShow = false
    }
    
    @objc func btnNoPressed(_ sender: UIButton){
        PopupCustomView.sharedInstance.hide()
    }
    @objc func btnYesPressed(_ sender: UIButton){
        //self.logoutApiCall()
        PopupCustomView.sharedInstance.hide()
        isIndicateLogout = true
        self.btnCloseIncident.setTitle("CLOSE INCIDENTS AND LOGOUT", for: .normal)
        self.callOpenIncidentApi()
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
    
    func goToReporterTab()  {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReportVC") as? ReportVC {
            //viewController.newsObj = newsObj
            let navigationController = UINavigationController(rootViewController: VC)
            navigationController.isNavigationBarHidden = true
            self.view.window?.rootViewController = navigationController
        }
    }
    func statartLocationUpdate(isStartUpdate:Bool)  {
        if isStartUpdate { //true
//            guard  MyLocationManager.share.internalTimer == nil else {
//                debugPrint("Already running")
//                return
//            }
            MyLocationManager.share.requestForLocation()
            MyLocationManager.share.configManager()
            //MyLocationManager.share.startTimer()
        }else{
           // MyLocationManager.share.stopTimer()
            MyLocationManager.share.distanceMile = 0.0
        }
    }
    
    
    
    func popToLogin()  {
        self.resetDefaults()
        UserDefaults.standard.set("", forKey: "SHIFTID")
        TimeService.instance.didShiftShow = true
//        for controller in self.navigationController!.viewControllers as Array {
//            if controller.isKind(of: LoginVC.self) {
//                self.navigationController!.popToViewController(controller, animated: true)
//                return
//            }
//        }
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.10, execute: {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.popPushToVC(ofKind: LoginVC.self, pushController: vc)//(vc, animated: true)
                    })
        
        
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
    
    @objc func btnPressEndSift(_ sender: UIButton){
        PopupCustomView.sharedInstance.hide()
        //self.endShiftApicall(isLogout: false)
        isIndicateLogout = false
        self.btnCloseIncident.setTitle("CLOSE INCIDENTS AND END SHIFT", for: .normal)
        self.callOpenIncidentApi()
        
    }
    @objc func applicationWillResignActive(notification: NSNotification) {
        if isbecomactive == true{
            self.callVersionChecking()
        }

    }
    func callVersionChecking() {
          //let myGroup = DispatchGroup()
          // myGroup.enter()
           var param:[String:AnyObject] = [String:AnyObject]()
          if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    param["version"] = version as AnyObject
                     param["device"] = "1" as AnyObject
                }
            //param["version"] =
               //"6" as AnyObject
           
           print(param)
           let operation = WebServiceOperation.init((API.version_control.getURL()?.absoluteString ?? ""), param, .WEB_SERVICE_POST, nil)
           operation.completionBlock = {
               print(operation.responseData?.dictionary?.prettyprintedJSON ?? "")
            self.isbecomactive = true
                   guard let dictResponse = operation.responseData?.dictionary, dictResponse.count > 0 else {
                      
                       return
                   }
                   guard let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0 else {
                      
                       return
                   }
                   
                   
                   guard let statusCode = dictStatus["error_code"] as? NSNumber else {
                       
                      
                       return
                   }
                   if statusCode.intValue == 0{
                    if let responseDict = dictResponse["result"] as? [String:Any] {
                        if let updateRespponse = responseDict["data"] as? [String:Any] {
                             let require = updateRespponse["update_type"] as? String
                            //let severity = updateRespponse["severity"] as? String
                            let dialog_message = updateRespponse["dialog_message"] as? String
                            let okClause =   PROJECT_CONSTANT.CLOUS {
                               // myGroup.leave()
                               // myGroup.notify(queue: DispatchQueue.main) {
                                    ////// do your remaining work
                                //}
                            }
                            
                           // if require?.uppercased() == "yes".uppercased(){
                                if require?.uppercased() == "critical".uppercased(){
                                    
                                    DispatchQueue.main.async {
                                        
                                        let updatePop = PROJECT_CONSTANT.CLOUS{
                                                                                       if let url = URL(string: "itms-apps://apple.com/app/id1531322285") {
                                                                                           UIApplication.shared.open(url)
                                                                                       }
                                                                                   }
                                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please update the latest version from app store", AllActions: ["Update":updatePop], Style: .alert)
                                    }
                                   
                                } else {
                                    let updatePop = PROJECT_CONSTANT.CLOUS{
                                                                                                                          if let url = URL(string: "itms-apps://apple.com/app/id1531322285") {
                                                                                                                              UIApplication.shared.open(url)
                                                                                                                          }
                                                                                                                      }
                                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please update the latest version from app store", AllActions: ["Update":updatePop,"Later":nil], Style: .alert)
                                }
//                            }else if require?.uppercased() == "no".uppercased(){
//                                //myGroup.leave()
//                            }
                        }
                      
                    } else {
                       
                    }
                } else {
                      
                   }
           }
           
        appDel.operationQueue.addOperation(operation)
       }
    
    
    func dashBoardApiCall(){
        if Connectivity.isConnectedToInternet {
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String {
                var param:[String:AnyObject] = [String:AnyObject]()
                param["user_id"] = userId as AnyObject
                param["source"] = "MOB" as AnyObject
                
                print(param)
                let opt = WebServiceOperation.init((API.MenuAccess.getURL()?.absoluteString ?? ""), param)
                opt.completionBlock = {
                    DispatchQueue.main.async {
                        print(opt.responseData?.dictionary)
                        guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                            return
                        }
                        if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                            if errorCode.intValue == 0 {
                                if let dictResult = dictResponse["result"] as? [String:Any] {
                                    
                                    if let dashboardData = dictResult["dashboardData"] as? [String:Any], dictResult.count > 0{
                                        if let count = dashboardData ["countUnreadNotification"] as? Int{
                                            if count > 0{
                                                self.lblNotify.isHidden = false
                                                self.lblNotify.text = String(count)
                                            }else{
                                                self.lblNotify.isHidden = true
                                            }
                                        }else{
                                            self.lblNotify.isHidden = true
                                        }
                                        UserDefaults.standard.set(dashboardData ["shift_id"] as? String, forKey: "SHIFTID")
                                        if dashboardData ["state_name"] as? String != ""{
                                            self.labelState.isHidden = false
                                            self.labelState.text = "State Name: \(dashboardData ["state_name"] as? String ??  " ")"
                                        }else{
                                            self.labelState.isHidden = true
                                        }
                                        UserDefaults.standard.set(dashboardData ["state_name"] as? String, forKey: "STATENAME")
                                        UserDefaults.standard.set(dashboardData ["state_id"] as? String, forKey: "STATEID")
                                        UserDefaults.standard.set(dashboardData ["vehicle_id"] as? String, forKey: "VEHICLEID")
                                        self.stringVehicle = dashboardData ["vehicleId"] as? String ?? ""
                                        UserDefaults.standard.set(dashboardData ["vehicleId"] as? String, forKey: "VEHICLENAME")
                                        if self.stringVehicle == ""{
                                            self.labelVechielID.isHidden = true
                                        }else{
                                            self.labelVechielID.text = "Vehicle Id: \(self.stringVehicle)"
                                            self.labelVechielID.isHidden = false
                                        }
                                        
                                        if let operationID = dashboardData ["operation_area_id"] as? String{
                                            if operationID == ""{
                                                UserDefaults.standard.removeObject(forKey: "OPERATIONID")
                                            }else{
                                        UserDefaults.standard.set(operationID, forKey: "OPERATIONID")
                                            }
                                        }else{
                                            UserDefaults.standard.removeObject(forKey: "OPERATIONID")
                                        }
                                        //share_link
                                        if let shareLinkString = dashboardData ["share_link"] as? String{
                                            if shareLinkString == ""{
                                                self.isShare_linkAvailable = ""
                                            }else{
                                                self.isShare_linkAvailable = shareLinkString
                                            }
                                        }
                                        self.shiftStatus = dashboardData ["shift_id"] as? String  == "" ? false : true
                                        
                                        if let rollID = dashboardData ["roleId"] as? String{
                                            if rollID == "3"{
                                                if self.shiftStatus == false{
                                                    if self.showShiftScreen == false{
                                                        //                                            UserDefaults.standard.set("1", forKey: "ShiftShatCalLed")
                                                        let vc = self.storyboard?.instantiateViewController(identifier: "StartShiftVC") as! StartShiftVC
                                                        self.navigationController?.pushViewController(vc, animated: true)
                                                        self.showShiftScreen = true
                                                    }
                                                }
                                            }
                                            
                                            
                                        }
                                        self.isPetrolling = dashboardData ["indicator_status"] as? String  == "1" ? false : true
                                        
                                        do{
                                            self.arrayshift2 = dashboardData["getMenuList"] as! [Dictionary<String, String>]
                                            if self.isShare_linkAvailable != ""{
                                                var paramlist:[String:String] = [:]
                                                paramlist["permissiontype_id"] = "555"
                                                self.arrayshift2.append(paramlist)
                                            }
                                            
                                            print("pritam",self.arrayshift2)
                                            DispatchQueue.main.async {
                                                self.BreakButtonUpdate()
                                                //if self.isPetrolling == true{
                                                    
//                                                    if UserDefaults.standard.value(forKey: "Petrolling") != nil {
//                                                        if MyLocationManager.share.calculateGreaterDistanceIn1Miles() == true{
//                                                            // self.isPetrolling = false
//                                                            MyLocationManager.share.distanceMile = 0.0
//
//                                                           // self.statusIndicatorApiCall(status: self.isPetrolling)
//
//                                                        }
//                                                    }
                                           //     }
                                               // self.statartLocationUpdate(isStartUpdate:self.isPetrolling)
                                                self.DashboardCollectionView.reloadData()
                                                self.DashboardCollectionView.isHidden =  false
                                            }
                                            
                                        }
                                        if self.shiftStatus == true{
                                            if UserDefaults.standard.value(forKey: "PREOPSSAVED") == nil {
                                                let vc = self.storyboard?.instantiateViewController(identifier: "StartPreOPsVC") as! StartPreOPsVC
                                                vc.isHome = false
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }
                                        }else{
                                            if let manager = dashboardData ["role_name"] as? String{
                                                if manager == "Manager"{
                                                    self.isManager = true
                                                    if self.isPetrolling == false{
                                                        if UserDefaults.standard.value(forKey: "ASKPETROLLING") == nil {
                                                            let yesClause =  PROJECT_CONSTANT.CLOUS{
                                                                let vc = self.storyboard?.instantiateViewController(identifier: "StartShiftVC") as! StartShiftVC
                                                                self.navigationController?.pushViewController(vc, animated: true)
                                                            }
                                                            let noClause =  PROJECT_CONSTANT.CLOUS{
                                                                
                                                            }
                                                            
                                                            
                                                            self.displayAlert(Header: App_Title, MessageBody: "“Are you going to patrol?”", AllActions: ["YES":yesClause,"NO":nil], Style: .alert)
                                                            UserDefaults.standard.set("1", forKey: "ASKPETROLLING")
                                                            
                                                        }
                                                    }
                                                }
                                            }else{
                                               // self.isManager = true
                                            }
                                        }
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
    func backGroundLocationUpdate()  {
        
    }
    
    // change new menu status
    /*
    func statusIndicatorApiCall(status: Bool){
        
        
        if Connectivity.isConnectedToInternet {
             var param:[String:AnyObject] = [String:AnyObject]()
            if  let shiftId: String = UserDefaults.standard.value(forKey: "SHIFTID") as? String  {
                param["operator_shift_time_details_id"] = shiftId as AnyObject
                }
               
                param["indicator_status"] = status ? 1 as AnyObject : 2  as AnyObject
                
                param["source"] = "MOB" as AnyObject
                param["indicator_direction"] = txtDirection.text as AnyObject
                param["indicator_description"] = txtDescriptionStatus.text as AnyObject
                param["lat"] = MyLocationManager.share.myCurrentLocaton?.latitude as AnyObject
                param["lng"] = MyLocationManager.share.myCurrentLocaton?.longitude as AnyObject
                if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                                  // param["source"] = "MOB" as AnyObject
                                   param["user_id"] = userId as AnyObject
                }else{
                    param["user_id"] = "17" as AnyObject
                 }
                if let vID:String = UserDefaults.standard.value(forKey: "VEHICLEID") as? String {
                    param["vehicle_id"] = vID as AnyObject
                }else{
                    param["vehicle_id"] = "25" as AnyObject
                }
                let date = Date()
               print("vehicleID=====%@",UserDefaults.standard.value(forKey: "VEHICLEID") as? String)
                
                let formatter = DateFormatter()
                //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            
                let defaultTimeZoneStr = formatter.string(from: date)
                //formatter.timeZone = NSTimeZone.local
                let utcTimeZoneStr = formatter.string(from: date)
                print(utcTimeZoneStr)
                param["timeUTC"] = utcTimeZoneStr as AnyObject
                print(param)
                let opt = WebServiceOperation.init((API.statusIndicator.getURL()?.absoluteString ?? ""), param)
                opt.completionBlock = {
                    DispatchQueue.main.async {
                        
                        guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                            return
                        }
                        if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                            if errorCode.intValue == 0 {
                                DispatchQueue.main.async {
                                    
                                    if self.isPetrolling == false{
                                        var paramSave:[String:AnyObject] = [String:AnyObject]()
                                        paramSave["lat"] = MyLocationManager.share.myCurrentLocaton?.latitude as AnyObject?
                                        paramSave["long"] = MyLocationManager.share.myCurrentLocaton?.longitude as AnyObject?
                                        UserDefaults.standard.set(paramSave, forKey: "Petrolling")
                                    }else{
                                        UserDefaults.standard.removeObject(forKey: "Petrolling")
                                    }
                                    
                                    self.isPetrolling = !self.isPetrolling
                                    self.DashboardCollectionView.reloadData()
                                    self.DashboardCollectionView.isHidden =  false
                                    self.statartLocationUpdate(isStartUpdate: self.isPetrolling)
                                    self.displayAlert(Header: App_Title, MessageBody: "Success", AllActions: ["OK":nil], Style: .alert)
                                }
                            }else{
                                
                                PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                            }
                        }
                    }
                }
                appDel.operationQueue.addOperation(opt)
            //}
            
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
        }
    }
    */
    func callSurvey(){
        if Connectivity.isConnectedToInternet {
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
                var param:[String:AnyObject] = [String:AnyObject]()
                param["companyId"] = companyID as AnyObject
                param["userId"] = userId as AnyObject
                //param["source"] = "MOB" as AnyObject
                param["userName"] = self.txtDirection.text as AnyObject
                param["userEmail"] = self.txtDescriptionStatus.text as AnyObject
                if self.serveyVia == "QR Code"{
                param["via"] = "mobile" as AnyObject
                }else{
                param["via"] = self.serveyVia as AnyObject
                }
                
                
                print(param)
                let opt = WebServiceOperation.init((API.sendSurvey.getURL()?.absoluteString ?? ""), param)
                opt.completionBlock = {
                    DispatchQueue.main.async {
                        
                        guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                            return
                        }
                        if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                            if errorCode.intValue == 0 {
                                DispatchQueue.main.async {
                                    if self.serveyVia != "mobile"{
                                        if self.serveyVia == "web"{
                                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Survey link sent to email.", AllActions: ["OK":nil], Style: .alert)
                                        }
                                    }
                                    
                                    
                                    if let dictResult = dictResponse["result"] as? [String:Any] {
                                        
                                        if let getData = dictResult["data"] as? [String:Any], dictResult.count > 0{
                                            
                                            if let surveyLink = getData["surveyLink"] as? String{
                                                if let url = URL(string: surveyLink) {
                                                    if self.serveyVia == "QR Code"{
                                                        let imageQR = self.generateQRCode(from: surveyLink ?? "")
                                                        self.imgviewQR.image = imageQR
                                                        self.transperentBlackView.isHidden = false
                                                        self.viewScan.isHidden = false
                                                        
                                                    }else{
                                                         UIApplication.shared.open(url)
                                                    }
                                                }
                                            }
                                            
                                            
                                        }
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
                                self.shiftStatus = false
                                DispatchQueue.main.async {
                                    if isLogout{
                                        self.popToLogin()
                                    }else{
                                        self.DashboardCollectionView.reloadData()
                                        self.goToReporterTab()
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
    
    @IBAction func btnVehicleIDSubmit(_ sender: UIButton) {
        if selectedVehicle != nil{
        self.viewVehicleListShow.isHidden = true
            UserDefaults.standard.set(selectedVehicle?.vehicle_id ?? "", forKey: "VEHICLEID")
            UserDefaults.standard.set(selectedVehicle?.state_name , forKey: "STATENAME")
            UserDefaults.standard.set(selectedVehicle?.state_id, forKey: "STATEID")
//            UserDefaults.standard.set(selectedVehicle?.operation_area_id, forKey: "OPERATIONID")
            UserDefaults.standard.set(selectedVehicle?.iD, forKey: "VEHICLENAME")
            UserDefaults.standard.synchronize()
        self.view.endEditing(true)
        switch menuIDNumber {
                    case 1:
                        let vc = storyboard?.instantiateViewController(identifier: "IncidentVC") as! IncidentVC
                        vc.shiftStatus = self.shiftStatus
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    case 2:
                        if self.shiftStatus{
                            PopupCustomView.sharedInstance.reSetPopUp()
                            PopupCustomView.sharedInstance.textView?.text = "Do you want to end the shift ?"
                            PopupCustomView.sharedInstance.btnLeft.addTarget(self, action: #selector(btnPressEndSift(_:)), for: .touchUpInside)
                            PopupCustomView.sharedInstance.btnRight.addTarget(self, action: #selector(self.btnNoPressed(_:)), for: .touchUpInside)
                            PopupCustomView.sharedInstance.display(onView: UIApplication.shared.keyWindow) {
                                
                                
                            }
                            
                        }else{
                            let vc = storyboard?.instantiateViewController(identifier: "StartShiftVC") as! StartShiftVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    case 3:
                       
                            let vc = storyboard?.instantiateViewController(identifier: "FuelReportVC") as! FuelReportVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    case 4:
                      let vc = storyboard?.instantiateViewController(withIdentifier: "StartPreOPsVC") as! StartPreOPsVC
                      self.navigationController?.pushViewController(vc, animated: true)
                        
                    case 5:
                         let vc = storyboard?.instantiateViewController(withIdentifier: "ExtraTimeReportVC") as! ExtraTimeReportVC
                                       self.navigationController?.pushViewController(vc, animated: true)
                            
                        
                        
                    case 6:
                       let vc = storyboard?.instantiateViewController(identifier: "FuelReportVC") as! FuelReportVC
                       vc.pageFor = "Crash Report"
                       self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    case 7:
                       
                            let vc = storyboard?.instantiateViewController(identifier: "SosVC") as! SosVC
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        
                    case 8:
                       
                           
                                let vc = storyboard?.instantiateViewController(identifier: "AdminHelpVC") as! AdminHelpVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            
                    case 9:
                       
                            let vc = storyboard?.instantiateViewController(identifier: "FuelReportVC") as! FuelReportVC
                                           vc.pageFor = "Maintenance Report"
                                           self.navigationController?.pushViewController(vc, animated: true)
                            
                    case 10:
                      
                                let vc = storyboard?.instantiateViewController(identifier: "InspectionVC") as! InspectionVC
                                               self.navigationController?.pushViewController(vc, animated: true)
                            
                    case 37:
                        
                       
                            
                            self.showSurveyPopup()
            
                        
                    default:
                        
                            self.showSurveyPopup()
                            
                       
                    }
        }else{
            self.displayAlert(Header: App_Title, MessageBody: "Please choose vehicle", AllActions: ["OK":nil], Style: .alert)
        }
    }
    
    @IBAction func btnVehicleCancel(_ sender: Any) {
        self.viewVehicleListShow.isHidden = true
        self.view.endEditing(true)
    }
    fileprivate func showPopupPetrolling(){
        isSurvey = false
        heightSurvey.constant = 280
        viewChooseServey.isHidden = true
        txtDescriptionStatus.text = ""
        txtDirection.text = ""
        downarrow1.isHidden = false
        downarrow2.isHidden = false
        self.lblfirst.text = "Direction:"
        self.lblSecond2.text = "Description:"
        self.createPickerView(textField: txtDirection)
        self.createPickerView(textField: txtDescriptionStatus)
        txtDirection.addLeftViewPadding(padding: 9, placeholderText: "Select")
        txtDescriptionStatus.addLeftViewPadding(padding: 9, placeholderText: "Select")
        txtDescriptionStatus.addRightViewPadding(padding: 20)
        txtDirection.addRightViewPadding(padding: 20)
        self.transperentBlackView.isHidden = false
        self.viewOnsceneStatus.isHidden = false
    }
    
    func touchesEnded(touches: NSSet, withEvent event: UIEvent)
    {
        super.touchesEnded(touches as! Set<UITouch>, with: event)
        TimeService.instance.resetInactivityTimer()
    }
}

// MARK: - Inactivity Alert delegate
extension DashboardViewController: InactivityAlertControllerDelegate {
    func inactivityAlertControllerDidSelectLogout(_ inactivityAlertController: InactivityAlertController) {
        logout()
    }
    
    func inactivityAlertControllerDidSelectContinue(_ inactivityAlertController: InactivityAlertController) {
        setupInactivityTimers()
        inactivityAlertController.presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - Window delegate
extension DashboardViewController: WindowDelegate {
    func window(_ window: Window, touchDetectedIn event: UIEvent) {
        print("============================Screen has been tapped============================")
        TimeService.instance.resetInactivityTimer()
    }
}

extension Notification.Name {

    static let appTimeout = Notification.Name("appTimeout")

}

extension UIApplication {
    struct Constants {
        static let CFBundleShortVersionString = "CFBundleShortVersionString"
    }
    class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: Constants.CFBundleShortVersionString) as! String
    }
  
    class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
  
    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
      
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
}

extension DashboardViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //if isShare_linkAvailable == false{
             return arrayshift2.count
//        }else{
//        return arrayshift2.count + 1
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = DashboardCollectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCollCell", for: indexPath) as! DashboardCollCell
        cell.lblNew.isHidden = true
        if self.arrayshift2.count > 0 {
            if let item = self.arrayshift2[safe: indexPath.row] {
                print(item)
                 let idNumber = self.arrayshift2[indexPath.row]["permissiontype_id"]
                 switch idNumber {
                           case "1":
//                            if self.model.incidentdetailsArray?.count ?? 0 > 0{
//                              cell.lblNew.isHidden = false
//                            }else{
//                                cell.lblNew.isHidden = true
//                            }
                               cell.labelDashboard.text = arrayshift[0]
                               cell.imgDashboard.image = UIImage.init(named: arrayImage[0])
                           case "2":
                                cell.labelDashboard.text = self.shiftStatus == false ?   arrayshift[1] : "End Shift"
                               
                               cell.imgDashboard.image = UIImage.init(named: arrayImage[1])
                           case "3":
                               cell.labelDashboard.text = arrayshift[2]
                               cell.imgDashboard.image = UIImage.init(named: arrayImage[2])
                           case "4":
                               cell.labelDashboard.text = arrayshift[3]
                               cell.imgDashboard.image = UIImage.init(named: arrayImage[3])
                               
                           case "5":
                               cell.labelDashboard.text = arrayshift[4]
                               cell.imgDashboard.image = UIImage.init(named: arrayImage[4])
                           case "6":
                               cell.labelDashboard.text = arrayshift[5]
                               cell.imgDashboard.image = UIImage.init(named: arrayImage[5])
                           case "7":
                               cell.labelDashboard.text = arrayshift[6]
                               cell.imgDashboard.image = UIImage.init(named: arrayImage[6])
                           case "8":
                               cell.labelDashboard.text = arrayshift[7]
                               cell.imgDashboard.image = UIImage.init(named: arrayImage[7])
                           case "9":
                               cell.labelDashboard.text = arrayshift[8]
                               cell.imgDashboard.image = UIImage.init(named: arrayImage[8])
                           case "10":
                               cell.labelDashboard.text = arrayshift[9]
                               cell.imgDashboard.image = UIImage.init(named: arrayImage[9])
                           case "37":
                              cell.labelDashboard.text = arrayshift[10]
                             cell.imgDashboard.image = UIImage.init(named: arrayImage[10])
                           case "555":
                           cell.labelDashboard.text = arrayshift.last
                           cell.imgDashboard.image = UIImage.init(named: arrayImage.last ?? "")
                default:
                    cell.labelDashboard.text = arrayshift.last
                    cell.imgDashboard.image = UIImage.init(named: arrayImage.last ?? "")
                }
            }else{
                cell.labelDashboard.text = arrayshift.last
                cell.imgDashboard.image = UIImage.init(named: arrayImage.last ?? "")
            }
        }
        
        
        return cell
    }
    
    fileprivate func showSurveyPopup() {
        isSurvey = true
        if serveyVia == ""{
            txtFieldChooseServey.text = "Mobile"
            serveyVia = "mobile"
        }
        heightSurvey.constant = 400
        viewChooseServey.isHidden = false
        txtDescriptionStatus.text = ""
        txtDirection.text = ""
        self.lblfirst.text = "Name:"
        self.lblSecond2.text = "Email:*"
        self.lblSecond2.setSubTextColor(pSubString: "*", pColor: .red)
        downarrow1.isHidden = true
        downarrow2.isHidden = true
        txtDirection.inputView = nil
        txtDirection.inputAccessoryView = nil
        txtDescriptionStatus.inputAccessoryView = nil
        txtDescriptionStatus.inputView = nil
        txtDirection.addLeftViewPadding(padding: 9, placeholderText: "Enter Name")
        txtDescriptionStatus.addLeftViewPadding(padding: 9, placeholderText: "Enter Email")
        txtDescriptionStatus.addRightViewPadding(padding: 10)
        txtDirection.addRightViewPadding(padding: 10)
        self.transperentBlackView.isHidden = false
        self.viewOnsceneStatus.isHidden = false
        
    }
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TimeService.instance.resetInactivityTimer()
        if self.arrayshift2[safe: indexPath.row] != nil {
            let idNumber = self.arrayshift2[indexPath.row]["permissiontype_id"]
            menuIDNumber = Int(idNumber ?? "0") ?? 0
            switch idNumber {
            case "1":
                
//                                   if self.shiftStatus{
//                                       let vc = storyboard?.instantiateViewController(identifier: "IncidentVC") as! IncidentVC
//                                       self.navigationController?.pushViewController(vc, animated: true)
//                                   }else{
//                                       PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoShift, AllActions: ["OK":nil], Style: .alert)
//
//                                   }
                if self.isManager == true{
                    if self.shiftStatus == false{
                    self.viewVehicleListShow.isHidden = false
                    }else{
                    let vc = storyboard?.instantiateViewController(identifier: "IncidentVC") as! IncidentVC
                        vc.shiftStatus = self.shiftStatus
                    self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    if self.shiftStatus{
                        let vc = storyboard?.instantiateViewController(identifier: "IncidentVC") as! IncidentVC
                        vc.shiftStatus = self.shiftStatus
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoShift, AllActions: ["OK":nil], Style: .alert)
                        
                    }
                }
                               
                
            case "2":
                if self.shiftStatus{
                    PopupCustomView.sharedInstance.reSetPopUp()
                    PopupCustomView.sharedInstance.textView?.text = "Do you want to end the shift ?"
                    PopupCustomView.sharedInstance.btnLeft.addTarget(self, action: #selector(btnPressEndSift(_:)), for: .touchUpInside)
                    PopupCustomView.sharedInstance.btnRight.addTarget(self, action: #selector(self.btnNoPressed(_:)), for: .touchUpInside)
                    PopupCustomView.sharedInstance.display(onView: UIApplication.shared.keyWindow) {
                        
                        
                    }
                    
                }else{
                    let vc = storyboard?.instantiateViewController(identifier: "StartShiftVC") as! StartShiftVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case "3":
                if self.isManager == true{
                    if self.shiftStatus == false{
                    self.viewVehicleListShow.isHidden = false
                    }else{
                    let vc = storyboard?.instantiateViewController(identifier: "FuelReportVC") as! FuelReportVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    if self.shiftStatus{
                        let vc = storyboard?.instantiateViewController(identifier: "FuelReportVC") as! FuelReportVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoShift, AllActions: ["OK":nil], Style: .alert)
                        
                    }
                }
            case "4":
                if self.isManager == true{
                    if self.shiftStatus == false{
                    self.viewVehicleListShow.isHidden = false
                     }else{
                     let vc = storyboard?.instantiateViewController(withIdentifier: "StartPreOPsVC") as! StartPreOPsVC
                                   self.navigationController?.pushViewController(vc, animated: true)
                }
                }else{
                    if self.shiftStatus{
                        let vc = storyboard?.instantiateViewController(withIdentifier: "StartPreOPsVC") as! StartPreOPsVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoShift, AllActions: ["OK":nil], Style: .alert)
                        
                    }
                }
            case "5":
                if self.isManager == true{
                     if self.shiftStatus == false{
                    self.viewVehicleListShow.isHidden = false
                     }else{
                    let vc = storyboard?.instantiateViewController(withIdentifier: "ExtraTimeReportVC") as! ExtraTimeReportVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    if self.shiftStatus{
                        let vc = storyboard?.instantiateViewController(withIdentifier: "ExtraTimeReportVC") as! ExtraTimeReportVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoShift, AllActions: ["OK":nil], Style: .alert)
                        
                    }
                }
                
            case "6":
                if self.isManager == true{
                     if self.shiftStatus == false{
                    self.viewVehicleListShow.isHidden = false
                     }else{
                    let vc = storyboard?.instantiateViewController(identifier: "FuelReportVC") as! FuelReportVC
                    vc.pageFor = "Crash Report"
                    self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    if self.shiftStatus{
                        let vc = storyboard?.instantiateViewController(identifier: "FuelReportVC") as! FuelReportVC
                        vc.pageFor = "Crash Report"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoShift, AllActions: ["OK":nil], Style: .alert)
                        
                    }
                }
                
            case "7":
                if self.isManager == true{
                     if self.shiftStatus == false{
                    self.viewVehicleListShow.isHidden = false
                     }else{
                    let vc = storyboard?.instantiateViewController(identifier: "SosVC") as! SosVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    if self.shiftStatus{
                        let vc = storyboard?.instantiateViewController(identifier: "SosVC") as! SosVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoShift, AllActions: ["OK":nil], Style: .alert)
                        
                    }
                }
            case "8":
                if self.isManager == true{
                    if self.shiftStatus == false{
                    self.viewVehicleListShow.isHidden = false
                    }else{
//                     let vc = storyboard?.instantiateViewController(identifier: "AdminHelpVC") as! AdminHelpVC
//                                           self.navigationController?.pushViewController(vc, animated: true)
                        self.transparentBugReportView.isHidden = false
                    }
                }else{
                    if self.shiftStatus{
//                        let vc = storyboard?.instantiateViewController(identifier: "AdminHelpVC") as! AdminHelpVC
//                        self.navigationController?.pushViewController(vc, animated: true)
                        self.transparentBugReportView.isHidden = false
                    }else{
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoShift, AllActions: ["OK":nil], Style: .alert)
                        
                    }
                }
            case "9":
                if self.isManager == true{
                   if self.shiftStatus == false{
                    self.viewVehicleListShow.isHidden = false
                   }else{
                    let vc = storyboard?.instantiateViewController(identifier: "FuelReportVC") as! FuelReportVC
                    vc.pageFor = "Maintenance Report"
                    self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    if self.shiftStatus{
                        let vc = storyboard?.instantiateViewController(identifier: "FuelReportVC") as! FuelReportVC
                        vc.pageFor = "Maintenance Report"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoShift, AllActions: ["OK":nil], Style: .alert)
                    }
                }
            case "10":
                if self.isManager == true{
                     if self.shiftStatus == false{
                    self.viewVehicleListShow.isHidden = false
                     }else{
                        let vc = storyboard?.instantiateViewController(identifier: "InspectionVC") as! InspectionVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
//                    let vc = storyboard?.instantiateViewController(identifier: "FuelReportVC") as! FuelReportVC
//                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    if self.shiftStatus{
                        let vc = storyboard?.instantiateViewController(identifier: "InspectionVC") as! InspectionVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoShift, AllActions: ["OK":nil], Style: .alert)
                    }
                }
            case "37":
                if self.isManager == true{
                   if self.shiftStatus == false{
                    self.viewVehicleListShow.isHidden = false
                     }else{
                         self.showSurveyPopup()
                    }
                }else{
                if self.shiftStatus{
                    
                    self.showSurveyPopup()
                    
                }else{
                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoShift, AllActions: ["OK":nil], Style: .alert)
                }
                }
            case "555":
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdminVC") as! AdminVC
                vc.urlString = isShare_linkAvailable
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                if self.isManager == true{
                    if self.shiftStatus == false{
                    self.viewVehicleListShow.isHidden = false
                     }else{
                         self.showSurveyPopup()
                    }
                }else{
                if self.shiftStatus{
                    
                    self.showSurveyPopup()
                    
                }else{
                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoShift, AllActions: ["OK":nil], Style: .alert)
                }
                }
            }
        }else{
            if self.shiftStatus{
                
                self.showSurveyPopup()
                
            }else{
                PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoShift, AllActions: ["OK":nil], Style: .alert)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.DashboardCollectionView.frame.width/2 - 6, height: self.DashboardCollectionView.frame.width/2 - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    
}

extension DashboardViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openIncidentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LaneLocTVC", for: indexPath) as! LaneLocTVC
        if openIncidentArray.count > 0{
            cell.lbl_LaneLocName.text = "#\(openIncidentArray[indexPath.row]["Incidents_report_data_id"])"
             if selectedIndexArray.contains(indexPath.row) {
                 cell.imgVw_Check.isHidden = false
             }
             else{
                 cell.imgVw_Check.isHidden = true
             }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TimeService.instance.resetInactivityTimer()

        if openIncidentArray.count > 0{
            let value = "\(openIncidentArray[indexPath.row]["Incidents_report_data_id"])"
            if selectedArray.contains(value) {
                selectedArray.remove(value)
            }else{
                selectedArray.add(value)
                
            }

            if selectedIndexArray.contains(indexPath.row) {
                selectedIndexArray.remove(indexPath.row)
            }else{
                selectedIndexArray.add(indexPath.row)
            }
            print(selectedArray)
            print(selectedIndexArray)
        }

        self.tblevw_OpenIncident.reloadData()
    }
    
    
}

// Location update
extension DashboardViewController {
//    func statartLocationUpdate(isStartUpdate:Bool)  {
//        if isStartUpdate { //true
//            guard  MyLocationManager.share.internalTimer == nil else {
//                debugPrint("Already running")
//                return
//            }
//            MyLocationManager.share.requestForLocation()
//            MyLocationManager.share.configManager()
//            MyLocationManager.share.startTimer()
//        }else{
//            MyLocationManager.share.stopTimer()
//            MyLocationManager.share.distanceMile = 0.0
//        }
//    }
    
    
}

//MARK: - Break Time Operation
extension DashboardViewController {
    func callIncidentListApi()  {
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String , let operationid:String = UserDefaults.standard.value(forKey: "OPERATIONID") as? String {
            model.callIncidentDetails(companyId: companyID, userId: userId, operationId: operationid) { (status) in
                if status == 0{
                    DispatchQueue.main.async {
                        self.model.incidentdetailsArray = self.model.incidentdetailsArray?.filter({ (modelIncidence) -> Bool in
                        modelIncidence.incident_status == "On Scene"
                        })
                        if self.model.incidentdetailsArray?.count ?? 0 > 0{
                        let incidents  = self.model.incidentdetailsArray ?? []
                        for obj in incidents{
                            
                            MyLocationManager.share.callCloseIncident(incidentID: obj.incidents_report_data_id ?? "")
                        }
                     }
                    }
                    
                }
            }
        }
    }
    func callVehicleListListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
        param["source"] = "MOB" as AnyObject
        param["companyId"] = companyID as AnyObject
        param["user_id"] = userId as AnyObject
//        param["stateId"] = stateID as AnyObject
//        param["operation_area_id"] = operationID as AnyObject
        }
        let opt = WebServiceOperation.init((API.VehicleList.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                print(opt.responseData?.dictionary)
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["data"] as? [[String:Any]] {
                                do {
                                    self.vehileList = try JSONDecoder().decode([ShiftVehileList].self,from:(listArray.data)!)
                                    
                                }
                                catch {
                                    print(error)
                                   
                                }
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
    fileprivate func callBreakTimeStatrApi(){
        if Connectivity.isConnectedToInternet {
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String, let shiftID:String = UserDefaults.standard.value(forKey: "SHIFTID") as? String{
                
                var param:[String:AnyObject] = [String:AnyObject]()
                param["userId"] = userId as AnyObject
                param["shiftId"] = shiftID as AnyObject
                param["companyId"] = companyID as AnyObject
                let date = Date()
                                                    
                                                       
                                                       let formatter = DateFormatter()
                                                       //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
                                                       formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                                                   
                                                       //let defaultTimeZoneStr = formatter.string(from: date)
                                                       //formatter.timeZone = NSTimeZone.local
                                                       let utcTimeZoneStr = formatter.string(from: date)
                                                       print(utcTimeZoneStr)
                                                       param["timeUTC"] = utcTimeZoneStr as AnyObject
                print(param)
                let opt = WebServiceOperation.init((API.startBreak.getURL()?.absoluteString ?? ""), param)
                opt.completionBlock = {
                    DispatchQueue.main.async {
                        
                        guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                            return
                        }
                        if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                            if errorCode.intValue == 0 {
                                if let dictResult = dictResponse["result"] as? [String:Any] {
                                    if let breakData = dictResult["data"] as? [String:Any], dictResult.count > 0{
                                        DispatchQueue.main.async {
                                            let breaktimeId = "\(breakData["breakTimeId"] ?? "")"
                                            UserDefaults.standard.set(breaktimeId, forKey: "BREAKTIME")
                                            TimeService.instance.timer = 900
                                            TimeService.instance.coundown()
                                            self.showBreakTimePopup()
                                        }
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
    //MARK: End break time
    fileprivate func callBreakTimeEndApi() {
        if Connectivity.isConnectedToInternet {
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String, let shiftID:String = UserDefaults.standard.value(forKey: "SHIFTID") as? String, let breakTime:String = UserDefaults.standard.value(forKey: "BREAKTIME") as? String{
                var param:[String:AnyObject] = [String:AnyObject]()
                param["userId"] = userId as AnyObject
                param["shiftId"] = shiftID as AnyObject
                param["companyId"] = companyID as AnyObject
                param["breakTimeId"] = breakTime as AnyObject
                let date = Date()
                                    
                                       
                                       let formatter = DateFormatter()
                                       //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
                                       formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                                   
                                       //let defaultTimeZoneStr = formatter.string(from: date)
                                       //formatter.timeZone = NSTimeZone.local
                                       let utcTimeZoneStr = formatter.string(from: date)
                                       print(utcTimeZoneStr)
                                       param["timeUTC"] = utcTimeZoneStr as AnyObject
                
                print(param)
                let opt = WebServiceOperation.init((API.endBreak.getURL()?.absoluteString ?? ""), param)
                opt.completionBlock = {
                    DispatchQueue.main.async {
                        
                        guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                            return
                        }
                        if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                            if errorCode.intValue == 0 {
                                DispatchQueue.main.async {
                                    UserDefaults.standard.removeObject(forKey: "BREAKTIME")
                                    self.showBreakTimePopup()
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
    
    @IBAction func buttonResumBreakTime(_ sender: Any) {
        PopupCustomView.sharedInstance.reSetPopUp()
        PopupCustomView.sharedInstance.textView?.text = "Are you sure you want end break time?"
        PopupCustomView.sharedInstance.btnLeft.addTarget(self, action: #selector(btnBreakTimeYesPressed(_:)), for: .touchUpInside)
        PopupCustomView.sharedInstance.btnRight.addTarget(self, action: #selector(self.btnBreakTimeNo(_:)), for: .touchUpInside)
        PopupCustomView.sharedInstance.display(onView: keyWindow) {
        }
    }
    
    @objc func btnBreakTimeStartYesPressed(sender:UIButton) {
        PopupCustomView.sharedInstance.hide()
        PopupCustomView.sharedInstance.reSetPopUp()
        self.callBreakTimeStatrApi()
    }
    @objc func btnBreakStartTimeNo(sender:UIButton) {
        PopupCustomView.sharedInstance.hide()
        PopupCustomView.sharedInstance.reSetPopUp()
    }
    
    @IBAction func buttonStartBreakTime(_ sender: Any) {
        
        guard (UserDefaults.standard.value(forKey: "BREAKTIME") != nil) else {
            self.transperentBlackView.isHidden = true
            self.BreakTimeView.isHidden = true
            //self.floating.setTitle("START BREAK", for: .normal)
            PopupCustomView.sharedInstance.reSetPopUp()
            PopupCustomView.sharedInstance.textView?.text = "Are you sure you want start break time?"
            PopupCustomView.sharedInstance.btnLeft.addTarget(self, action: #selector(self.btnBreakTimeStartYesPressed(sender:)), for: .touchUpInside)
            PopupCustomView.sharedInstance.btnRight.addTarget(self, action: #selector(btnBreakStartTimeNo(sender:)), for: .touchUpInside)
            PopupCustomView.sharedInstance.display(onView: keyWindow) {
            }
            return
        }
        
//        PopupCustomView.sharedInstance.reSetPopUp()
//        PopupCustomView.sharedInstance.textView?.text = "Are you sure you want start break time?"
//        PopupCustomView.sharedInstance.btnLeft.addTarget(self, action: #selector(self.btnBreakTimeStartYesPressed(sender:)), for: .touchUpInside)
//        PopupCustomView.sharedInstance.btnRight.addTarget(self, action: #selector(btnBreakStartTimeNo(sender:)), for: .touchUpInside)
//        PopupCustomView.sharedInstance.display(onView: keyWindow) {
//        }
        
        PopupCustomView.sharedInstance.hide()
        PopupCustomView.sharedInstance.reSetPopUp()
        self.callBreakTimeEndApi()
    }
    
    @objc func btnBreakTimeNo(_ sender: UIButton){
        PopupCustomView.sharedInstance.hide()
    }
    
    @objc func btnBreakTimeYesPressed(_ sender: UIButton){
        self.callBreakTimeEndApi()
        PopupCustomView.sharedInstance.reSetPopUp()
    }
    
    fileprivate func showBreakTimePopup() {
        guard (UserDefaults.standard.value(forKey: "BREAKTIME") != nil) else {
            self.transperentBlackView.isHidden = true
            self.BreakTimeView.isHidden = true
            self.floating.setTitle("START BREAK", for: .normal)
            self.constantCustomVwTop.constant = 16.0
            self.lbl_TimerOnStartBreak.isHidden = true
            return
        }
       // self.transperentBlackView.isHidden = false
       // self.BreakTimeView.isHidden = false
        self.transperentBlackView.isHidden = true
        self.BreakTimeView.isHidden = true
        self.floating.setTitle("END BREAK", for: .normal)
        self.constantCustomVwTop.constant = 30.0
        self.lbl_TimerOnStartBreak.isHidden = false
        count = TimeService.instance.timer!
        let changeColor = CATransition()
        changeColor.repeatCount = 0.0
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.lbl_TimerOnStartBreak.layer.add(changeColor, forKey: nil)
            self.lbl_TimerOnStartBreak.textColor = .black
        }
        CATransaction.commit()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                if self.count > 0 {
                    print ("\(self.count) seconds")
                    self.count -= 1
                    let min = self.count / 60
                    let minPad = min < 9 ? "0" : ""
                    let second = self.count % 60
                    let secondPad = second < 9 ? "0" : ""
                    self.lbl_TimerOnStartBreak.text = "\(minPad)\(min):\(secondPad)\(second)"
                } else {
                    Timer.invalidate()
                    TimeService.instance.timer = 0
                    
                    changeColor.duration = 1
                    changeColor.type = .fade
                    changeColor.repeatCount = Float.infinity
                    CATransaction.begin()
                    CATransaction.setCompletionBlock {
                        self.lbl_TimerOnStartBreak.layer.add(changeColor, forKey: nil)
                        self.lbl_TimerOnStartBreak.textColor = .red
                    }
                    self.lbl_TimerOnStartBreak.textColor = .clear
                    CATransaction.commit()
                }
            }

    }
    
    @objc func update() {
        if(count > 0) {
            lbl_TimerOnStartBreak.text = String(count-1)
        }
    }
    
    fileprivate func BreakButtonUpdate() {
        let shift: String = UserDefaults.standard.value(forKey: "SHIFTID") as! String
        if shift != "" {
            UIView.animate(withDuration: 0.5) {
                self.connectedViewConstent.constant = 100
                self.breakTimeConstent.constant = 36
                self.floating.isHidden = false
            }
        }else{
            UIView.animate(withDuration: 0.5) {
                self.connectedViewConstent.constant = 64
                self.breakTimeConstent.constant = 0
                self.floating.isHidden = true
            }
            
        }
    }
    func createPickerView(textField:UITextField) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        textField.inputView = pickerView
        pickerView.tag = textField.tag
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.action(sender:)))
        button.tag = textField.tag
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancel,spacer,button], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        
    }
    @objc func action(sender: UIBarButtonItem) {
        if sender.tag == 0{
            if txtDirection.text?.count == 0{
                txtDirection.text = arrayDirection[0]
            }
        }else if sender.tag == 1{
            if txtDescriptionStatus.text?.count == 0{
                txtDescriptionStatus.text = arrayDescription[0]
            }
        }else if sender.tag == 300{
            if txtFieldVehcle.text?.count == 0{
                txtFieldVehcle.text = vehileList[0].iD
                selectedVehicle = self.vehileList[0]
            }
        }else{
            if serveyVia.count == 0{
                txtFieldChooseServey.text = arrayDescription[0]
            }
        }
        self.view.endEditing(true)
        
    }
    @objc func cancelAction() {
        self.view.endEditing(true)
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return arrayDirection.count
        }else if pickerView.tag == 2{
            return arrayChooseServey.count
        }
        else if pickerView.tag == 300{
            return self.vehileList.count
        }else{
            return arrayDescription.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return arrayDirection[row]
        }else if pickerView.tag == 1{
            return arrayDescription[row]
        }else if pickerView.tag == 300{
            return self.vehileList[row].iD
        }else{
            return arrayChooseServey[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{
            txtDirection.text = arrayDirection[row]
        }else if pickerView.tag == 1{
            txtDescriptionStatus.text =  arrayDescription[row]
        }
        else if pickerView.tag == 300{
            txtFieldVehcle.text = self.vehileList[row].iD
            selectedVehicle = self.vehileList[row]
            print(selectedVehicle?.state_name)
            TimeService.instance.vechileId = selectedVehicle?.iD
        }else{
            txtFieldChooseServey.text = arrayChooseServey[row]
            if row == 0{
                self.serveyVia = "mobile"
            }else if row == 1{
                self.serveyVia = "web"
            }else{
                self.serveyVia = "QR Code"
            }
        }
    }
    
    
}
extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
