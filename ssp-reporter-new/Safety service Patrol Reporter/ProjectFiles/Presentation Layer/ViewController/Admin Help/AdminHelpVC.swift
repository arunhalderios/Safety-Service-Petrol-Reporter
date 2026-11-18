//
//  AdminHelpVC.swift
//  ATIMS
//
//  Created by Mahesh Prasad Mahaliik on 19/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit
import CoreLocation
class AdminHelpVC: BaseViewController,CLLocationManagerDelegate {

    @IBOutlet weak var txtFieldSubject: UITextField!
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet weak var txtViewMessage: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    var locationManager: CLLocationManager = CLLocationManager()
    var lat :String = " "
    var long :String = " "
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFieldSubject.addborder()
        txtViewMessage.addborder()
        txtFieldSubject.addRightViewPadding(padding: 10)
        txtFieldSubject.addLeftViewPadding(padding: 10, placeholderText: "")
        btnSend.roundedView()
        btncancel.roundedView()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            locationManager.startUpdatingLocation()
        }else{
            locationManager.startUpdatingLocation()
        }
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSendAction(_ sender: UIButton) {
        self.callHelpAPI()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            self.lat = String(location.coordinate.latitude)
            self.long = String(location.coordinate.longitude)
        }
    }
  

}
extension AdminHelpVC{
    func callHelpAPI(){
           if Connectivity.isConnectedToInternet {
               var param:[String:AnyObject] = [String:AnyObject]()
               
               
            if let shiftID = UserDefaults.standard.value(forKey: "SHIFTID"){
                                   param["operator_shift_time_details_id"] = shiftID as AnyObject
                               }else{
                                   param["operator_shift_time_details_id"] = "1" as AnyObject
                               }
               
               if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
                   if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                       param["source"] = "MOB" as AnyObject
                       param["user_id"] = userId as AnyObject
                       param["companyId"] = companyID as AnyObject
                       param["subject"] = txtFieldSubject.text as AnyObject
                       param["message"] = txtViewMessage.text as AnyObject
                       param["location_lat"] = lat as AnyObject
                       param["location_long"] = long as AnyObject
                       param["status"] = "1" as AnyObject
                   }
                   
               }
               
               // }
               print(param)
                 let opt = WebServiceOperation.init(API.Help.getURL()?.absoluteString ?? "", param, .WEB_SERVICE_MULTI_PART, nil)
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
                                       
                                       PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Your request submitted successfully.", AllActions: ["OK":okclause], Style: .alert)
                                   
                               
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
