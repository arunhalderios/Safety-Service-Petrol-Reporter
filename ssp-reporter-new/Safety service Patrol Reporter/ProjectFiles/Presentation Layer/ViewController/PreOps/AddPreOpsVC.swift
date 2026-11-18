//
//  AddPreOpsVC.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Mahalik on 31/03/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class AddPreOpsVC: BaseViewController {
     let model = modelPreOps()
    let arrayTitle = ["Vehicle Interior and Exterior Clean","Decals/Reflective Striping in good condtion","Vehicle mounted jumper cables operational","Paint scratches","Rust","Dents","All Radio equipment operational ","No authorized radio equipment in vehicle","Compressed air system operational","Uniform, Rain Gear, Safety Gear, Hard Hats"]
    
    @IBOutlet weak var lblNodata: UILabel!
    var arrayQuestions:[PreOpsQuestions] = []
    var modelPreOPSData:[PreOpsModel] = []
    let pickerView = UIPickerView()
    var picker :UIImagePickerController?
    var isOPS :Bool  = true
    var selectedIndex = 0
    var arrayAnswers = ["YES","NO"]
    var arrayImageInfoPreOps : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    var arrayImagequestions : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tablePreops: UITableView!
    
    var paramDictionary = Dictionary<String, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isOPS == false{
            lblTitle.text = "INSPECTIONS - VEHICLE"
        }
        self.callQuestionListApi()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let cell = tablePreops.cellForRow(at: IndexPath(row: 0, section: 1)) as? IncidentButtomCell
        if cell != nil {
            cell?.btnNext.layer.cornerRadius = 8
        }
    }
    
    func createParam() -> Dictionary<String, AnyObject> {
        var preOpsVehicleQuestionsArray:[Dictionary<String,String>] = []
        self.arrayImageInfoPreOps.removeAll()
        self.arrayImagequestions.removeAll()
        var count = 0
        for item in modelPreOPSData {
            var dict = [String:String]()
            let imageFileInfo = MultiPartDataFormatStructure.init(key: "file", mimeType: .image_jpeg, data: item.imageData , name: item.imageName)
            
            let imageFileInfo1 = MultiPartDataFormatStructure.init(key: "\(count)", mimeType: .image_jpeg, data: item.imageData , name: item.imageName)
            
            self.arrayImageInfoPreOps.append(imageFileInfo)
            self.arrayImagequestions.append(imageFileInfo1)
            let questionIDKey:String = self.isOPS ? "preops_vehicle_question_id" : "inspection_vehicle_question_id"
            dict[questionIDKey] = item.PreopsVehicleQuestionID
            dict["image"] = item.imageName
            dict["answer"] = item.Answer
            dict["comments"] = item.Comments
            dict["name"] = item.PreopsVehicleQuestion
            count = count + 1
            preOpsVehicleQuestionsArray.append(dict)
        }
        let QuestionArrayKey:String = self.isOPS ? "preOpsVehicleQuestions" : "inspectionsVehicleQuestions"
        self.paramDictionary[QuestionArrayKey] = preOpsVehicleQuestionsArray as AnyObject
        return  self.paramDictionary
    }
    
    func loadDataIntoModel(apiData:[PreOpsQuestions])  {
        self.modelPreOPSData.removeAll()
        for info in apiData {
            let modelObject = PreOpsModel()
            modelObject.Answer = "NO"
            modelObject.Comments = ""
            modelObject.PreopsVehicleQuestion = info.preops_vehicle_question
            modelObject.PreopsVehicleQuestionID = info.preops_vehicle_question_id
            self.modelPreOPSData.append(modelObject)
        }
        self.tablePreops.reloadData()
    }

    
    @IBAction func btnNextAction(_ sender: Any) {
        self.view.endEditing(true)
        if validation(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "PreOPSToolsVC") as! PreOPSToolsVC
        vc.isOPS = self.isOPS
        vc.paramDictionary = createParam()
        vc.arrayImageInfoPreOps =  arrayImagequestions
        self.navigationController?.pushViewController(vc, animated: true)
        }
        
//        else{
//            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill up all of the field", AllActions: ["OK":nil], Style: .alert)
//        }
    }
    
    func validation() -> Bool  {
        for item in modelPreOPSData {
           // if item.Answer == "YES"{
   //         if item.Comments?.isEmpty ?? true ||  item.imageData == nil || item.imageName?.isEmpty ?? true  {
                
//                if item.Comments?.isEmpty ?? true{
//                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill up all of Comments", AllActions: ["OK":nil], Style: .alert)
//                }
//                if item.imageName?.isEmpty ?? true{
//                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill up all of images", AllActions: ["OK":nil], Style: .alert)
//                    return false
//                }else{
//                    return true
//                }
                
          //  }
       // }
        }
        return true
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
    @objc func action(sender:UIBarButtonItem) {
        //ekanei korte hobe
        let index = IndexPath(row: sender.tag, section: 0)
        if let cell:PreOpsVehicleCell  = self.tablePreops.cellForRow(at: index) as? PreOpsVehicleCell{
            if self.selectedIndex >= 0{
                cell.txtFieldInput.text = self.arrayAnswers[self.selectedIndex]
                self.modelPreOPSData[sender.tag].Answer = self.arrayAnswers[self.selectedIndex]
            }
        }
        self.view.endEditing(true)
        self.selectedIndex =  0
    }
       
       @objc func cancelAction() {
           self.selectedIndex = 0
           self.view.endEditing(true)
       }
    
    
    //MARK: - Show popup for comments-
    @objc func btnShowPopupForComment(_ sender: UIButton){
        PopupCustomView.sharedInstance.reSetPopUp()
        PopupCustomView.sharedInstance.textView?.setBorder(width: 2.0, borderColor: AppthemeColor, cornerRadious: 10.0)
        PopupCustomView.sharedInstance.textView?.isSelectable = true
        PopupCustomView.sharedInstance.textView?.isEditable = true
        PopupCustomView.sharedInstance.textView?.textAlignment = .left
        PopupCustomView.sharedInstance.textView?.isUserInteractionEnabled = true
        PopupCustomView.sharedInstance.btnLeft.tag = sender.tag
        PopupCustomView.sharedInstance.textView?.text = self.modelPreOPSData[sender.tag].Comments ?? ""
        PopupCustomView.sharedInstance.btnLeft.addTarget(self, action: #selector(btnYesPressed(_:)), for: .touchUpInside)
        PopupCustomView.sharedInstance.btnRight.addTarget(self, action: #selector(btnNoPressed), for: .touchUpInside)
        PopupCustomView.sharedInstance.display(onView: UIApplication.shared.keyWindow) {
        }
        
    }
    @objc func btnYesPressed(_ sender: UIButton){
        self.modelPreOPSData[sender.tag].Comments = PopupCustomView.sharedInstance.textView?.text
        self.tablePreops.reloadData()
        self.reSetPopUp()
    }
    @objc func btnNoPressed(_ sender: UIButton){
        self.reSetPopUp()
    }
    
    func reSetPopUp() {
        PopupCustomView.sharedInstance.textView?.isUserInteractionEnabled = false
        PopupCustomView.sharedInstance.textView?.isEditable = false
        PopupCustomView.sharedInstance.textView?.isSelectable = false
        PopupCustomView.sharedInstance.hide()
        PopupCustomView.sharedInstance.btnLeft.removeTarget(self, action: #selector(btnYesPressed(_:)), for: .touchUpInside)
        PopupCustomView.sharedInstance.btnRight.removeTarget(self, action: #selector(btnNoPressed), for: .touchUpInside)
        PopupCustomView.sharedInstance.textView?.setBorder(width: 0.0, borderColor: .white, cornerRadious: 0.0)
        PopupCustomView.sharedInstance.textView?.textAlignment = .center
    }
    
    @objc func btnOpenImageSelection(_ sender: UIButton) {
        if self.modelPreOPSData[sender.tag].Answer == "NO"{
            PROJECT_CONSTANT.displayAlert(Header: "Warning", MessageBody: "You are not allowed. Please Select Yes to proceed", AllActions: ["OK":nil], Style: .alert)
        }else{
        self.openActionSheetAlert(tag: sender.tag)
        }
    }
    
    @IBAction func btnAnswerSelection(_ sender: Any) {
    }
    
}
extension AddPreOpsVC:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayAnswers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayAnswers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedIndex = row
    }
}
extension AddPreOpsVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.modelPreOPSData.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1{
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "IncidentButtomCell", for: indexPath) as! IncidentButtomCell
            self.view.setNeedsLayout()
            return cell1
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreOpsVehicleCell", for: indexPath) as! PreOpsVehicleCell
            cell.btnSelection.tag = indexPath.row
            cell.btnSelection.isHidden = true
            cell.txtFieldInput.tag = indexPath.row
            self.createPickerView(textField: cell.txtFieldInput)
            cell.txtFieldInput.text = self.modelPreOPSData[indexPath.row].Answer ?? "NO"
            cell.lblTitle.text =   self.modelPreOPSData[indexPath.row].PreopsVehicleQuestion ?? " "
            cell.imgViewDropDown.isHidden = false
            //cell.viewRound.roundedView()
            cell.btnUploadComments.tag = indexPath.row
            cell.btnSelectImage.tag = indexPath.row
            cell.btnUploadComments.addTarget(self, action: #selector(self.btnShowPopupForComment(_:)), for: .touchUpInside)
            cell.btnSelectImage.addTarget(self, action: #selector(self.btnOpenImageSelection(_:)), for: .touchUpInside)
            //btnOpenImageSelection
            cell.viewRound.layer.borderWidth = 1.5
            cell.viewRound.layer.borderColor = darkThemeColor.cgColor
            cell.imgComments.tintColor = self.modelPreOPSData[indexPath.row].Comments != "" ? darkThemeColor : .darkGray
            
            cell.imgOption.image = self.modelPreOPSData[indexPath.row].imageData != nil ?   UIImage(named: "yellowcamera") : UIImage(named: "smallcam")

            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            if arrayQuestions.count > 0{
            return 95
            }else{
                return 0.01
            }
        }
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
extension AddPreOpsVC{
    func callQuestionListApi(){
         if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["user_id"] = userId as AnyObject
                 self.paramDictionary["userId"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject
            self.paramDictionary["companyId"] = companyID as AnyObject
           
            
            
        }
        var urlString:URL?
        if isOPS == true{
            urlString = API.questionsList.getURL()
        }else{
            urlString = API.inspectionQuestionsList.getURL()
        }
        let opt = WebServiceOperation.init((urlString?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                self.lblNodata.isHidden = false
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["data"] as? [[String:Any]] {
                                do {
                                    self.arrayQuestions = try JSONDecoder().decode([PreOpsQuestions].self,from:(listArray.data)!)
                                    DispatchQueue.main.async {
                                        self.loadDataIntoModel(apiData: self.arrayQuestions)
                                    }
                                    if self.arrayQuestions.count > 0{
                                        self.lblNodata.isHidden = true
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
}

extension AddPreOpsVC : UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
          if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            if picker.view.tag < self.modelPreOPSData.count {
                let imageData = pickedImage.jpegData(compressionQuality: 0.6)
                if ((imageData) != nil){
                    
                    var keyName = "file"
                    if isOPS == true{
                        keyName = "file"
                    }else{
                        keyName = "file[]"
                    }
                    
                    let imageFileInfo = MultiPartDataFormatStructure.init(key: keyName, mimeType: .image_jpeg, data: imageData , name: "\(picker.view.tag).jpg")
                    var multArray = [MultiPartDataFormatStructure]()
                    multArray.removeAll()
                    multArray.append(imageFileInfo)
                    model.callUploadPreOpsImages(imageArray: multArray, companyID: self.paramDictionary["companyId"] as! String, isPreOps: self.isOPS) { (status, name)  in
                        if status == 0 {
                            DispatchQueue.main.async {
                                self.modelPreOPSData[picker.view.tag].imageData = imageData
                                self.modelPreOPSData[picker.view.tag].imageName = name
                                print(self.modelPreOPSData[picker.view.tag].imageName)
                                self.tablePreops.reloadData()
                            }
                            
                        }
                    }
                    
                }
                
                
            }
          }
           self.dismiss(animated: true, completion: nil)
      }

      func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
          self.dismiss(animated: true, completion: nil)
      }
    
   //MARK: Open Action Sheet
    func openActionSheetAlert(tag: Int) {
        let attributedString = NSAttributedString(string: "Please select an image", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), //your font here
            NSAttributedString.Key.foregroundColor :AppthemeColor as Any
        ])
        
        let actionSheetController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheetController.setValue(attributedString, forKey: "attributedTitle")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            self.dismiss(animated: true, completion: nil)
        }
        let openCamera = UIAlertAction(title: "Camera", style: .default) { action in
            self.openCamera(tag: tag)
        }
        let openGalary = UIAlertAction(title: "Gallery", style: .default) { action in
            self.openGalary(tag: tag)
        }
        actionSheetController.addAction(openGalary)
        actionSheetController.addAction(openCamera)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    
    func openGalary(tag: Int){
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            self.picker = UIImagePickerController()
            self.picker?.view.tag = tag
            self.picker?.delegate = self
            self.picker?.sourceType = .photoLibrary
            self.picker?.allowsEditing = true
            self.present(picker!, animated: true, completion: nil)
        }
    }
    
    func openCamera(tag: Int){
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            self.picker = UIImagePickerController()
            self.picker?.view.tag = tag
            self.picker?.delegate = self
            self.picker?.sourceType = .camera
            self.picker?.allowsEditing = true
            self.present(picker!, animated: true, completion: nil)
        }
    }
}


