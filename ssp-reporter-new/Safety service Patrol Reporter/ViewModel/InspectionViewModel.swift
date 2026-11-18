//
//  InspectionViewModel.swift
//  Safety service Patrol Reporter
//
//  Created by Pritam Dey on 30/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import Foundation
class InspectionViewModel {
    
    var inspectionObject: InspectionDataModel?
      
    func callInspectionViewDetails(companyId: String, userId: String, inspectionReportId: String, completionHandler: @escaping(_ status:Int) ->()){
             var param:[String:AnyObject] = [String:AnyObject]()
             param["inspectionReportId"] = inspectionReportId as AnyObject
             param["companyId"] = companyId as AnyObject
             param["userId"] = userId as AnyObject
    
             let opt = WebServiceOperation.init((API.inspectionReport.getURL()?.absoluteString ?? ""), param)
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
                                        print(listArray)
                                         self.inspectionObject = try JSONDecoder().decode(InspectionDataModel.self,from:(listArray.data)!)
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
}
