//
//  ShiftModel.swift
//  Safety service Patrol Reporter
//
//  Created by Pritam Dey on 17/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import Foundation
import UIKit

struct ShitStateList : Codable {
    let state_id : String?
    let state_name : String?
    enum CodingKeys: String, CodingKey {
        case state_id = "state_id"
        case state_name = "state_name"
    }

}


//MARK: - ShiftOperationAreaList -

struct ShiftOperationAreaList : Codable {
    let operation_area_name : String?
    let state_name : String?
    let company_name : String?
    let operationarea_id : String?
    let operationAreaStatus : String?

    enum CodingKeys: String, CodingKey {

        case operation_area_name = "operation_area_name"
        case state_name = "state_name"
        case company_name = "company_name"
        case operationarea_id = "operationarea_id"
        case operationAreaStatus = "operationAreaStatus"
    }

    
}


//MARK: - ShiftVehileList -
struct ShiftVehileList: Codable {
    let vehicle_id : String?
    let vehicle_type_id : String?
    let state_id : String?
    let operation_area_id : String?
    let company_id : String?
    let iD : String?
    let name : String?
    let make : String?
    let vin_number : String?
    let model : String?
    let registration_no : String?
    let color : String?
    let insurance_expiary_date : String?
    let state_inspection_expirary_date : String?
    let front_photo : String?
    let back_photo : String?
    let left_photo : String?
    let right_photo : String?
    let status : String?
    let created_by : String?
    let created_ts : String?
    let updated_by : String?
    let updated_ts : String?
    let is_delete : String?
    let vehicle_type_name : String?
    let state_name : String?
    

    enum CodingKeys: String, CodingKey {

        case vehicle_id = "vehicle_id"
        case vehicle_type_id = "vehicle_type_id"
        case state_id = "state_id"
        case operation_area_id = "operation_area_id"
        case company_id = "company_id"
        case iD = "ID"
        case name = "name"
        case make = "make"
        case vin_number = "vin_number"
        case model = "model"
        case registration_no = "registration_no"
        case color = "color"
        case insurance_expiary_date = "insurance_expiary_date"
        case state_inspection_expirary_date = "state_inspection_expirary_date"
        case front_photo = "front_photo"
        case back_photo = "back_photo"
        case left_photo = "left_photo"
        case right_photo = "right_photo"
        case status = "status"
        case created_by = "created_by"
        case created_ts = "created_ts"
        case updated_by = "updated_by"
        case updated_ts = "updated_ts"
        case is_delete = "is_delete"
        case vehicle_type_name = "vehicle_type_name"
        case state_name = "state_name"
    }

}

struct ShiftZone : Codable {
    let beats_zone_id : String?
    let beat_zone_name : String?
    let operationarea_id : String?
    let geo_fencing_radious : String?
    let state_id : String?
    let company_id : String?
    let status : String?
    let created_by : String?
    let created_ts : String?
    let updated_by : String?
    let updated_ts : String?
    let is_delete : String?
    let operation_area_name : String?
    let state_name : String?

    enum CodingKeys: String, CodingKey {

        case beats_zone_id = "beats_zone_id"
        case beat_zone_name = "beat_zone_name"
        case operationarea_id = "operationarea_id"
        case geo_fencing_radious = "geo_fencing_radious"
        case state_id = "state_id"
        case company_id = "company_id"
        case status = "status"
        case created_by = "created_by"
        case created_ts = "created_ts"
        case updated_by = "updated_by"
        case updated_ts = "updated_ts"
        case is_delete = "is_delete"
        case operation_area_name = "operation_area_name"
        case state_name = "state_name"
    }

    

}

class ShiftModel {
     
      var stateList:[ShitStateList]?
      var operationAreaList:[ShiftOperationAreaList]?
     var vehileList: [ShiftVehileList]?
     var zoneList: [ShiftZone]?
    var timelist:[TimeShift]?
    
    

    
    func callStateListApi(companyId: String, userId: String, completionHandler: @escaping(_ status:Int) ->()){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        param["companyId"] = companyId as AnyObject
        param["user_id"] = userId as AnyObject
        
        let opt = WebServiceOperation.init((API.StateList.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["stateList"] as? [[String:Any]] {
                            do {
                                self.stateList = try JSONDecoder().decode([ShitStateList].self,from:(listArray.data)!)
                                if self.stateList?.count ?? 0 > 0{
                                    completionHandler(0)
                                }else{
                                    completionHandler(1)
                                }
                                
                             }
                            catch {
                                print(error)
                                completionHandler(1)
                            }
                        }
                        }
                    }else{
                        completionHandler(1)
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                    }
                }
            }
        }
        appDel.operationQueue.addOperation(opt)
        
    }
    
    
    
    
    func callOperationListApi(companyId: String, userId: String,stateId: String, completionHandler: @escaping(_ status:Int) ->()){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        param["companyId"] = companyId as AnyObject
        param["user_id"] = userId as AnyObject
        param["stateId"] = stateId as AnyObject
        
        let opt = WebServiceOperation.init((API.OperationAreaList.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["data"] as? [[String:Any]] {
                                do {
                                    self.operationAreaList = try JSONDecoder().decode([ShiftOperationAreaList].self,from:(listArray.data)!)
                                    if self.operationAreaList?.count ?? 0 > 0{
                                         completionHandler(0)
                                    }else{
                                        completionHandler(1)
                                    }
                                   
                                }
                                catch {
                                    print(error)
                                    completionHandler(1)
                                }
                            }
                        }
                    }else{
                        completionHandler(1)
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                    }
                }
            }
        }
       appDel.operationQueue.addOperation(opt)
        
    }
    
    
    
    func callZoneListApi(companyId: String, userId: String , stateId: String, operationAreaId: String, completionHandler: @escaping(_ status:Int) ->()){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        param["companyId"] = companyId as AnyObject
        param["user_id"] = userId as AnyObject
        param["stateId"] = stateId as AnyObject
        param["operationAreaId"] = operationAreaId as AnyObject
        
        let opt = WebServiceOperation.init((API.ZoneList.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["data"] as? [[String:Any]] {
                                do {
                                    self.zoneList = try JSONDecoder().decode([ShiftZone].self,from:(listArray.data)!)
                                    if self.zoneList?.count ?? 0 > 0{
                                        completionHandler(0)
                                    }else{
                                        completionHandler(1)
                                    }
                                }
                                catch {
                                    print(error)
                                    completionHandler(1)
                                }
                            }
                        }
                    }else{
                        completionHandler(1)
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                    }
                }
            }
        }
        appDel.operationQueue.addOperation(opt)
        
    }
    
    func callTimeListApi(companyId: String, userId: String, completionHandler: @escaping(_ status:Int) ->()){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        param["companyId"] = companyId as AnyObject
        param["user_id"] = userId as AnyObject
        
        let opt = WebServiceOperation.init((API.getOperationShift.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["data"] as? [[String:Any]] {
                                do {
                                    self.timelist = try JSONDecoder().decode([TimeShift].self,from:(listArray.data)!)
                                    if self.timelist?.count ?? 0 > 0{
                                        completionHandler(0)
                                    }else{
                                        completionHandler(1)
                                    }
                                    
                                }
                                catch {
                                    print(error)
                                    completionHandler(1)
                                }
                            }
                        }
                    }else{
                        completionHandler(1)
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                    }
                }
            }
        }
        appDel.operationQueue.addOperation(opt)
        
    }
    
    
    func callVehicleListListApi(companyId: String, userId: String, stateID: String, operationID: String, completionHandler: @escaping(_ status:Int) ->()){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        param["companyId"] = companyId as AnyObject
        param["user_id"] = userId as AnyObject
        param["stateId"] = stateID as AnyObject
        param["operation_area_id"] = operationID as AnyObject
        print(param)
        let opt = WebServiceOperation.init((API.VehicleList.getURL()?.absoluteString ?? ""), param)
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
                                    self.vehileList = try JSONDecoder().decode([ShiftVehileList].self,from:(listArray.data)!)
                                    if self.vehileList?.count ?? 0 > 0{
                                    completionHandler(0)
                                    }else{
                                        completionHandler(1)
                                    }
                                }
                                catch {
                                    print(error)
                                    completionHandler(1)
                                }
                            }
                        }
                    }else{
                        completionHandler(1)
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                    }
                }
            }
        }
        appDel.operationQueue.addOperation(opt)
        
    }
    
    
    
    func callStartShiftApi(companyId: String, userId: String, vehicleID: String,stateId:String, operationarea: String, bitaZoneID: String,shiftTimeID:String, completionHandler: @escaping(_ status:Int) ->()){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        param["companyId"] = companyId as AnyObject
        param["user_id"] = userId as AnyObject
        param["vehicle_id"] = vehicleID as AnyObject
        param["state_id"] = stateId as AnyObject
        param["operationarea_id"] = operationarea as AnyObject
        param["beats_zone_id"] = bitaZoneID as AnyObject
        param["status"] = "1" as AnyObject
        param["operationShifttimeId"] = shiftTimeID as AnyObject
        //param["operator_shift_time_details_id"] = shiftTimeDetailsID as AnyObject
        if let shiftID = UserDefaults.standard.value(forKey: "SHIFTID"){
            param["operator_shift_time_details_id"] = "\(shiftID)" as AnyObject
        }else{
            param["operator_shift_time_details_id"] = "" as AnyObject
        }
        
        print(param)
        
        let opt = WebServiceOperation.init((API.StartShift.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if let details = dictResult["details"] as? [String:Any] {
                                if  let ShiftID = details["operator_shift_time_details_id"]  {
                                    UserDefaults.standard.set(ShiftID, forKey: "SHIFTID")
                                    if let vehicleID = details["vehicleId"]{
                                    UserDefaults.standard.set(vehicleID, forKey: "VEHICLENAME")
                                    }
                                    completionHandler(0)
                                }
                            }
                        }
                    }else{
                        completionHandler(1)
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                    }
                }
            }
        }
        appDel.operationQueue.addOperation(opt)
        
    }
    
    
}
