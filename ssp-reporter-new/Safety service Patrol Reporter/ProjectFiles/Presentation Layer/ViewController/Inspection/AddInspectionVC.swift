//
//  AddInspectionVC.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Mahalik on 31/03/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class AddInspectionVC: BaseViewController {
    var paramInspecionDictionary = Dictionary<String, AnyObject>()
    var datePicker = UIDatePicker()
    var isDatePickerSelected: Bool = false
    let arrayTitle = ["Vehicle ID*","Odometer Reading*","Insurance Exp*","Registration Exp*","State Inspection Exp*"]
    var  arrayTextInfo = [String]()
    var selectedIndex = 0
    var isOps:Bool = true
    //["#12345","1232020","03/19/2020","03/19/2020","03/19/2020"]
    var arrayImageInfoInspection : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    var inspectionNew = true
    var imagePicker = UIImagePickerController()
    var inspectionImages :[UIImage] = [UIImage(),UIImage(),UIImage(),UIImage()]
    var sectionTotal = 2
    var selectedImage : Int = 0
    @IBOutlet weak var tableInspection: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if inspectionNew == true{
            sectionTotal = 6
        }else{
            sectionTotal = 2
        }
        self.arrayTextInfo.removeAll()
        if let vID:String = UserDefaults.standard.value(forKey: "VEHICLENAME") as? String {
            self.arrayTextInfo.append(vID)
        }else{
            self.arrayTextInfo.append("")
        }
        self.fillWithBlankData()
        for _ in 0...4{
            let multi = MultiPartDataFormatStructure.init(key: "", mimeType: .image_jpeg, data: nil, name: "")
            arrayImageInfoInspection.append(multi)
        }
    }
    
    func fillWithBlankData(){
        for   _ in 0 ..< arrayTitle.count - 1 {
            self.arrayTextInfo.append("")
        }
        print(self.arrayTextInfo.count)
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let cell = tableInspection.cellForRow(at: IndexPath(row: 0, section: 1)) as? IncidentButtomCell
        if cell != nil {
            cell?.btnNext.roundedView()
        }
    }
    @IBAction func btnNextAction(_ sender: Any) {
        if validation() {
            //            if isOps == false{
            //                 let vc = storyboard?.instantiateViewController(withIdentifier: "InspectionImageVC") as! InspectionImageVC
            //                 vc.paramDictionary = self.fillUpParam()
            //                self.navigationController?.pushViewController(vc, animated: true)
            //
            //            }else{
            if self.validateAllImages() == true{
                let vc = storyboard?.instantiateViewController(withIdentifier: "AddPreOpsVC") as! AddPreOpsVC
                vc.isOPS = false
                vc.paramDictionary = self.fillUpParam()
                //vc.arrayImageInspections = self.arrayImageInfoInspection
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func validateAllImages() -> Bool {
        
        if inspectionImages[0].jpegData(compressionQuality: 1) != nil{
            
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill the required field", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        if inspectionImages[1].jpegData(compressionQuality: 1) != nil{
            
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill the required field", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        if inspectionImages[2].jpegData(compressionQuality: 1) != nil{
            
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill the required field", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        if inspectionImages[3].jpegData(compressionQuality: 1) != nil{
            
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill the required field", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        return true
    }
    @objc func textFieldValueChanged(_ textField:UITextField) {
        print(textField.tag)
        self.arrayTextInfo[textField.tag] = textField.text!
        print (self.arrayTextInfo)
    }
    
    func validation() -> Bool {
        guard self.arrayTextInfo[1] != "" else {
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Odometer Reading can't be Blank", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard self.arrayTextInfo[2] != "" else {
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Insurance Exp can't be Blank", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        guard self.arrayTextInfo[3] != "" else {
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Registration Exp can't be Blank", AllActions: ["OK":nil], Style: .alert)
            return false
        }
        //        guard self.arrayTextInfo[4] != "" else {
        //                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "State Inspection Exp can't be Blank", AllActions: ["OK":nil], Style: .alert)
        //                   return false
        //               }
        return true
    }
    
    
    
    func fillUpParam() -> Dictionary<String, AnyObject> {
        if let vID:String = UserDefaults.standard.value(forKey: "VEHICLEID") as? String {
            self.paramInspecionDictionary["vehicleId"] = vID as AnyObject
        }
        self.paramInspecionDictionary["odoMeterData"] = self.arrayTextInfo[1] as AnyObject
        self.paramInspecionDictionary["insuranceExp"] = self.arrayTextInfo[2] as AnyObject
        self.paramInspecionDictionary["regExp"] = self.arrayTextInfo[3] as AnyObject
        self.paramInspecionDictionary["stateInspectionExp"] = self.arrayTextInfo[4] as AnyObject
        self.paramInspecionDictionary["source"] = "MOB" as AnyObject
        self.paramInspecionDictionary["date"] = Date().dateStringInDateFormat("MM-dd-yyyy") as AnyObject
        self.paramInspecionDictionary["time"] = Date().dateStringInDateFormat("h:mm:ss a") as AnyObject
        if let shiftID = UserDefaults.standard.value(forKey: "SHIFTID"){
            self.paramInspecionDictionary["operatorShiftTimeDetailsId"] = shiftID as AnyObject
        }else{
            self.paramInspecionDictionary["operatorShiftTimeDetailsId"] = "1" as AnyObject
        }
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
            self.paramInspecionDictionary["inspectedBy"] = userId as AnyObject
        }
        self.paramInspecionDictionary["plate_number"] = "" as AnyObject
        return self.paramInspecionDictionary
    }
}

extension AddInspectionVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if inspectionNew == true{
            return sectionTotal
        }else{
            return sectionTotal
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return arrayTitle.count
        }else{
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == sectionTotal - 1{ // button cell
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "IncidentButtomCell", for: indexPath) as! IncidentButtomCell
            self.view.setNeedsLayout()
            return cell1
        }
        else if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell", for: indexPath) as! IncidentInputCell
            cell.txtFieldInput.text = arrayTextInfo[indexPath.row]
            if indexPath.row == 0{
                cell.lblTitle.text = arrayTitle[indexPath.row]
                cell.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
                cell.txtFieldInput.isUserInteractionEnabled = false
                cell.txtFieldInput.textColor = .lightGray
                cell.viewRound.roundedView()
                cell.viewRound.layer.borderWidth = 2.0
                cell.viewRound.layer.borderColor = AppthemeColor.cgColor
                cell.imgViewDropDown.isHidden =   true
            }else{
                cell.btnSelection.tag = indexPath.row
                cell.btnSelection.isHidden = true
                cell.txtFieldInput.tag = indexPath.row
                cell.lblTitle.text = arrayTitle[indexPath.row]
                cell.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
                cell.viewRound.roundedView()
                cell.viewRound.layer.borderWidth = 2.0
                cell.viewRound.layer.borderColor = AppthemeColor.cgColor
                cell.imgViewDropDown.isHidden =   true
                cell.txtFieldInput.inputAccessoryView = nil
                cell.txtFieldInput.inputView = nil
                cell.txtFieldInput.tintColor = .black
                if indexPath.row != 1{
                    self.createPickerView(textField: cell.txtFieldInput)
                    cell.imgViewDropDown.isHidden = false
                }else{
                    cell.txtFieldInput.keyboardType = .decimalPad
                    cell.txtFieldInput?.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
                    
                }
                cell.txtFieldInput.tintColor = .white
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell2", for: indexPath) as! IncidentInputCell
            let imageInspection = inspectionImages[indexPath.section - 1]
            
            if indexPath.section == 1{
                cell.lblTitle.text = "Insurance*"
            }
            else if indexPath.section == 2{
                cell.lblTitle.text = "Registration*"
            }else if indexPath.section == 3{
                //cell.lblTitle.text = "Registration"
                cell.lblTitle.text = "State Inspection*"
            }else{
                cell.lblTitle.text = "License*"
            }
            if let image = imageInspection.jpegData(compressionQuality: 1){
                cell.btnSelection.setImage(imageInspection, for: .normal)
                cell.imageViewCell.image = imageInspection
                cell.imageDefaultCamera.isHidden = true
                cell.lblCounter.isHidden = true
            }else{
                cell.imageViewCell.image = nil
                cell.imageDefaultCamera.isHidden = false
                cell.lblCounter.isHidden = false
                
            }
            cell.btnSelection.tag =  indexPath.section
            cell.btnSelection.addTarget(self, action: #selector(btnUploadPicPressed(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == sectionTotal - 1{
            return 95
        }else if indexPath.section == 0{
            return UITableView.automaticDimension
        }else{
            return 200
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
extension AddInspectionVC {
    
    func createPickerView(textField:UITextField) {
        
        self.datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        self.datePicker.tag = textField.tag
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.action(sender:)))
        done.tag = textField.tag
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spacer,done], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc func action(sender:UIBarButtonItem) {
        print(sender.tag)
        if self.isDatePickerSelected == false{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            self.arrayTextInfo[sender.tag] = dateFormatter.string(from: Date())
        }
        self.tableInspection.reloadData()
        view.endEditing(true)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        self.isDatePickerSelected = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        self.arrayTextInfo[sender.tag] = dateFormatter.string(from: sender.date)
        
    }
}
extension AddInspectionVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate,AddPhotoDelegate {
    
    
    @objc func btnUploadPicPressed(_ sender: UIButton!){
        selectedImage = sender.tag
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Choose profile image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let pickedimage = info[.editedImage] as? UIImage{
            if inspectionNew == true{
                
                let imageData = pickedimage.jpegData(compressionQuality: 0.7)
                var imageFileInfo
                :MultiPartDataFormatStructure?
                if self.selectedImage == 1{
                    imageFileInfo = MultiPartDataFormatStructure.init(key: "file[]", mimeType: .image_jpeg, data: imageData, name: "inspectionIns.jpg")
                    // self.paramInspecionDictionary["inspectionIns"] = "inspectionIns.jpg" as AnyObject
                }
                else if self.selectedImage == 2{
                    imageFileInfo = MultiPartDataFormatStructure.init(key: "file[]", mimeType: .image_jpeg, data: imageData, name: "registrationImg.jpg")
                    // self.paramInspecionDictionary["registrationImg"] = "registrationImg.jpg" as AnyObject
                }
                else if self.selectedImage == 3{
                    imageFileInfo = MultiPartDataFormatStructure.init(key: "file[]", mimeType: .image_jpeg, data: imageData, name: "inspectionState.jpg")
                    // self.paramInspecionDictionary["inspectionState"] = "inspectionState.jpg" as AnyObject
                }else{
                    imageFileInfo = MultiPartDataFormatStructure.init(key: "file[]", mimeType: .image_jpeg, data: imageData, name: "inspectionPlate.jpg")
                    //self.paramInspecionDictionary["inspectionPlate"] = "inspectionPlate.jpg" as AnyObject
                }
                //arrayImageInfoInspection[selectedImage - 1] = imageFileInfo!
                arrayImageInfoInspection.removeAll()
                
                self.arrayImageInfoInspection.append(imageFileInfo!)
                //inspectionImages.append(pickedimage)
                inspectionImages[selectedImage - 1] = pickedimage
                self.tableInspection.reloadData()
                if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
                    self.callUploadPreOpsImages(imageArray: arrayImageInfoInspection, companyID: companyID, isPreOps: false) { (index, responsekey) in
                        if self.selectedImage == 1{
                            self.paramInspecionDictionary["inspectionIns"] = responsekey as AnyObject
                            
                        }else if self.selectedImage == 2{
                            self.paramInspecionDictionary["registrationImg"] = responsekey as AnyObject
                        } else if self.selectedImage == 3{
                            self.paramInspecionDictionary["inspectionState"] = responsekey as AnyObject
                        }else{
                            self.paramInspecionDictionary["inspectionPlate"] = responsekey as AnyObject
                        }
                        
                    }
                }
                
                //arrayImageInfoInspection[selectedImage - 1] = imageFileInfo!
                //inspectionImages.append(pickedimage)
                //inspectionImages[selectedImage - 1] = pickedimage
                //self.tableInspection.reloadData()
                
            }
        }else {
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
    func addPhoto() {
        self.btnUploadPicPressed(UIButton())
    }
    func callUploadPreOpsImages(imageArray: [MultiPartDataFormatStructure], companyID:String, isPreOps: Bool, completionHandler: @escaping(_ status:Int, _ imageName: String) ->()) {
        if Connectivity.isConnectedToInternet {
            var param:[String:AnyObject] = [String:AnyObject]()
            param["companyId"] = companyID as AnyObject
            
            let url = isPreOps ? API.preopsUploadimage.getURL()?.absoluteString ?? "" :  API.uploadInspectionImage.getURL()?.absoluteString ?? ""
            let opt = WebServiceOperation.init(url, param, .WEB_SERVICE_MULTI_PART, imageArray)
            
            opt.completionBlock = {
                DispatchQueue.main.async {
                    
                    guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                        return
                    }
                    if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                        if errorCode.intValue == 0 {
                            if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                                if  let imageArr = dictResult["data"] as? [String] {
                                    let imageName = imageArr[0]
                                    completionHandler(0, imageName )
                                }
                            }
                        }else{
                            completionHandler(1, "")
                            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                        }
                    }
                }
            }
            appDel.operationQueue.addOperation(opt)
            
            
        }else{
            completionHandler(1, "")
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
        }
    }
}
