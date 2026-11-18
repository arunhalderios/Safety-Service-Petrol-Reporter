//
//  FuelReportVC.swift
//  Safety service Patrol Reporter
//
//  Created by Pritam Dey on 30/03/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class FuelReportVC: BaseViewController {
   
    
    @IBOutlet weak var lblNodata: UILabel!
    @IBOutlet weak var viewTabbar: UIView!
    @IBOutlet weak var tableFuel: UITableView!
     @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var labelAddButton:UILabel!
    var pageFor = ""
    var arrayFuels: [FuelData] = []
    var arrayCrashList:[CrashModel] = []
    var arrayMaintainList:[Maintainace] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TimeService.instance.resetInactivityTimer()
        if pageFor == "Crash Report" {
            self.labelTitle.text = "CRASH REPORT"
            self.labelAddButton.text = "ADD CRASH REPORT"
            self.callCrashListApi()
        }else if  pageFor == "Maintenance Report"{
            self.labelTitle.text = "MANTENANCE REPORT"
            self.labelAddButton.text = "ADD MANTENANCE REPORT"
            self.callMaintainanceListApi()
            
        }else{
            self.callFuelListApi()
        }
    }
    @IBAction func btnAddFuelReport(_ sender: Any) {
        if pageFor == "Crash Report" {
          
             let vc = storyboard?.instantiateViewController(identifier: "AddCrashReportVC") as! AddCrashReportVC
             self.navigationController?.pushViewController(vc, animated: true)
            
        }else if  pageFor == "Maintenance Report"{
            let vc = storyboard?.instantiateViewController(identifier: "AddMaintananceRportVC") as! AddMaintananceRportVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = storyboard?.instantiateViewController(identifier: "AddFuelVC") as! AddFuelVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnShowDetails( _ sender: UIButton)  {
        if pageFor == "Crash Report"{
            let vc = storyboard?.instantiateViewController(identifier: "CrashReportDetails") as! CrashReportDetails
            vc.selectedCrashModel = arrayCrashList[sender.tag]
            self.navigationController?.pushViewController(vc, animated: true)
        }else if pageFor == "Maintenance Report"{
            let vc = storyboard?.instantiateViewController(identifier: "FuelReportDetailsVC") as! FuelReportDetailsVC
            let id = arrayMaintainList[sender.tag].vehicleId
            vc.stringVehicleID = id
            vc.maintainanceID = arrayMaintainList[sender.tag].maintenance_report_data_id
            vc.detailsPageFor = "Maintenance Report"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else{
            let vc = storyboard?.instantiateViewController(identifier: "FuelReportDetailsVC") as! FuelReportDetailsVC
            vc.modelFuel = arrayFuels[sender.tag]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func callFuelListApi(){
         if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
                       if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
        param["source"] = "MOB" as AnyObject
        param["companyId"] = companyID as AnyObject
        param["user_id"] = userId as AnyObject
            }
            
        }
        let opt = WebServiceOperation.init((API.FuelReportList.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                self.lblNodata.isHidden = false
                self.lblNodata.text = "No fuel report has been submitted by you"
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                print(dictResponse)
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["data"] as? [[String:Any]] {
                            do {
                                self.arrayFuels = try JSONDecoder().decode([FuelData].self,from:(listArray.data)!)
                                self.tableFuel.reloadData()
                                if self.arrayFuels.count > 0{
                                    self.lblNodata.isHidden = true
                                    
                                }
                               
                             }
                            catch {
                                print(error)
                                
                            }
                        }
                        }
                    }else{
                        
                       // PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                    }
                }
            }
        }
        appDel.operationQueue.addOperation(opt)
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
        }
        
    }
    func callCrashListApi(){
         if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
                       if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
        param["source"] = "MOB" as AnyObject
        param["companyId"] = companyID as AnyObject
        param["user_id"] = userId as AnyObject
            }
            
        }
        let opt = WebServiceOperation.init((API.crashReportListAll.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                self.lblNodata.isHidden = false
                self.lblNodata.text = "No crash report has been submitted by you"
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                print(dictResponse)
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["data"] as? [[String:Any]] {
                            do {
                                self.arrayCrashList = try JSONDecoder().decode([CrashModel].self,from:(listArray.data)!)
                                self.tableFuel.reloadData()
                               if self.arrayCrashList.count > 0{
                                   self.lblNodata.isHidden = true
                                   
                               }
                             }
                            catch {
                                print(error)
                                
                            }
                        }
                        }
                    }else{
                        
                        //PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                    }
                }
            }
        }
        appDel.operationQueue.addOperation(opt)
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
        }
        
    }
    func callMaintainanceListApi(){
         if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
                       if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
        param["source"] = "MOB" as AnyObject
        param["companyId"] = companyID as AnyObject
        param["user_id"] = userId as AnyObject
            }
            
        }
        let opt = WebServiceOperation.init((API.maintenanceListAll.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                self.lblNodata.isHidden = false
                self.lblNodata.text = "No maintainance report has been submitted by you"
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                print(dictResponse)
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["data"] as? [[String:Any]] {
                            do {
                                self.arrayMaintainList = try JSONDecoder().decode([Maintainace].self,from:(listArray.data)!)
                                if self.arrayMaintainList.count > 0{
                                    self.lblNodata.isHidden = true
                                    
                                }
                                self.tableFuel.reloadData()
                               
                             }
                            catch {
                                print(error)
                                
                            }
                        }
                        }
                    }else{
                        
                       // PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
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

extension FuelReportVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pageFor == "Crash Report" {
            return arrayCrashList.count
        }else if  pageFor == "Maintenance Report"{
            return arrayMaintainList.count
        }else{
            return arrayFuels.count
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FuelReportCell", for: indexPath) as! FuelCell
        if pageFor == "Crash Report"{
            cell.setUpTableForCrashReport(list: self.arrayCrashList, index: indexPath.row)
            
        }else if pageFor == "Maintenance Report"{
            cell.setUpTableForMaintenanceReport(list: arrayMaintainList, index: indexPath.row)
        }
        else{
            cell.lableRefulingDate.text = arrayFuels[indexPath.row].refueling_date
            cell.lableRefulingTime.text = arrayFuels[indexPath.row].refueling_time
            cell.lableCostPerLtr.text = arrayFuels[indexPath.row].cost_per_galon
            cell.lableFuleQuantity.text = arrayFuels[indexPath.row].fuel_quantity
        }
        cell.buttonShowDetails.addTarget(self, action: #selector(btnShowDetails(_:)), for: .touchUpInside)
        cell.buttonShowDetails.tag = indexPath.row
       
        return cell
    }
    
    
}
