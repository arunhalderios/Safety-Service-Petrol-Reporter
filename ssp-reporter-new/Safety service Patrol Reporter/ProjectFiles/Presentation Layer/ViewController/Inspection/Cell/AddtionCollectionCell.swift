//
//  AddtionCollectionCell.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Mahalik on 22/07/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit
protocol AddPhotoDelegate:class {
    func addPhoto()
}
class AddtionCollectionCell: UITableViewCell {
@IBOutlet weak var colvw: UICollectionView!
   // var arrayThirdpartyFileInfo : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    var arrayImages :[UIImage] = []
    var imagePicker = UIImagePickerController()
    weak var delegate:AddPhotoDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        colvw.delegate = self
        colvw.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension AddtionCollectionCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
            if (arrayImages.count == 0){
                return 1
            }else{
                if arrayImages.count == 6{
                return arrayImages.count 
                }else{
                    return arrayImages.count + 1
                }
            }
        
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
        
        return  CGSize.init(width:(collectionView.bounds.size.height - 5) , height: (collectionView.bounds.size.height - 5))
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if(indexPath.row == arrayImages.count){
          delegate?.addPhoto()
      }
       
        
    }
    
}



