//
//  ProfileVC.swift
//  HMS
//
//  Created by Dipika on 09/01/20.
//  Copyright © 2020 MET Technologies. All rights reserved.
//

import UIKit
import Kingfisher
//import MRCountryPicker
//import SkyFloatingLabelTextField

class ProfileVC: BaseViewController {
    var tempcountryCode = "+1"
    @IBOutlet var viewRound: ViewX!
    @IBOutlet weak var tableProfile: UITableView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var viewTabbar: UIView!
    @IBOutlet var viewRoundedCorner: UIView!
    
    
    var arrayFieldValue = [String]()
    var modelUser : Userdetails?
    var strcountryCode: String = "+1"
    var selectedCountryNameCode = "IN"
    var modelProfile = modelProfileClass()
    var isbtnEdit:Bool = false
    //var ischangeData:Bool = false
    
    var imagepicData : Data?
    fileprivate var imageBase64:String = ""
    var imagePicker = UIImagePickerController()
    //var tagButtonStatePicker:Int = 0
    var profileImage:UIImage?
    var arrayFileInfo : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    fileprivate enum CELL_CONTENT:Int{
        case FName = 0
        case LName
        case Email
        case Mobile
        case Address
        case City
        case State
        case PinCode
    }
    
    
    // @IBOutlet var customTabbar:CustomTabbarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.vwHeader?.lableTitle.text = "Profile"
        //        self.vwHeader?.headerType = .back
        //        self.vwHeader?.tintColor = .white
        //        self.vwHeader?.rightButton2.isHidden = false
        //
        //        self.vwHeader?.rightButton2.tintColor = .white
        //        self.vwHeader?.backgroundColor = themeColor
        self.btnEdit.layer.cornerRadius =  self.btnEdit.frame.size.height/2
        tableProfile.delegate = self
        tableProfile.dataSource = self
        tableProfile.reloadData()
        arrayFieldValue = ["","","","","","","",""]
        
        
        //self.callProfileApi()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.isTabbarClick = true
        TimeService.instance.resetInactivityTimer()
        if let childVC = self.children.first as? TabbarVC {
            childVC.selectedIndex = 3
            childVC.tabBarCollectionView.reloadData()
        }
        
        //viewTabbar.addShadow(location: .top)
        callFetchDetail()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //super.viewDidLayoutSubviews()
//            let rectShape = CAShapeLayer()
//            rectShape.bounds = self.viewRound.frame
//            rectShape.position = self.viewRound.center
//            rectShape.path = UIBezierPath(roundedRect: self.viewRound.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 40, height: 40)).cgPath
//            //self.viewRoundedCorner.layer.backgroundColor = UIColor.green.cgColor
//            self.viewRound.layer.mask = rectShape
        
        
        
        
        //self.viewRoundedCorner.roundCorners(corners: [.topLeft, .topLeft], radius: 30.0)
        let indexPath = IndexPath(row: 0, section: 0)
        
        let cell = self.tableProfile.cellForRow(at: indexPath) as? ProfileImageCell
        if (cell != nil){
            cell?.imageProfile.layer.cornerRadius = (((cell?.imageProfile.frame.height)!) / 2 )
            cell?.imageProfile.clipsToBounds = true
            cell?.viewRoundedCorner.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 50.0)
        }
        
        let indexPath1 = IndexPath(row: 7, section: 0)
        
        let cell1 = self.tableProfile.cellForRow(at: indexPath1) as? IncidentButtomCell
        if (cell1 != nil){
            //cell1?.btnNext.layer.cornerRadius = (((cell1?.btnNext.frame.height)!) / 2 )
            cell1?.btnNext.clipsToBounds = true
        }
        
        tabbarUISetup()
    }
    func tabbarUISetup(){
        ///// Call Custom Tabbar
        //        customTabbar.setup(activeFor:"MyAccount")
        //        customTabbar.myDelegate = self
        //        makeShadowToChildView(shadowView: customTabbar)
    }
    
    @IBAction func btnPasswordAction(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangedPasswordVC") as? ChangedPasswordVC {
                
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func callFetchDetail(){
        
        
        if let user = UserDefaults.standard.value(forKey: "USER") as? [String:Any]{
            do{
                self.modelUser = try JSONDecoder().decode(Userdetails.self,from:(user.data)!)
                
                arrayFieldValue[CELL_CONTENT.FName.rawValue] = modelUser?.first_name ?? ""
                arrayFieldValue[CELL_CONTENT.LName.rawValue] = modelUser?.last_name ?? ""
                arrayFieldValue[CELL_CONTENT.Email.rawValue] = modelUser?.email ?? ""
                arrayFieldValue[CELL_CONTENT.City.rawValue] = modelUser?.city ?? ""
                arrayFieldValue[CELL_CONTENT.PinCode.rawValue] = modelUser?.zip ?? ""
                arrayFieldValue[CELL_CONTENT.Address.rawValue] = modelUser?.address ?? ""
                arrayFieldValue[CELL_CONTENT.Mobile.rawValue] = modelUser?.phone ?? ""
                
                if let state = UserDefaults.standard.value(forKey: "STATENAME") as? String{
                    
                     arrayFieldValue[CELL_CONTENT.State.rawValue] = state
                }else{
                    arrayFieldValue[CELL_CONTENT.State.rawValue] = ""
                }
                
                //UserDefaults.standard.set(dashboardData ["state_name"] as? String, forKey: "STATENAME")
                let indexPath = IndexPath(row: 0, section: 0)
                       
                       let cell = self.tableProfile.cellForRow(at: indexPath) as? ProfileImageCell
                       if (cell != nil){
                           cell?.imageProfile.layer.cornerRadius = (((cell?.imageProfile.frame.height)!) / 2 )
                           cell?.imageProfile.clipsToBounds = true
                        let urlString = URL(string: modelUser?.profile_image ?? "")
                        if let url = urlString{
                        cell?.imageProfile.kf.setImage(with: url)
                        }
                       }
                
                self.tableProfile.reloadData()
            }catch{
                
            }
        }
    }
    
    @objc func textFieldValueChanged(_ textField:UITextField) {
        arrayFieldValue[textField.tag] = textField.text!
        print (arrayFieldValue)
        
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        if (isbtnEdit) {
            
            self.callUpdateProfileAPI()
            
        } else {
            
            isbtnEdit = true
            btnEdit.setTitle("SAVE", for: .normal)
            tableProfile.reloadData()
        }
        
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDone(_ sender: Any) {
        strcountryCode = self.tempcountryCode
        let indexPath = IndexPath(row: 3, section: 0)
        let cell = tableProfile.cellForRow(at: indexPath) as! MobileCell
        cell.lblCountryCode.text = strcountryCode
        
    }
    
}

extension ProfileVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0){
            return UIDevice.current.userInterfaceIdiom == .phone ? 200 : 350
        }
        else if (indexPath.row == 7){
                return 100
        }
        else {
            return UIDevice.current.userInterfaceIdiom == .phone ? 105 : 134
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
            if self.profileImage == nil{
                
            }else{
                cell.imageProfile.image = self.profileImage
            }
            if(isbtnEdit == false){
                cell.imageUpload.isHidden = true
                cell.btnUploadPic.isHidden = true
            }else{
                cell.imageUpload.isHidden = false
                cell.btnUploadPic.isHidden = false
            }
            
            cell.btnUploadPic.addTarget(self, action: #selector(btnUploadPicPressed(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        else if (indexPath.row == 3){
            let cell = tableView.dequeueReusableCell(withIdentifier: "MobileCell", for: indexPath) as! MobileCell
            cell.txtMobileNumber.keyboardType = .numberPad
            cell.txtMobileNumber.tag =  CELL_CONTENT.Mobile.rawValue
            cell.txtMobileNumber?.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
            cell.txtMobileNumber.addLeftViewPadding(padding: 8, placeholderText: "Mobile")
            cell.txtMobileNumber.text = arrayFieldValue[CELL_CONTENT.Mobile.rawValue]
            if isbtnEdit{
                cell.txtMobileNumber.isUserInteractionEnabled = true
            }else{
                cell.txtMobileNumber.isUserInteractionEnabled = false
            }
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 7{
             let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentButtomCell", for: indexPath) as! IncidentButtomCell
            cell.setNeedsLayout()
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textinputCell", for: indexPath) as! textinputCell
            cell.selectionStyle = .none
            cell.textInputLast.keyboardType = .default
            cell.textInputFirst.keyboardType = .default
            if isbtnEdit{
                cell.textInputFirst.isUserInteractionEnabled = true
                cell.textInputLast.isUserInteractionEnabled = true
            }else{
                cell.textInputFirst.isUserInteractionEnabled = false
                cell.textInputLast.isUserInteractionEnabled = false
            }
            cell.textInputLast?.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
            cell.textInputFirst?.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
            if (indexPath.row == 1){
                cell.viewFirst.isHidden = false
                cell.viewLast.isHidden = false
                cell.lblFieldName.text = "First Name"
                cell.lblFieldNameSecond.text = "Last Name"
                cell.textInputFirst.placeholder = "First Name"
                cell.textInputLast.placeholder = "Last Name"
                cell.textInputFirst.text = arrayFieldValue[CELL_CONTENT.FName.rawValue]
                cell.textInputLast.text = arrayFieldValue[CELL_CONTENT.LName.rawValue]
                cell.textInputFirst.tag = CELL_CONTENT.FName.rawValue
                cell.textInputLast.tag = CELL_CONTENT.LName.rawValue
            }
            else if(indexPath.row == 2){
                cell.viewFirst.isHidden = false
                cell.viewLast.isHidden = true
                cell.lblFieldName.text = "Email ID"
                cell.textInputFirst.placeholder = "Email ID"
                cell.textInputFirst.text = arrayFieldValue[CELL_CONTENT.Email.rawValue]
                cell.textInputFirst.isUserInteractionEnabled = false
                cell.textInputFirst.tag = CELL_CONTENT.Email.rawValue
                
            }
            else if(indexPath.row == 4){
                cell.viewFirst.isHidden = false
                cell.viewLast.isHidden = true
                cell.lblFieldName.text = "Street"
                cell.textInputFirst.placeholder = "Street"
                cell.textInputFirst.text = arrayFieldValue[CELL_CONTENT.Address.rawValue]
                cell.textInputFirst.tag = CELL_CONTENT.Address.rawValue
            }
                else if(indexPath.row == 5){
                //cell.textInputFirst.isUserInteractionEnabled = false
                    cell.viewFirst.isHidden = false
                    cell.viewLast.isHidden = true
                    cell.lblFieldName.text = "City"
                    cell.textInputFirst.placeholder = "City"
                    cell.textInputFirst.text = arrayFieldValue[CELL_CONTENT.City.rawValue]
                    cell.textInputFirst.tag = CELL_CONTENT.City.rawValue
                }
            else if(indexPath.row == 6) {
                cell.textInputLast.keyboardType = .numberPad
                cell.textInputFirst.isUserInteractionEnabled = false
                cell.viewFirst.isHidden = false
                cell.viewLast.isHidden = false
                cell.lblFieldName.text = "State"
                cell.lblFieldNameSecond.text = "Zip Code"
                cell.textInputFirst.placeholder = "State"
                cell.textInputLast.placeholder = "Zip Code"
                cell.textInputLast.text = arrayFieldValue[CELL_CONTENT.PinCode.rawValue]
                cell.textInputFirst.text = arrayFieldValue[CELL_CONTENT.State.rawValue]
                cell.textInputFirst.tag = CELL_CONTENT.State.rawValue
                cell.textInputLast.tag = CELL_CONTENT.PinCode.rawValue
            }
            else {
                cell.viewFirst.isHidden = false
                cell.viewLast.isHidden = false
                // cell.lblFieldName.text = "Nationality"
                // cell.lblFieldNameSecond.text = "Company"
                
            }
            return cell
        }
    }
    
    
}

//MARK:UPDATE PROFILE IMAGE

extension ProfileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
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
            
            let indexPath = IndexPath(row: 0, section: 0)
            print("Picked image is:",pickedimage)
            let cell = self.tableProfile.cellForRow(at: indexPath) as! ProfileImageCell
            cell.imageProfile.image = pickedimage
            self.profileImage = pickedimage
            let resizeImage = self.resizeImage(image: pickedimage, newWidth: 100)!
            let imageData = resizeImage.jpegData(compressionQuality: 1)
            self.imagepicData =  imageData
            
            
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

extension URL {
    
    var isValid: Bool {
        get {
            return UIApplication.shared.canOpenURL(self)
        }
    }
    
}


extension ProfileVC{
    func callProfileApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["user_id"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject
        }
        let opt = WebServiceOperation.init((API.Userdetails.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                print(opt.responseData?.dictionary)
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["userdetails"] as? [String:Any] {
                                do {
                                    self.modelUser = try JSONDecoder().decode(Userdetails.self,from:(listArray.data)!)
                                    self.callFetchDetail()
                                    self.tableProfile.reloadData()
                                    
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
        
    }
    func callUpdateProfileAPI(){
        arrayFileInfo.removeAll()
        if ((self.imagepicData) != nil){
            let imageFileInfo = MultiPartDataFormatStructure.init(key: "profile_image", mimeType: .image_jpeg, data: self.imagepicData, name: "profile.jpg")
            arrayFileInfo.append(imageFileInfo)
        }
        if arrayFieldValue[CELL_CONTENT.Mobile.rawValue].count > 0{
            if arrayFieldValue[CELL_CONTENT.Mobile.rawValue].count < 8 || arrayFieldValue[CELL_CONTENT.Mobile.rawValue].count > 13{
                self.displayAlert(Header: App_Title, MessageBody: "Please enter minimum 8-13 digit number", AllActions: ["OK":nil], Style: .alert)
                return
            }
        }
        if Connectivity.isConnectedToInternet {
            var param:[String:AnyObject] = [String:AnyObject]()
            
            if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
                if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                    param["source"] = "MOB" as AnyObject
                    param["user_id"] = userId as AnyObject
                    param["companyId"] = companyID as AnyObject
                    param["address"] = arrayFieldValue[CELL_CONTENT.Address.rawValue] as AnyObject
                    param["phone"] = arrayFieldValue[CELL_CONTENT.Mobile.rawValue] as AnyObject
                    param["city"] = arrayFieldValue[CELL_CONTENT.City.rawValue] as AnyObject
                    param["zip"] = arrayFieldValue[CELL_CONTENT.PinCode.rawValue] as AnyObject
                    param["first_name"] = arrayFieldValue[CELL_CONTENT.FName.rawValue] as AnyObject
                    param["last_name"] = arrayFieldValue[CELL_CONTENT.LName.rawValue] as AnyObject
                }
                
            }
            print(param)
            let opt = WebServiceOperation.init(API.userprofileEdit.getURL()?.absoluteString ?? "", param, .WEB_SERVICE_MULTI_PART, arrayFileInfo)
            opt.completionBlock = {
                DispatchQueue.main.async {
                    
                    guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                        return
                    }
                    if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                        if errorCode.intValue == 0 {
                            if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                                if  let listArray = dictResult["userdetails"] as? [String:Any] {
                                    do {
                                        self.modelUser = try JSONDecoder().decode(Userdetails.self,from:(listArray.data)!)
                                        UserDefaults.standard.set(listArray, forKey: "USER")
                                        self.isbtnEdit = false
                                        self.btnEdit.setTitle("EDIT", for: .normal)
                                        //self.callFetchDetail()
                                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Profile Updated", AllActions: ["OK":nil], Style: .alert)
                                        self.tableProfile.reloadData()
                                    }catch{
                                        
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
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
