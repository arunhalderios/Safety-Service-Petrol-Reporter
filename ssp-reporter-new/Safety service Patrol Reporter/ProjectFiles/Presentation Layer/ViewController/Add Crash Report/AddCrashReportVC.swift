//
//  AddCrashReportVC.swift
//  Safety service Patrol Reporter
//
//  Created by Pritam Dey on 01/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit
import CoreLocation
class AddCrashReportVC: BaseViewController {
    var arrayManagerList:[Manager] = []
    @IBOutlet weak var tableAddCrashReport: UITableView!
    let arrayTitle = ["Name*","Vehicle ID*","State*","Latitude*","Longitude*","Are You Injured?*","Was Anyone Else Injured?*", "How Many Other People Involved?*", "Which supervisor did you contact?*", "Were You In Your Truck?*", "Was Your Safety Belt Fastened?*", "Were the Police Notified?*","Any Property Damaged?*","Third party vehicle present?*"]
    //"Have you contacted the TMC yet?*" pos: 8
    let arraySamplertext = ["Yes","No"]
    let arrayPoliceNotified = ["Yes-Police arrived and completed report", "Yes-Police arrived and did not complete report", "No Police Involved"]
    var isSelected = false
    var modelUser : Userdetails?
    var arrayPopulate: [String] = []
    var arrayValues :[String] = []
    var vehicleID : String = ""
    var name:String = ""
    var locationManager: CLLocationManager = CLLocationManager()
    var cellHeight: [IndexPath :CGFloat] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...arrayTitle.count{
            self.arrayValues.append("")
            self.arrayPopulate.append("")
        }
        arrayValues[5] = "No"
        arrayPopulate[5] = "No"
        arrayValues[6] = "No"
        arrayPopulate[6] = "No"
        arrayValues[7] = "0"
        arrayPopulate[7] = "0"
        //arrayValues[8] = "No"
        //arrayPopulate[8] = "No"
        //arrayValues[9] = "No"
        // arrayPopulate[9] = "No"
        arrayValues[10] = "No"
        arrayPopulate[10] = "No"
        arrayValues[12] = "Yes"
        arrayPopulate[12] = "Yes"
        arrayValues[13] = "Yes"
        arrayPopulate[13] = "Yes"
        
        if let state = UserDefaults.standard.value(forKey: "STATENAME") as? String{
            
            if let stateID = UserDefaults.standard.value(forKey: "STATEID") as? String{
                
                arrayValues[2] = stateID
            }
            arrayPopulate[2] = state
        }
        // Do any additional setup after loading the view.
        locationManagerSetUp()
        callManagerListApi()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }
    
    func locationManagerSetUp(){
        if let user = UserDefaults.standard.value(forKey: "USER") as? [String:Any]{
            do{
                self.modelUser = try JSONDecoder().decode(Userdetails.self,from:(user.data)!)
            }
            catch{
                
            }
        }
        
        if let vID:String = UserDefaults.standard.value(forKey: "VEHICLENAME") as? String {
           
            arrayPopulate[1] = vID
        }
        if let vID:String = UserDefaults.standard.value(forKey: "VEHICLEID") as? String {
            arrayValues[1] = vID
            
        }
        arrayValues[0] = "\(self.modelUser?.first_name ?? "") \(self.modelUser?.last_name ?? "")"
        arrayPopulate[0] = "\(self.modelUser?.first_name ?? "") \(self.modelUser?.last_name ?? "")"
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            locationManager.startUpdatingLocation()
        }else{
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let cell = tableAddCrashReport.cellForRow(at: IndexPath(row: 0, section: 1)) as? IncidentButtomCell
        if cell != nil {
            cell?.btnNext.roundedView()
        }
    }
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNext(_ sender: Any) {
        if(isValidateField()){
            //if arrayValues[13] == "Yes" || arrayValues[14] == "Yes" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "AddCrashPhotoVC") as! AddCrashPhotoVC
            vc.arrayPopulate = arrayValues
            self.navigationController?.pushViewController(vc, animated: true)
//            }else{
//                let vc = storyboard?.instantiateViewController(withIdentifier: "AddCrashReportCommentVC") as! AddCrashReportCommentVC
//                vc.arrayPopulate = arrayValues
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        }
    }
    
    
    
}

extension AddCrashReportVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return arrayTitle.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1{
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "IncidentButtomCell", for: indexPath) as! IncidentButtomCell
            self.view.setNeedsLayout()
            return cell1
        }else{
            if (indexPath.row == 0)||(indexPath.row == 1)||(indexPath.row == 2)||(indexPath.row == 3)||(indexPath.row == 4)||(indexPath.row == 8)||(indexPath.row == 9)||(indexPath.row == 11){
                let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell", for: indexPath) as! IncidentInputCell
                cell.btnSelection.tag = indexPath.row
                cell.btnSelection.isHidden = true
                cell.txtFieldInput.isUserInteractionEnabled = true
                cell.txtFieldInput.tag = indexPath.row
                cell.lblTitle.text = arrayTitle[indexPath.row]
                cell.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
                cell.viewRound.roundedView()
                cell.viewRound.layer.borderWidth = 2.0
                cell.viewRound.layer.borderColor = AppthemeColor.cgColor
                cell.txtFieldInput.isUserInteractionEnabled = true
                
                cell.imgViewDropDown.isHidden = true
                cell.txtFieldInput.text = arrayPopulate[indexPath.row]
                cell.txtFieldInput.inputAccessoryView = nil
                cell.txtFieldInput.inputView = nil
                cell.txtFieldInput.tintColor = .black
                
                cell.txtFieldInput?.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
                if  indexPath.row == 9 || indexPath.row == 8 || indexPath.row == 11 {
                    cell.imgViewDropDown.isHidden = false
                    cell.txtFieldInput.text = (arrayPopulate[indexPath.row].count != 0) ? arrayPopulate[indexPath.row] : "Select"
                    self.createPickerView(textField: cell.txtFieldInput)
                    cell.txtFieldInput.tintColor = .white
                }else if indexPath.row == 0 ||  indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4{
                    cell.txtFieldInput.isUserInteractionEnabled = false
                }
                
                return cell
                
            }else {
                if indexPath.row == 7 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentNumberCell", for: indexPath) as! IncidentInputCell
                    cell.lblTitle.text = arrayTitle[indexPath.row]
                    cell.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
                    cell.lblCounter.text = arrayPopulate[indexPath.row]
                    cell.btnMinus.tag = indexPath.row
                    cell.btnPlus.tag = indexPath.row
                    cell.btnMinus.addTarget(self, action:  #selector(btnDecrement(_:)), for: .touchUpInside)
                    cell.btnPlus.addTarget(self, action:  #selector(btnIncement(_:)), for: .touchUpInside)
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentBoolCell", for: indexPath) as! IncidentInputCell
                    cell.lblTitle.text = arrayTitle[indexPath.row]
                    cell.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
                    if(arrayValues[indexPath.row].count != 0){
                        cell.imgYes.image = arrayPopulate[indexPath.row] == "Yes" ? UIImage(named: "Group 490") :  UIImage(named: "Ellipse 381")
                        cell.imgNo.image = arrayPopulate[indexPath.row] == "No" ? UIImage(named: "Group 490") :  UIImage(named: "Ellipse 381")
                    }
                    cell.btnNo.tag = indexPath.row
                    cell.btnYes.tag = indexPath.row
                    cell.btnNo.addTarget(self, action:  #selector(btnSelectOptionNo(_:)), for: .touchUpInside)
                    cell.btnYes.addTarget(self, action:  #selector(btnSelectOptionYes(_:)), for: .touchUpInside)
                    return cell
                    
                }
            }
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*if indexPath.section == 1{
            return UIDevice.current.userInterfaceIdiom == .phone ? 95 : 120
        }
        return UITableView.automaticDimension*/
        
        return UIDevice.current.userInterfaceIdiom == .phone ? 95 : 110
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeight[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            let height = UIDevice.current.userInterfaceIdiom == .phone ? 95 : 110
            return cellHeight[indexPath] ?? CGFloat(height)
        }
        return cellHeight[indexPath] ?? UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    @objc func btnDecrement(_ sender:UIButton) {
        var int_val = Int(arrayValues[sender.tag])!
        if(int_val > 0){
            int_val -= 1
        }
        arrayValues[sender.tag] = "\(int_val)"
        arrayPopulate[sender.tag] = "\(int_val)"
        self.tableAddCrashReport.reloadData()
    }
    @objc func btnIncement(_ sender:UIButton) {
        var int_val = Int(arrayValues[sender.tag])!
        
        int_val += 1
        arrayValues[sender.tag] = "\(int_val)"
        arrayPopulate[sender.tag] = "\(int_val)"
        
        self.tableAddCrashReport.reloadData()
    }
    @objc func btnSelectOptionNo(_ sender:UIButton) {
        arrayValues[sender.tag] = "No"
        arrayPopulate[sender.tag] = "No"
        self.tableAddCrashReport.reloadData()
    }
    @objc func btnSelectOptionYes(_ sender:UIButton) {
        arrayValues[sender.tag] = "Yes"
        arrayPopulate[sender.tag] = "Yes"
        self.tableAddCrashReport.reloadData()
    }
}

extension AddCrashReportVC:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 8{
            return arrayManagerList.count
        }
        else if pickerView.tag == 11{
            return arrayPoliceNotified.count
        }
        else {
            return arraySamplertext.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 8{
            return "\(arrayManagerList[row].first_name ?? "") \(arrayManagerList[row].last_name ?? "")"
        }
        else if pickerView.tag == 11{
            return arrayPoliceNotified[row]
        }
        else{
            return arraySamplertext[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        isSelected = true
        guard arrayPopulate.count > 0 else {
            return
        }
        if pickerView.tag == 8{
            arrayPopulate[pickerView.tag] = "\(arrayManagerList[row].first_name ?? "") \(arrayManagerList[row].last_name ?? "")"
            arrayValues[pickerView.tag] = "\(arrayManagerList[row].first_name ?? "") \(arrayManagerList[row].last_name ?? "")"
        }
        else if pickerView.tag == 11{
            arrayPopulate[pickerView.tag] = arrayPoliceNotified[row]
            arrayValues[pickerView.tag] = arrayPoliceNotified[row]
            
        }
        else{
            arrayPopulate[pickerView.tag] = arraySamplertext[row]
            arrayValues[pickerView.tag] = arraySamplertext[row]
        }
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
    
    func dismissPickerView() {
        
        //
    }
    
    @objc func cancelAction() {
        view.endEditing(true)
        isSelected = false
    }
    @objc func doneAction(sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
        if isSelected == false{
            if sender.tag == 8{
                guard arrayManagerList.count > 0 else {
                    return
                }
                arrayPopulate[sender.tag] = "\(arrayManagerList[0].first_name ?? "") \(arrayManagerList[0].last_name ?? "")"
                arrayValues[sender.tag] = "\(arrayManagerList[0].first_name ?? "") \(arrayManagerList[0].last_name ?? "")"
            }
            else if sender.tag == 11{
                guard arrayPoliceNotified.count > 0 else {
                    return
                }
                arrayPopulate[sender.tag] = arrayPoliceNotified[0]
                arrayValues[sender.tag] = arrayPoliceNotified[0]
                
            }
            else{
                guard arraySamplertext.count > 0 else {
                    return
                }
                arrayPopulate[sender.tag] = arraySamplertext[0]
                arrayValues[sender.tag] = arraySamplertext[0]
            }
        }
        self.tableAddCrashReport.reloadData()
        isSelected = false
        
        view.endEditing(true)
    }
}
///
///Mark:Api Work
/////
extension AddCrashReportVC{
    
    func callManagerListApi(){
        if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        //param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            
            param["companyId"] = companyID as AnyObject
            //if  let rolliD = UserDefaults.standard.value(forKey: "ROLLID"){
                param["roleId"] = "4" as AnyObject
            //}
            
        }
        print(param)
        
        let opt = WebServiceOperation.init((API.getUserList.getURL()?.absoluteString ?? ""), param)
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
                                    self.arrayManagerList = try JSONDecoder().decode([Manager].self,from:(listArray.data)!)
                                    print("Success State")
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
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
        }
    }
    
}
///
////Mark: LocationWork
///
extension AddCrashReportVC:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            arrayValues[3] = String(location.coordinate.latitude)
            arrayValues[4] = String(location.coordinate.longitude)
            arrayPopulate[3] = String(location.coordinate.latitude)
            arrayPopulate[4] = String(location.coordinate.longitude)
            locationManager.stopUpdatingLocation()
            self.tableAddCrashReport.reloadData()
        }
    }
}
///
////Mark: textField work
///
extension AddCrashReportVC:UITextFieldDelegate{
    @objc func textFieldValueChanged(_ textField:UITextField) {
        arrayValues[textField.tag] = textField.text!
        arrayPopulate[textField.tag] = textField.text!
        print (arrayValues)
    }
    
}
///
////Mark:Validation
///
extension AddCrashReportVC{
    func isValidateField()->Bool{
        
        self.view.endEditing(true)
        
        
        guard arrayPopulate[0].count > 0 else {
            self.displayAlert(Header: App_Title, MessageBody: "Please enter name", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[1].count > 0 else {
            self.displayAlert(Header: App_Title, MessageBody: "Please enter vhicle id", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[2].count > 0 else {
            self.displayAlert(Header: App_Title, MessageBody: "Please select state", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[3].count > 0 else {
            self.displayAlert(Header: App_Title, MessageBody: "Please enter latitude", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[4].count > 0 else {
            self.displayAlert(Header: App_Title, MessageBody: "Please enter longitude", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[5].count > 0 else {
            self.displayAlert(Header: App_Title, MessageBody: "Please mention your's injuries", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[6].count > 0 else {
            self.displayAlert(Header: App_Title, MessageBody: "Please mention other's injuries", AllActions: ["OK":nil], Style: .alert)
            return false
            
        }
        guard arrayPopulate[7].count > 0 else {
            self.displayAlert(Header: App_Title, MessageBody: "Please mention number of people", AllActions: ["OK":nil], Style: .alert)
            return false
        }
//        guard arrayPopulate[8].count > 0 else {
//            self.displayAlert(Header: App_Title, MessageBody: "Did You Contact TMC?", AllActions: ["OK":nil], Style: .alert)
//            return false
//        }
        guard arrayPopulate[8].count > 0 else {
            self.displayAlert(Header: App_Title, MessageBody: "Did You Contact Your Supervisor?", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[9].count > 0 else {
            self.displayAlert(Header: App_Title, MessageBody: "Were You In Your Truck?", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[10].count > 0 else {
            self.displayAlert(Header: App_Title, MessageBody: "Was Your Safety Belt Fastened?", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[11].count > 0 else {
            self.displayAlert(Header: App_Title, MessageBody: "Police Report Info", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        
        
        return true
    }
}
