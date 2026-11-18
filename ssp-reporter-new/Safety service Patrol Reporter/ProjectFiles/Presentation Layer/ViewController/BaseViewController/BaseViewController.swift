//
//  BaseViewController.swift
//  WeCareStaffing
//
//  Created by Samprita on 20/04/18.
//  Copyright © 2018 Samprita. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import MediaPlayer
import SystemConfiguration

class BaseViewController: UIViewController {
    

    
    var inputAccView : UIView?
    
    var strCountValue : String = ""
    var apiRequired:Bool = true
    @IBOutlet var lblCartCount:UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
        //return .default
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        statusBarColourChangeYellow()
        if apiRequired{
        self.callisLoginApi()
        }

    }
    
    func statusBarColourChangeYellow (){
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(named: "AppThemeColor")
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        
    }
    func statusBarColourChangewhite (){
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor.white
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
  
    @IBAction func backAction(sender:UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func isPasswordValid(passwordStr : String) -> Bool
    {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$&*%^&~ ]).{8,}$")
        return passwordTest.evaluate(with: passwordStr)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidPhoneNumber(numberStr:String) -> Bool {
       
        //"^((\\+)|(00))[1-9][0-9]{9,14}$"
        let PHONE_REGEX = "^[1-9][0-9]{9,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: numberStr)
        return result
        
    }
    
    
    func isUserNameValid(strName:String) -> Bool {
        do
        {
            // "^[0-9a-zA-Z\\_]{7,18}$"
            let regex = try NSRegularExpression(pattern: "([a-zA-Z+]+[0-9+]+)", options: .caseInsensitive)  //?=\\S{3,10})
            if regex.matches(in: strName, options: [], range: NSMakeRange(0, strName.count)).count > 0 {return true}
        }
        catch {}
        return false
        
    }
    func callEndShiftApicall() {
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
                                
                                
                            }else{
                               // PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                            }
                        }
                    }
                }
                appDel.operationQueueBG.addOperation(opt)
            }
            
        }else{
            //PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
        }
    }
func callisLoginApi(){
    var param:[String:AnyObject] = [String:AnyObject]()
    //param["source"] = "MOB" as AnyObject
    if let companyID:String = UserDefaults.standard.value(forKey: "FCM") as? String{
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
            param["deviceId"] = companyID as AnyObject
            param["userId"] = userId as AnyObject
        }
        
    }
    let opt = WebServiceOperation.init((API.isLoggedIn.getURL()?.absoluteString ?? ""), param)
    opt.completionBlock = {
        DispatchQueue.main.async {
            
            guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                return
            }
            if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                if errorCode.intValue == 0 {
                    if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                        if  let listArray = dictResult["data"] as? [String:Any] {
                            
                            

                            
                        }
                    }
                }else{
                    
                    let okClause = PROJECT_CONSTANT.CLOUS{
                        
                        self.forceLogout()
                    }
                    self.deleteAllKeys()
                    self.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":okClause], Style: .alert)
                    // self.displayAlert(Header: App_Title, MessageBody: "You have logged in some other device", AllActions: ["OK":okClause], Style: .alert)
                    
                }
            }
        }
    }
    appDel.operationQueueBG.addOperation(opt)
    
}
    func forceLogout()  {
        self.deleteAllKeys()
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                return
            }
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
       // self.callEndShiftApicall()
    }
    func deleteAllKeys() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key == "FCM" || key == "PREOPSSAVED"{
                
            }else{
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    func createInputAccessoryView()
    {
        inputAccView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 40.0))
        inputAccView!.backgroundColor = UIColor.lightGray
        let btnDone: UIButton = UIButton(type: .custom)
        btnDone.frame = CGRect(x: (self.view.frame.width - 100.0), y: 0.0, width: 80.0, height: 40.0)
        btnDone.setTitle("Done", for: UIControl.State())
        btnDone.setTitleColor(UIColor.black, for: UIControl.State())
        btnDone.addTarget(self, action: #selector(doneTyping), for: .touchUpInside)
        inputAccView!.addSubview(btnDone)
        
        let btnCancel: UIButton = UIButton(type: .custom)
        btnCancel.frame = CGRect(x: 20, y: 0.0, width: 80.0, height: 40.0)
        btnCancel.setTitle("Cancel", for: UIControl.State())
        btnCancel.setTitleColor(UIColor.black, for: UIControl.State())
        btnCancel.addTarget(self, action: #selector(cancelTyping), for: .touchUpInside)
        inputAccView!.addSubview(btnCancel)
    }
    
    @objc func doneTyping()
    {
        self.view.endEditing(true)
    }
    
    //MARK: CANCEL BUTTON
    @objc func cancelTyping()
    {
        self.view.endEditing(true)
    }

//    func animateViewMoving (up:Bool, moveValue :CGFloat){
//
//        let movementDuration:TimeInterval = 0.5
//
//        let movement:CGFloat = ( up ? -moveValue : moveValue)
//
//        UIView.beginAnimations("animateView", context: nil)
//
//        UIView.setAnimationBeginsFromCurrentState(true)
//
//        UIView.setAnimationDuration(movementDuration)
//
//        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
//
//        UIView.commitAnimations()
//    }

}

//MARK:
//MARK: Helper Methods
//MARK:

extension BaseViewController {
    
    func displayAlert(Header strHeader:String!,MessageBody strMsgBody:String!,AllActions actions:[String:PROJECT_CONSTANT.CLOUS],Style style:UIAlertController.Style) {
        PROJECT_CONSTANT.displayAlert(Header: strHeader, MessageBody: strMsgBody, AllActions: actions, Style: style)
    }
    func getSuperview(OfType type:AnyClass, fromView vw:AnyObject?) -> AnyObject? {
        return PROJECT_CONSTANT.getSuperview(OfType: type, fromView: vw)
    }
}

//MARK:
//MARK: IBAction
//MARK:

extension BaseViewController {
    
    @IBAction func backPressed(_ btn:UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
 
    
}

//MARK:
//MARK: UITextFieldDelegate
//MARK:



