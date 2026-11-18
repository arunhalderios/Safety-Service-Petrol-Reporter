//
//  PreOPSSummaryVC.swift
//  Safety service Patrol Reporter
//
//  Created by Abhik on 01/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class PreOPSSummaryVC: BaseViewController {
    var counter:Int = 0
    var model = modelPreOps()
    var paramDictionary = Dictionary<String, AnyObject>()
    var arrayTitle = ["Comment",""]
    var picker :UIImagePickerController?
    var modelPreOPSTools:[PreOpsModelTools] = []
    var arrayImageInfoPreOps : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    var arrayQuestionsImages : [MultiPartDataFormatStructure] = []
    var arrayImageInspect : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    var brokenTools:[PreOpsModelTools] = []
    var missingTools:[PreOpsModelTools] = []
    var presentTools:[PreOpsModelTools] = []
   var isOPS :Bool  = true
    @IBOutlet weak var lblTitleHeader: UILabel!
    @IBOutlet weak var tableIncident: UITableView!
    let arraySamplertext = ["Lorem ipsum","Lorem ipsum","Lorem ipsum","Lorem ipsum"]
    var imagePicker = UIImagePickerController()
    var receiptImage:UIImage?
    var inspectionImages:[UIImage] = []
    var inspectionImageString:[String] = []
     var questionsList : [Dictionary<String,String>] = []
    var inspectionNew:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        print(paramDictionary)
                
        self.counter = 0
        brokenTools = modelPreOPSTools.filter { $0.answerTool == "Broken" }
        missingTools = modelPreOPSTools.filter { $0.answerTool == "Missing" }
        presentTools = modelPreOPSTools.filter { $0.answerTool == "Present" }
        
        if brokenTools.count > 0{
            arrayTitle.insert("Tools Broken", at: 0)
        }
        if missingTools.count > 0{
            arrayTitle.insert("Tools Missing", at: 0)
        }
        if presentTools.count > 0{
            arrayTitle.insert("Tools Present", at: 0)
        }
//        if let questList = paramDictionary["preOpsVehicleQuestions"] as?  [Dictionary<String,String>]{
//            questionsList = questList
            
//        }
        self.tableIncident.reloadData()
        
        if isOPS == false{
            lblTitleHeader.text = "INSPECTIONS - SUMMARY"
            arrayTitle.insert("Inspection Questions:", at: 0)
            if let questList = paramDictionary["inspectionsVehicleQuestions"] as?  [Dictionary<String,String>]{
                        questionsList = questList
            }
        }else{
            arrayTitle.insert("Preops Questions:", at: 0)
            if let questList = paramDictionary["preOpsVehicleQuestions"] as?  [Dictionary<String,String>]{
                        questionsList = questList
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
   
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    fileprivate func callUploadAllData() {
        self.model.callUploadPreOpsUserInput(param: paramDictionary, isPreOps: self.isOPS) { (status) in
            if status == 0 {
                let okClause = PROJECT_CONSTANT.CLOUS{
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(identifier: "DashboardViewController") as! DashboardViewController
                        self.navigationController?.popPushToVC(ofKind: DashboardViewController.self, pushController: vc)
                        
                    }
                    
                }
                if self.isOPS == true{
                    UserDefaults.standard.set("1", forKey: "PREOPSSAVED")
                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Your Pre ops Report submitted successfully.", AllActions: ["Ok":okClause], Style: .alert)
                }else{
                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Your inspection Report submitted successfully", AllActions: ["Ok":okClause], Style: .alert)
                }
                
            }
        }
    }
    
    @IBAction func btnNext(_ sender: Any) {
        self.counter = 0
        //if receiptImage != nil{
            let index = IndexPath(row: 0, section:  self.arrayTitle.count-2)
            if   let cell : IncidentCommentCell = tableIncident.cellForRow(at: index) as? IncidentCommentCell {
                let commentsKey = self.isOPS ? "reportsComment" : "inspectionComment"
                paramDictionary[commentsKey] =  cell.txtViewComment.text as AnyObject?
            }
            
            print("finalData", self.paramDictionary)
       if isOPS == true{
         if   let cell : IncidentCommentCell = tableIncident.cellForRow(at: index) as? IncidentCommentCell {
//            if cell.txtViewComment.text == ""{
//                 displayAlert(Header: App_Title, MessageBody: "Please fill the mandatory filed", AllActions: ["OK":nil], Style: .alert)
//            }else{
                if receiptImage == nil{
                     displayAlert(Header: App_Title, MessageBody: "Please submit the image", AllActions: ["OK":nil], Style: .alert)
                }else{
        callUploadAllData()
                }
            //}
         }else{
             displayAlert(Header: App_Title, MessageBody: "Please fill the mandatory filed", AllActions: ["OK":nil], Style: .alert)
        }

       }else{
        if arrayImageInfoPreOps.count > 0{
            self.uploadAllInspectionImages()
        }else{
            displayAlert(Header: App_Title, MessageBody: "Please upload atleast 1 inspection image", AllActions: ["OK":nil], Style: .alert)
            //callUploadAllData()
        }
      
        
        
        
        }
    }
    
   
    
}
extension PreOPSSummaryVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayTitle.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return questionsList.count
        }
        else if section == 1 && arrayTitle.count  >= 4{
            if self.presentTools.count > 0{
                return self.presentTools.count
            }else if self.missingTools.count > 0{
                return self.missingTools.count
            }else{
                return self.brokenTools.count
            }
            
        }else if section == 2 && arrayTitle.count  >= 5{
            if self.missingTools.count > 0{
                return self.missingTools.count
            }else{
                return self.brokenTools.count
            }
        }else if section == 3 && (arrayTitle.count ) >= 6{
            return self.brokenTools.count
            
        }else {
            return 1
        }
     
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section < self.arrayTitle.count{
//            if section == 0{
//                if questionsList.count == 0{
//                    return ""
//                }
//            }
//            return self.arrayTitle[section]
//        }else{
//            return ""
//        }
//    }
    
    //func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        guard let headerView = view as? UITableViewHeaderFooterView else { return }
//        if headerView.textLabel?.text == "Tools Broken"{
//            headerView.textLabel?.textColor = .systemRed
//        }else if headerView.textLabel?.text == "Tools Missing"{
//            headerView.textLabel?.textColor = darkThemeColor
//        }else if headerView.textLabel?.text == "Tools Present"{
//            headerView.textLabel?.textColor = .systemGreen
//        }else{
//            headerView.textLabel?.textColor = .darkGray
//        }
       
       
    //}
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell1") as? ReportCell
        if cell != nil {
            
            if section < self.arrayTitle.count{
                if section == 0{
                    if questionsList.count == 0{
                       
                    }
                }
                cell?.labelToolsName.text = self.arrayTitle[section]
                print(self.arrayTitle[section])
                if cell?.labelToolsName.text == "Tools Broken"{
                    cell?.labelToolsName.textColor = .systemRed
                        }else if cell?.labelToolsName.text == "Tools Missing"{
                            cell?.labelToolsName.textColor = darkThemeColor
                        }else if cell?.labelToolsName.text == "Tools Present"{
                            cell?.labelToolsName.textColor = .systemGreen
                        }else{
                            cell?.labelToolsName.textColor = .darkGray
                        }
                return cell
            }else{
                cell?.labelToolsName.text = ""
                return cell
            }
        }else{
            return nil
        }
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == arrayTitle.count   {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "IncidentButtomCell", for: indexPath) as! IncidentButtomCell
            cell1.btnNext.layer.cornerRadius = cell1.btnNext.frame.size.height / 2
            self.view.setNeedsLayout()
            return cell1
        }else
        if indexPath.section == 0{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell2", for: indexPath) as! ReportCell
            let obj = questionsList[indexPath.row]
            
            cell.labelToolsName.text = obj["name"]
            cell.labelToolsNumber.text = obj["answer"]
            if  obj["comments"] == ""{
                cell.lblMessage.text = ""
            }else{
                cell.lblMessage.text = "  \(obj["comments"] ?? "")  "
            }
            
            if arrayQuestionsImages.count > 0{
                let image = arrayQuestionsImages.filter({ obj in
                    obj.strKey == "\(indexPath.row)"
                })
                if image.count > 0{
                    
                    let getDaa = image[0].data
                    if getDaa != nil{
                    cell.imageQuestions.image = UIImage(data: getDaa!)
                        cell.widthImage.constant = 130
                        cell.heightImage.constant = 130
                    }else{
                        cell.widthImage.constant = 0
                        cell.heightImage.constant = 0
                    }
                }else{
                    cell.widthImage.constant = 0
                    cell.heightImage.constant = 0
                }
            }else{
                cell.widthImage.constant = 0
                cell.heightImage.constant = 0
            }
            return cell
        }
            
            else if indexPath.section == 1 && (arrayTitle.count ) >= 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
            if self.presentTools.count > 0{
                cell.labelToolsName.text = "\(self.presentTools[indexPath.row].preOpsToosName ?? "") (\(self.presentTools[indexPath.row].number))"
                cell.labelToolsNumber.text = ""//"(\(self.presentTools[indexPath.row].number))"
            }else if self.missingTools.count > 0{
                cell.labelToolsName.text = "\(self.missingTools[indexPath.row].preOpsToosName ?? "") (\(self.missingTools[indexPath.row].number))"
                cell.labelToolsNumber.text = ""//"(\(self.missingTools[indexPath.row].number))"
            }else if self.brokenTools.count > 0{
                cell.labelToolsName.text = "\(self.brokenTools[indexPath.row].preOpsToosName ?? "") (\(self.brokenTools[indexPath.row].number))"
                cell.labelToolsNumber.text = ""//"(\(self.brokenTools[indexPath.row].number))"
            }
            return cell
            
        }
        else if indexPath.section == 2 && (arrayTitle.count ) >= 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
            if self.missingTools.count > 0{
                cell.labelToolsName.text = "\(self.missingTools[indexPath.row].preOpsToosName ?? "") (\(self.missingTools[indexPath.row].number))"
                cell.labelToolsNumber.text = ""//"(\(self.missingTools[indexPath.row].number))"
            }else{
                cell.labelToolsName.text = "\(self.brokenTools[indexPath.row].preOpsToosName ?? "") (\(self.brokenTools[indexPath.row].number))"
                cell.labelToolsNumber.text = ""//"(\(self.brokenTools[indexPath.row].number))"
            }
            return cell
        }
        else if indexPath.section == 3 && (arrayTitle.count ) >= 6{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
            
            cell.labelToolsName.text = "\(self.brokenTools[indexPath.row].preOpsToosName ?? "") (\(self.brokenTools[indexPath.row].number))"
            cell.labelToolsNumber.text = ""//"(\(self.brokenTools[indexPath.row].number))"
            
            return cell
        }else if indexPath.section == self.arrayTitle.count-2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentCommentCell", for: indexPath) as! IncidentCommentCell
            cell.txtViewComment.layer.borderColor = AppthemeColor.cgColor
            cell.txtViewComment.isEditable = true
            cell.txtViewComment.isUserInteractionEnabled = true
            cell.txtViewComment.layer.borderWidth = 1.0
            cell.txtViewComment.layer.cornerRadius = 5.0
            return cell
        }else {
            if inspectionNew == true{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddtionCollectionCell", for: indexPath) as! AddtionCollectionCell
                cell.delegate = self
                cell.arrayImages = inspectionImages
                //cell.arrayThirdpartyFileInfo = self.arrayImageInfoPreOps
                cell.colvw.reloadData()
                return cell
                
            }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell2", for: indexPath) as! IncidentInputCell
            if let image = receiptImage{
                // cell.btnSelection.setImage(image, for: .normal)
                cell.imageViewCell.image = image
                cell.imageDefaultCamera.isHidden = true
                cell.lblTitle.isHidden = true
            }else{
                cell.imageViewCell.image = nil
                cell.imageDefaultCamera.isHidden = false
                cell.lblTitle.isHidden = false
            }
            cell.btnSelection.addTarget(self, action: #selector(btnUploadPicPressed(_:)), for: .touchUpInside)
            return cell
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayTitle.count  == indexPath.section {
            return 95
        }else if (indexPath.section == self.arrayTitle.count-2 ){
            return 161
        }else if (indexPath.section == self.arrayTitle.count-1){
            if inspectionNew == true{
                return 120
            }
            return 180
        }
        return UITableView.automaticDimension
        
    }
}





extension PreOPSSummaryVC:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arraySamplertext.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arraySamplertext[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // selectedCountry = countryList[row]
        // textFiled.text = selectedCountry
    }
    
    func createPickerView(textField:UITextField) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        textField.inputView = pickerView
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.action(sender:)))
        button.tag = textField.tag
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.cancelAction))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([button,spacer,cancel], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        
    }
    
    func dismissPickerView() {
        
        //
    }
    
    @objc func cancelAction() {
        view.endEditing(true)
    }
    @objc func action(sender: UIBarButtonItem) {
        view.endEditing(true)
    }
    
    
    
    func createDatePickerView(textField:UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        textField.inputView = datePicker
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.datePickerAction(sender:)))
        button.tag = textField.tag
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.cancelAction))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([button,spacer,cancel], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        
    }
    
    @objc func datePickerAction(sender: UIBarButtonItem) {
        view.endEditing(true)
    }
}

//MARK:UPLOAD IMAGE

extension PreOPSSummaryVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate,AddPhotoDelegate {
    
    
    @objc func btnUploadPicPressed(_ sender: UIButton!){
        self.view.endEditing(true)
        imagePicker.view.tag = sender.tag
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
    
    
    func uploadAllInspectionImages(){
        self.callUploadPreOpsImages(imageArray: self.arrayImageInfoPreOps, companyID: self.paramDictionary["companyId"] as! String, isPreOps: self.isOPS) { (status, name)  in
            if status == 0 {
                DispatchQueue.main.async {
                    self.paramDictionary["inspectionImg"] = name as AnyObject
                    self.callUploadAllData()
//                    let keyImage:String = self.isOPS ? "reportsImage" : "inspectionImg"
//                    self.paramDictionary[keyImage] = name as AnyObject
//                    self.tableIncident.reloadData()
                }
            }
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let pickedimage = info[.editedImage] as? UIImage{
            if inspectionNew == true{
                let count = arrayImageInfoPreOps.count
                    let imageData = pickedimage.jpegData(compressionQuality: 0.7)
                    let imageFileInfo = MultiPartDataFormatStructure.init(key: "file[]", mimeType: .image_jpeg, data: imageData, name: "\(count+1).jpg")
                    arrayImageInfoPreOps.append(imageFileInfo)
                    inspectionImages.append(pickedimage)
              
                
                    self.tableIncident.reloadData()
                
            }else{
            let imageData = pickedimage.jpegData(compressionQuality: 0.7)
            let imageFileInfo = MultiPartDataFormatStructure.init(key: "file", mimeType: .image_jpeg, data: imageData , name: "reportsImage.png")
            self.arrayImageInfoPreOps.removeAll()
            self.arrayImageInfoPreOps.append(imageFileInfo)

            model.callUploadPreOpsImages(imageArray: self.arrayImageInfoPreOps, companyID: self.paramDictionary["companyId"] as! String, isPreOps: self.isOPS) { (status, name)  in
                if status == 0 {
                    DispatchQueue.main.async {
                        self.receiptImage = pickedimage
                        let keyImage:String = self.isOPS ? "reportsImage" : "inspectionImg"
                        self.paramDictionary[keyImage] = name as AnyObject
                        self.tableIncident.reloadData()
                    }
                }
            }
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
    func callUploadPreOpsImages(imageArray: [MultiPartDataFormatStructure], companyID:String, isPreOps: Bool, completionHandler: @escaping(_ status:Int, _ imageName: [String]) ->()) {
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
                                
                             completionHandler(0, imageArr )
                            }
                        }
                    }else{
                        completionHandler(1, [])
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                    }
                }
            }
        }
        appDel.operationQueue.addOperation(opt)
        
        
    }else{
        completionHandler(1, [])
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
        }
    }
}
