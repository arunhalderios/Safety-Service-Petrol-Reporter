//
//  CrashReportDetails.swift
//  Safety service Patrol Reporter
//
//  Created by Abhik on 29/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class CrashReportDetails: BaseViewController {
    @IBOutlet weak var tableViewCrash: UITableView!
    
    var numberofSec = 1
    var stringName = " "
    var selectedCrashModel :CrashModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = UserDefaults.standard.value(forKey: "USER") as? [String:Any]{
                   do{
                       let modeluser = try JSONDecoder().decode(Userdetails.self,from:(user.data)!)
                    stringName = modeluser.name
                   }catch{
                    
            }
        }
        print(selectedCrashModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }

    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension CrashReportDetails:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        print("numberOfSections ::\(numberofSec)")
        let sectionNumber = selectedCrashModel?.driver_info?.count ?? 0
        return (1 + sectionNumber)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section ==  0){
            return 1
        }else{
            let driverModel = selectedCrashModel?.driver_info?[section - 1]
            let rowNumber = driverModel?.passenger_info?.count ?? 0
            return rowNumber
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt ::\(indexPath.section) ::\(indexPath.row)")
        if indexPath.section == 0{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "CrashReportGeneralCell", for: indexPath) as! CrashReportGeneralCell
            
            
            
            cell.viewTitle.text = "Crash Report - " + (selectedCrashModel?.crash_report_data_id ?? " ")
            cell.labelDate.text = selectedCrashModel?.crash_report_date ?? " "
            cell.labelTime.text = selectedCrashModel?.crash_report_time ?? " "
            cell.label1Right.text = stringName
            cell.label2Right.text = selectedCrashModel?.vehicleId ?? " "
            cell.label3Right.text = selectedCrashModel?.state_name ?? " "
            cell.label4Right.text = selectedCrashModel?.latitude ?? " "
            cell.label5Right.text = selectedCrashModel?.longitude ?? " "
            cell.label6Right.text = selectedCrashModel?.crash_report_date ?? " "
            cell.label7Right.text = selectedCrashModel?.crash_report_time ?? " "
            cell.label8Right.text = selectedCrashModel?.self_injured ?? " "
            cell.label9Right.text = selectedCrashModel?.other_injured ?? " "
            cell.label10Right.text = selectedCrashModel?.number_of_injured_people ?? " "
            cell.label11Right.text = selectedCrashModel?.contacted_tmc ?? " "
            cell.label12Right.text = selectedCrashModel?.contacted_supervisor ?? " "
            cell.label13Right.text = selectedCrashModel?.you_inside_truck ?? " "
            cell.label14Right.text = selectedCrashModel?.safety_belt ?? " "
            
            
            var exteriorImagelist :[String] = []
            if let exteriorimg =  selectedCrashModel?.exterior_vehicle_photo1,exteriorimg.count > 0{
                exteriorImagelist.append(exteriorimg)
            }
            if let exteriorimg =  selectedCrashModel?.exterior_vehicle_photo2,exteriorimg.count > 0{
                exteriorImagelist.append(exteriorimg)
            }
            if let exteriorimg =  selectedCrashModel?.exterior_vehicle_photo3,exteriorimg.count > 0{
                exteriorImagelist.append(exteriorimg)
            }
            if let exteriorimg =  selectedCrashModel?.exterior_vehicle_photo4,exteriorimg.count > 0{
                exteriorImagelist.append(exteriorimg)
            }
            cell.ImageList_Exterior = exteriorImagelist
            
            var ineriorImagelist :[String] = []
            if let exteriorimg =  selectedCrashModel?.interior_vehicle_photo1,exteriorimg.count > 0{
                ineriorImagelist.append(exteriorimg)
            }
            if let exteriorimg =  selectedCrashModel?.interior_vehicle_photo2,exteriorimg.count > 0{
                ineriorImagelist.append(exteriorimg)
            }
            if let exteriorimg =  selectedCrashModel?.interior_vehicle_photo3,exteriorimg.count > 0{
                ineriorImagelist.append(exteriorimg)
            }
            if let exteriorimg =  selectedCrashModel?.interior_vehicle_photo4,exteriorimg.count > 0{
                ineriorImagelist.append(exteriorimg)
            }
            cell.ImageList_Interior = ineriorImagelist
            
            
            
            
            var vinImagelist :[String] = []
            if let exteriorimg =  selectedCrashModel?.autotag_vin_photo1,exteriorimg.count > 0{
                vinImagelist.append(exteriorimg)
            }
            if let exteriorimg =  selectedCrashModel?.autotag_vin_photo2,exteriorimg.count > 0{
                vinImagelist.append(exteriorimg)
            }
            if let exteriorimg =  selectedCrashModel?.autotag_vin_photo3,exteriorimg.count > 0{
                vinImagelist.append(exteriorimg)
            }
            if let exteriorimg =  selectedCrashModel?.autotag_vin_photo4,exteriorimg.count > 0{
                vinImagelist.append(exteriorimg)
            }
            cell.ImageList_AutoTagVIN = vinImagelist
            
            
            var thirdpartyImagelist :[String] = []
            if let exteriorimg =  selectedCrashModel?.third_party_vehicle_photo1,exteriorimg.count > 0{
                thirdpartyImagelist.append(exteriorimg)
            }
            if let exteriorimg =  selectedCrashModel?.third_party_vehicle_photo2,exteriorimg.count > 0{
                thirdpartyImagelist.append(exteriorimg)
            }
            if let exteriorimg =  selectedCrashModel?.third_party_vehicle_photo3,exteriorimg.count > 0{
                thirdpartyImagelist.append(exteriorimg)
            }
            if let exteriorimg =  selectedCrashModel?.third_party_vehicle_photo4,exteriorimg.count > 0{
                thirdpartyImagelist.append(exteriorimg)
            }
            cell.ImageList_ThirdPartyVehicle = thirdpartyImagelist
            
            
            cell.collectionViewExterior.reloadData()
            cell.collectionViewInterior.reloadData()
            cell.collectionViewAutoTagVIN.reloadData()
            cell.collectionViewThirdPartyVehicle.reloadData()
            
            
            cell.populatedata()
            
            
            
            return cell
        }else{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "CrashReportPassengerDetailCell", for: indexPath) as! CrashReportPassengerDetailCell
            
            let driverModel = selectedCrashModel?.driver_info?[indexPath.section - 1]
            let passengerMode = driverModel?.passenger_info?[indexPath.row]
            
            var data = "  "
            
            if let tempData = passengerMode?.name, tempData.count != 0
            {
                data = tempData
            }
            cell.label1Right.text = data
            
            data = "  "
            
            if let tempData = passengerMode?.passenger_phone, tempData.count != 0
            {
                data = tempData
            }
            cell.label2Right.text = data
            
            
            data = "  "
            
            if let tempData = passengerMode?.passenger_address, tempData.count != 0
            {
                data = tempData
            }
            cell.label3Right.text = data
            
            data = "  "
            
            if let tempData = passengerMode?.passenger_licence_number, tempData.count != 0
            {
                data = tempData
            }
            cell.label4Right.text = data
            
            data = "  "
            if let tempData = passengerMode?.is_injury, tempData.count != 0
            {
                data = tempData
            }
            cell.label5Right.text = data
            data = "  "
            cell.contanierView.layer.cornerRadius = 5
            cell.contanierView.layer.borderColor = AppthemeColor.cgColor
            cell.contanierView.layer.borderWidth = 2.0
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0){
            return nil
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CrashreportDriverDetailCell") as? CrashreportDriverDetailCell
            if cell != nil {
                
                if(section == 1){
                    cell?.driverScetionTop.constant = 10
                }else{
                    cell?.driverScetionTop.constant = -10
                }
                
                
                
                
                
                
                cell?.viewTitle.text = "Third Party Information Set \(section):"
                let driverModel = selectedCrashModel?.driver_info?[section - 1]
                
                var data = "  "
                
                if let tempData =  driverModel?.dirver_name, tempData.count != 0
                {
                    data = tempData
                }
                cell?.label1Right.text = data
                
                data = "  "
                
                if let tempData =  driverModel?.driver_phone, tempData.count != 0
                {
                    data = tempData
                }
                cell?.label2Right.text = data
                
                
                data = "  "
                
                if let tempData = driverModel?.driver_address, tempData.count != 0
                {
                    data = tempData
                }
                cell?.label3Right.text = data
                
                data = "  "
                
                if let tempData = driverModel?.driver_licence_number, tempData.count != 0
                {
                    data = tempData
                }
                cell?.label4Right.text = data
                
                data = "  "
                
                
                data = "  "
                
                if let tempData = driverModel?.vehicle_insurance_info , tempData.count != 0
                {
                    data = tempData
                }
                cell?.label5Right.text = data
                
                data = "  "
                
                if let tempData = driverModel?.insurance_expriary_date, tempData.count != 0
                {
                    data = tempData
                }
                cell?.label6Right.text = data
                
                
                if let tempData = driverModel?.insurance_expriary_date, tempData.count != 0
                {
                    data = tempData
                }
                cell?.label7Right.text = "No"
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (section == 0){
            return 0.1
        }else{
            return 355
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
