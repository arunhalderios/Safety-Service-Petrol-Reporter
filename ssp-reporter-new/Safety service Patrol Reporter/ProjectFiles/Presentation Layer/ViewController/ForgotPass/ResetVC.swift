//
//  ResetVC.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Mahalik on 07/05/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class ResetVC: UIViewController {
    var email:String?
    @IBOutlet weak var tableReset: UITableView!
    var arrayValues:[String] = ["","","",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayValues[0] = email ?? ""
        // Do any additional setup after loading the view.
    }
    func validate(){
        guard self.arrayValues[0].count > 0 else {
             PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please enter email address", AllActions: ["OK":nil], Style: .alert)
             return
         }
        guard PROJECT_CONSTANT.isValidEmail(testStr: arrayValues[0]) else {
             PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please enter valid email address", AllActions: ["OK":nil], Style: .alert)
             return
         }
         
        guard self.arrayValues[1].count > 0 else {
             PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please enter OTP", AllActions: ["OK":nil], Style: .alert)
             return
         }
        
        guard self.arrayValues[2].count > 0 else {
                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please enter New Password", AllActions: ["OK":nil], Style: .alert)
                    return
                }
        guard self.arrayValues[2].isValidPassword() else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Password should be more than 8 characters and  1 letter, 1 special character and 1 number", AllActions: ["OK":nil], Style: .alert)
            return
        }
        guard self.arrayValues[3].count > 0 else {
                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Enter your confirm password", AllActions: ["OK":nil], Style: .alert)
                    return
                }
        
        
        guard self.arrayValues[2] == arrayValues[3] else {
                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Password Missmatched", AllActions: ["OK":nil], Style: .alert)
                    return
                }
        self.callForgotPasswordApi()
        
        
    }
    func callForgotPasswordApi(){
        if Connectivity.isConnectedToInternet {
             var param:[String:AnyObject] = [String:AnyObject]()
            
           
                    param["source"] = "MOB" as AnyObject
                    param["email"] = arrayValues[0] as AnyObject
                    param["reset_password_otp"] = arrayValues[1] as AnyObject
                    param["password"] = arrayValues[2] as AnyObject
                   
            print(param)
          let opt = WebServiceOperation.init((API.resetPassword.getURL()?.absoluteString ?? ""), param)
            opt.completionBlock = {
                DispatchQueue.main.async {
                    
                    guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                        return
                    }
                    if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                        if errorCode.intValue == 0 {
                           
                                    let okclause = PROJECT_CONSTANT.CLOUS{
                                        for controller in self.navigationController!.viewControllers as Array {
                                            
                                            if controller.isKind(of: LoginVC.self) {
                                                self.navigationController!.popToViewController(controller, animated: true)
                                                break
                                            }
                                        }
                                    }
                                    
                                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":okclause], Style: .alert)
                                
                            
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
    
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        self.validate()
    }
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func textFieldChangeCharacter( _ textField:UITextField){
        arrayValues[textField.tag] = textField.text ?? ""
    }
    
}
extension ResetVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForgotInputCell1", for: indexPath) as! ForgotInputCell
        //cell.lblHeader.text = "Enter your Email"
            cell.txtInputField.tag = indexPath.row
        cell.txtInputField.addTarget(self, action: #selector(textFieldChangeCharacter(_:)), for: .editingChanged)
        cell.txtInputField?.text = arrayValues[indexPath.row]
            cell.viewCell.layer.cornerRadius = 8//cell.viewCell.frame.height / 2
            cell.txtInputField.isUserInteractionEnabled = false
            return cell
        }else if indexPath.row == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForgotButtonCell", for: indexPath) as! ForgotButtonCell
            
            return cell
        }
        else if indexPath.row == 5{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForgotButtonCell1", for: indexPath) as! ForgotButtonCell
             
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForgotInputCell1", for: indexPath) as! ForgotInputCell
            cell.txtInputField.tag = indexPath.row
            cell.txtInputField.isSecureTextEntry = false
            cell.viewCell.layer.cornerRadius = 8//cell.viewCell.frame.height / 2
            cell.txtInputField.text = arrayValues[indexPath.row]
            cell.txtInputField.addTarget(self, action: #selector(textFieldChangeCharacter(_:)), for: .editingChanged)
            cell.txtInputField.keyboardType = .emailAddress
            cell.txtInputField.isUserInteractionEnabled = true
        
             if indexPath.row == 1{
               // cell.lblHeader.text = "Enter OTP"
                cell.txtInputField.placeholder = "Enter OTP"
                cell.txtInputField.keyboardType = .numberPad
            }else if indexPath.row == 2{
               // cell.lblHeader.text = "Enter New Password"
                cell.txtInputField.placeholder = "Enter New Password"
                 cell.txtInputField.isSecureTextEntry = true
            }else if indexPath.row == 3{
                //cell.lblHeader.text = "Confirm New Password"
                cell.txtInputField.placeholder = "Confirm New Password"
                 cell.txtInputField.isSecureTextEntry = true
            }else{
              //  cell.lblHeader.text = ""
            }
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
