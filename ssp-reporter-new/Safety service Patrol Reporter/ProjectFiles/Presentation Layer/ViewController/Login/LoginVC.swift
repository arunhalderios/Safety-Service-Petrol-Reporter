//
//  LoginVC.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 17/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var buttonForgotPass: UIButton!
    var type:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewEmail.layer.cornerRadius = 8//viewEmail.frame.size.height / 2
        viewEmail.layer.borderWidth = 2
        viewEmail.layer.borderColor = AppthemeColor.cgColor
        
        viewPassword.layer.cornerRadius = 8//viewPassword.frame.size.height / 2
        viewPassword.layer.borderWidth = 2
        viewPassword.layer.borderColor = AppthemeColor.cgColor
        
        btnLogin.layer.cornerRadius = 8//btnLogin.frame.size.height / 2
        //textEmail.layer.sublayerTransform = CATransform3DMakeTranslation(-25, 0, 0)
        //textPassword.layer.sublayerTransform = CATransform3DMakeTranslation(-25, 0, 0)
        //statusBarColourChangewhite()
        
        textEmail.text = "demo3@yopmail.com"
        textPassword.text = "123456"
        
        if Platform.isSimulator{
            //textEmail.text = "manager1@gmail.com"
            //textPassword.text = "123456"
            //operator1@gmail.com
            
            textEmail.text = "demo3@yopmail.com"//"mahesh5@region10.com"
            textPassword.text = "123456"//"cbP1QtZt9"

            
        
            
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func buttonLogin(_ sender: Any) {
      UserDefaults.standard.set(type, forKey: "USERTYPE")
      self.validateField()
        
    }
    
}
extension LoginVC{
    func validateField(){

         self.view.endEditing(true)
        
        guard self.textEmail.text?.count ?? 0 > 0 else {
             PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please enter email address", AllActions: ["OK":nil], Style: .alert)
             return
         }
        guard PROJECT_CONSTANT.isValidEmail(testStr: self.textEmail.text ?? "") else {
             PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please enter valid email address", AllActions: ["OK":nil], Style: .alert)
             return
         }
         
        guard self.textPassword.text?.count ?? 0 > 0 else {
             PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please enter password", AllActions: ["OK":nil], Style: .alert)
             return
         }
         
         self.loginApiCall()
    }
    func loginApiCall(){
           if Connectivity.isConnectedToInternet {
               
               
               var param:[String:AnyObject] = [String:AnyObject]()
               
              // if let token = UserDefaults.standard.value(forKey: "TOKEN"){
                param["email"] = textEmail.text as AnyObject
                param["password"] = textPassword.text as AnyObject
               param["source"] = "MOB" as AnyObject
               if let token = UserDefaults.standard.value(forKey: "FCM"){
               param["device_token"] = token as AnyObject
               param["deviceId"] = token as AnyObject
               }
               param["device_type"] = "2" as AnyObject
              // }
                print(param)
            let opt = WebServiceOperation.init((API.Login.getURL()?.absoluteString ?? ""), param)
               opt.completionBlock = {
                   DispatchQueue.main.async {
                   
                       guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                           return
                       }
                       if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                           if errorCode.intValue == 0 {
                               if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0,let dictDetails = dictResult["userdetails"] as? [String:Any] {
                                   do{
//                                    let model = try JSONDecoder().decode(Userdetails.self,from:(dictDetails.data)!)
                                     UserDefaults.standard.set(dictDetails, forKey: "USER")
                                    
                                       if let userid = dictDetails["user_id"]{
                                           UserDefaults.standard.set(userid, forKey: "USERID")
                                           print(UserDefaults.standard.value(forKey: "USERID") as Any)
                                       }
//                                       if let Email = dictDetails["email"]{
//                                           UserDefaults.standard.set(Email, forKey: "EMAIL")
//                                           print(UserDefaults.standard.value(forKey: "EMAIL") as Any)
//                                       }
                                    
                                    if let companyID = dictDetails["company_id"]{
                                        UserDefaults.standard.set(companyID, forKey: "COMPANYID")
                                    }

                                       if let rollID = dictDetails["role_id"]{
                                           UserDefaults.standard.set(rollID, forKey: "ROLLID")
                                           
                                       }
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                                    self.navigationController!.pushViewController(vc, animated: true)
                                    
                                       
                                   }catch{
                                    
                                }
                               }
                           }else{
//                                     let attributedString = NSAttributedString(string: msg, attributes: [
//                                           NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                                           NSAttributedString.Key.foregroundColor : UIColor.black
//                                       ])
//                                       let alert = UIAlertController(title: App_Title, message: msg, preferredStyle: .alert)
//
//                                       alert.setValue(attributedString, forKey: "attributedMessage")
//
//                                       let cancelAction = UIAlertAction(title: "OK",
//                                                                        style: .default) { (action: UIAlertAction!) -> Void in
//                                       }
//
//                                     alert.addAction(cancelAction)
//                                     self.present(alert, animated: true, completion: nil)

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



