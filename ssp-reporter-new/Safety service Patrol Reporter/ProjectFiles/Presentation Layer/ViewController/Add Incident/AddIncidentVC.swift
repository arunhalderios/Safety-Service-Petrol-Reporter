//
//  AddIncidentVC.swift
//  Safety service Patrol Reporter
//
//  Created by Subha on 11/23/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit
import CoreLocation
import RSSelectionMenu

class AddIncidentVC: BaseViewController,UITextViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate {
    let arrayTitle = ["Latitude","Longitude","Call At","Call Started","Call Completed","Incident Time","Incident type *","Route *","Traffic Direction*","Mile Marker *","State","Property Damage*","Secondary crash involved","First Responders on scene?","First Responder Information","Road Surface *","Lane Location *","Passengers Transported in SSP Truck","Vendor","Contract","Assist Type *","Number of Vehicles involved in Incident *","","Comments","Next"]
       let numberVehicle = ["1","2","3","4","5","6","7","8","9","10"]//,"11","12","13","14","15","16","17","18","19","20"]
       let roadSurface = ["Paved", "Gravel", "Wet", "Icey", "Debris","Not an open text"]
       var laneLoc = ["Left Shoulder", "Left Lane", "Middle Lane", "Right Lane", "Right Shoulder","Gore"]
       
       //["Left Shoulder", "Left Lane", "Middle Lane", "Right Lane", "Right Shoulder"]
       let passangerTransported = ["Not Applicable", "1", "2", "3", "4"]
       var arrayDescription = ["Motor Vehicle Accident", "Safety Service Operator-Roadside Assistance","Debris in Road","Disabled Vehicle"]
       var arrayDirection = ["One Direction", "Both Directions"]
       @IBOutlet weak var tableIncident: UITableView!
       @IBOutlet weak var labelTitle: UILabel!
       var locationManager: CLLocationManager = CLLocationManager()
       var pageFor = ""
       var modelIncidence:IncidentDetailsDataModel?
       var arrayValues :[String] = []
       var stateList:[ShitStateList] = []
       var colorList:[Colors] = []
       //var firstResponderList:[FirstResponder] = []
       var firstResponderList:[String] = ["Yes","No"]
       var trafficdirectionList:[TrafficDirection] = []
       var routeList:[Routes] = []
       var secondaryCrashList:[SecondaryCrash] = []
       var propertyList:[PropertyDamage] = []
       var asystList:[AsysteType] = []
       var incidenceTypeList:[IncidenceType] = []
       var vehicleTypeList :[VehicleType] = []
       var responderUnitList :[ResponderUnit] = []
       var arrayVenderList:[VenderIncident] = []
       var arrayContractList:[ContractList] = []
       var arrayTotalVehicles:[TotalVehiclesObject] = []
       var arrayMotoristType:[MotoristType] = []
       var isSelected = false
       var arrayPopulate: [String] = []
       var isSelectLicensePlate = 0
       var isDispatched = true
       var cellSelectionStyle: CellSelectionStyle = .tickmark
       var isSectionVehicle:Bool = false
       var selectedIndexpath:IndexPath = IndexPath(row: 0, section: 22)
       
    @IBOutlet weak var txtIncidentType: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            locationManager.startUpdatingLocation()
        }else{
            locationManager.startUpdatingLocation()
        }
        if pageFor == "Update"{
            self.labelTitle.text = "UPDATE INCIDENT"
        }
        DispatchQueue.global(qos: .background).async {
            
            //self.callStateListApi()
            self.callColorListApi()
            //self.callFirstResponderListApi()
            self.calldirectionListApi()
            self.callRouteListApi()
            self.callPropertyListApi()
            self.callSecondarycrashListApi()
            self.callIncidenceTypeListApi()
            self.callAsystTypeListApi()
            self.callVehicleListApi()
            //self.callLaneLocApi()
            self.callVenderListApi()
            self.callContractListApi()
            self.callMotorTypeListApi()
            
            print(self.arrayValues.count)
//            DispatchQueue.main.async {
//                if let state = UserDefaults.standard.value(forKey: "STATENAME") as? String{
//                    
//                    if let stateID = UserDefaults.standard.value(forKey: "STATEID") as? String{
//                    
//                        self.arrayValues[CELL_CONTENT.State.rawValue] = stateID
//                    }
//                    self.arrayPopulate[CELL_CONTENT.State.rawValue] = state
//                }
//                self.tableIncident.reloadData()
//                if self.pageFor == "Update"{
//                    self.populateData()
//                }else{
//                    self.arrayValues[CELL_CONTENT.Number_of_Vehicles.rawValue] = "1"
//                    self.arrayPopulate[CELL_CONTENT.Number_of_Vehicles.rawValue] = "1"
//                    let objVehicle = TotalVehiclesObject()
//                    self.arrayTotalVehicles.append(objVehicle)
//                    self.tableIncident.reloadData()
//                    
//                }
//            }
        }
        
        // Do any additional setup after loading the view.
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
extension AddIncidentVC{
    
    func callStateListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["companyId"] = companyID as AnyObject
                param["user_id"] = userId as AnyObject
            }
            
        }
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
                                    print("Success State")
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
        
    }
    
    func callLaneLocApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.getLaneLocation.getURL()?.absoluteString ?? ""), param)
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
                                   // self.laneLoc = try JSONDecoder().decode([LaneLocation].self,from:(listArray.data)!)
                                    print("Success Color")
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
        
    }
    func callColorListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.colorList.getURL()?.absoluteString ?? ""), param)
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
                                    self.colorList = try JSONDecoder().decode([Colors].self,from:(listArray.data)!)
                                    print("Success Color")
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
        
    }
    
    func callFirstResponderListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.firstresponderList.getURL()?.absoluteString ?? ""), param)
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
                                    //self.firstResponderList = try JSONDecoder().decode([FirstResponder].self,from:(listArray.data)!)
                                    print("Success First Responder")
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
        
    }
    func calldirectionListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.trafficdirectionList.getURL()?.absoluteString ?? ""), param)
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
                                    self.trafficdirectionList = try JSONDecoder().decode([TrafficDirection].self,from:(listArray.data)!)
                                    print("Success call direction")
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
        
    }
    
    func callRouteListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            
            param["companyId"] = companyID as AnyObject
            
            
        }
        if let shiftID = UserDefaults.standard.value(forKey: "SHIFTID"){
            param["shiftId"] = shiftID as AnyObject
        }else{
            param["shiftId"] = "1" as AnyObject
        }
        let opt = WebServiceOperation.init((API.getRouteList.getURL()?.absoluteString ?? ""), param)
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
                                    self.routeList = try JSONDecoder().decode([Routes].self,from:(listArray.data)!)
                                    print("Success Route")
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
        
    }
    func callSecondarycrashListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.SecondarycrashList.getURL()?.absoluteString ?? ""), param)
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
                                    self.secondaryCrashList = try JSONDecoder().decode([SecondaryCrash].self,from:(listArray.data)!)
                                    print("Success Secondary")
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
        
    }
    func callMotorTypeListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            
            param["companyId"] = companyID as AnyObject
            
            
        }
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
            param["user_id"] = userId as AnyObject
        }
        let opt = WebServiceOperation.init((API.MotorType.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
               // print(opt.responseData?.dictionary)
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["data"] as? [[String:Any]] {
                                do {
                                    self.arrayMotoristType = try JSONDecoder().decode([MotoristType].self,from:(listArray.data)!)
                                    print("Success Property")
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
        
    }
    
    func callPropertyListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.propertydamageList.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
               // print(opt.responseData?.dictionary)
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["data"] as? [[String:Any]] {
                                do {
                                    self.propertyList = try JSONDecoder().decode([PropertyDamage].self,from:(listArray.data)!)
                                    print("Success Property")
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
        
    }
    
    func callAsystTypeListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["user_id"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.assistList.getURL()?.absoluteString ?? ""), param)
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
                                    self.asystList = try JSONDecoder().decode([AsysteType].self,from:(listArray.data)!)
                                    print("Success Asyst")
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
        
    }
    func callContractListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["userId"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.contractList.getURL()?.absoluteString ?? ""), param)
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
                                    self.arrayContractList = try JSONDecoder().decode([ContractList].self,from:(listArray.data)!)
                                    print("Success Incidence Type")
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
        
    }
    func callVenderListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["user_id"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.VenderList.getURL()?.absoluteString ?? ""), param)
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
                                    self.arrayVenderList = try JSONDecoder().decode([VenderIncident].self,from:(listArray.data)!)
                                    print("Success Incidence Type")
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
        
    }
    
    func callIncidenceTypeListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["user_id"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.incidenttypeList.getURL()?.absoluteString ?? ""), param)
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
                                    self.incidenceTypeList = try JSONDecoder().decode([IncidenceType].self,from:(listArray.data)!)
                                    print("Success Incidence Type")
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
        
    }
    
    func callVehicleListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["user_id"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.vehicletypeList.getURL()?.absoluteString ?? ""), param)
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
                                    self.vehicleTypeList = try JSONDecoder().decode([VehicleType].self,from:(listArray.data)!)
                                    print("Success Incidence Type")
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
        
    }
    func callResponderUnitListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["user_id"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.ResponderUnit.getURL()?.absoluteString ?? ""), param)
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
                                    self.responderUnitList = try JSONDecoder().decode([ResponderUnit].self,from:(listArray.data)!)
                                    
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
        
    }
    
    
}
