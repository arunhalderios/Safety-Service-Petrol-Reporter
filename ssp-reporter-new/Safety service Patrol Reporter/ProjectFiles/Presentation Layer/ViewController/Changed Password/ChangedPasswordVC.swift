//
//  ChangedPasswordVC.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Mahalik on 02/07/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class ChangedPasswordVC: BaseViewController {

    @IBOutlet weak var txtConfirm: TextFieldX!
    @IBOutlet weak var txtNewPass: TextFieldX!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtConfirm.addLeftViewPadding(padding: 10, placeholderText: "")
        txtNewPass.addLeftViewPadding(padding: 10, placeholderText: "")
        txtConfirm.addRightViewPadding(padding: 10)
        txtNewPass.addRightViewPadding(padding: 10)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }
    
    @IBAction func btnChangePassword(_ sender: Any) {
        self.view.endEditing(true)
        self.validate()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validate(){
        if txtNewPass.text == ""{
             self.displayAlert(Header: App_Title, MessageBody: "Please enter new Password", AllActions: ["OK":nil], Style: .alert)
            return
        }
        if txtNewPass.text?.isValidPassword() == false{
            self.displayAlert(Header: App_Title, MessageBody: "Password should be more than 8 characters and  1 letter, 1 special character and 1 number", AllActions: ["OK":nil], Style: .alert)
            return
        }
        if txtConfirm.text == "" {
            self.displayAlert(Header: App_Title, MessageBody: "Please enter confirm Password", AllActions: ["OK":nil], Style: .alert)
            return
        }
        if txtConfirm.text != txtNewPass.text {
            self.displayAlert(Header: App_Title, MessageBody: "Confirm password miss matched", AllActions: ["OK":nil], Style: .alert)
            return
        }
        
        
        self.callUpdatePassword()
        
    }
    

   func callUpdatePassword(){
        if Connectivity.isConnectedToInternet {
            var param:[String:AnyObject] = [String:AnyObject]()
            
            
    
            
            if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
                if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                   // param["source"] = "MOB" as AnyObject
                    param["user_id"] = userId as AnyObject
                    param["companyId"] = companyID as AnyObject
                    param["password"] = txtNewPass.text as AnyObject
                }
                
            }
            
            // }
            print(param)
              let opt = WebServiceOperation.init(API.changePassword.getURL()?.absoluteString ?? "", param, .WEB_SERVICE_POST, nil)
            opt.completionBlock = {
                DispatchQueue.main.async {
                    
                    guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                        return
                    }
                    if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                        if errorCode.intValue == 0 {
                            
                                    let okclause = PROJECT_CONSTANT.CLOUS{
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    
                                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Your password is updated successfully", AllActions: ["OK":okclause], Style: .alert)
                                
                            
                        }else{
                            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                        }
                    }
                }
            }
            appDel.operationQueue.addOperation(opt)
            
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
        }
    }

}
extension String {
func isValidPassword() -> Bool {
    //let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
    let regress  = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
    let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regress)

    return passwordValidation.evaluate(with: self)
}
}
