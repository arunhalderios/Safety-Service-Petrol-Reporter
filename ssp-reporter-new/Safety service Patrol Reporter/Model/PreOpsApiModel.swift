//
//  PreOpsModel.swift
//  Safety service Patrol Reporter
//
//  Created by Pritam Dey on 29/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import Foundation
class modelPreOps {
    func callUploadPreOpsUserInput(param: [String:AnyObject], isPreOps: Bool, completionHandler: @escaping(_ status:Int) ->()){
        let url = isPreOps ? API.savePreOpsReportData.getURL()?.absoluteString ?? "" :  API.saveInspectionData.getURL()?.absoluteString ?? ""
        print(param)
        
        let opt = WebServiceOperation.init(url, param)
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
    
    
    func callUploadPreOpsImages(imageArray: [MultiPartDataFormatStructure], companyID:String, isPreOps: Bool, completionHandler: @escaping(_ status:Int, _ imageName: String) ->()) {
        if Connectivity.isConnectedToInternet {
            var param:[String:AnyObject] = [String:AnyObject]()
            param["companyId"] = companyID as AnyObject
            
            let url = isPreOps ? API.preopsUploadimage.getURL()?.absoluteString ?? "" :  API.uploadInspectionImage.getURL()?.absoluteString ?? ""
            let opt = WebServiceOperation.init(url, param, .WEB_SERVICE_MULTI_PART, imageArray)
            
            opt.completionBlock = {
                DispatchQueue.main.async {
                    
                    guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                        return
                    }
                    if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                        if errorCode.intValue == 0 {
                            if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                                if  let imageArr = dictResult["data"] as? [String:Any] {
                                    let imageName = imageArr["file_name"] as? String
                                    completionHandler(0, imageName ?? "")
                                }else if let imageArr = dictResult["data"] as? [String], dictResult.count > 0{
                                     let image = imageArr[0]
                                        completionHandler(0, image )
                                    
                                }
                            }
                        }else{
                            completionHandler(1, "")
                            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                        }
                    }
                }
            }
            appDel.operationQueue.addOperation(opt)
            
            
        }else{
            completionHandler(1, "")
                PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
            }
        }
    
        
        
    }

