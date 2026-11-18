//
//  AddCrashPhotoVC.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Mahalik on 02/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class AddCrashPhotoVC: BaseViewController{
    var arrayPopulate: [String] = []
    
    var imageSelectFor = ""
    var arrayFileInfo : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    var imagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var viewThirdParty: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewScrollIncident: UIScrollView!
    
    
    var arrayExteriorFileInfo : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    var arrayInteriorFileInfo : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    var arrayVINFileInfo : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    var arrayThirdpartyFileInfo : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    
    var arrayExteriorFileData : [UIImage] = [UIImage]()
    var arrayInteriorFileData : [UIImage] = [UIImage]()
    var arrayVINFileData : [UIImage] = [UIImage]()
    var arrayThirdpartyFileData : [UIImage] = [UIImage]()
    
    @IBOutlet weak var colvwExterior: UICollectionView!
    @IBOutlet weak var colvwInterior: UICollectionView!
    @IBOutlet weak var colvwVIN: UICollectionView!
    @IBOutlet weak var colvwThirdparty: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSubmit.roundedView()
        colvwExterior.delegate = self
        colvwExterior.dataSource = self
        colvwInterior.delegate = self
        colvwInterior.dataSource = self
        colvwVIN.delegate = self
        colvwVIN.dataSource = self
        colvwThirdparty.delegate = self
        colvwThirdparty.dataSource = self
        
        let blankMupltipart = MultiPartDataFormatStructure(key: "", mimeType: .image_jpg, data: nil, name: "")
        arrayFileInfo = [blankMupltipart,blankMupltipart,blankMupltipart,blankMupltipart]
        if arrayPopulate[14] == "No"{
            self.viewThirdParty.isHidden = true
        }else{
            self.viewThirdParty.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
       
        if((arrayExteriorFileInfo.count >= 1) && (arrayInteriorFileInfo.count >= 1) && (arrayVINFileInfo.count >= 1)){
            arrayFileInfo = arrayExteriorFileInfo + arrayInteriorFileInfo + arrayVINFileInfo + arrayThirdpartyFileInfo
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCrashReportCommentVC") as! AddCrashReportCommentVC
            vc.arrayPopulate = arrayPopulate
            vc.arrayFileInfo = arrayFileInfo
            self.navigationController?.pushViewController(vc, animated: true)
             
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please provide at least one image for each", AllActions: ["OK":nil], Style: .alert)
        }
    }
    
}


extension AddCrashPhotoVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == colvwExterior)
        {
            if (arrayExteriorFileInfo.count == 0){
                return 1
            }else   if (arrayExteriorFileInfo.count < 4){
                return (arrayExteriorFileInfo.count + 1)
            }else{
                return arrayExteriorFileInfo.count
            }
        }else if(collectionView == colvwInterior){
            if (arrayInteriorFileInfo.count == 0){
                return 1
            }else   if (arrayInteriorFileInfo.count < 4){
                return (arrayInteriorFileInfo.count + 1)
            }else{
                return arrayInteriorFileInfo.count
            }
        }else if(collectionView == colvwVIN){
            if (arrayVINFileInfo.count == 0){
                return 1
            }else   if (arrayVINFileInfo.count < 4){
                return (arrayVINFileInfo.count + 1)
            }else{
                return arrayVINFileInfo.count
            }
            
        }else{
            if (arrayThirdpartyFileInfo.count == 0){
                return 1
            }else   if (arrayThirdpartyFileInfo.count < 4){
                return (arrayThirdpartyFileInfo.count + 1)
            }else{
                return arrayThirdpartyFileInfo.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CrashPhotoColCell", for: indexPath) as! CrashPhotoColCell
        
        
        if(collectionView == colvwExterior)
        {
            if (arrayExteriorFileInfo.count == indexPath.row){
                cell.imagContent.image   = UIImage(named:"Camera_icon")
            }else{
                let multipartContentData = arrayExteriorFileData[indexPath.row ]
                cell.imagContent.image = multipartContentData
                
            }
         }else if(collectionView == colvwInterior){
            
            if (arrayInteriorFileInfo.count == indexPath.row){
                cell.imagContent.image   = UIImage(named:"Camera_icon")
            }else{
                let multipartContentData = arrayInteriorFileData[indexPath.row ]
                cell.imagContent.image = multipartContentData
                
            }
        }else if(collectionView == colvwVIN){
            
            if (arrayVINFileInfo.count == indexPath.row){
                cell.imagContent.image   = UIImage(named:"Camera_icon")
            }else{
                let multipartContentData = arrayVINFileData[indexPath.row ]
                cell.imagContent.image = multipartContentData
                
            }
            
        }else{
            
            if (arrayThirdpartyFileInfo.count == indexPath.row){
                cell.imagContent.image   = UIImage(named:"Camera_icon")
            }else{
                let multipartContentData = arrayThirdpartyFileData[indexPath.row ]
                cell.imagContent.image = multipartContentData
                
            }
        }
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return  CGSize.init(width:(collectionView.bounds.size.height - 5) , height: (collectionView.bounds.size.height - 5))
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == colvwExterior)
        {
            if(indexPath.row == arrayExteriorFileInfo.count){
                imageSelectFor = "Exterior"
                btnUploadPicPressed(message: "Choose Exterior Image")
            }
        }else if(collectionView == colvwInterior){
            if(indexPath.row == arrayInteriorFileInfo.count){
                imageSelectFor = "Interior"
                btnUploadPicPressed(message: "Choose Interior Image")
            }
        }else if(collectionView == colvwVIN){
            if(indexPath.row == arrayVINFileInfo.count){
                imageSelectFor = "Vin"
                btnUploadPicPressed(message: "Choose Tag & VIN Image")
            }
        }else if(collectionView == colvwThirdparty){
            if(indexPath.row == arrayThirdpartyFileInfo.count){
                imageSelectFor = "ThirdParty"
                btnUploadPicPressed(message: "Choose ThirdParty Vehicle Image")
            }
        }
    }
    
}




extension AddCrashPhotoVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func btnUploadPicPressed(message:String){
        self.view.endEditing(true)
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .actionSheet)
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
            
            //let resizeImage = self.resizeImage(image: pickedimage, newWidth: 100)!
            let imageData = pickedimage.jpegData(compressionQuality: 0.7)
            
            if ((imageData) != nil){
                
                
                
                if(imageSelectFor == "Exterior"){
                    
                    let imageFileInfo = MultiPartDataFormatStructure.init(key: "exterior_vehicle_photo[]", mimeType: .image_jpeg, data: imageData, name: "profile.jpg")
                    arrayExteriorFileInfo.append(imageFileInfo)
                    arrayExteriorFileData.append(pickedimage)
                    self.colvwExterior.reloadData()
                }else if(imageSelectFor == "Interior"){
                    
                    let imageFileInfo =  MultiPartDataFormatStructure.init(key: "interior_vehicle_photo[]", mimeType: .image_jpeg, data: imageData, name: "Interior.jpg")
                    arrayInteriorFileInfo.append(imageFileInfo)
                    arrayInteriorFileData.append(pickedimage)
                    self.colvwInterior.reloadData()
                }else if(imageSelectFor == "Vin"){
                    
                    let imageFileInfo = MultiPartDataFormatStructure.init(key: "autotag_vin_photo[]", mimeType: .image_jpeg, data: imageData, name: "TagVin.jpg")
                    arrayVINFileInfo.append(imageFileInfo)
                    arrayVINFileData.append(pickedimage)
                    self.colvwVIN.reloadData()
                }else if(imageSelectFor == "ThirdParty"){
                    
                    let imageFileInfo = MultiPartDataFormatStructure.init(key: "third_party_vehicle_photo[]", mimeType: .image_jpeg, data: imageData, name: "ThirdParty.jpg")
                    arrayThirdpartyFileInfo.append(imageFileInfo)
                    arrayThirdpartyFileData.append(pickedimage)
                    self.colvwThirdparty.reloadData()
                }
                
            }
            
        }
        else
        {
            print("Something went wrong")
        }
        
        self.view.setNeedsLayout()
        self.dismiss(animated: true, completion: nil)
        
        
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




/*
///
///Mark:Api Work
/////
extension AddCrashPhotoVC{
    func callCrashReportPhotoApi(crash_report_data_id:String){
           var param:[String:AnyObject] = [String:AnyObject]()
           param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["companyId"] = "2" as AnyObject
                param["user_id"] = "15" as AnyObject
                param["crash_report_data_id"] = "2" as AnyObject//
            }
            
        }
        let opt = WebServiceOperation.init((API.crashReportUploadImage.getURL()?.absoluteString ?? ""), param, .WEB_SERVICE_MULTI_PART, arrayFileInfo)
            //WebServiceOperation.init((API.crashReportUploadImage.getURL()?.absoluteString ?? ""), param)
           opt.completionBlock = {
               DispatchQueue.main.async {
                   
                   guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                       return
                   }
                   if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                       if errorCode.intValue == 0 {
                          PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                       }else{
                           
                           PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                       }
                   }
               }
           }
           appDel.operationQueue.addOperation(opt)
           
       }
}
*/
