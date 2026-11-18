//
//  AddIncidentImageVC.swift
//  ATIMS
//
//  Created by Mahesh Prasad Mahaliik on 19/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
class AddIncidentImageVC: BaseViewController,UITextViewDelegate {
    
    @IBOutlet weak var heightStackConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightCommentConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imgviewVideo: UIImageView!
    @IBOutlet weak var imageViewCamICon: UIImageView!
    @IBOutlet weak var imgViewVideoIcon: UIImageView!
    @IBOutlet weak var lblrecord: UILabel!
    @IBOutlet weak var lblTakePic: UILabel!
    @IBOutlet weak var viewScrollIncident: UIScrollView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var textViewComment: UITextView!
    @IBOutlet weak var imgViewCamera: UIImageView!
    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var lblNote: UILabel!
    let imageCache = NSCache<NSString, UIImage>()
    var pageFor = ""
    var arrayValues :[String] = []
    //var imagePicker = UIImagePickerController()
    var arrayFileInfo : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    var incidenceImage:UIImage?
    var incedent_thumb:UIImage?
    var selectIdex:Int = 0
    var incidentVideo :UIImage?
    var videoData:Data?
    var modelIncidence:IncidentDetailsDataModel?
    var vehicleInformation:String = ""
    var arraySortFormList:[IncidenceFormList] = []
    
    fileprivate enum CELL_CONTENT:Int{
        case Latitude = 0
              case Longitude
              case Call_At
              case Call_Started
              case Call_Completed
              case Incident_Time
              case Incident_type
              case Route_1
              case Mile_Marker
              case Traffic_Direction
              //case Plate_Number
              case State
              case Property_Damage
              case Secondary_crash_involved
              case First_Responder
              case First_Responder_Unit_Number
              case Road_Surface
              case Lane_Location
              case Passengers_Transported
              case Assist_Type
              case Contract
              case Vendor
              case Ramplanes
              case Number_of_Vehicles
              case Comments
              case TotalVehicles
              case TravelLanesBlocked
              case LaneRestorationTime
              case IncidentNo
              case Photo
              case video
              case Notes
              case CELL_RESET_CONTENT_TOTAL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNote.text = "Note *"
        lblNote.setSubTextColor(pSubString: "*", pColor: .red)
        
        if pageFor == "Crash Report"{
            labelTitle.text = "ADD CRASH REPORT"
        }else  if pageFor.lowercased() == "update"{
            self.labelTitle.text = "UPDATE INCIDENT \(modelIncidence?.incidents_report_data_id ?? "")"//"UPDATE INCIDENT 52055"
            self.checkUpdate()
            
        }
        textViewComment.layer.borderWidth = 1.0
        textViewComment.layer.borderColor = darkThemeColor.cgColor
        textViewComment.layer.cornerRadius = 10
        textViewComment.delegate = self
        //imgViewCamera.layer.borderWidth = 1.0
        //imgViewCamera.layer.borderColor = darkThemeColor.cgColor
        viewImage.addborder()
        viewVideo.addborder()
        
        
        imgviewVideo.backgroundColor = appOffWhite
        imgViewCamera.backgroundColor = appOffWhite
        imgViewCamera.layer.cornerRadius = 10
//        if textViewComment.text == "" {
//
//            textViewComment.text = "Write Here..."
//
//        }
        
//        if arraySortFormList[CELL_CONTENT.Photo.rawValue].show == "0"{
//            self.viewImage.isHidden = true
//             self.heightCommentConstraint.constant = 560 / 2
//        }
//        else{
//            self.viewImage.isHidden = false
//             self.heightCommentConstraint.constant = 560 / 2
//        }
        if arraySortFormList[CELL_CONTENT.video.rawValue].show == "0"{
            self.viewVideo.isHidden = true
            self.heightStackConstraint.constant = 560 / 2
        }
        else{
            self.viewVideo.isHidden = false
            self.heightStackConstraint.constant = 560 / 2
        }
         if arraySortFormList[CELL_CONTENT.video.rawValue].show == "0" && arraySortFormList[CELL_CONTENT.Photo.rawValue].show == "0"{
            self.heightStackConstraint.constant = 0
        }
        
        if arraySortFormList[CELL_CONTENT.Notes.rawValue].show == "0"{
            self.viewComment.isHidden = true
            self.heightCommentConstraint.constant = 0.0
        }
        else{
            self.viewComment.isHidden = true // false
            self.heightCommentConstraint.constant = 0.0//180.0
        }
        if  arrayValues[CELL_CONTENT.Notes.rawValue] != ""{
            textViewComment.text = arrayValues[CELL_CONTENT.Notes.rawValue]
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }
    
    
    override func viewWillLayoutSubviews() {
        btnSubmit.roundedView()
    }
    func checkUpdate(){
        let url1 = URL(string: self.modelIncidence?.incedent_video ?? "")
        DispatchQueue.global(qos: .userInitiated).async {
            if let videoUrl = url1{
                
                if let cachedImage = self.imageCache.object(forKey: videoUrl.absoluteString as NSString) {
                    DispatchQueue.main.async {
                        self.imgviewVideo.kf.indicatorType = .activity
                        self.imgviewVideo.image =   cachedImage
                        self.lblrecord.isHidden = true
                        self.imgViewVideoIcon.isHidden = true
                        
                        //cell.viewIndicator.isHidden = true
                        //cell.viewIndicator.stopAnimating()
                    }
                } else {
                    let asset = AVAsset(url:videoUrl)
                    if let getImage = asset.videoThumbnail{
                        self.imageCache.setObject(getImage, forKey: videoUrl.absoluteString as NSString)
                        DispatchQueue.main.async {
                            self.imgviewVideo.kf.indicatorType = .activity
                            self.imgviewVideo.image =   getImage
                            self.lblrecord.isHidden = true
                            self.imgViewVideoIcon.isHidden = true
                            
                        }
                    }else{
                        
                    }
                    
                }
            }
        }
        
        let url2 = URL(string: self.modelIncidence?.incedent_photo ?? "")
        
        if let imageUrl = url2{
            self.imgViewCamera.kf.indicatorType = .activity
            self.imgViewCamera.kf.setImage(with: imageUrl)
            self.imageViewCamICon.isHidden = true
            self.lblTakePic.isHidden = true
            
        }
        
        
    }
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    func validatationCheck() -> Bool{
//
//        if arrayValues[CELL_CONTENT.Notes.rawValue] == ""{
//            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill the Notes field", AllActions: ["Ok":nil], Style: .alert)
//            return false
//        }
//
//        return true
//    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        
        if arraySortFormList[CELL_CONTENT.Notes.rawValue].show == "1"{
           // if textViewComment.text != "" {//|| textViewComment.text == "Write Here..."{
                PopupCustomView.sharedInstance.reSetPopUp()
                if pageFor.lowercased() == "update"{
                    PopupCustomView.sharedInstance.textView?.text = "Do you want to update this incident?"
                    PopupCustomView.sharedInstance.btnLeft.tag = 2
                }else{
                    PopupCustomView.sharedInstance.textView?.text = "Do you want to submit this new incident?"
                    PopupCustomView.sharedInstance.btnLeft.tag = 1
                }
                PopupCustomView.sharedInstance.btnLeft.addTarget(self, action: #selector(btnYesPressed(_:)), for: .touchUpInside)
                PopupCustomView.sharedInstance.display(onView: UIApplication.shared.keyWindow) {
                }
//            }else{
//                self.displayAlert(Header: App_Title, MessageBody: "Please fill the notes fields", AllActions: ["Ok":nil], Style: .alert)
//            }
        }
        else{
                PopupCustomView.sharedInstance.reSetPopUp()
                if pageFor.lowercased() == "update"{
                    PopupCustomView.sharedInstance.textView?.text = "Do you want to update this incident?"
                    PopupCustomView.sharedInstance.btnLeft.tag = 2
                }else{
                    PopupCustomView.sharedInstance.textView?.text = "Do you want to submit this new incident?"
                    PopupCustomView.sharedInstance.btnLeft.tag = 1
                }
                PopupCustomView.sharedInstance.btnLeft.addTarget(self, action: #selector(btnYesPressed(_:)), for: .touchUpInside)
                PopupCustomView.sharedInstance.display(onView: UIApplication.shared.keyWindow) {
                }

        }
        
        
    }
    
    @objc func btnYesPressed(_ sender: UIButton){
        PopupCustomView.sharedInstance.reSetPopUp()
        
        if sender.tag == 1{
            self.callAddIncidenceAPI(isUpdate: "insert")
        }else{
            self.callAddIncidenceAPI(isUpdate: "update")
        }
        
    }
    
    @IBAction func selectAssetFromGallery(_ sender: UIButton) {
        self.btnUploadPicPressed(tag: sender.tag)
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
//        if textViewComment.text == "Write Here..." {
//            textViewComment.text = ""
//
//        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        
//        if textViewComment.text == "" {
//
//            textViewComment.text = "Write Here..."
//
//        }else{
//
//        }
        
    }
    
    
}
extension AddIncidentImageVC{
    
    func callAddIncidenceAPI(isUpdate:String){
        if Connectivity.isConnectedToInternet {
            var param:[String:AnyObject] = [String:AnyObject]()
            if let image = self.incidenceImage{
                //let resizeImage = self.resizeImage(image: image, newWidth: 100)!
                let imageData = image.jpegData(compressionQuality: 0.7)
                
                let imageFileInfo = MultiPartDataFormatStructure.init(key: "incedent_photo", mimeType: .image_jpeg, data: imageData, name: "incedent_photo.jpg")
                arrayFileInfo.append(imageFileInfo)
            }
            
            if let image = self.incedent_thumb{
                //let resizeImage = self.resizeImage(image: image, newWidth: 100)!
                let imageData = image.jpegData(compressionQuality: 0.7)
                
                let imageFileInfo = MultiPartDataFormatStructure.init(key: "incedent_thumb", mimeType: .image_jpeg, data: imageData, name: "incedent_thumb.jpg")
                arrayFileInfo.append(imageFileInfo)
            }
            
            if let video = self.videoData{
                
                let imageFileInfo = MultiPartDataFormatStructure.init(key: "incedent_video", mimeType: .video_mp4, data: video, name: "incidence_video.mp4")
                arrayFileInfo.append(imageFileInfo)
            }
            
            if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
                if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                    //param["companyState"] = self.arrayValues[CELL_CONTENT.State.rawValue] as AnyObject as AnyObject
                    //                       param["companyArea"] = "6" as AnyObject//companyID as AnyObject
                    //                       param["companyZone"] = "2" as AnyObject
                    if let shiftID = UserDefaults.standard.value(forKey: "SHIFTID"){
                        param["shift_id"] = shiftID as AnyObject
                    }else{
                        param["shift_id"] = "1" as AnyObject
                    }
//                    if let vID:String = UserDefaults.standard.value(forKey: "VEHICLEID") as? String {
//                        param["vehicle_id"] = vID as AnyObject
//                    }
                    param["vehicle_id"] = TimeService.instance.vechileId as AnyObject?

                    param["companyRoute"] = self.arrayValues[CELL_CONTENT.Ramplanes.rawValue] as AnyObject
                    param["latitude"] = self.arrayValues[CELL_CONTENT.Latitude.rawValue] as AnyObject
                    param["longitude"] = self.arrayValues[CELL_CONTENT.Longitude.rawValue] as AnyObject
                    param["callAt"] =  self.arrayValues[CELL_CONTENT.Call_At.rawValue] as AnyObject
                    param["callStarted"] = self.arrayValues[CELL_CONTENT.Call_Started.rawValue] as AnyObject
                    param["callComplete"] = self.arrayValues[CELL_CONTENT.Call_Completed.rawValue] as AnyObject
                    param["incidentTime"] = self.arrayValues[CELL_CONTENT.Incident_Time.rawValue] as AnyObject
                    param["incidentType"] = self.arrayValues[CELL_CONTENT.Incident_type.rawValue] as AnyObject
                    param["trafficDirection"] = self.arrayValues[CELL_CONTENT.Traffic_Direction.rawValue] as AnyObject
                    param["milageIn"] = "1" as AnyObject //self.arrayValues[CELL_CONTENT.Mileage_In.rawValue] as AnyObject
                    param["milageOut"] = "2" as AnyObject //self.arrayValues[CELL_CONTENT.Mileage_Out.rawValue] as AnyObject
                    param["mileMaker"] = self.arrayValues[CELL_CONTENT.Mile_Marker.rawValue] as AnyObject
                    param["ramp_lane"] = self.arrayValues[CELL_CONTENT.Ramplanes.rawValue] as AnyObject
                    param["propertyDamage"] = self.arrayValues[CELL_CONTENT.Property_Damage.rawValue] as AnyObject
                    param["crashInvolced"] = self.arrayValues[CELL_CONTENT.Secondary_crash_involved.rawValue] as AnyObject//"2" as AnyObject
                    param["firstResponder"] = self.arrayValues[CELL_CONTENT.First_Responder.rawValue] as AnyObject
                    param["firstResponderUnit"] = self.arrayValues[CELL_CONTENT.First_Responder_Unit_Number.rawValue] as AnyObject as AnyObject
                    param["roadSurver"] = self.arrayValues[CELL_CONTENT.Road_Surface.rawValue] as AnyObject
                    param["laneLocation"] = self.arrayValues[CELL_CONTENT.Lane_Location.rawValue] as AnyObject as AnyObject
                    param["personTransported"] = self.arrayValues[CELL_CONTENT.Passengers_Transported.rawValue] as AnyObject
                    param["companyColor"] = "" as AnyObject//self.arrayValues[CELL_CONTENT.Color.rawValue] as AnyObject
                    param["vehicleType"] = "" as AnyObject //self.arrayValues[CELL_CONTENT.Vehicle_Type.rawValue] as AnyObject
                    param["assistType"] = self.arrayValues[CELL_CONTENT.Assist_Type.rawValue] as AnyObject
                    param["comments"] = self.arrayValues[CELL_CONTENT.Comments.rawValue] as AnyObject
                    param["travel_lanes_blocked"] = self.arrayValues[CELL_CONTENT.TravelLanesBlocked.rawValue] as AnyObject//self.arrayValues[CELL_CONTENT.Comments.rawValue] as AnyObject
                    param["lane_restoration_time"] = self.arrayValues[CELL_CONTENT.LaneRestorationTime.rawValue] as AnyObject
                    param["incident_no"] = self.arrayValues[CELL_CONTENT.IncidentNo.rawValue] as AnyObject
                    param["actionStatus"] = isUpdate as AnyObject
                    
//                    if textViewComment.text == "Write Here..." {
//                        textViewComment.text = ""
//
//                    }
                  //  param["note"] = textViewComment.text as AnyObject
                    param["userId"] = userId as AnyObject
                    param["companyId"] = companyID as AnyObject
                    // param["is_no_licence_plate"] = "1" as AnyObject
                    param["plate_no"] = "0" as AnyObject //self.arrayValues[CELL_CONTENT.Plate_Number.rawValue] as AnyObject
                    param["source"] = "MOB" as AnyObject
                    param["companyState"] = self.arrayValues[CELL_CONTENT.State.rawValue] as AnyObject
                    param["vehicleQty"] = self.arrayValues[CELL_CONTENT.Number_of_Vehicles.rawValue] as AnyObject
                    if isUpdate == "update"{
                        param["incidentReportId"] = modelIncidence?.incidents_report_data_id as AnyObject?
                        param["incident_status"] = "On Scene" as AnyObject?
                    }else{
                        param["incident_status"] = "On Scene" as AnyObject?
                    }
                    //vehicleInformation
                    //vendor_id
                    param["vendor_id"] = self.arrayValues[CELL_CONTENT.Vendor.rawValue] as AnyObject
                    param["contract_id"] = self.arrayValues[CELL_CONTENT.Contract.rawValue] as AnyObject
                    if vehicleInformation == "[]"{
                        //vehicleInformation = ""
                    }
                    param["vehicleInformation"] = vehicleInformation as AnyObject
                    if self.arrayValues[CELL_CONTENT.Number_of_Vehicles.rawValue] == ""{
                        param["vehicleQty"] = "1" as AnyObject
                    }else{
                    param["vehicleQty"] = self.arrayValues[CELL_CONTENT.Number_of_Vehicles.rawValue] as AnyObject
                    }
                    //param["direction"] = self.arrayValues[CELL_CONTENT.Direction.rawValue] as AnyObject
                    //param["description"] = self.arrayValues[CELL_CONTENT.Description.rawValue] as AnyObject
                    let date = Date()
                       print("vehicleID=====%@",UserDefaults.standard.value(forKey: "VEHICLEID") as? String)
                        
                        let formatter = DateFormatter()
                        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                    
                        //let defaultTimeZoneStr = formatter.string(from: date)
                        //formatter.timeZone = NSTimeZone.local
                        let utcTimeZoneStr = formatter.string(from: date)
                        print(utcTimeZoneStr)
                        param["timeUTC"] = utcTimeZoneStr as AnyObject
                    
                    
                }
                
            }
            
            // }
            print(param)
            let opt = WebServiceOperation.init(API.putIncidents.getURL()?.absoluteString ?? "", param, .WEB_SERVICE_MULTI_PART, arrayFileInfo)
            opt.completionBlock = {
                DispatchQueue.main.async {
                    print(opt.responseData?.dictionary?.prettyprintedJSON ?? "")
                    guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                        return
                    }
                    if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                        if errorCode.intValue == 0 {
                            if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0,let dictDetails = dictResult["data"] as? [String:Any] {
                                do{
                                    
                                    let okClause = PROJECT_CONSTANT.CLOUS{
                                        for controller in self.navigationController!.viewControllers as Array {
                                            
                                            if controller.isKind(of: IncidentVC.self) {
                                                self.navigationController!.popToViewController(controller, animated: true)
                                                break
                                            }
                                        }
                                    }
                                    
                                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":okClause], Style: .alert)
                                    var paramSave:[String:AnyObject] = [String:AnyObject]()
                                                                           paramSave["lat"] = MyLocationManager.share.myCurrentLocaton?.latitude as AnyObject?
                                                                           paramSave["long"] = MyLocationManager.share.myCurrentLocaton?.longitude as AnyObject?
                                                                           UserDefaults.standard.set(paramSave, forKey: "Petrolling")
                                    
                                    
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
extension AddIncidentImageVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func btnUploadPicPressed(tag:Int){
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Choose profile image", message: nil, preferredStyle: .actionSheet)
        if tag == 1{
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera(tag: tag)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary(tag: tag)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(tag:Int)
    {
        selectIdex = tag
        if(UIImagePickerController.isSourceTypeAvailable(.camera))
        {
            let imagePicker = UIImagePickerController()
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
    
    func openGallary(tag:Int)
    {
        selectIdex = tag
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = true
            if tag == 2{
                imagePicker.mediaTypes = ["public.movie"]
            }
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker.dismiss(animated: true)
        if let pickedimage = info[.editedImage] as? UIImage
        {
            
            if selectIdex == 1{
                self.incidenceImage = pickedimage
                self.imgViewCamera.image = pickedimage
                self.imageViewCamICon.isHidden = true
                self.lblTakePic.isHidden = true
            }else{
                if let videoURL = info[.mediaURL] as? URL
                {
                    let asset = AVAsset(url:videoURL)
                    let duration = asset.duration
                    let durationTime = CMTimeGetSeconds(duration)
                    let durationInSecond = Double(durationTime)
                    do {
                        let video = try Data(contentsOf: videoURL, options: .mappedIfSafe)
                        if let videoThumbnail = asset.videoThumbnail{
                            
                            if  durationInSecond >= 60{
                                self.dismiss(animated: true, completion: nil)
                                PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Your video exceeded 1 minute. Kindly upload 1 minute video", AllActions: ["OK":nil], Style: .alert)
                                self.videoData = nil
                                self.imgviewVideo = nil
                                self.imgviewVideo.image = nil
                                self.imgViewVideoIcon.isHidden = false
                                self.lblrecord.isHidden = false
                                return
                            }
                            else{
                                self.videoData = video
                                self.imgviewVideo.image = videoThumbnail
                                self.incedent_thumb = videoThumbnail
                                self.imgViewVideoIcon.isHidden = true
                                self.lblrecord.isHidden = true
                            }
                            
                        }
                    } catch {
                        print(error.localizedDescription)
                        self.dismiss(animated: true, completion: nil)
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Something Went Wrong", AllActions: ["OK":nil], Style: .alert)
                        return
                        
                        
                    }
                    self.dismiss(animated: true, completion: nil)
                    self.view.setNeedsLayout()
                }
            }
            
            
        }
        else
        {
            if let videoURL = info[.mediaURL] as? URL
            {
                let asset = AVAsset(url:videoURL)
                let duration = asset.duration
                let durationTime = CMTimeGetSeconds(duration)
                let durationInSecond = Double(durationTime)
                do {
                    let video = try Data(contentsOf: videoURL, options: .mappedIfSafe)
                    if let videoThumbnail = asset.videoThumbnail{
                        
                        if  durationInSecond >= 60{
                            self.dismiss(animated: true, completion: nil)
                            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Your video exceeded 1 minute. Kindly upload 1 minute video", AllActions: ["OK":nil], Style: .alert)
                            self.videoData = nil
                            self.imgviewVideo = nil
                          //  self.imgviewVideo.image = nil
                            self.imgViewVideoIcon.isHidden = false
                            self.lblrecord.isHidden = false
                            return
                        }
                        else{
                            self.videoData = video
                           // self.imgviewVideo.image = videoThumbnail
                            self.imgViewVideoIcon.isHidden = true
                            self.lblrecord.isHidden = true
                        }
                        
                    }
                } catch {
                    print(error.localizedDescription)
                    self.dismiss(animated: true, completion: nil)
                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Something Went Wrong", AllActions: ["OK":nil], Style: .alert)
                    return
                    
                    
                }
                self.dismiss(animated: true, completion: nil)
                self.view.setNeedsLayout()
            }
        }
        
        
        self.dismiss(animated: true, completion: nil)
        self.view.setNeedsLayout()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        selectIdex = 0
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
extension AVAsset{
    var videoThumbnail:UIImage?{
        
        let assetImageGenerator = AVAssetImageGenerator(asset: self)
        assetImageGenerator.appliesPreferredTrackTransform = true
        
        var time = self.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbNail = UIImage.init(cgImage: imageRef)
            
            
            // print("Video Thumbnail genertated successfuly".DubugSuccess())
            
            return thumbNail
            
        } catch {
            
            //  print("error getting thumbnail video".DubugError(),error.localizedDescription)
            return nil
            
            
        }
        
    }
}
extension UIView {
  func addDashedBorder() {
    let color = darkThemeColor.cgColor

    let shapeLayer:CAShapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = color
    shapeLayer.lineWidth = 2
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    shapeLayer.lineDashPattern = [6,3]
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
    //self.layer.masksToBounds = false
    self.layer.addSublayer(shapeLayer)
    }
}
