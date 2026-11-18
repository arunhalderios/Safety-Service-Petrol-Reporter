//
//  InspectionVC.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Mahalik on 01/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class InspectionVC: BaseViewController {
    var arrayInspections: [Inspection] = []
    @IBOutlet weak var tableInspect: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.callInspectionListApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }
    
    
    @IBAction func btnAddInspectionAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddInspectionVC") as! AddInspectionVC
        vc.isOps = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttoClickViewDetails(_ sender: ButtionX) {
        let vc = storyboard?.instantiateViewController(identifier: "InspectionDetailsOne") as! InspectionDetailsOne
         vc.inspectionReportId = self.arrayInspections[sender.tag].inspection_reports_id ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
  

}
extension InspectionVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayInspections.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FuelCell
        cell.lableRefulingTime.text = arrayInspections[indexPath.row].insurance_expiary_date ?? " "
        cell.lableFuleQuantity.text = arrayInspections[indexPath.row].state_inspection_expiry_date ?? " "
        cell.lableCostPerLtr.text = arrayInspections[indexPath.row].odometer_reading ?? " "
        cell.lableRefulingDate.text = arrayInspections[indexPath.row].registration_expiry_date ?? " "
        cell.lableOne.text = arrayInspections[indexPath.row].vehicleId ?? ""
        cell.buttonShowDetails.tag = indexPath.row
        return cell
    }
    
    
}

extension InspectionVC{
    func callInspectionListApi(){
         if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
                       if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
        param["source"] = "MOB" as AnyObject
        param["companyId"] = companyID as AnyObject
        param["userId"] = userId as AnyObject
            }
            
        }
        let opt = WebServiceOperation.init((API.inspectionList.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                print(dictResponse)
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["data"] as? [[String:Any]] {
                            do {
                                self.arrayInspections = try JSONDecoder().decode([Inspection].self,from:(listArray.data)!)
                                if self.arrayInspections.count == 0{
                                self.displayAlert(Header: App_Title, MessageBody: "No record found", AllActions: ["OK":nil], Style: .alert)
                                }
                                self.tableInspect.reloadData()
                               
                             }
                            catch {
                                print(error)
                                
                            }
                            }else{
                                if self.arrayInspections.count == 0{
                                self.displayAlert(Header: App_Title, MessageBody: "No record found", AllActions: ["OK":nil], Style: .alert)
                                }
                            }
                        }else{
                            if self.arrayInspections.count == 0{
                            self.displayAlert(Header: App_Title, MessageBody: "No record found", AllActions: ["OK":nil], Style: .alert)
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
