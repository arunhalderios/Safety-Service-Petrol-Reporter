//
//  ForgotPasswordVC.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 18/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var buttonRequestPass: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.apiRequired = false
        viewEmail.layer.cornerRadius = 8//viewEmail.frame.size.height / 2
        viewEmail.layer.borderWidth = 2
        viewEmail.layer.borderColor = AppthemeColor.cgColor
        buttonRequestPass.layer.cornerRadius = 8
        
        //buttonRequestPass.frame.size.height / 2
        //txtFieldEmail.layer.sublayerTransform = CATransform3DMakeTranslation(-30, 0, 0)
        //statusBarColourChangewhite()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRequestAction(_ sender: Any) {
        self.view.endEditing(true)
        self.callForgotPasswordAPI()
        
    }
    func callForgotPasswordAPI(){
        
        if Connectivity.isConnectedToInternet {
            
            
            var param:[String:AnyObject] = [String:AnyObject]()
            param["source"] = "MOB" as AnyObject
            param["email"] = self.txtFieldEmail.text as AnyObject
            
            
            let opt = WebServiceOperation.init((API.resetPasswordOtpSend.getURL()?.absoluteString ?? ""), param)
            opt.completionBlock = {
                DispatchQueue.main.async {
                    print(opt.responseData?.dictionary?.prettyprintedJSON ?? "")
                    guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                        return
                    }
                    
                    if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                        if errorCode.intValue == 0 {
                            
                            do{
                                
                                
                                let okClause = PROJECT_CONSTANT.CLOUS{
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetVC") as! ResetVC
                                    vc.email = self.txtFieldEmail.text
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                
                                PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":okClause], Style: .alert)
                                
                                
                                
                                
                                
                                
                            }
                            
                            
                            
                        }else{
                            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                        }
                    }else{
                        //                            PROJECT_CONSTANT.displayAlert(Header: "Failure", MessageBody: message, AllActions: [Localizationkey.OK:nil], Style: .alert)
                    }
                }
            }
            
            appDel.operationQueue.addOperation(opt)
            
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
        }
    }
    
}
