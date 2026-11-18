//
//  TabbarVC.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 11/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit
class TabbarCollCell:UICollectionViewCell{
    
    @IBOutlet weak var imageTab: UIImageView!
    @IBOutlet weak var labelTap: UILabel!
    @IBOutlet weak var viewBackground: UIView!
}

class TabbarVC: UIViewController {

    @IBOutlet var viewRoundedCorner: UIView!
    @IBOutlet weak var tabBarCollectionView: UICollectionView!
    
    var selectedIndex:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarCollectionView.delegate = self
        tabBarCollectionView.dataSource = self
        tabBarCollectionView.reloadData()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.view.roundCorners(corners: [.topLeft,.topRight], radius: 20)
        //tabBarCollectionView.layer.cornerRadius = 25
    }

}

extension TabbarVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3//4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tabBarCollectionView.dequeueReusableCell(withReuseIdentifier: "TabbarCollCell", for: indexPath) as! TabbarCollCell
         if (indexPath.row == 0){
             cell.imageTab.image = UIImage.init(named: "home")
             if (selectedIndex == indexPath.row){
                
                cell.labelTap.textColor = darkThemeColor
            //    cell.viewBackground.backgroundColor = darkThemeColor
                cell.imageTab.tintColor = darkThemeColor
             }
             else {
             //   cell.viewBackground.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                 //cell.imageTab.image = UIImage.init(named: "home_icon")
                 cell.imageTab.tintColor = .gray
                 cell.labelTap.textColor = .gray
                cell.imageTab.tintColor = .gray
              }
            cell.labelTap.text = "Home"
         }
//        else if (indexPath.row == 1){
//            cell.imageTab.image = UIImage.init(named: "question")
//                   if (selectedIndex == indexPath.row){
//
//                    cell.labelTap.textColor = darkThemeColor
//                //    cell.viewBackground.backgroundColor = darkThemeColor
//                    cell.imageTab.tintColor = darkThemeColor
//                    }
//                    else {
//                  //   cell.viewBackground.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
//                        //cell.imageTab.image = UIImage.init(named: "bookingGray")
//                        cell.imageTab.tintColor = .gray
//                        cell.labelTap.textColor = .gray
//                        cell.imageTab.tintColor = .gray
//                     }
//
//
//                   cell.labelTap.text = "FAQ"
//
//               }
        else if (indexPath.row == 1){
            cell.imageTab.image = UIImage.init(named: "statistics")
           
            if (selectedIndex == indexPath.row){
            cell.imageTab.tintColor = darkThemeColor
             cell.labelTap.textColor = darkThemeColor
                //cell.viewBackground.backgroundColor = darkThemeColor
                
             }
             else {
               // cell.viewBackground.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                // cell.imageTab.image = UIImage.init(named: "bookingGray")
                 cell.imageTab.tintColor = .gray
                 cell.labelTap.textColor = .gray
                cell.imageTab.tintColor =  .gray
              }
            
             
            cell.labelTap.text = "Report"
          
        }
        else {
            cell.imageTab.image = UIImage.init(named: "avatar")
            if (selectedIndex == indexPath.row){
                cell.imageTab.tintColor = darkThemeColor
                cell.labelTap.textColor = darkThemeColor
              //cell.viewBackground.backgroundColor = darkThemeColor
             }
             else {
                 cell.imageTab.tintColor = .gray
                 cell.labelTap.textColor = .gray
              }
            
             
            cell.labelTap.text = "Profile"
          
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex != indexPath.row{
        if (indexPath.row == 0){
           if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController {
            //viewController.newsObj = newsObj
            let navigationController = UINavigationController(rootViewController: VC)
            navigationController.isNavigationBarHidden = true
            self.view.window?.rootViewController = navigationController
            }
        }
//           else if (indexPath.row == 1){
//
//
//                if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FAQVC") as? FAQVC {
//                //viewController.newsObj = newsObj
//                let navigationController = UINavigationController(rootViewController: VC)
//                navigationController.isNavigationBarHidden = true
//                self.view.window?.rootViewController = navigationController
//                }
//            }
             else if (indexPath.row == 1){
                    if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReportVC") as? ReportVC {
                    //viewController.newsObj = newsObj
                     let navigationController = UINavigationController(rootViewController: VC)
                     navigationController.isNavigationBarHidden = true
                     self.view.window?.rootViewController = navigationController
                     }
              }
        else {
                  if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC {
                                            //viewController.newsObj = newsObj
                   let navigationController = UINavigationController(rootViewController: VC)
                   navigationController.isNavigationBarHidden = true
                   self.view.window?.rootViewController = navigationController
                   }
            }
            self.selectedIndex = indexPath.row
            self.tabBarCollectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        return CGSize(width: self.tabBarCollectionView.frame.width/3, height: self.tabBarCollectionView.frame.size.height)
        //return CGSize(width: self.tabBarCollectionView.frame.width/4, height: self.tabBarCollectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    

    
}
