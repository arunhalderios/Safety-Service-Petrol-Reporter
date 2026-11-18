//
//  LocationManager.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 07/11/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class MyLocationManager: NSObject {
    static let share = MyLocationManager() //single tone class
   
    var internalTimer: Timer?
    var myCurrentLocaton:CLLocationCoordinate2D?
    var firstLocation :CLLocationCoordinate2D?
    let manager = CLLocationManager()
    var coordinatesArray = [Dictionary<String,String>]()
    //MARK: - Location Permission
    var distanceMile :Double = 0.0
    func requestForLocation(){
        //Code Process
        manager.requestAlwaysAuthorization()
       // manager.allowsBackgroundLocationUpdates = f
        print("Location granted")
    }
    
    func configManager(){
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.startUpdatingLocation()
        
    }
    
    func calculateGreaterDistanceIn1Miles() -> Bool{
//
//        let coordinateFirst = CLLocation(latitude:firstLocation?.latitude ?? 0.0, longitude:firstLocation?.longitude ?? 0.0)

        
            if let latLong = UserDefaults.standard.value(forKey: "Petrolling") as? [String:AnyObject]{
                let lat  = latLong["lat"] as? Double
                let long = latLong["long"] as? Double
                let coordinateFirst = CLLocation(latitude: lat ?? 0.0, longitude:long ?? 0.0)
                let coordinateLast = CLLocation(latitude: myCurrentLocaton?.latitude ?? 0.0, longitude:myCurrentLocaton?.longitude ?? 0.0)
                let distanceInMeters = coordinateFirst.distance(from: coordinateLast)
                distanceMile = distanceInMeters
                if(distanceInMeters > 1609)
                {
                    return true
                }
                else
                {
                    return false

                }
            }else{
                return false
            }



        
    }
   
}

extension MyLocationManager:  CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        myCurrentLocaton = manager.location?.coordinate
        if firstLocation == nil{
            firstLocation = manager.location?.coordinate
        }
      
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

extension MyLocationManager {
    func startTimer(){
        guard self.internalTimer == nil else {
            debugPrint("Already running")
            return
           // fatalError("Timer already intialized, how did we get here with a singleton?!")
        }
        //self.internalTimer = Timer.scheduledTimer(timeInterval: 60.0 , target: self, selector: #selector(fireTimerAction), userInfo: nil, repeats: true)
        
    }
    
    func stopTimer(){
        guard self.internalTimer != nil else {
            return
           // fatalError("No timer active, start the timer before you stop it.")
        }
        self.internalTimer?.invalidate()
        self.internalTimer = nil
    }
    
    @objc func fireTimerAction(sender: AnyObject?){
        
        //self.updateCurrentLocationToServer()
        debugPrint("Timer Fired! \(String(describing: sender))")
    }


   
    //MARK: - Call api to update location to server
    /*
    func updateCurrentLocationToServer(){
//        guard   let shiftID = UserDefaults.standard.string(forKey: "SHIFTID") else {
//            self.stopTimer()
//            return
//        }
//        guard  UserDefaults.standard.string(forKey: "SHIFTID") != "" else {
//            self.stopTimer()
//            return
//        }
        guard  self.calculateGreaterDistanceIn1Miles() == false else {
            self.stopTimer()
            return
        }
        let coordinateObj: Dictionary<String,String> = [
            "latitude": "\(myCurrentLocaton?.latitude ?? 0.00)",
            "longitude":"\(myCurrentLocaton?.longitude ?? 0.00)",
        ]
        self.coordinatesArray.append(coordinateObj)
        print(self.coordinatesArray)
        
        var param:[String:AnyObject] = [String:AnyObject]()
              param["coordinates"] = self.coordinatesArray as AnyObject
              //param["operator_shift_time_details_id"] = shiftID as AnyObject
              param["source"] = "MOB" as AnyObject
              if  let shiftId: String = UserDefaults.standard.value(forKey: "SHIFTID") as? String  {
              param["operator_shift_time_details_id"] = shiftId as AnyObject
              }
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                          // param["source"] = "MOB" as AnyObject
                           param["user_id"] = userId as AnyObject
        }else{
            param["user_id"] = "17" as AnyObject
         }
        if let vID:String = UserDefaults.standard.value(forKey: "VEHICLEID") as? String {
            if vID == ""{
                 param["vehicle_id"] = "25" as AnyObject
            }else{
            param["vehicle_id"] = vID as AnyObject
            }
        }else{
            param["vehicle_id"] = "25" as AnyObject
        }
        let opt = WebServiceOperation.init((API.gpsData.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        self.coordinatesArray.removeAll()
                        
                    }else{
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                    }
                }
            }
        }
        appDel.operationQueueBG.addOperation(opt)
    }
    */
    func callCloseIncident(incidentID:String){
        guard  self.calculateGreaterDistanceIn1Miles() == false else {
            
            return
        }
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            
            param["companyId"] = companyID as AnyObject
            
            
        }
        param["incidentStatus"] = "Closed" as AnyObject
        param["incidentReportId"] = incidentID as AnyObject
        let formatter = DateFormatter()
            //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
            //let defaultTimeZoneStr = formatter.string(from: date)
            //formatter.timeZone = NSTimeZone.local
         let date = Date()
            let utcTimeZoneStr = formatter.string(from: date)
            print(utcTimeZoneStr)
            param["timeUTC"] = utcTimeZoneStr as AnyObject
        param["timeUTC"] = utcTimeZoneStr as AnyObject
         
        let opt = WebServiceOperation.init((API.closeIncident.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber {
                    if errorCode.intValue == 0 {
                        
                    }else{
                        
                    }
                }
            }
        }
        appDel.operationQueueBG.addOperation(opt)
        
    }
}
