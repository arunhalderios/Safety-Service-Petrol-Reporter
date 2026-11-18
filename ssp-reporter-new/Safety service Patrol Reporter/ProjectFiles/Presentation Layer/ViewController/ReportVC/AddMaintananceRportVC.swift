//
//  AddMaintananceRportVC.swift
//  Safety service Patrol Reporter
//
//  Created by Abhik on 01/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class AddMaintananceRportVC: BaseViewController,UITextViewDelegate {
    let arrayTitle = ["State*","Contract*","Vehicle*","Date*","Service Type*","Description of Repair*","Vendor*","Mileage*","Service Cost*","Labour Hours*","Notes","Receipt","Submit"]
    
    
    @IBOutlet weak var tableIncident: UITableView!
    let arraySamplertext = ["Lorem ipsum","Lorem ipsum","Lorem ipsum","Lorem ipsum"]
    var imagePicker = UIImagePickerController()
    var receiptImage:UIImage?
    var stateList:[ShitStateList] = []
    var vehicleTypeList :[VehicleType] = []
    var servicelist :[ServiceType] = []
    var vendorList : [Vendor] = []
    var arrayValues :[String] = []
    var arrayPopulate: [String] = []
    var isSelected = false
    var arrayFileInfo : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    
    fileprivate enum CELL_CONTENT:Int{
        case state = 0
        case contract
        case vehicle
        case dateAdd
        case service
        case descriptionOFrepair
        case vendor
        case mileage
        case serviceCost
        case Labour_Hour
        case Note
        case CELL_RESET_CONTENT_TOTAL
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .background).async {
            for _ in 0...CELL_CONTENT.CELL_RESET_CONTENT_TOTAL.rawValue - 1{
                self.arrayValues.append("")
                self.arrayPopulate.append("")
            }
            DispatchQueue.main.async {
                if let vID = UserDefaults.standard.value(forKey: "VEHICLENAME") as? String {
                    self.arrayValues[2] = vID
                     self.arrayPopulate[2] = vID
                }else{
                     if let shiftID = UserDefaults.standard.value(forKey: "VEHICLENAME") as? Int{
                        self.arrayValues[2] = String(shiftID)
                         self.arrayPopulate[2] = String(shiftID)
                    }
                }
               // self.tableFuel.reloadData()
            }
            //self.callStateListApi()
            self.callVendorListApi()
            self.callServiceListApi()
            self.callVehicleListApi()
            DispatchQueue.main.async {
                if let state = UserDefaults.standard.value(forKey: "STATENAME") as? String{
                    
                    
                    self.arrayPopulate[CELL_CONTENT.state.rawValue] = state
                }
                if let stateID = UserDefaults.standard.value(forKey: "STATEID") as? String{
                    
                    self.arrayValues[CELL_CONTENT.state.rawValue] = stateID
                }
                self.tableIncident.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let cell = tableIncident.cellForRow(at: IndexPath(row: arrayTitle.count - 1, section: 0)) as? IncidentButtomCell
        if cell != nil {
            cell?.btnNext.roundedView()
        }
    }
    
    
    @IBAction func btnSelectLicence(_ sender: Any) {
        PopupCustomView.sharedInstance.display(onView: UIApplication.shared.keyWindow) {
            
        }
    }
    
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @IBAction func btnNext(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        if self.validate() == true{
        self.callAddmaintenanceAPI()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        //        if textView.tag == 5{
        //            arrayPopulate[textView.tag] = textView
        //        }else if textView.tag = 10{
        //
        //        }
        arrayPopulate[textView.tag] = textView.text
        arrayValues[textView.tag] = textView.text
        print (arrayValues)
    }
    @objc func textFieldValueChanged(_ textField:UITextField) {
        arrayValues[textField.tag] = textField.text!
        arrayPopulate[textField.tag] = textField.text!
        print (arrayValues)
    }
    func validate() -> Bool{
        guard arrayPopulate[0] != "" else{
            self.displayAlert(Header: App_Title, MessageBody: "Please fill up the required field", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[1] != "" else{
            self.displayAlert(Header: App_Title, MessageBody: "Please fill up the required field", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[2] != "" else{
            self.displayAlert(Header: App_Title, MessageBody: "Please fill up the required field", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[3] != "" else{
            self.displayAlert(Header: App_Title, MessageBody: "Please fill up the required field", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[4] != "" else{
            self.displayAlert(Header: App_Title, MessageBody: "Please fill up the required field", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[5] != "" else{
            self.displayAlert(Header: App_Title, MessageBody: "Please fill up the required field", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[6] != "" else{
            self.displayAlert(Header: App_Title, MessageBody: "Please fill up the required field", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[7] != "" else{
            self.displayAlert(Header: App_Title, MessageBody: "Please fill up the required field", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[8] != "" else{
            self.displayAlert(Header: App_Title, MessageBody: "Please fill up the required field", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard arrayPopulate[9] != "" else{
            self.displayAlert(Header: App_Title, MessageBody: "Please fill up the required field", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        return true
        
    }
    
}
extension AddMaintananceRportVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if arrayTitle.count == indexPath.row + 1{
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "IncidentButtomCell", for: indexPath) as! IncidentButtomCell
            self.view.setNeedsLayout()
            return cell1
        }else if (indexPath.row == 5 ||
            indexPath.row == 10){
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentCommentCell", for: indexPath) as! IncidentCommentCell
            cell.lblTitle.text = arrayTitle[indexPath.row]
            cell.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
            cell.txtViewComment.layer.borderColor = AppthemeColor.cgColor
            cell.txtViewComment.layer.borderWidth = 1.0
            cell.txtViewComment.tag = indexPath.row
            cell.txtViewComment.layer.cornerRadius = 5.0
            if arrayPopulate.count > 0{
                cell.txtViewComment.text = arrayPopulate[indexPath.row]
            }
            return cell
        }
        else  if (indexPath.row == 11){
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell2", for: indexPath) as! IncidentInputCell
            cell.lblTitle.text = arrayTitle[indexPath.row]
            cell.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
            // cell.txtFieldInput.tag = indexPath.row
            if let image = self.receiptImage{
                //cell.btnSelection.setImage(image, for: .normal)
                cell.lblCounter.isHidden = true
                cell.imgViewBox.image = image
                cell.imageDefaultCamera.isHidden = true
                
            }
            cell.btnSelection.addTarget(self, action: #selector(btnUploadPicPressed(_:)), for: .touchUpInside)
            return cell
        }
        else if (indexPath.row == 0 || indexPath.row == 1 ||  indexPath.row == 2 || indexPath.row == 6 || indexPath.row == 7 ||
            indexPath.row == 8 ||
            indexPath.row == 9 ){
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell1", for: indexPath) as! IncidentInputCell
            cell2.lblTitle.text = arrayTitle[indexPath.row]
            cell2.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
            cell2.txtFieldInput.tag = indexPath.row
            cell2.txtFieldInput.isUserInteractionEnabled = true
            if arrayPopulate.count > 0{
                cell2.txtFieldInput.text = arrayPopulate[indexPath.row]
            }
            if indexPath.row == 0 || indexPath.row == 2{
                cell2.txtFieldInput.isUserInteractionEnabled = false
            }
            cell2.txtFieldInput?.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
            cell2.viewRound.layer.borderWidth = 2.0
            cell2.viewRound.layer.borderColor = AppthemeColor.cgColor
            cell2.viewRound.layer.cornerRadius = 8//cell2.viewRound.frame.size.height / 2
            if indexPath.row == 5 || indexPath.row == 1{
            cell2.txtFieldInput.keyboardType = .default
            }else{
            cell2.txtFieldInput.keyboardType = .decimalPad
            }
            return cell2
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell", for: indexPath) as! IncidentInputCell
            if arrayPopulate.count > 0{
                cell.txtFieldInput.text = arrayPopulate[indexPath.row]
            }
            cell.btnSelection.tag = indexPath.row
            cell.btnSelection.isHidden = true
            cell.txtFieldInput.keyboardType = .default
            cell.txtFieldInput.tag = indexPath.row
            cell.lblTitle.text = arrayTitle[indexPath.row]
            cell.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
            cell.viewRound.roundedView()
            cell.viewRound.layer.borderWidth = 2.0
            cell.viewRound.layer.borderColor = AppthemeColor.cgColor
            cell.txtFieldInput?.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
            
            cell.imgViewDropDown.isHidden = true
            //cell.txtFieldInput.text = ""
            cell.txtFieldInput.inputAccessoryView = nil
            cell.txtFieldInput.inputView = nil
            cell.txtFieldInput.tintColor = .black
            
            if(indexPath.row == 3 ){
                
                cell.imgViewDropDown.isHidden = false
                cell.imgViewDropDown.image = UIImage(named: "calendar")
                if arrayPopulate.count > 0{
                    if arrayPopulate[indexPath.row] == ""{
                        cell.txtFieldInput.text = "mm-dd-yyyy"
                    }
                }
                self.createDatePickerView(textField: cell.txtFieldInput)
                cell.txtFieldInput.tintColor = .white
                cell.txtFieldInput.tag = indexPath.row
            }else{
                cell.txtFieldInput.tag = indexPath.row
                cell.imgViewDropDown.isHidden = false
                if arrayPopulate.count > 0{
                    if arrayPopulate[indexPath.row] == ""{
                        cell.txtFieldInput.text = "Select"
                    }
                }
                self.createPickerView(textField: cell.txtFieldInput)
                cell.txtFieldInput.tintColor = .white
            }
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayTitle.count == indexPath.row + 1{
            return 95
        }else if (indexPath.row == 5 ||
            indexPath.row == 10 ){
            return 161
        }else if (indexPath.row == 11){
            return 200
        }
        return UITableView.automaticDimension
        
    }
}
extension AddMaintananceRportVC:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return stateList.count
        }
        
        else if pickerView.tag == 4 {
            return servicelist.count
        }
        else if pickerView.tag == 6{
            return vendorList.count
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return stateList[row].state_name
        }
        else if pickerView.tag == 4 {
            return servicelist[row].service_type
        }
        else if pickerView.tag == 6{
            return vendorList[row].vendor_name
        }
        else{
            return ""
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        isSelected = true
        if pickerView.tag == 0{
            guard stateList.count > 0 else {
                return
            }
            arrayValues[pickerView.tag] =  stateList[row].state_id ?? ""
            arrayPopulate[pickerView.tag] =  stateList[row].state_name ?? ""
        }
        
        else if pickerView.tag == 4{
            guard servicelist.count > 0 else {
                return
            }
            arrayValues[pickerView.tag] = servicelist[row].service_type_id ?? ""
            arrayPopulate[pickerView.tag] = servicelist[row].service_type ?? ""
        }
        else if pickerView.tag == 6{
            guard vendorList.count > 0 else {
                return
            }
            arrayValues[pickerView.tag] = vendorList[row].vendor_id ?? ""
            arrayPopulate[pickerView.tag] = vendorList[row].vendor_name ?? ""
        }
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
        view.endEditing(true)
        isSelected = false
    }
    @objc func action(sender: UIBarButtonItem) {
        view.endEditing(true)
        if isSelected == false{
            if sender.tag == 0{
                guard stateList.count > 0 else {
                    return
                }
                arrayValues[sender.tag] =  stateList[0].state_id ?? ""
                arrayPopulate[sender.tag] =  stateList[0].state_name ?? ""
            }
            
            else if sender.tag == 4{
                guard servicelist.count > 0 else {
                    return
                }
                arrayValues[sender.tag] = servicelist[0].service_type_id ?? ""
                arrayPopulate[sender.tag] = servicelist[0].service_type ?? ""
            }
            else if sender.tag == 6{
                guard vendorList.count > 0 else {
                    return
                }
                arrayValues[sender.tag] = vendorList[0].vendor_id ?? ""
                arrayPopulate[sender.tag] = vendorList[0].vendor_name ?? ""
            }
        }
        self.tableIncident.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
        isSelected = false
    }
    
    
    
    func createDatePickerView(textField:UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.tag = textField.tag
        textField.inputView = datePicker
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.datePickerAction(sender:)))
        button.tag = textField.tag
        datePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: UIControl.Event.valueChanged)
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelDateAction))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancel,spacer,button], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat =  "MM-dd-yyyy"
        arrayValues[sender.tag] = timeFormatter.string(from: sender.date)
        arrayPopulate[sender.tag] = timeFormatter.string(from: sender.date)
        isSelected = true
    }
    
    
    @objc func datePickerAction(sender: UIBarButtonItem) {
        view.endEditing(true)
        if isSelected == false{
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat =  "MM-dd-yyyy"
            arrayValues[sender.tag] = timeFormatter.string(from: Date())
            arrayPopulate[sender.tag] = timeFormatter.string(from: Date())
        }
        self.tableIncident.reloadData()
        isSelected = false
    }
    @objc func cancelDateAction(sender: UIBarButtonItem) {
        view.endEditing(true)
        isSelected = false
    }
}

//MARK:UPLOAD IMAGE

extension AddMaintananceRportVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @objc func btnUploadPicPressed(_ sender: UIButton!){
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
            
            
            self.receiptImage = pickedimage
            //let resizeImage = self.resizeImage(image: pickedimage, newWidth: 100)!
            let imageData = pickedimage.jpegData(compressionQuality: 0.7)
            arrayFileInfo.removeAll()
            if ((imageData) != nil){
                let imageFileInfo = MultiPartDataFormatStructure.init(key: "reciept", mimeType: .image_jpeg, data: imageData, name: "reciept11.jpg")
                arrayFileInfo.append(imageFileInfo)
            }
            tableIncident.reloadData()
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
extension AddMaintananceRportVC{
    func callStateListApi(){
         if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["companyId"] = companyID as AnyObject
                param["user_id"] = userId as AnyObject
            }
            
        }
        let opt = WebServiceOperation.init((API.StateList.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["stateList"] as? [[String:Any]] {
                                do {
                                    self.stateList = try JSONDecoder().decode([ShitStateList].self,from:(listArray.data)!)
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
    func callVehicleListApi(){
         if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["user_id"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.vehicletypeList.getURL()?.absoluteString ?? ""), param)
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
                                    self.vehicleTypeList = try JSONDecoder().decode([VehicleType].self,from:(listArray.data)!)
                                    print("Success Incidence Type")
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
    func callServiceListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["user_id"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.servicTypeListAll.getURL()?.absoluteString ?? ""), param)
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
                                    self.servicelist = try JSONDecoder().decode([ServiceType].self,from:(listArray.data)!)
                                    print("Success Incidence Type")
                                }
                                catch {
                                    print(error)
                                    
                                }
                            }
                        }
                    }else{
                        
                       // PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                    }
                }
            }
        }
        appDel.operationQueue.addOperation(opt)
        
    }
    func callVendorListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["user_id"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.vendorListAll.getURL()?.absoluteString ?? ""), param)
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
                                    self.vendorList = try JSONDecoder().decode([Vendor].self,from:(listArray.data)!)
                                    print("Success Incidence Type")
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
        
    }
    func callAddmaintenanceAPI(){
        if Connectivity.isConnectedToInternet {
            var param:[String:AnyObject] = [String:AnyObject]()
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "yyyy-MM-dd,hh:mm"
            let dateString = formatter1.string(from: Date())
            let arrayDate = dateString.components(separatedBy: ",")
            
            if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
                if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                    param["source"] = "MOB" as AnyObject
                    param["user_id"] = userId as AnyObject
                    param["companyId"] = companyID as AnyObject
                    
                    if let vID:String = UserDefaults.standard.value(forKey: "VEHICLEID") as? String {
                        param["vehicle_id"] = vID as AnyObject
                    }else{
                        return
                    }
                    param["state_id"] = self.arrayValues[CELL_CONTENT.state.rawValue] as AnyObject
                    param["contract_period"] = self.arrayValues[CELL_CONTENT.contract.rawValue] as AnyObject
                    param["report_date"] = self.arrayValues[CELL_CONTENT.dateAdd.rawValue] as AnyObject
                    param["service_type_id"] = self.arrayValues[CELL_CONTENT.service.rawValue] as AnyObject
                    param["mileage"] = self.arrayValues[CELL_CONTENT.mileage.rawValue] as AnyObject as AnyObject
                    param["service_cost"] = self.arrayValues[CELL_CONTENT.serviceCost.rawValue] as AnyObject
                    param["vendor_id"] = self.arrayValues[CELL_CONTENT.vendor.rawValue] as AnyObject
                    param["vendor_name"] = self.arrayValues[CELL_CONTENT.vendor.rawValue] as AnyObject
                    param["repair_description"] = self.arrayValues[CELL_CONTENT.descriptionOFrepair.rawValue] as AnyObject
                    param["note"] = self.arrayValues[CELL_CONTENT.Note.rawValue] as AnyObject
                    param["used_labour_hour"] = self.arrayValues[CELL_CONTENT.Labour_Hour.rawValue] as AnyObject
                    param["used_labour_min"] = "10" as AnyObject
                    
                }
                
            }
            
            // }
            print(param)
            let opt = WebServiceOperation.init(API.maintenanceAddEdit.getURL()?.absoluteString ?? "", param, .WEB_SERVICE_MULTI_PART, arrayFileInfo)
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
    
}
