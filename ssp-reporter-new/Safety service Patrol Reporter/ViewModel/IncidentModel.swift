//
//  IncidentModel.swift
//  Safety service Patrol Reporter
//
//  Created by Pritam Dey on 22/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import Foundation

class IncidentModel {
    var incidentdetailsArray: [IncidentDetailsDataModel]? 
    
       func callIncidentDetails(companyId: String, userId: String, operationId: String, completionHandler: @escaping(_ status:Int) ->()){
            var param:[String:AnyObject] = [String:AnyObject]()
            param["source"] = "MOB" as AnyObject
            param["companyId"] = companyId as AnyObject
            param["user_id"] = userId as AnyObject
            //param["operationId"] = operationId as AnyObject // temporarily closed.
        print(param)
  
           let opt = WebServiceOperation.init((API.IncidentsDetails.getURL()?.absoluteString ?? ""), param)
           opt.completionBlock = {
               DispatchQueue.main.async {
                   print(opt.responseData?.dictionary)
                   guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                       return
                   }
                   if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                       if errorCode.intValue == 0 {
                           if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                               if  let listArray = dictResult["data"] as? [[String:Any]] {
                                   do {
                                     
                                       self.incidentdetailsArray = try JSONDecoder().decode([IncidentDetailsDataModel].self,from:(listArray.data)!)
                                    print(self.incidentdetailsArray)
                                       completionHandler(0)
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
       
      //http://dev.fitser.com:3794/ATIMS/api/incidentStatusUpdate
    func callIncidentStatusUpdate(companyId: String, userId: String,IncidentsReportId:String, Status:String,denyReason:String = "", completionHandler: @escaping(_ status:Int) ->()){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        param["companyId"] = companyId as AnyObject
        param["userId"] = userId as AnyObject
        param["incidentsReportId"] = IncidentsReportId as AnyObject
        param["incident_status"] = Status as AnyObject
        param["deny_reason"] = denyReason as AnyObject
        let date = Date()
           print("vehicleID=====%@",UserDefaults.standard.value(forKey: "VEHICLEID") as? String)
            
            let formatter = DateFormatter()
            //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
            //let defaultTimeZoneStr = formatter.string(from: date)
            //formatter.timeZone = NSTimeZone.local
            let utcTimeZoneStr = formatter.string(from: date)
            print(utcTimeZoneStr)
            param["timeUTC"] = utcTimeZoneStr as AnyObject
        print(param)
        
        
        let opt = WebServiceOperation.init((API.IncidentStatusUpdate.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                       completionHandler(0)
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
