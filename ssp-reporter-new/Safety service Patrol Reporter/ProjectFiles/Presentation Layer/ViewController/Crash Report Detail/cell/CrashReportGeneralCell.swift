//
//  CrashReportGeneralCell.swift
//  Safety service Patrol Reporter
//
//  Created by Abhik on 29/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class CrashReportGeneralCell: UITableViewCell {
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    
    @IBOutlet weak var label1Right: UILabel!
    @IBOutlet weak var label2Right: UILabel!
    @IBOutlet weak var label3Right: UILabel!
    @IBOutlet weak var label4Right: UILabel!
    @IBOutlet weak var label5Right: UILabel!
    @IBOutlet weak var label6Right: UILabel!
    @IBOutlet weak var label7Right: UILabel!
    @IBOutlet weak var label8Right: UILabel!
    @IBOutlet weak var label9Right: UILabel!
    @IBOutlet weak var label10Right: UILabel!
    @IBOutlet weak var label11Right: UILabel!
    
    @IBOutlet weak var label12Right: UILabel!
    @IBOutlet weak var label13Right: UILabel!
    @IBOutlet weak var label14Right: UILabel!
    
    
    
    
    @IBOutlet weak var imgExterior: UIImageView!
    @IBOutlet weak var collectionViewExterior: UICollectionView!
    var ImageList_Exterior :[String] = []// = ["Crash Report","Fuel","Crash Report","Fuel"]
    
    @IBOutlet weak var imgInterior: UIImageView!
    @IBOutlet weak var collectionViewInterior: UICollectionView!
    var ImageList_Interior :[String] = []//  = ["Crash Report","Fuel","Crash Report","Fuel"]
    
    @IBOutlet weak var imgAutoTagVIN: UIImageView!
    @IBOutlet weak var collectionViewAutoTagVIN: UICollectionView!
    var ImageList_AutoTagVIN :[String] = []//  = ["Crash Report","Fuel","Crash Report","Fuel"]
    
    @IBOutlet weak var imgThirdPartyVehicle: UIImageView!
    @IBOutlet weak var collectionViewThirdPartyVehicle: UICollectionView!
    var ImageList_ThirdPartyVehicle :[String] = []//  = ["Crash Report","Fuel","Crash Report","Fuel"]
    
    
    @IBOutlet weak var colvwExteriorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var colvwInteriorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var colvwVINHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var colvwThirdPartyVHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func populatedata(){
        if(ImageList_Exterior.count != 0){
            let url = URL(string:ImageList_Exterior[0])
            imgExterior.kf.setImage(with: url)
            colvwExteriorHeightConstraint.constant = 76.5
            collectionViewExterior.isHidden = false
        }else{
            colvwExteriorHeightConstraint.constant = 0
            collectionViewExterior.isHidden = true
        }
        
        if(ImageList_Interior.count != 0){
            let url = URL(string:ImageList_Interior[0])
            imgInterior.kf.setImage(with: url)
            colvwInteriorHeightConstraint.constant = 76.5
            collectionViewInterior.isHidden = false
        }else{
            colvwInteriorHeightConstraint.constant = 0
            collectionViewInterior.isHidden = true
        }
        
        if(ImageList_AutoTagVIN.count != 0){
            let url = URL(string:ImageList_AutoTagVIN[0])
            imgAutoTagVIN.kf.setImage(with: url)
            colvwVINHeightConstraint.constant = 76.5
            collectionViewAutoTagVIN.isHidden = false
        }else{
            colvwVINHeightConstraint.constant = 0
            collectionViewAutoTagVIN.isHidden = true
        }
        if(ImageList_ThirdPartyVehicle.count != 0){
            let url = URL(string:ImageList_ThirdPartyVehicle[0])
            imgThirdPartyVehicle.kf.setImage(with: url)
            colvwThirdPartyVHeightConstraint.constant = 76.5
            collectionViewThirdPartyVehicle.isHidden = false
        }else{
            colvwThirdPartyVHeightConstraint.constant = 0
            collectionViewThirdPartyVehicle.isHidden = true
        }
        collectionViewExterior.delegate = self
        collectionViewExterior.dataSource = self
        collectionViewInterior.delegate = self
        collectionViewInterior.dataSource = self
        collectionViewAutoTagVIN.delegate = self
        collectionViewAutoTagVIN.dataSource = self
        collectionViewThirdPartyVehicle.delegate = self
        collectionViewThirdPartyVehicle.dataSource = self
    }
}
extension CrashReportGeneralCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == collectionViewExterior){
            return ImageList_Exterior.count
        }else if(collectionView == collectionViewInterior){
            return ImageList_Interior.count
        }else if(collectionView == collectionViewAutoTagVIN){
            return ImageList_AutoTagVIN.count
        }else{
            return ImageList_ThirdPartyVehicle.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CrashCollectionCell", for: indexPath) as! CrashCollectionCell
        
        if(collectionView == collectionViewExterior){
             if let images = ImageList_Exterior[safe: indexPath.row]{
            let url = URL(string:ImageList_Exterior[indexPath.row])
            cell.imageOption.kf.setImage(with: url)
            }else{
                cell.imageOption.image = UIImage(named: "")
            }
        }else  if(collectionView == collectionViewInterior){
            if let images = ImageList_Interior[safe: indexPath.row]{
            let url = URL(string:ImageList_Interior[indexPath.row])
            cell.imageOption.kf.setImage(with: url)
            }else{
                cell.imageOption.image = UIImage(named: "")
            }
           
        }else  if(collectionView == collectionViewAutoTagVIN){
            if let images = ImageList_AutoTagVIN[safe: indexPath.row]{
            let url = URL(string:ImageList_AutoTagVIN[indexPath.row])
            cell.imageOption.kf.setImage(with: url)
            }else{
                cell.imageOption.image = UIImage(named: "")
            }
            
        }else{
            if let images = ImageList_ThirdPartyVehicle[safe: indexPath.row]{
            let url = URL(string:ImageList_ThirdPartyVehicle[indexPath.row])
            cell.imageOption.kf.setImage(with: url)
            }else{
                cell.imageOption.image = UIImage(named: "")
            }
            
        }
        
        cell.imageOption.layer.cornerRadius = 5.0
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == collectionViewExterior){
            let url = URL(string:ImageList_Exterior[indexPath.row])
            imgExterior.kf.setImage(with: url)
        }else  if(collectionView == collectionViewInterior){
            let url = URL(string:ImageList_Interior[indexPath.row])
            imgInterior.kf.setImage(with: url)
        }else if(collectionView == collectionViewAutoTagVIN){
            let  url = URL(string:ImageList_AutoTagVIN[indexPath.row])
            imgAutoTagVIN.kf.setImage(with: url)
        }else{
            let url = URL(string:ImageList_ThirdPartyVehicle[indexPath.row])
            imgThirdPartyVehicle.kf.setImage(with: url)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize.init(width: (collectionViewExterior.bounds.size.height * 1.2) , height: (collectionViewExterior.bounds.size.height * 0.8))
    }
    
}


