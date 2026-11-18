//
//  InspectionDetailsOne.swift
//  Safety service Patrol Reporter
//
//  Created by Pritam Dey on 08/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class InspectionDetailsOne: BaseViewController {
    let model = InspectionViewModel()
    @IBOutlet weak var tabeInspectionDetails: UITableView!
   var  inspectionReportId: String?
    var isImageAvailable:Bool = false
    var totalImageCount : Int = 0
    var paramImages:[[String:String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabeInspectionDetails.isHidden = true
        self.callApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }

    
    
    func callApi()  {
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            self.model.callInspectionViewDetails(companyId: companyID, userId: userId, inspectionReportId: self.inspectionReportId ?? "") { (status) in
                if status  == 0 {
                    DispatchQueue.main.async {
                        if let insurance = self.model.inspectionObject?.reportUserData?.insurance_image{
                            var param : [String:String] = [:]
                            if insurance != ""{
                                self.isImageAvailable = true
                                 param["image"] = insurance
                                 param["key"] = "Insurance"
                                self.paramImages.append(param)
                            }
                            
                        }
                        if let insurance = self.model.inspectionObject?.reportUserData?.registration_image{
                            var param : [String:String] = [:]
                            if insurance != ""{
                                self.isImageAvailable = true
                                 param["image"] = insurance
                                 param["key"] = "Registration"
                                self.paramImages.append(param)
                            }
                            
                        }
                        if let insurance = self.model.inspectionObject?.reportUserData?.inspection_image{
                            var param : [String:String] = [:]
                            if insurance != ""{
                                self.isImageAvailable = true
                                 param["image"] = insurance
                                 param["key"] = "State Inspection"
                                self.paramImages.append(param)
                            }
                            
                        }
                        if let insurance = self.model.inspectionObject?.reportUserData?.plate_image{
                            var param : [String:String] = [:]
                            if insurance != ""{
                                self.isImageAvailable = true
                                 param["image"] = insurance
                                 param["key"] = "License"
                                self.paramImages.append(param)
                            }
                            
                        }
                        self.totalImageCount = self.paramImages.count
                        self.tabeInspectionDetails.reloadData()
                        self.tabeInspectionDetails.isHidden = false
                    }
                }
            }
        }
    }

    @IBAction func buttonTapViewSummary(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "InspectionSummeryVC") as! InspectionSummeryVC
        vc.tootsArray = model.inspectionObject?.toolsReport ?? []
        vc.comments = model.inspectionObject?.reportUserData?.inspection_reports_comment
        vc.imageLink = model.inspectionObject?.reportUserData?.inspection_reports_image
        vc.model = self.model
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension InspectionDetailsOne: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if isImageAvailable == true{
        return 3
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
          return 1
        }else{
            if isImageAvailable == true{
                if section  == 1{
                return totalImageCount
                }else{
                    return (self.model.inspectionObject?.questionsResult?.count ?? 0) == 0 ? 0 :  ((self.model.inspectionObject?.questionsResult?.count ?? 0) + 1)
                }
            }else{
            return (self.model.inspectionObject?.questionsResult?.count ?? 0) == 0 ? 0 :  ((self.model.inspectionObject?.questionsResult?.count ?? 0) + 1)
            }
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! InpectionDetailsCell
            if self.model.inspectionObject?.reportUserData != nil {
                cell.inpectionReortDetailCell1(info: (self.model.inspectionObject?.reportUserData)! )
            }
            return cell
        }else{
            if isImageAvailable == true{
                if indexPath.section == 1{
                 let cell  = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell2", for: indexPath) as! IncidentInputCell
                    let obj = self.paramImages[indexPath.row]
                    let key = obj["key"]
                    let imageString = obj["image"] ?? ""
                    if let url = URL(string: imageString){
                        cell.imageViewCell.kf.setImage(with: url)
                        cell.lblTitle.text = key
                    }else{
                        cell.imageViewCell.image = UIImage()
                        cell.lblTitle.text = key
                    }
                return cell
                }else{
                    if indexPath.row == 0 {
                                   let cell1  = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! InpectionDetailsCell
                                    
                                   return cell1
                               }else{
                                   
                                   let cell2  = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! InpectionDetailsCell
                                   cell2.inpectionVehicleCell2(info: (self.model.inspectionObject?.questionsResult?[indexPath.row-1])! )
                                       cell2.lastHightContent.constant =  self.model.inspectionObject?.questionsResult?.count == indexPath.row ? 20 : -15
                                   return cell2

                                   
                               }
                }
            }else{
            
            if indexPath.row == 0 {
                let cell1  = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! InpectionDetailsCell
                return cell1
            }else{
                
                let cell2  = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! InpectionDetailsCell
                cell2.inpectionVehicleCell2(info: (self.model.inspectionObject?.questionsResult?[indexPath.row-1])! )
                    cell2.lastHightContent.constant =  self.model.inspectionObject?.questionsResult?.count == indexPath.row ? 20 : -15
                return cell2

                
            }
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isImageAvailable == true{
            if indexPath.section == 1{
                return 200
            }
        }
        return UITableView.automaticDimension
    }
    
    
}
