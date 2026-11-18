//
//  CrashReportDetailVC.swift
//  ATIMSTracker
//
//  Created by Abhik on 08/04/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit

class CrashReportDetailVC: BaseViewController {
    
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    
    
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
    var ImageList_Exterior = ["Crash Report","Fuel","Crash Report","Fuel"]
    
    
    @IBOutlet weak var imgInterior: UIImageView!
    @IBOutlet weak var collectionViewInterior: UICollectionView!
    var ImageList_Interior = ["Crash Report","Fuel","Crash Report","Fuel"]
    
    @IBOutlet weak var imgAutoTagVIN: UIImageView!
    @IBOutlet weak var collectionViewAutoTagVIN: UICollectionView!
    var ImageList_AutoTagVIN = ["Crash Report","Fuel","Crash Report","Fuel"]
    
    @IBOutlet weak var imgThirdPartyVehicle: UIImageView!
    @IBOutlet weak var collectionViewThirdPartyVehicle: UICollectionView!
    var ImageList_ThirdPartyVehicle = ["Crash Report","Fuel","Crash Report","Fuel"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateCrashReport()
        
        imgExterior.layer.cornerRadius = 10
        imgInterior.layer.cornerRadius = 10
        imgAutoTagVIN.layer.cornerRadius = 10
        imgThirdPartyVehicle.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }
    
    func populateCrashReport()  {
        label1Right.text = "1458"
        label2Right.text = "30 Gallons"
        label3Right.text = "Fuel (Diesel)"
        label4Right.text = "125.25568"
        label5Right.text = "-258.2568"
        label6Right.text = "12/25/2020"
        label7Right.text = "22:30:57"
        label8Right.text = "Yes"
        label9Right.text = "No"
        label10Right.text = "4"
        label11Right.text = "Yes"
        label12Right.text = "No"
        label13Right.text = "Highway"
        label14Right.text = "Yes"
        
    }
}

extension CrashReportDetailVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
            cell.imageOption.image = UIImage(named:ImageList_Exterior[indexPath.row])
        }else  if(collectionView == collectionViewInterior){
            cell.imageOption.image = UIImage(named:ImageList_Exterior[indexPath.row])
        }else  if(collectionView == collectionViewAutoTagVIN){
            cell.imageOption.image = UIImage(named:ImageList_AutoTagVIN[indexPath.row])
        }else{
            cell.imageOption.image = UIImage(named:ImageList_ThirdPartyVehicle[indexPath.row])
        }
        
        cell.imageOption.layer.cornerRadius = 5.0
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == collectionViewExterior){
            imgExterior.image = UIImage(named: ImageList_Exterior[indexPath.row])
        }else  if(collectionView == collectionViewInterior){
            imgInterior.image = UIImage(named:ImageList_Exterior[indexPath.row])
        }else if(collectionView == collectionViewAutoTagVIN){
            imgAutoTagVIN.image = UIImage(named:ImageList_AutoTagVIN[indexPath.row])
        }else{
            imgThirdPartyVehicle.image = UIImage(named:ImageList_ThirdPartyVehicle[indexPath.row])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize.init(width: (collectionViewExterior.bounds.size.height * 1.2) , height: (collectionViewExterior.bounds.size.height * 0.8))
    }
    
}

