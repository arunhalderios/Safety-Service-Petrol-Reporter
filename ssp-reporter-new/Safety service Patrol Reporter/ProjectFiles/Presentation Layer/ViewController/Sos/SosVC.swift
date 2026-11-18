//
//  SosVC.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 19/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit
import CoreLocation
class SosVC: BaseViewController,CLLocationManagerDelegate {
    var modelUser : Userdetails?
    @IBOutlet weak var tableSOS: UITableView!
    var arraySamplertext = [String]()
    var paramDictionary = Dictionary<String, AnyObject>()
    var locationManager: CLLocationManager = CLLocationManager()
    var lat :String = " "
    var long :String = " "
    var selectedReason = ""
    var selectedReasonId = ""
    var isselected:Bool = false
    var arrayeason :[SOSReason] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateTableWithData()
        self.tableSOS.delegate = self
        self.tableSOS.dataSource = self
        self.tableSOS.reloadData()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            locationManager.startUpdatingLocation()
        }else{
            locationManager.startUpdatingLocation()
        }
        self.callReasonListApi()
    }
    
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func btnSendSos(_ sender:UIButton){
        PopupCustomView.sharedInstance.reSetPopUp()
        PopupCustomView.sharedInstance.textView?.text = "Do you want to send a SOS ?"
        PopupCustomView.sharedInstance.btnLeft.addTarget(self, action: #selector(btnYesPressed(_:)), for: .touchUpInside)
        PopupCustomView.sharedInstance.display(onView: UIApplication.shared.keyWindow) {
            
            
        }
        
    }
    @IBAction func btnCancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func btnYesPressed(_ sender: UIButton){
        PopupCustomView.sharedInstance.hide()
        self.callSOSAPI()
    }
    func populateTableWithData()  {
        self.tableSOS.isHidden = true
        self.arraySamplertext.removeAll()
        
        if let user = UserDefaults.standard.value(forKey: "USER") as? [String:Any]{
            do{
                self.modelUser = try JSONDecoder().decode(Userdetails.self,from:(user.data)!)
            }
            catch{
                
            }
        }
        
        if let vID:String = UserDefaults.standard.value(forKey: "VEHICLEID") as? String {
            arraySamplertext.append(vID)
        }else{
            arraySamplertext.append(" ")
        }
        
        
        arraySamplertext.append("\(self.modelUser?.first_name ?? " ") " + "\(self.modelUser?.last_name ?? " ") " )
        arraySamplertext.append(self.modelUser?.phone ?? " ")
        
        arraySamplertext.append("")
        self.tableSOS.reloadData()
        self.tableSOS.isHidden = false
    }
    func collectParamiterInfoForPre_ops() -> Dictionary<String, AnyObject> {
        self.paramDictionary.removeAll()
        
        if let shiftID = UserDefaults.standard.value(forKey: "SHIFTID"){
            self.paramDictionary["operator_shift_time_details_id"] = shiftID as AnyObject
        }else{
            self.paramDictionary["operator_shift_time_details_id"] = "1" as AnyObject
        }
        
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                self.paramDictionary["companyId"] = companyID as AnyObject
                self.paramDictionary["user_id"] = userId as AnyObject
            }}
        //VEHICLENAME
       
        self.paramDictionary["source"] = "MOB" as AnyObject
        self.paramDictionary["vehicle_id"] = arraySamplertext[0] as AnyObject
        self.paramDictionary["location_lat"] = arraySamplertext[3] as AnyObject
        self.paramDictionary["location_long"] = arraySamplertext[4] as AnyObject
        self.paramDictionary["phone"] = modelUser?.phone as AnyObject
        self.paramDictionary["Name"] = modelUser?.first_name as AnyObject
        self.paramDictionary["status"] = "1" as AnyObject
        //self.paramDictionary["location_address"] = "USA" as AnyObject
        // self.paramDictionary["subject"] = "SOS" as AnyObject
        // self.paramDictionary["message"] = "SOS detail MSG" as AnyObject
        
        
        
        
        return  self.paramDictionary
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            arraySamplertext.append(String(location.coordinate.latitude))
            arraySamplertext.append(String(location.coordinate.longitude))
            self.lat = String(location.coordinate.latitude)
            self.long = String(location.coordinate.longitude)
            self.tableSOS.reloadData()
        }
    }
    
}
extension SosVC:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SosDetailsCell", for: indexPath) as! SosDetailsCell
            if let vID:String = UserDefaults.standard.value(forKey: "VEHICLENAME") as? String {
                cell.lblVehicleID.text = vID
            }else{
                cell.lblVehicleID.text = " "
            }
            cell.lblName.text = "\(self.modelUser?.first_name ?? " ") " + "\(self.modelUser?.last_name ?? " ")"
            cell.lblLat.text = lat
            cell.lblLong.text = long
            if self.modelUser?.phone == ""{
                cell.lblPhone.text = " "
            }else{
            cell.lblPhone.text = self.modelUser?.phone ?? " "
            }
            
            
            return cell
            
        }else if (indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell", for: indexPath) as! IncidentInputCell
            cell.imgViewDropDown.isHidden = false
            self.createPickerView(textField: cell.txtFieldInput)
            cell.txtFieldInput.text = self.selectedReason
            cell.txtFieldInput.tintColor = .white
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SosSubmitCell", for: indexPath) as! SosSubmitCell
            cell.buttonsend.addTarget(self, action: #selector(btnSendSos(_:)), for: .touchUpInside)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    
}
extension SosVC{
    func callSOSAPI(){
        if self.selectedReasonId == ""{
             PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please select the reason", AllActions: ["OK":nil], Style: .alert)
            return
        }
        if Connectivity.isConnectedToInternet {
            var param:[String:AnyObject] = [String:AnyObject]()
            //            let formatter1 = DateFormatter()
            //            formatter1.dateFormat = "yyyy-MM-dd,hh:mm"
            //            let dateString = formatter1.string(from: Date())
            //            let arrayDate = dateString.components(separatedBy: ",")
            if let vID:String = UserDefaults.standard.value(forKey: "VEHICLEID") as? String {
                param["vehicle_id"] = vID as AnyObject
            }else{
                return
            }
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
                    param["phone"] = modelUser?.phone as AnyObject
                    param["sos_reasons_master_id"] = self.selectedReasonId as AnyObject
                    param["location_lat"] = lat as AnyObject
                    param["location_long"] = long as AnyObject
                    param["status"] = "1" as AnyObject
                    param["message"] = self.selectedReason as AnyObject
                }
                
            }
            
            // }
            print(param)
            let opt = WebServiceOperation.init(API.putsos.getURL()?.absoluteString ?? "", param, .WEB_SERVICE_MULTI_PART, nil)
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
}
extension SosVC:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return arrayeason.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return arrayeason[row].sos_reason
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        isselected = true
        guard arrayeason.count > 0 else {
                       return
                   }
        self.selectedReason = arrayeason[row].sos_reason ?? ""
        self.selectedReasonId = arrayeason[row].sos_reasons_master_id ?? ""
        
        
    }
    
    func createPickerView(textField:UITextField) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.tag = textField.tag
        textField.inputView = pickerView
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let cancelBTN = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        cancelBTN.tag = textField.tag
        
        let doneBTN = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneAction(sender:)))
        doneBTN.tag = textField.tag
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelBTN,spacer,doneBTN], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        
    }
    
    
    @objc func cancelAction() {
        view.endEditing(true)
        isselected = false
    }
    @objc func doneAction(sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
        if isselected == false{
            guard arrayeason.count > 0 else {
                return
            }
            self.selectedReason = arrayeason[0].sos_reason ?? ""
            self.selectedReasonId = arrayeason[0].sos_reasons_master_id ?? ""
            
            
        }
        self.tableSOS.reloadData()
        isselected = false
        
        view.endEditing(true)
    }
    
    func callReasonListApi(){
         if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["user_id"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject
            param["location_lat"] = lat as AnyObject
            param["location_long"] = long as AnyObject
        }
             
        let opt = WebServiceOperation.init((API.sosReasonListAll.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["data"] as? [[String:Any]] {
                                do {
                                    self.arrayeason = try JSONDecoder().decode([SOSReason].self,from:(listArray.data)!)
                                    
                                }
                                catch {
                                    print(error)
                                    
                                }
                            }
                        }
                    }else{
                        
                        //PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
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

