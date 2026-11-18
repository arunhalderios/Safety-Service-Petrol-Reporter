//
//  InspectionImageVC.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Mahalik on 21/07/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class InspectionImageVC: BaseViewController {
    var arrayFileInfo : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    var imagePicker = UIImagePickerController()
    var arrayImages : [UIImage] = [UIImage]()
    var paramDictionary = Dictionary<String, AnyObject>()
    @IBOutlet weak var collectionViewInspection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }
    
    
    @IBAction func btnbackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
extension InspectionImageVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
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
            let imageFileInfo = MultiPartDataFormatStructure.init(key: "inspection_photo[]", mimeType: .image_jpeg, data: imageData, name: "TagVin.jpg")
            arrayFileInfo.append(imageFileInfo)
            arrayImages.append(pickedimage)
            self.collectionViewInspection.reloadData()
            
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


extension InspectionImageVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        // ------------------------------------------
        // +1 here for the extra add button
        // at the bottom of the collection view
        // ------------------------------------------
        return arrayImages.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CrashPhotoColCell", for: indexPath) as! CrashPhotoColCell
      
      if (arrayImages.count == indexPath.row){
            cell.imagContent.image   = UIImage(named:"Camera_icon")
        }else{
            let multipartContentData = arrayImages[indexPath.row ]
            cell.imagContent.image = multipartContentData
            
        }
     

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return  CGSize.init(width:((collectionView.bounds.size.width/2) - 10) , height: ((collectionView.bounds.size.width / 2) - 10))
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
            if(indexPath.row == arrayImages.count){
                btnUploadPicPressed(message: "Choose image")
            }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
  
   
}
