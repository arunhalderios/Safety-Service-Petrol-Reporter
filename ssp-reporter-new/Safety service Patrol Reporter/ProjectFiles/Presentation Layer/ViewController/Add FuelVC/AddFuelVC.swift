//
//  AddFuelVC.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Mahalik on 30/03/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit
import CoreLocation
class AddFuelVC: BaseViewController,CLLocationManagerDelegate,UITextViewDelegate,UITextFieldDelegate {
    @IBOutlet weak var tableFuel: UITableView!
    //let arrayTitle = ["Vehicle ID*","Fuel type*","Odometer Reading*","Price/Gallon*","Total Cost*","Fuel Quantity*", "Fuel for Truck/Can?*"]
    let arrayTitle = ["Vehicle ID*","Fuel type*","Odometer Reading*","Price/Gallon*","Fuel Quantity*","Total Cost*", "Fuel for Truck/Can?*"]
    var selectedIndex:Int = -1
    var arrayFuelType :[String] = []
    let arrayVehicleType = ["Truck","Can"]
    var arrayVehicleID:[String] = []
    var arrayValues :[String] = []
    var imagePicker = UIImagePickerController()
    var fuelImage:UIImage?
    var imageData:Data?
    var vehileList: [ShiftVehileList]?
    var arrayFileInfo : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLoc: CLLocation?
    var isselected:Bool = false
     var model = ShiftModel()
    var isSkip :Bool = false
    var arrayReceiptFor = ["Receipt","Pump"]
    var receiptfor:String = ""
    fileprivate enum CELL_CONTENT:Int{
        case videoID = 0
        case FuelType
        case Odometer_Reading
        case Cost_Gallon
        case Total_Cost
        case Fuel_Quantity
        case Fuel_Taken_Tank
        case CELL_RESET_CONTENT_TOTAL
        func getPlaceholder () -> String {
            switch self {
            case .videoID:
                return "Select"
            case .FuelType:
                return "Select"
            case .Odometer_Reading:
                return "Enter value"
            case .Cost_Gallon:
                return "Enter value in $"
            case .Fuel_Quantity:
                return "Enter value"
            case .Total_Cost:
                return "Enter value in $"
            case .Fuel_Taken_Tank:
                return "Enter value"
            default:
                return ""
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
            locationManager.startUpdatingLocation()
        }else{
            locationManager.startUpdatingLocation()
        }
        
        DispatchQueue.global(qos: .background).async {
            for _ in 0...self.arrayTitle.count{
                self.arrayValues.append("")
                
            }
            self.callFuelTypeApi()
           
            DispatchQueue.main.async {
                if let vID = UserDefaults.standard.value(forKey: "VEHICLENAME") as? String {
                    self.arrayValues[0] = vID
                }else{
                     if let shiftID = UserDefaults.standard.value(forKey: "VEHICLENAME") as? Int{
                        self.arrayValues[0] = String(shiftID)
                    }
                }
                self.tableFuel.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }
    
    func retriveVehicleIDs(){
        if let vehicles = self.vehileList{
            for vehicle in vehicles {
                if let id = vehicle.vehicle_id{
                    arrayVehicleID.append(id)
                }
            }
        }
        
        
    }
    func callFuelTypeApi(){
         if Connectivity.isConnectedToInternet {
           var param:[String:AnyObject] = [String:AnyObject]()
           param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
                       if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
           param["companyId"] = companyID as AnyObject
           param["user_id"] = userId as AnyObject
            }}
           print(param)
          
           let opt = WebServiceOperation.init((API.fuelTypeListAll.getURL()?.absoluteString ?? ""), param)
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
                                    print(listArray)
//                                       self.vehileList = try JSONDecoder().decode([ShiftVehileList].self,from:(listArray.data)!)
//                                       self.retriveVehicleIDs()
                                    for fuelObj in listArray{
                                        let fuel = fuelObj["fuel_type"] as? String
                                        self.arrayFuelType.append(fuel ?? "")
                                        
                                    }
                                    
                                    
                                    
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
       
    func callAddFuelAPI(){
        if Connectivity.isConnectedToInternet {
            var param:[String:AnyObject] = [String:AnyObject]()
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "MM-dd-yyyy,h:mm a"
            let dateString = formatter1.string(from: Date())
            let arrayDate = dateString.components(separatedBy: ",")
            arrayFileInfo.removeAll()
            if isSkip == false{
            if ((imageData) != nil){
                if receiptfor == "Pump"{
                    let imageFileInfo = MultiPartDataFormatStructure.init(key: "pumping", mimeType: .image_jpeg, data: imageData, name: "Pump.jpg")
                    arrayFileInfo.append(imageFileInfo)
                }else{
                let imageFileInfo = MultiPartDataFormatStructure.init(key: "reciept", mimeType: .image_jpeg, data: imageData, name: "Reciept.jpg")
                arrayFileInfo.append(imageFileInfo)
                }
            }
            }
            if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
                if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                    if let vID:String = UserDefaults.standard.value(forKey: "VEHICLEID") as? String {
                               param["vehicle_id"] = vID as AnyObject
                           }
                    param["source"] = "MOB" as AnyObject
                    param["user_id"] = userId as AnyObject
                    param["companyId"] = companyID as AnyObject
                    if let shiftID = UserDefaults.standard.value(forKey: "SHIFTID"){
                        param["shift_id"] = shiftID as AnyObject
                    }else{
                        param["shift_id"] = "1" as AnyObject
                    }
                    param["cost_per_galon"] = self.arrayValues[CELL_CONTENT.Cost_Gallon.rawValue] as AnyObject
                    param["total_cost"] = self.arrayValues[CELL_CONTENT.Total_Cost.rawValue] as AnyObject
                    param["fuel_quantity"] = self.arrayValues[CELL_CONTENT.Fuel_Quantity.rawValue] as AnyObject
                    param["refueling_date"] = arrayDate[0] as AnyObject
                    param["refueling_time"] = arrayDate[1] as AnyObject
                    param["fuel_type"] = self.arrayValues[CELL_CONTENT.FuelType.rawValue] as AnyObject
                    param["odo_meter_reading"] = self.arrayValues[CELL_CONTENT.Odometer_Reading.rawValue] as AnyObject
                   
                    if self.arrayValues[CELL_CONTENT.Fuel_Taken_Tank.rawValue] == "Truck"{
                         param["fuel_taken_tank"] = self.arrayValues[CELL_CONTENT.Fuel_Quantity.rawValue] as AnyObject
                        param["fuel_taken_can"] = "" as AnyObject
                    }else{
                        param["fuel_taken_can"] = self.arrayValues[CELL_CONTENT.Fuel_Quantity.rawValue] as AnyObject
                        param["fuel_taken_tank"] = "" as AnyObject
                    }
                    
                    if self.currentLoc != nil{
                    param["latitude"] = self.currentLoc?.coordinate.latitude as AnyObject
                    param["longitude"] = self.currentLoc?.coordinate.longitude as AnyObject
                    }else{
                        param["latitude"] = "" as AnyObject
                        param["longitude"] = "" as AnyObject
                    }
                    param["note"] = arrayValues[arrayTitle.count] as AnyObject //arrayValues.last as AnyObject
                    param["status"] = "1" as AnyObject
                    if receiptfor == "Pump"{
                    param["report_for"] = "pumping" as AnyObject
                    }else{
                        param["report_for"] = "receipt" as AnyObject
                    }
                    
                }
                
            }
            
            // }
            print(param)
            let opt = WebServiceOperation.init(API.fuelReportAdd.getURL()?.absoluteString ?? "", param, .WEB_SERVICE_MULTI_PART, arrayFileInfo)
            opt.completionBlock = {
                DispatchQueue.main.async {
                    
                    guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                        return
                    }
                    if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                        if errorCode.intValue == 0 {
                            if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0,let dictDetails = dictResult["details"] as? [String:Any] {
                                do{
                                    let okclause = PROJECT_CONSTANT.CLOUS{
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    
                                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":okclause], Style: .alert)
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
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let cell = tableFuel.cellForRow(at: IndexPath(row: 0, section: 3)) as? IncidentButtomCell
        if cell != nil {
            cell?.btnNext.roundedView()
        }
    }
    @IBAction func btnSkipReceiptAction(_ sender: UIButton) {
        if isSkip == false{
                   isSkip = true
               }else{
                   isSkip = false
               }
               self.tableFuel.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
    }
    
    @IBAction func btnAddFuel(_ sender: Any) {
        guard receiptfor != "" else {
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill the mandatory fields", AllActions: ["OK":nil], Style: .alert)
            return
        }
        guard arrayValues[arrayTitle.count] != "" else {
                   PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill the mandatory fields", AllActions: ["OK":nil], Style: .alert)
                   return
               }
        guard imageData != nil else {
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please Upload image", AllActions: ["OK":nil], Style: .alert)
            return
        }
        
        if arrayValues[CELL_CONTENT.Cost_Gallon.rawValue] == "0.0" || arrayValues[CELL_CONTENT.Cost_Gallon.rawValue] == "0" || arrayValues[CELL_CONTENT.Cost_Gallon.rawValue] == "0.00" {
        
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please add greater than 0.0 gallon", AllActions: ["Ok":nil], Style: .alert)
            return
        }
        
        
        self.callAddFuelAPI()
        
        //self.navigationController?.popViewController(animated: true)
    }
    @objc func textFieldValueChanged(_ textField:UITextField) {
        arrayValues[textField.tag] = textField.text!
       
        print (arrayValues)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLoc = location
            locationManager.stopUpdatingLocation()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 3 || textField.tag == 5{
            textField.text = "$" + textField.text!
            
    
            
            
            guard arrayValues[CELL_CONTENT.Cost_Gallon.rawValue] != ""  else {
                       return
                   }
                   
                   guard arrayValues[CELL_CONTENT.Total_Cost.rawValue] != "" else {
                       return
                   }
//                   if Float(arrayValues[CELL_CONTENT.Total_Cost.rawValue].toDouble() ?? 0) > Float(arrayValues[CELL_CONTENT.Cost_Gallon.rawValue].toDouble() ?? 0){
                       let total = Double((Float(arrayValues[CELL_CONTENT.Total_Cost.rawValue].toDouble() ?? 0 ))) / Double((Float(arrayValues[CELL_CONTENT.Cost_Gallon.rawValue].toDouble() ?? 0 )))
            arrayValues[CELL_CONTENT.Fuel_Quantity.rawValue] = String(total.rounded(toPlaces: 3))
                    self.tableFuel.reloadRows(at: [IndexPath(row: CELL_CONTENT.Fuel_Quantity.rawValue, section: 0)], with: .none)
                       
 //                  }
                   
//                   else{
//                       arrayValues[CELL_CONTENT.Fuel_Quantity.rawValue] = ""
//                        self.tableFuel.reloadRows(at: [IndexPath(row: textField.tag, section: 0)], with: .none)
//                       PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Input Error", AllActions: ["OK":nil], Style: .alert)
//                   }
            
                
        }else if textField.tag == 5{
            let total = Double((Float(arrayValues[CELL_CONTENT.Fuel_Quantity.rawValue].toDouble() ?? 0 ))) * Double((Float(arrayValues[CELL_CONTENT.Cost_Gallon.rawValue].toDouble() ?? 0 )))
                        arrayValues[CELL_CONTENT.Total_Cost.rawValue] = String(total.rounded(toPlaces: 3))
                                self.tableFuel.reloadRows(at: [IndexPath(row: CELL_CONTENT.Total_Cost.rawValue, section: 0)], with: .none)
                                   
             //                  }
        }
        
       
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
         if textField.tag == 3 || textField.tag == 4{
            if textField.text?.count ?? 0 > 0{
                let modified = String(textField.text?.dropFirst() ?? "")
                textField.text = modified
            }
               
        }
    }

}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension AddFuelVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return arrayTitle.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 4{
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "IncidentButtomCell", for: indexPath) as! IncidentButtomCell
            self.view.setNeedsLayout()
            return cell1
        }else if indexPath.section == 1{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "IncidentCommentCell", for: indexPath) as! IncidentCommentCell
            cell2.txtViewComment.delegate = self
            cell2.txtViewComment.tag = indexPath.row
            if arrayValues.last == ""{
                cell2.txtViewComment.text = "Write Here..."
            }else{
                cell2.txtViewComment.text = arrayValues.last
            }
            return cell2
        }
            else if indexPath.section == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell", for: indexPath) as! IncidentInputCell
                cell.btnSelection.tag = 100
                cell.btnSelection.isHidden = true
                cell.txtFieldInput.delegate = self
            cell.txtFieldInput.text = receiptfor
            if cell.txtFieldInput.text == ""{
                cell.txtFieldInput.text = "Select"
            }
            cell.txtFieldInput.isUserInteractionEnabled = false
            self.createPickerView(textField: cell.txtFieldInput)
            cell.txtFieldInput.tintColor = .white
            cell.txtFieldInput.tag = 100
            cell.lblTitle.text = "Upload Picture for*"
            cell.imgViewDropDown.isHidden = false
            cell.viewRound.roundedView()
            cell.viewRound.layer.borderWidth = 2.0
            cell.viewRound.layer.borderColor = AppthemeColor.cgColor
            cell.txtFieldInput.isUserInteractionEnabled = true
            cell.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
                return cell
            }
        else if indexPath.section == 3{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell1", for: indexPath) as! IncidentInputCell
            if self.fuelImage != nil{
                cell2.imgViewDropDown.isHidden = true
                cell2.lblCounter.isHidden = true
                cell2.imageViewCell.image = self.fuelImage
            }
            cell2.viewRound.addborder()
            if isSkip == true{
                cell2.imgViewBox.image = UIImage(named: "checked")
            }else{
                cell2.imgViewBox.image = UIImage(named: "YellowBox")
            }
            return cell2
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell", for: indexPath) as! IncidentInputCell
            cell.btnSelection.tag = indexPath.row
            cell.btnSelection.isHidden = true
            cell.txtFieldInput.delegate = self
            cell.txtFieldInput.placeholder = CELL_CONTENT.init(rawValue: indexPath.row)?.getPlaceholder() ?? ""
            cell.txtFieldInput.tag = indexPath.row
            cell.lblTitle.text = arrayTitle[indexPath.row]
            cell.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
            cell.viewRound.roundedView()
            cell.viewRound.layer.borderWidth = 2.0
            cell.viewRound.layer.borderColor = AppthemeColor.cgColor
            cell.txtFieldInput?.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
            cell.txtFieldInput.keyboardType = .decimalPad
            cell.imgViewDropDown.isHidden = true
            cell.txtFieldInput.text = ""
            cell.txtFieldInput.inputAccessoryView = nil
            cell.txtFieldInput.inputView = nil
            cell.txtFieldInput.tintColor = .black
            cell.txtFieldInput.isUserInteractionEnabled = true
            
            if arrayValues.count > 0{
                cell.txtFieldInput.text = arrayValues[indexPath.row]
            }else{
                cell.txtFieldInput.text = ""
            }
            if indexPath.row == 3 || indexPath.row == 5{
                 if arrayValues.count > 0{
                if  arrayValues[indexPath.row] == ""{
                    
                }else{
                cell.txtFieldInput.text = "$" + arrayValues[indexPath.row]
                }
                }
            }
            if indexPath.row == 0{
                cell.imgViewDropDown.isHidden = true
                if cell.txtFieldInput.text == ""{
                    cell.txtFieldInput.text = "Select"
                }
                cell.txtFieldInput.isUserInteractionEnabled = false
                self.createPickerView(textField: cell.txtFieldInput)
                cell.txtFieldInput.tintColor = .white
            }else if indexPath.row == 1 || indexPath.row == 6{
                cell.imgViewDropDown.isHidden = false
                if cell.txtFieldInput.text == ""{
                    cell.txtFieldInput.text = "Select"
                }
                self.createPickerView(textField: cell.txtFieldInput)
                cell.txtFieldInput.tintColor = .white
                
            }else{
                cell.txtFieldInput.inputView = nil
                cell.txtFieldInput.inputAccessoryView = nil
            }
            
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4{
            return 95
        }else if indexPath.section == 3 {
            return 200
        }
        else if indexPath.section == 1{
            return 200
        }
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TimeService.instance.resetInactivityTimer()

        if indexPath.section == 3{
            self.btnUploadPicPressed()
        }
    }
}
extension AddFuelVC:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 6{
            return arrayVehicleType.count
        }else if pickerView.tag == 100{
            return arrayReceiptFor.count
        }
        else {
            return arrayFuelType.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 6{
            return arrayVehicleType[row]
        }else if pickerView.tag == 100{
            return arrayReceiptFor[row]
        }else{
            return arrayFuelType[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        isselected = true
        if pickerView.tag == 6{
            guard arrayVehicleType.count > 0 else {
                return
            }
            arrayValues[6] = arrayVehicleType[row]
        }else if pickerView.tag == 100{
            guard arrayReceiptFor.count > 0 else {
                return
            }
            receiptfor = arrayReceiptFor[row]
        }
        else{
            guard arrayFuelType.count > 0 else {
                return
            }
            arrayValues[1] = arrayFuelType[row]
        }
        //self.tableFuel.reloadData()
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
    
    
    @objc func cancelAction() {
        isselected = false
        view.endEditing(true)
    }
    @objc func action(sender: UIBarButtonItem) {
        if sender.tag == 6{
            if isselected == false{
                guard arrayVehicleType.count > 0 else {
                    return
                }
            arrayValues[6] = arrayVehicleType[0]
            }
        }else if sender.tag == 100{
             if isselected == false{
            guard arrayReceiptFor.count > 0 else {
                return
            }
            receiptfor = arrayReceiptFor[0]
            }
        }

        else{
            if isselected == false{
                guard arrayFuelType.count > 0 else {
                    return
                }
            arrayValues[1] = arrayFuelType[0]
            }
        }
        self.tableFuel.reloadData()
        view.endEditing(true)
        isselected = false
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        let cell = self.tableFuel.cellForRow(at: IndexPath(row: 0, section: 1)) as? IncidentCommentCell
        if cell != nil{
            
            if cell?.txtViewComment.text == "Write Here..." {
                cell?.txtViewComment.text = ""
                
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        let cell = self.tableFuel.cellForRow(at: IndexPath(row: 0, section: 1)) as? IncidentCommentCell
        if cell != nil{
            
            
            if cell?.txtViewComment.text == "" {
                
                cell?.txtViewComment.text = "Write Here..."
                
            }
        }
    }
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        arrayValues[arrayTitle.count] =  textView.text
    }
}
extension AddFuelVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func btnUploadPicPressed(){
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Choose profile image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController.isSourceTypeAvailable(.camera))
        {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker.dismiss(animated: true)
        if let pickedimage = info[.editedImage] as? UIImage
        {
            
            
            self.fuelImage = pickedimage
            //let resizeImage = self.resizeImage(image: pickedimage, newWidth: 100)!
            imageData = pickedimage.jpegData(compressionQuality: 0.7)
            
            tableFuel.reloadData()
        }
        else
        {
            print("Something went wrong")
        }
        
        
        self.dismiss(animated: true, completion: nil)
        self.view.setNeedsLayout()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: { () -> Void in
            
            
        })
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
