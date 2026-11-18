//
//  FuelReportDetailsVC.swift
//  Safety service Patrol Reporter
//
//  Created by Pritam Dey on 30/03/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit
import Kingfisher
class FuelReportDetailsVC: BaseViewController {
    

    @IBOutlet weak var gapConstrain: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var label1Left: UILabel!
    @IBOutlet weak var label2Left: UILabel!
    @IBOutlet weak var label3Left: UILabel!
    @IBOutlet weak var label4Left: UILabel!
    @IBOutlet weak var label5Left: UILabel!
    @IBOutlet weak var label6Left: UILabel!
    @IBOutlet weak var label7Left: UILabel!
    @IBOutlet weak var label8Left: UILabel!
    @IBOutlet weak var label9Left: UILabel!
    @IBOutlet weak var label10Left: UILabel!
    @IBOutlet weak var label11Left: UILabel!
    @IBOutlet weak var label12Left: UILabel!
    @IBOutlet weak var label13Left: UILabel!

    @IBOutlet weak var imageReceipt: UIImageView!
    
    
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
   
    
    
    var stringVehicleID:String?
    var modelFuel :FuelData?
    var detailsPageFor = ""
    var modelMaintainance :MaintanceDetail?
    var maintainanceID:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if detailsPageFor == "Maintenance Report" {
            self.populateMaintenanceReport()
            self.populateMaintenanceReportLeftSide()
            self.callMaintainanceDetailsApi()
        }else{
            self.populateFuelReport()
        }

        // Do any additional setup after loading the view.
    }
    
    
    func populateFuelReport()  {
        gapConstrain.constant = 25
        label1Right.text = modelFuel?.vehicleId ?? " "
        label2Right.text = "Fuel (\(modelFuel?.fuel_type ?? ""))"//"Fuel (Diesel)"
        label3Right.text = modelFuel?.refueling_date ?? " "
        label4Right.text = modelFuel?.refueling_time ?? " "
        if modelFuel?.latitude == ""{
            label5Right.text =  " "
            label6Right.text =  " "
        }else{
        label5Right.text = modelFuel?.latitude ?? " "
        label6Right.text = modelFuel?.longitude ?? " "
        }
        label7Right.text = "\( modelFuel?.odo_meter_reading ?? "0") miles"
        label8Right.text = "$\(modelFuel?.cost_per_galon ?? "0")"
        label9Right.text = "$\(modelFuel?.total_cost ?? "0")"
        label10Right.text = "\(modelFuel?.fuel_quantity ?? "0") Gallon"
        label11Right.text = "\(modelFuel?.fuel_taken_tank ?? "0") Gallon"
        label12Right.text = "\(modelFuel?.fuel_taken_can ?? "0") Gallon"
        if modelFuel?.fuel_taken_tank == ""{
            label11Right.text = "0 Gallon"
        }
        if modelFuel?.fuel_taken_can == ""{
            label12Right.text = "0 Gallon"
        }
        
        label13Right.text = modelFuel?.note ?? " "
        if modelFuel?.report_for == "pumping"{
        let url = URL(string: modelFuel?.pumping ?? "")
        imageReceipt.kf.setImage(with: url)
        }else{
            let url = URL(string: modelFuel?.reciept ?? "")
            imageReceipt.kf.setImage(with: url)
        }
    }
    func populateMaintainanceReport()  {
        gapConstrain.constant = 25
        label1Right.text = modelMaintainance?.state_name ?? " "
        label2Right.text = modelMaintainance?.contract_period//"Fuel (Diesel)"
        label3Right.text = modelMaintainance?.vehicleId ?? " "
        label4Right.text = modelMaintainance?.report_date ?? " "
        label5Right.text = modelMaintainance?.service_type ?? " "
        label6Right.text = modelMaintainance?.repair_description ?? " "
        label7Right.text = modelMaintainance?.vendor_id ?? " "
        label8Right.text = modelMaintainance?.mileage ?? " "
        label9Right.text = "$\(modelMaintainance?.service_cost ?? " ")"
        label10Right.text = "\(modelMaintainance?.used_labour_hour ?? " ")"
        label11Right.text = ""
        label12Right.text = ""
        label13Right.text = modelMaintainance?.note ?? " "
        let url = URL(string: modelMaintainance?.reciept ?? "")
        imageReceipt.kf.setImage(with: url)
    }
    
    func populateMaintenanceReport()  {
        self.labelPageTitle?.text = "MAINTENANCE REPORT"
        self.viewTitle?.text = "Maintenance Report"
        gapConstrain.constant = 15
        label1Right.text = "New York"
        label2Right.text = "1"
        label3Right.text = "#1458"
        label4Right.text = "12/25/2020"
        label5Right.text = "2"
        label6Right.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        label7Right.text = "Phasellus placerat diam e lilbero pulvinar parttitor."
        label8Right.text = "1458"
        label9Right.text = "$60"
        label10Right.text = "10hrs 30 mins"
        label11Right.text = ""
        label12Right.text = ""
        label13Right.text = "Phasellus placerat diam e lilbero pulvinar parttitor."
        
    }
    func populateMaintenanceReportLeftSide()  {
        
        label1Left.text = "State:"
        label2Left.text = "Contract:"
        label3Left.text = "Vehicle:"
        label4Left.text = "Date"
        label5Left.text = "Service Type:"
        label6Left.text = "Repair:" //"Description of Repair:"
        label7Left.text = "Vendor:"
        label8Left.text = "Milege"
        label9Left.text = "Service Cost"
        label10Left.text = "Labor Hours"
        label11Left.text = ""
        label12Left.text = ""
        label13Left.text = "Notes"
        
    }
    func callMaintainanceDetailsApi(){
        if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["user_id"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject
            param["maintenance_report_data_id"] = maintainanceID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.maintenanceListSingle.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["data"] as? [String:Any] {
                                do {
                                    self.modelMaintainance = try JSONDecoder().decode(MaintanceDetail.self,from:(listArray.data)!)
                                    self.modelMaintainance?.vehicleId = self.stringVehicleID
                                    self.populateMaintainanceReport()
                                    //self.ta.reloadData()
                                    
                                }
                                catch {
                                    print(error)
                                    
                                }
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
