//
//  SliderTableCell.swift
//  Alkindi
//
//  Created by Mahesh Mahalik on 30/01/20.
//  Copyright © 2020 Alkindi. All rights reserved.
//

import UIKit
protocol SliderCellDelegate:class {
    func reloadTableDashboud()
}
class SliderTableCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
@IBOutlet weak var sliderImgCollVw: UICollectionView!
     weak var delegate : SliderCellDelegate?
     var arrBannerList :[String] = []
    var timer:Timer?
    var x = 1
    override func awakeFromNib() {
        super.awakeFromNib()
        sliderImgCollVw.delegate = self
        sliderImgCollVw.dataSource = self
        //self.startTimer()
    }
    func startTimer() {
        if timer == nil{

         timer =  Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
        }
    }
    @objc func autoScroll() {
            if self.x < self.arrBannerList.count {
              let indexPath = IndexPath(item: x, section: 0)
              self.sliderImgCollVw.scrollToItem(at: indexPath, at: .right, animated: true)
                self.delegate?.reloadTableDashboud()
              self.x = self.x + 1
            }else{
              self.x = 0
             self.sliderImgCollVw.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                self.delegate?.reloadTableDashboud()
            }
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1//arrBannerList.count
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //self.pageController.currentPage = indexPath.row
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sliderImgCollVw.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
        //let url = URL(string: arrBannerList[indexPath.row].banner_image ?? "")
        cell.imgViewSlide.image = UIImage(named: arrBannerList[indexPath.row])
//        let test = String(arrBannerList[indexPath.row].banner_text?.filter { !"\t\r".contains($0) } ?? "")
    
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize.init(width: (sliderImgCollVw.bounds.size.width), height: (sliderImgCollVw.bounds.size.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

}
