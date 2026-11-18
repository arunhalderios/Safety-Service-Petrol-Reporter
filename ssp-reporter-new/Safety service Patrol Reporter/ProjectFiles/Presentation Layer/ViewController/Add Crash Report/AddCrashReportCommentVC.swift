//
//  AddCrashReportCommentVC.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Mahalik on 02/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
struct Driver_Empty_info : Codable {
    let dirver_name : String?
    let driver_phone : String?
    let driver_address : String?
    let driver_licence_number : String?
    let vehicle_insurance_info : String?
    let insurance_expriary_date : String?
    let Injuries : String?
    let passenger_info : [Passenger_Empty_info]?
    
    enum CodingKeys: String, CodingKey {
        
        case dirver_name = "dirver_name"
        case driver_phone = "driver_phone"
        case driver_address = "driver_address"
        case driver_licence_number = "driver_licence_number"
        case vehicle_insurance_info = "vehicle_insurance_info"
        case insurance_expriary_date = "insurance_expriary_date"
        case Injuries = "Injuries"
        case passenger_info = "passenger_info"
    }
}
struct Passenger_Empty_info : Codable {
    let name : String?
    let passenger_address : String?
    let passenger_phone : String?
    let passenger_licence_number : String?
    let passenger_Injuries : String?
    enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case passenger_address = "passenger_address"
        case passenger_phone = "passenger_phone"
        case passenger_licence_number = "passenger_licence_number"
        case passenger_Injuries = "passenger_inuries"
    }
    
}

class AddCrashReportCommentVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var isSelected = false
    var arrayPopulate: [String] = []
    var arrayFileInfo : [MultiPartDataFormatStructure] = []
    
    var arrayValues : [String] = []
    let arrayInjuries = ["Yes","No"]
    
    
    var numberofSec = 2
    var numberofPassenger = 0
    var isThirdPartyAdded : Bool = false
    
    @IBOutlet weak var tableViewCrash: UITableView!
    var cellHeight: [IndexPath :CGFloat] = [:]
    var datePicker = UIDatePicker()
    
    var arrayDriver_info :  [Driver_Empty_info] = []
 
    
    var selectedTextField: UITextField = UITextField()
    override func viewDidLoad() {
     
        self.statusBarColourChangeYellow()
        // Do any additional setup after loading the view.
        arrayValues = ["","","","","","","",""]
    }
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(true)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        TimeService.instance.resetInactivityTimer()
    }
    override func viewWillDisappear(_ animated:Bool){
        super.viewWillDisappear(true)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableViewCrash.reloadData()
         self.view.setNeedsLayout()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textViewDidBeginEditing(_ textField: UITextField) {
         self.view.setNeedsLayout()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let cell = self.tableViewCrash.cellForRow(at: IndexPath(row: 0, section: numberofSec - 1)) as? SosSubmitCell
        if cell != nil{
            cell?.buttonCancel.roundedView()
            cell?.buttonsend.roundedView()
        }
        
    }
    
    @IBAction func btnAddThirdPartyAction(_ sender: Any) {
        ///blank passenger info insertion
        let passenger = Passenger_Empty_info.init(name: "",
                                                  passenger_address: "",
                                                  passenger_phone: "",
                                                  passenger_licence_number: "",
                                                  passenger_Injuries:"")
        let Driver = Driver_Empty_info.init(dirver_name: "",
                                            driver_phone: "",
                                            driver_address: "",
                                            driver_licence_number: "",
                                            vehicle_insurance_info: "",
                                            insurance_expriary_date: "",
                                            Injuries: "",
                                            passenger_info:[passenger])
        arrayDriver_info.append(Driver)
        isThirdPartyAdded = true
        tableViewCrash.reloadData()
       // self.view.setNeedsLayout()
       
    }
    
    @IBAction func btnMinusAction(_ sender: UIButton) {
        
        let superViews = sender.superview?.superview
        
        if superViews?.isKind(of: AddCrashPassengerCell.self) ?? false {
            if let cell = superViews as? AddCrashPassengerCell{
                let indexPath = tableViewCrash.indexPath(for: cell)
                
                let selectedSection = indexPath?.section
                let section = (selectedSection! - 1)
                let modifiedDriverInfo = arrayDriver_info[section]
                var modifiedPassengerInfoList =  modifiedDriverInfo.passenger_info
                modifiedPassengerInfoList?.remove(at: sender.tag)
                
                let Driver = Driver_Empty_info.init(dirver_name: modifiedDriverInfo.dirver_name,
                                                    driver_phone: modifiedDriverInfo.driver_phone,
                                                    driver_address:  modifiedDriverInfo.driver_address,
                                                    driver_licence_number: modifiedDriverInfo.driver_licence_number,
                                                    vehicle_insurance_info: modifiedDriverInfo.vehicle_insurance_info,
                                                    insurance_expriary_date: modifiedDriverInfo.insurance_expriary_date,
                                                    Injuries: modifiedDriverInfo.Injuries,
                                                    passenger_info:modifiedPassengerInfoList)
                arrayDriver_info[section] = Driver
                
                   
            }
            
        }
        tableViewCrash.reloadData()
        //self.view.setNeedsLayout()
        /*
         numberofPassenger = numberofPassenger - 1
         if numberofPassenger == 0{
         numberofSec = numberofSec - 1
         }
         tableViewCrash.reloadData()
         self.view.setNeedsLayout()
         */
    }
    
    @IBAction func btnAddMorePassengeres(_ sender: UIButton ) {
        /*
        numberofPassenger = numberofPassenger + 1
        if numberofSec == 3{
            numberofSec = numberofSec + 1
        }*/
        ///blank passenger info insertion
        let mdObj = arrayDriver_info[sender.tag]
        var addedPassengerInfo = mdObj.passenger_info
        let passenger = Passenger_Empty_info.init(name: "",
                                                  passenger_address: "",
                                                  passenger_phone: "",
                                                  passenger_licence_number: "",
                                                  passenger_Injuries:"")
        addedPassengerInfo?.append(passenger)
        
        let Driver = Driver_Empty_info.init(dirver_name: mdObj.dirver_name,
                                                   driver_phone: mdObj.driver_phone,
                                                   driver_address: mdObj.driver_address,
                                                   driver_licence_number:  mdObj.driver_licence_number,
                                                   vehicle_insurance_info: mdObj.vehicle_insurance_info,
                                                   insurance_expriary_date: mdObj.insurance_expriary_date,
                                                   Injuries: "",
                                                   passenger_info:addedPassengerInfo)
        arrayDriver_info[sender.tag] = Driver
        //arrayDriver_info
        tableViewCrash.reloadData()
        //self.view.setNeedsLayout()
    }
    func validate() -> Bool{
        for thirdParty in arrayDriver_info{
            if thirdParty.insurance_expriary_date == ""{
                self.displayAlert(Header: App_Title, MessageBody: "Please select insurance expiry date ", AllActions: ["OK":nil], Style: .alert)
                return false
            }
        }
        return true
    }
    @IBAction func buttonSubmit(_ sender: Any) {
        if validate() == true{
        callAddCrashReportApi()
        }
        
        /*
         for controller in self.navigationController!.viewControllers as Array {
         if controller.isKind(of: DashboardViewController.self) {
         self.navigationController!.popToViewController(controller, animated: true)
         break
         }
         }*/
    }
    func navigateToList() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: DashboardViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        print("numberOfSections ::\(numberofSec)")
        return (arrayDriver_info.count + 2)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section ==  0 {
            return 1
        }else if (section == arrayDriver_info.count + 1){
            return 0
        }else{
            let addedPassengerInfo = arrayDriver_info[section-1].passenger_info
            return addedPassengerInfo?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cellForRowAt ::\(indexPath.section) ::\(indexPath.row)")
        if indexPath.section == 0{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "AddCrashCommentCell", for: indexPath) as! AddCrashCommentCell
            cell.txtComment.addborder()
            cell.txtComment.layer.borderColor = darkThemeColor.cgColor
          
            cell.txtComment.tag = 0
            cell.txtComment.delegate = self
            return cell
        } else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "AddCrashPassengerCell", for: indexPath) as! AddCrashPassengerCell
            cell.viewRound.roundedViewTheme()
            cell.viewRound1.roundedViewTheme()
            //cell.viewRound2.roundedViewTheme()
            // cell.viewRound3.roundedViewTheme()
            
            cell.txtPassengerName.tag = indexPath.row
            cell.txtPhonrNumber.tag =   indexPath.row
            //cell.txtPhonrNumber.keyboardType = .numberPad
            cell.txtvwAddress.tag =  indexPath.row
            cell.txtvwDriverLicenseInfo.tag =  indexPath.row
            cell.btnSelection.tag = indexPath.row
            cell.btnSelection.isHidden = true
            cell.txtInjuries.tag =  indexPath.row
            cell.txtInjuries.delegate = self
            cell.txtPassengerName?.addTarget(self, action: #selector(textFieldPassengerNameValueChanged(_:)), for: .editingChanged)
            cell.txtPhonrNumber?.addTarget(self, action: #selector(textFieldPassengerPhoneNumberValueChanged(_:)), for: .editingChanged)
            cell.txtvwAddress.delegate = self
            cell.txtvwDriverLicenseInfo.delegate = self
            self.createPickerView(textField: cell.txtInjuries)
            let arrPasengerinfoTemp =  arrayDriver_info[(indexPath.section - 1)].passenger_info
            let pInfo = arrPasengerinfoTemp?[indexPath.row]
            cell.txtPassengerName.text = pInfo?.name
            cell.txtPhonrNumber.text = pInfo?.passenger_phone
            cell.txtvwAddress.text =  pInfo?.passenger_address
            cell.txtvwDriverLicenseInfo.text = pInfo?.passenger_licence_number
            cell.txtInjuries.text =  (pInfo?.passenger_Injuries?.count != 0) ?  pInfo?.passenger_Injuries : "Select"
            
            cell.btnMinus.tag = indexPath.row
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        if section == 0{
            return nil
        }
        if (section == arrayDriver_info.count + 1){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCrashSubmitCell") as! AddCrashSubmitCell
          
            cell.buttonsend.layer.cornerRadius = 8//cell.buttonsend.frame.size.height / 2
            cell.buttonCancel.layer.cornerRadius = 8 //cell.buttonCancel.frame.size.height / 2
            if arrayPopulate[14] == "No"{
                cell.buttonsend.isHidden = true
            }else{
                cell.buttonsend.isHidden = false
            }
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CrsahReportFooterCell") as! CrsahReportFooterCell
            
            cell.btnAddMorePassenger.tag = (section - 1)
             cell.btnAddMorePassenger.layer.cornerRadius = 8 //cell.btnAddMorePassenger.frame.size.height / 2
            return cell
        }
    }
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            if section == 0{
                return 0.1
            }else if (section == arrayDriver_info.count + 1){
                if  arrayPopulate[14] == "No"{
                    return 88
                }else{
                return 152
                }
            }else{
                return 70
            }
        }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if ((section == 0) || (section == arrayDriver_info.count + 1)){
            return nil
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCrashThirdPartyCell") as! AddCrashThirdPartyCell
           
                cell.viewRound.roundedViewTheme()
                cell.viewRound1.roundedViewTheme()
                cell.viewRound5.roundedViewTheme()
                cell.viewRound6.roundedViewTheme()
                
                cell.txtDriverName.tag = (section - 1)
                cell.txtDriverName.delegate = self
                cell.txtPhonrNumber.tag = (section - 1)
                //cell.txtPhonrNumber.keyboardType = .numberPad
                cell.txtvwAddress.tag = (section - 1)
                cell.txtvwDriverLicenseInfo.tag = (section - 1)
                cell.txtvwVehicleInsuranceInfo.tag = (section - 1)
                cell.txtInsuranceExpiryDate.tag = (section - 1)
                cell.btnSelection.tag = (section - 1)
                cell.btnSelection.isHidden = true
                cell.txtInjuries.tag = (section - 1)
                cell.txtInjuries.delegate = self
                
                cell.txtDriverName?.addTarget(self, action: #selector(textFieldDriverNameValueChanged(_:)), for: .editingChanged)
                cell.txtPhonrNumber?.addTarget(self, action: #selector(textFieldDriverPhoneNumberValueChanged(_:)), for: .editingChanged)
                cell.txtvwAddress.delegate = self
                cell.txtvwDriverLicenseInfo.delegate = self
                cell.txtvwVehicleInsuranceInfo.delegate = self
                cell.txtInsuranceExpiryDate?.addTarget(self, action: #selector(textFieldDriverExpiryValueChanged(_:)), for: .editingChanged)
                self.createDatePickerView(textField: cell.txtInsuranceExpiryDate)
                self.createPickerView(textField: cell.txtInjuries)
                
                let addeDriverInfo = arrayDriver_info[section-1]
                cell.txtDriverName.text = addeDriverInfo.dirver_name
                cell.txtPhonrNumber.text =  addeDriverInfo.driver_phone
                cell.txtvwAddress.text = addeDriverInfo.driver_address
                cell.txtvwDriverLicenseInfo.text = addeDriverInfo.driver_licence_number
                cell.txtvwVehicleInsuranceInfo.text = addeDriverInfo.vehicle_insurance_info
                cell.txtInsuranceExpiryDate.text =  addeDriverInfo.insurance_expriary_date
                
                cell.txtInjuries.text =   ( addeDriverInfo.Injuries?.count != 0) ? addeDriverInfo.Injuries : "Select"
            
           
            cell.lblHeader.text = "Third Party Information Set \(section) :"
            
            return cell
        }
    }
      func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          
          if ((section == 0) || (section == arrayDriver_info.count + 1)){
              return 0.1
          }else{
              return 585
          }
      }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if indexPath.section == 0{
            return UITableView.automaticDimension
        }else if(indexPath.section == arrayDriver_info.count + 1){
            return 0
        }else{
           return 378
        }
    }
    //
   ////////Mark:  TextField Work Passenger
    //
    @objc func textFieldPassengerNameValueChanged(_ textField:UITextField) {
        let superViews = textField.superview?.superview?.superview?.superview?.superview
        if superViews?.isKind(of: AddCrashPassengerCell.self) ?? false {
            if let cell = superViews as? AddCrashPassengerCell{
                let indexPath = tableViewCrash.indexPath(for: cell)
                
                let selectedSection = indexPath?.section
                let section = (selectedSection! - 1)
                let modifiedDriverInfo = arrayDriver_info[section]
                var modifiedPassengerInfoList =  modifiedDriverInfo.passenger_info
                let modifiedPassengerInfo = modifiedPassengerInfoList?[textField.tag]
                let pInfo = Passenger_Empty_info.init(name: textField.text,
                                                      passenger_address: modifiedPassengerInfo?.passenger_address,
                                                      passenger_phone: modifiedPassengerInfo?.passenger_phone,
                                                      passenger_licence_number: modifiedPassengerInfo?.passenger_licence_number,
                                                      passenger_Injuries:modifiedPassengerInfo?.passenger_Injuries)
                modifiedPassengerInfoList?[textField.tag] = pInfo
                
                let Driver = Driver_Empty_info.init(dirver_name: modifiedDriverInfo.dirver_name,
                                                    driver_phone: modifiedDriverInfo.driver_phone,
                                                    driver_address:  modifiedDriverInfo.driver_address,
                                                    driver_licence_number: modifiedDriverInfo.driver_licence_number,
                                                    vehicle_insurance_info: modifiedDriverInfo.vehicle_insurance_info,
                                                    insurance_expriary_date: modifiedDriverInfo.insurance_expriary_date,
                                                    Injuries: modifiedDriverInfo.Injuries,
                                                    passenger_info:modifiedPassengerInfoList)
                arrayDriver_info[section] = Driver
                
                
                
            }
            
        }
     
        
    }
    @objc func textFieldPassengerPhoneNumberValueChanged(_ textField:UITextField) {
        let superViews = textField.superview?.superview?.superview?.superview?.superview
        if superViews?.isKind(of: AddCrashPassengerCell.self) ?? false {
            if let cell = superViews as? AddCrashPassengerCell{
                let indexPath = tableViewCrash.indexPath(for: cell)
                
                let selectedSection = indexPath?.section
                let section = (selectedSection! - 1)
                let modifiedDriverInfo = arrayDriver_info[section]
                var modifiedPassengerInfoList =  modifiedDriverInfo.passenger_info
                let modifiedPassengerInfo = modifiedPassengerInfoList?[textField.tag]
                let pInfo = Passenger_Empty_info.init(name: modifiedPassengerInfo?.name,
                                                      passenger_address: modifiedPassengerInfo?.passenger_address,
                                                      passenger_phone: textField.text,
                                                      passenger_licence_number: modifiedPassengerInfo?.passenger_licence_number,
                                                      passenger_Injuries:modifiedPassengerInfo?.passenger_Injuries)
                modifiedPassengerInfoList?[textField.tag] = pInfo
                
                let Driver = Driver_Empty_info.init(dirver_name: modifiedDriverInfo.dirver_name,
                                                    driver_phone: modifiedDriverInfo.driver_phone,
                                                    driver_address:  modifiedDriverInfo.driver_address,
                                                    driver_licence_number: modifiedDriverInfo.driver_licence_number,
                                                    vehicle_insurance_info: modifiedDriverInfo.vehicle_insurance_info,
                                                    insurance_expriary_date: modifiedDriverInfo.insurance_expriary_date,
                                                    Injuries: modifiedDriverInfo.Injuries,
                                                    passenger_info:modifiedPassengerInfoList)
                arrayDriver_info[section] = Driver
                
                
                
            }
            
        }
     
    }
    //
    ////////Mark:  TextField Work Driver
     //
    @objc func textFieldDriverExpiryValueChanged(_ textField:UITextField) {
        let drivarInfo = arrayDriver_info[textField.tag]
        
        let Driver = Driver_Empty_info.init(dirver_name: drivarInfo.dirver_name,
                                            driver_phone: drivarInfo.driver_phone,
                                            driver_address: drivarInfo.driver_address,
                                            driver_licence_number: drivarInfo.driver_licence_number,
                                            vehicle_insurance_info: drivarInfo.vehicle_insurance_info,
                                                   insurance_expriary_date: textField.text,
                                                   Injuries: drivarInfo.Injuries,
                                                   passenger_info:drivarInfo.passenger_info)
        arrayDriver_info[textField.tag] = Driver
        
        //arrayValues[textField.tag] = textField.text ?? ""
    }
    @objc func textFieldDriverNameValueChanged(_ textField:UITextField) {
        let drivarInfo = arrayDriver_info[textField.tag]
        
        let Driver = Driver_Empty_info.init(dirver_name: textField.text ?? "",
                                            driver_phone: drivarInfo.driver_phone,
                                            driver_address: drivarInfo.driver_address,
                                            driver_licence_number: drivarInfo.driver_licence_number,
                                            vehicle_insurance_info: drivarInfo.vehicle_insurance_info,
                                            insurance_expriary_date: drivarInfo.insurance_expriary_date,
                                            Injuries: drivarInfo.Injuries,
                                            passenger_info:drivarInfo.passenger_info)
        arrayDriver_info[textField.tag] = Driver
        //arrayValues[textField.tag] = textField.text ?? ""
    }
    
    @objc func textFieldDriverPhoneNumberValueChanged(_ textField:UITextField) {
        let drivarInfo = arrayDriver_info[textField.tag]
        
        let Driver = Driver_Empty_info.init(dirver_name: drivarInfo.dirver_name,
                                            driver_phone: textField.text ?? "",
                                            driver_address: drivarInfo.driver_address,
                                            driver_licence_number: drivarInfo.driver_licence_number,
                                            vehicle_insurance_info: drivarInfo.vehicle_insurance_info,
                                            insurance_expriary_date: drivarInfo.insurance_expriary_date,
                                            Injuries: drivarInfo.Injuries,
                                            passenger_info:drivarInfo.passenger_info)
        arrayDriver_info[textField.tag] = Driver
        // arrayValues[textField.tag] = textField.text ?? ""
    }
    
}

extension AddCrashReportCommentVC:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.view.setNeedsLayout()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        tableViewCrash.reloadData()
         self.view.setNeedsLayout()
    }
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        
        
        let superViews = textView.superview?.superview?.superview?.superview?.superview
        
        if superViews?.isKind(of: AddCrashThirdPartyCell.self) ?? false {
            let cell = superViews as? AddCrashThirdPartyCell
            if textView == cell?.txtvwAddress{
                let drivarInfo = arrayDriver_info[textView.tag]
                
                let Driver = Driver_Empty_info.init(dirver_name: drivarInfo.dirver_name,
                                                    driver_phone: drivarInfo.driver_phone,
                                                    driver_address: textView.text,
                                                    driver_licence_number: drivarInfo.driver_licence_number,
                                                    vehicle_insurance_info: drivarInfo.vehicle_insurance_info,
                                                    insurance_expriary_date: drivarInfo.insurance_expriary_date,
                                                    Injuries: drivarInfo.Injuries,
                                                    passenger_info:drivarInfo.passenger_info)
                arrayDriver_info[textView.tag] = Driver
            }else if textView == cell?.txtvwDriverLicenseInfo{
                let drivarInfo = arrayDriver_info[textView.tag]
                
                let Driver = Driver_Empty_info.init(dirver_name: drivarInfo.dirver_name,
                                                    driver_phone: drivarInfo.driver_phone,
                                                    driver_address: drivarInfo.driver_address,
                                                    driver_licence_number: textView.text,
                                                    vehicle_insurance_info: drivarInfo.vehicle_insurance_info,
                                                    insurance_expriary_date: drivarInfo.insurance_expriary_date,
                                                    Injuries: drivarInfo.Injuries,
                                                    passenger_info:drivarInfo.passenger_info)
                arrayDriver_info[textView.tag] = Driver
            }else if textView == cell?.txtvwVehicleInsuranceInfo{
                let drivarInfo = arrayDriver_info[textView.tag]
                
                let Driver = Driver_Empty_info.init(dirver_name: drivarInfo.dirver_name,
                                                    driver_phone: drivarInfo.driver_phone,
                                                    driver_address:  drivarInfo.driver_address,
                                                    driver_licence_number: drivarInfo.driver_licence_number,
                                                    vehicle_insurance_info: textView.text,
                                                    insurance_expriary_date: drivarInfo.insurance_expriary_date,
                                                    Injuries: drivarInfo.Injuries,
                                                    passenger_info:drivarInfo.passenger_info)
                arrayDriver_info[textView.tag] = Driver
            }
        }else if superViews?.isKind(of: AddCrashPassengerCell.self) ?? false {
            let cell = superViews as? AddCrashPassengerCell
            if textView == cell?.txtvwAddress{
                let indexPath = tableViewCrash.indexPath(for: cell!)
                let selectedSection = indexPath?.section
                let section = (selectedSection! - 1)
                let modifiedDriverInfo = arrayDriver_info[section]
                var modifiedPassengerInfoList =  modifiedDriverInfo.passenger_info
                let modifiedPassengerInfo = modifiedPassengerInfoList?[textView.tag]
                let pInfo = Passenger_Empty_info.init(name: modifiedPassengerInfo?.name,
                                                      passenger_address:  textView.text,
                                                      passenger_phone: modifiedPassengerInfo?.passenger_phone,
                                                      passenger_licence_number: modifiedPassengerInfo?.passenger_licence_number,
                                                      passenger_Injuries:modifiedPassengerInfo?.passenger_Injuries)
                modifiedPassengerInfoList?[textView.tag] = pInfo
                
                let Driver = Driver_Empty_info.init(dirver_name: modifiedDriverInfo.dirver_name,
                                                    driver_phone: modifiedDriverInfo.driver_phone,
                                                    driver_address:  modifiedDriverInfo.driver_address,
                                                    driver_licence_number: modifiedDriverInfo.driver_licence_number,
                                                    vehicle_insurance_info: modifiedDriverInfo.vehicle_insurance_info,
                                                    insurance_expriary_date: modifiedDriverInfo.insurance_expriary_date,
                                                    Injuries: modifiedDriverInfo.Injuries,
                                                    passenger_info:modifiedPassengerInfoList)
                arrayDriver_info[section] = Driver
                
            }else if textView == cell?.txtvwDriverLicenseInfo{
                let indexPath = tableViewCrash.indexPath(for: cell!)
                let selectedSection = indexPath?.section
                let section = (selectedSection! - 1)
                let modifiedDriverInfo = arrayDriver_info[section]
                var modifiedPassengerInfoList =  modifiedDriverInfo.passenger_info
                let modifiedPassengerInfo = modifiedPassengerInfoList?[textView.tag]
                let pInfo = Passenger_Empty_info.init(name: modifiedPassengerInfo?.name,
                                                      passenger_address: modifiedPassengerInfo?.passenger_address,
                                                      passenger_phone: modifiedPassengerInfo?.passenger_phone,
                                                      passenger_licence_number: textView.text,
                                                      passenger_Injuries:modifiedPassengerInfo?.passenger_Injuries)
                modifiedPassengerInfoList?[textView.tag] = pInfo
                
                let Driver = Driver_Empty_info.init(dirver_name: modifiedDriverInfo.dirver_name,
                                                    driver_phone: modifiedDriverInfo.driver_phone,
                                                    driver_address:  modifiedDriverInfo.driver_address,
                                                    driver_licence_number: modifiedDriverInfo.driver_licence_number,
                                                    vehicle_insurance_info: modifiedDriverInfo.vehicle_insurance_info,
                                                    insurance_expriary_date: modifiedDriverInfo.insurance_expriary_date,
                                                    Injuries: modifiedDriverInfo.Injuries,
                                                    passenger_info:modifiedPassengerInfoList)
                arrayDriver_info[section] = Driver
                
            }
        }else{
            arrayValues[textView.tag] = textView.text
        }
       
    }
}
//
//Mark : PICKER WORK
///
extension AddCrashReportCommentVC:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayInjuries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayInjuries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
      isSelected = true
        let superViews = self.selectedTextField.superview?.superview?.superview?.superview?.superview
        if superViews?.isKind(of: AddCrashThirdPartyCell.self) ?? false {
           // let cell = superViews as? AddCrashThirdPartyCell
           
            let drivarInfo = arrayDriver_info[pickerView.tag]
            
            let Driver = Driver_Empty_info.init(dirver_name: drivarInfo.dirver_name,
                                                driver_phone: drivarInfo.driver_phone,
                                                driver_address:  drivarInfo.driver_address,
                                                driver_licence_number: drivarInfo.driver_licence_number,
                                                vehicle_insurance_info: drivarInfo.vehicle_insurance_info,
                                                insurance_expriary_date: drivarInfo.insurance_expriary_date,
                                                Injuries: arrayInjuries[row],
                                                passenger_info:drivarInfo.passenger_info)
            arrayDriver_info[pickerView.tag] = Driver
            
        }else if superViews?.isKind(of: AddCrashPassengerCell.self) ?? false {
            
            let cell = superViews as? AddCrashPassengerCell
            let indexPath = tableViewCrash.indexPath(for: cell!)
            let selectedSection = indexPath?.section
            if(selectedSection == nil){
                return
            }
            let section = (selectedSection! - 1)
            
            let modifiedDriverInfo = arrayDriver_info[section]
            var modifiedPassengerInfoList =  modifiedDriverInfo.passenger_info
            let modifiedPassengerInfo = modifiedPassengerInfoList?[pickerView.tag]
            let pInfo = Passenger_Empty_info.init(name: modifiedPassengerInfo?.name,
                                                  passenger_address: modifiedPassengerInfo?.passenger_address,
                                                  passenger_phone: modifiedPassengerInfo?.passenger_phone,
                                                  passenger_licence_number: modifiedPassengerInfo?.passenger_licence_number,
                                                  passenger_Injuries:arrayInjuries[row])
            modifiedPassengerInfoList?[pickerView.tag] = pInfo
            
            let Driver = Driver_Empty_info.init(dirver_name: modifiedDriverInfo.dirver_name,
                                                driver_phone: modifiedDriverInfo.driver_phone,
                                                driver_address:  modifiedDriverInfo.driver_address,
                                                driver_licence_number: modifiedDriverInfo.driver_licence_number,
                                                vehicle_insurance_info: modifiedDriverInfo.vehicle_insurance_info,
                                                insurance_expriary_date: modifiedDriverInfo.insurance_expriary_date,
                                                Injuries: modifiedDriverInfo.Injuries,
                                                passenger_info:modifiedPassengerInfoList)
            arrayDriver_info[section] = Driver
            
          
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
    func addDoneButtonOnKeyboard(textfild:UITextField){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        textfild.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }
  
    @objc func cancelAction() {
        isSelected = false
        view.endEditing(true)
    }
    @objc func doneAction(sender: UIBarButtonItem) {
        self.view.endEditing(true)
        if isSelected == false{
            let superViews = self.selectedTextField.superview?.superview?.superview?.superview?.superview
            if superViews?.isKind(of: AddCrashThirdPartyCell.self) ?? false {
                // let cell = superViews as? AddCrashThirdPartyCell
                
                let drivarInfo = arrayDriver_info[sender.tag]
                
                let Driver = Driver_Empty_info.init(dirver_name: drivarInfo.dirver_name,
                                                    driver_phone: drivarInfo.driver_phone,
                                                    driver_address:  drivarInfo.driver_address,
                                                    driver_licence_number: drivarInfo.driver_licence_number,
                                                    vehicle_insurance_info: drivarInfo.vehicle_insurance_info,
                                                    insurance_expriary_date: drivarInfo.insurance_expriary_date,
                                                    Injuries: arrayInjuries[0],
                                                    passenger_info:drivarInfo.passenger_info)
                arrayDriver_info[sender.tag] = Driver
                
            }else if superViews?.isKind(of: AddCrashPassengerCell.self) ?? false {
                
                let cell = superViews as? AddCrashPassengerCell
                let indexPath = tableViewCrash.indexPath(for: cell!)
                let selectedSection = indexPath?.section
                if(selectedSection == nil){
                    return
                }
                let section = (selectedSection! - 1)
                
                let modifiedDriverInfo = arrayDriver_info[section]
                var modifiedPassengerInfoList =  modifiedDriverInfo.passenger_info
                let modifiedPassengerInfo = modifiedPassengerInfoList?[sender.tag]
                let pInfo = Passenger_Empty_info.init(name: modifiedPassengerInfo?.name,
                                                      passenger_address: modifiedPassengerInfo?.passenger_address,
                                                      passenger_phone: modifiedPassengerInfo?.passenger_phone,
                                                      passenger_licence_number: modifiedPassengerInfo?.passenger_licence_number,
                                                      passenger_Injuries:arrayInjuries[0])
                modifiedPassengerInfoList?[sender.tag] = pInfo
                
                let Driver = Driver_Empty_info.init(dirver_name: modifiedDriverInfo.dirver_name,
                                                    driver_phone: modifiedDriverInfo.driver_phone,
                                                    driver_address:  modifiedDriverInfo.driver_address,
                                                    driver_licence_number: modifiedDriverInfo.driver_licence_number,
                                                    vehicle_insurance_info: modifiedDriverInfo.vehicle_insurance_info,
                                                    insurance_expriary_date: modifiedDriverInfo.insurance_expriary_date,
                                                    Injuries: modifiedDriverInfo.Injuries,
                                                    passenger_info:modifiedPassengerInfoList)
                arrayDriver_info[section] = Driver
                
                
            }
        }
        self.tableViewCrash.reloadData()
        view.endEditing(true)
        isSelected = false
    }
    
    func createDatePickerView(textField:UITextField) {
        //datePicker  = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.minimumDate = Date()
        textField.inputView = datePicker
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let cancelBTN = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        cancelBTN.tag = textField.tag
        
        let doneBTN = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.donDatePickereAction(sender:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        doneBTN.tag = textField.tag
        
        toolBar.setItems([cancelBTN,spacer,doneBTN], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        
    }
    @objc func donDatePickereAction(sender: UIBarButtonItem) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        ////date validation
        //self.arrayValues[sender.tag] = formatter.string(from: datePicker.date)
        let drivarInfo = arrayDriver_info[sender.tag]
        
        let Driver = Driver_Empty_info.init(dirver_name: drivarInfo.dirver_name,
                                            driver_phone: drivarInfo.driver_phone,
                                            driver_address: drivarInfo.driver_address,
                                            driver_licence_number: drivarInfo.driver_licence_number,
                                            vehicle_insurance_info: drivarInfo.vehicle_insurance_info,
                                                   insurance_expriary_date:formatter.string(from: datePicker.date),
                                                   Injuries: drivarInfo.Injuries,
                                                   passenger_info:drivarInfo.passenger_info)
        arrayDriver_info[sender.tag] = Driver
        
        tableViewCrash.reloadData()
        
        self.view.endEditing(true)
        
    }
   
}
extension AddCrashReportCommentVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
///
///Mark:Api Work
/////
extension AddCrashReportCommentVC{
   
    func callAddCrashReportApi(){
        if Connectivity.isConnectedToInternet {
          var param:[String:AnyObject] = [String:AnyObject]()
          param["source"] = "MOB" as AnyObject
          if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
              if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                  param["companyId"] = companyID as AnyObject
                  param["user_id"] = userId as AnyObject
                  if let shiftID = UserDefaults.standard.value(forKey: "SHIFTID"){
                      param["operator_shift_time_details_id"] = shiftID as AnyObject
                  }else{
                      param["operator_shift_time_details_id"] = "1" as AnyObject
                  }
                  param["vehicle_id"] = arrayPopulate[1] as AnyObject
                  param["state_id"] = arrayPopulate[2] as AnyObject
                  param["latitude"] = arrayPopulate[3] as AnyObject
                  param["longitude"] = arrayPopulate[4] as AnyObject
                  param["self_injured"] = arrayPopulate[5] as AnyObject
                  param["other_injured"] = arrayPopulate[6] as AnyObject
                  
                  param["number_of_injured_people"] = arrayPopulate[7] as AnyObject
                  param["contacted_tmc"] = arrayPopulate[8] as AnyObject
                  param["contacted_supervisor"] = arrayPopulate[9] as AnyObject
                  param["you_inside_truck"] = arrayPopulate[10] as AnyObject
                  param["safety_belt"] = arrayPopulate[11] as AnyObject
                  param["police_report"] = arrayPopulate[12] as AnyObject
                  param["written_statement"] = arrayValues[0] as AnyObject
                  
                  
                 ////////Set Driver Info List passenger Info
                  var driverInfo_list : [[String:AnyObject]] = []
                  param["written_statement"] = arrayValues[0] as AnyObject
                  for(_,object) in arrayDriver_info.enumerated(){
                      var param1:[String:AnyObject] = [String:AnyObject]()
                      param1["dirver_name"] =  object.dirver_name as AnyObject
                      param1["driver_phone"] =  object.driver_phone as AnyObject
                      param1["driver_address"] =  object.driver_address as AnyObject
                      param1["driver_licence_number"] =  object.driver_licence_number as AnyObject
                      param1["vehicle_insurance_info"] =  object.vehicle_insurance_info as AnyObject
                      param1["insurance_expriary_date"] =  object.insurance_expriary_date as AnyObject
                      param1["is_injury"] = object.Injuries  as AnyObject
                      ////////Set Passenger Info List
                      
                      var passengerInfo_list : [[String:AnyObject]] = []
                      if let arrPassengerInfo_list = object.passenger_info{
                          for(_,object_passenger) in arrPassengerInfo_list.enumerated(){
                              var param2:[String:AnyObject] = [String:AnyObject]()
                              param2["name"] = object_passenger.name as AnyObject
                              param2["passenger_phone"] = object_passenger.passenger_phone  as AnyObject
                              param2["passenger_address"] = object_passenger.passenger_address  as AnyObject
                              param2["passenger_licence_number"] = object_passenger.passenger_licence_number  as AnyObject
                              param2["is_injury"] = object_passenger.passenger_Injuries  as AnyObject
                              passengerInfo_list.append(param2)
                              
                          }
                          param1["passenger_info"] = passengerInfo_list as AnyObject
                      }
                      driverInfo_list.append(param1)
                      
                  }
                param["driver_info"] = driverInfo_list as AnyObject
                  
                  let formatter = DateFormatter()
                  formatter.dateFormat = "MM-dd-yyyy"
                  
                  let year = formatter.string(from: Date())
                  
                  formatter.dateFormat = "h:mm a"
                  let time = formatter.string(from: Date())
                  param["crash_report_date"] = year as AnyObject
                  param["crash_report_time"] = time as AnyObject
                  
                  
              }
              
          }
          let opt = WebServiceOperation.init((API.crashReportAddEdit.getURL()?.absoluteString ?? ""), param)
          opt.completionBlock = {
              DispatchQueue.main.async {
                  
                  guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                      return
                  }
                  if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                      if errorCode.intValue == 0 {
                          if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0,
                              let details = dictResult["details"] as? [String:Any], details.count > 0,
                              let id = details["crash_report_data_id"] as? Int{
                              
                              if(self.arrayFileInfo.count != 0 ){
                                  self.callCrashReportPhotoApi(crash_report_data_id: "\(id)")
                              }else{
                                  let okClause = PROJECT_CONSTANT.CLOUS{
                                      for controller in self.navigationController!.viewControllers as Array {
                                          if controller.isKind(of: DashboardViewController.self) {
                                              self.navigationController!.popToViewController(controller, animated: true)
                                              break
                                          }
                                      }
                                  }
                                  
                                  PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":okClause], Style: .alert)
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
 
    
    func callCrashReportPhotoApi(crash_report_data_id:String){
        if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["companyId"] = companyID as AnyObject
                param["user_id"] = userId as AnyObject
                param["crash_report_data_id"] = crash_report_data_id as AnyObject
            }
            
        }
        let opt = WebServiceOperation.init((API.crashReportUploadImage.getURL()?.absoluteString ?? ""), param, .WEB_SERVICE_MULTI_PART, arrayFileInfo)
    
        opt.completionBlock = {
            DispatchQueue.main.async {
                
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        
                        let okClause = PROJECT_CONSTANT.CLOUS{
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: DashboardViewController.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }
                        
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":okClause], Style: .alert)
                        
                        
                    }else{
                        
                        let okClause = PROJECT_CONSTANT.CLOUS{
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: DashboardViewController.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }
                        
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":okClause], Style: .alert)
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



