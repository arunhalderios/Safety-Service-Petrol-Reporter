//
//  AddIncidentFormVC.swift
//  ATIMS
//
//  Created by Mahesh Prasad Mahaliik on 17/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit
import CoreLocation
import RSSelectionMenu
import Alamofire
import SwiftyJSON

class TotalVehiclesObject :NSObject{
    var vehicleType:String = ""
    var vehicleTypeID:String = ""
    var vehicleColorName:String = ""
    var vehicleColorID:String = ""
    var vehicleLincense:String = ""
}
class AddIncidentFormVC: BaseViewController,UITextViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate {
    let arrayTitle = ["Latitude","Longitude","Call At","Call Started","Call Completed","Incident Time","Incident type *","Route *","Traffic Direction*","Mile Marker *","State","Property Damage*","Secondary crash involved","First Responders on scene?","First Responder Information","Road Surface *","Lane Location *","Passengers Transported in SSP Truck","Vendor","Contract","Assist Type *","Number of Vehicles involved in Incident *","","Resolution","Travel Lanes Blocked","Lane restoration time","Next","",""]
    let numberVehicle = ["0","1","2","3","4","5","6","7","8","9","10"]//,"11","12","13","14","15","16","17","18","19","20"]
    let roadSurface = ["Wet","Dry"]//["Paved", "Gravel", "Wet", "Icey", "Debris","Not an open text"]
    var laneLoc = ["Left Shoulder", "Left Lane", "Middle Lane", "Right Lane", "Right Shoulder","Gore"]
    var arraySelectedRoadSurface : [String] = []
    var arraySelectedLaneLocation :[String] = []
    var arrayFileInfo : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    
    //["Left Shoulder", "Left Lane", "Middle Lane", "Right Lane", "Right Shoulder"]
    let passangerTransported = ["Not Applicable", "1", "2", "3", "4"]
    var arrayDescription = ["Motor Vehicle Accident", "Safety Service Operator-Roadside Assistance","Debris in Road","Disabled Vehicle"]
    @IBOutlet weak var txtIncidentType: UITextField!
    var arrayDirection = ["One Direction", "Both Directions"]
    var arrayRamplanes = ["Glen Cove Rd-Roude 110", "Little Neck Pkwy - Route 106/107", "Motor Parkway - Route 112", "Round Swamp Road -- Route 454", "Route 27 - NSP", "SSP - NSP"]//["Exit Ramp","On Ramp"]
    @IBOutlet weak var viewText: UIView!
    @IBOutlet weak var tableIncident: UITableView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var vw_LaneLocation: UIView!
    @IBOutlet weak var tbleVw_LaneLocation: UITableView!
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
    var arrayFormList:[IncidenceFormList] = []
    var arraySortFormList:[IncidenceFormList] = []
    var getIncidentTypeId:String = ""
    var getIncidenceType: String = ""
    
    var selectedArray = NSMutableArray()
    var selectedIndexArray = NSMutableArray()
    var laneLocArray = [JSON]()
    
    fileprivate enum CELL_CONTENT:Int{
        case Latitude = 0
        case Longitude
        case Call_At
        case Call_Started
        case Call_Completed
        case Incident_Time
        case Incident_type
        case Route_1
        case Mile_Marker
        case Traffic_Direction
        case State
        case Property_Damage
        case Secondary_crash_involved
        case First_Responder
        case First_Responder_Unit_Number
        case Road_Surface
        case Lane_Location
        case Passengers_Transported
        case Assist_Type
        case Contract
        case Vendor
        case Ramplanes
        case Number_of_Vehicles
        case Comments
        case TotalVehicles
        case TravelLanesBlocked
        case LaneRestorationTime
        case IncidentNo
        case Photo
        case video
        case Notes
        case CELL_RESET_CONTENT_TOTAL
        func getPlaceholder () -> String {
            switch self {
            case .Latitude:
                return "Enter value"
            case .Longitude:
                return "Enter value"
            case .Call_At:
                return "Enter value"
            case .Call_Started:
                return "Enter value"
            case .Call_Completed:
                return "Enter value"
            case .Incident_Time:
                return "Enter value"
            case .Incident_type:
                return "Enter value"
            case .Route_1:
                return "Enter value"
            case .Traffic_Direction:
                return "Enter value"
            case .Mile_Marker:
                return "Enter value"
            //case .Plate_Number:
              //  return "Enter value"
            case .State:
                return "Enter value"
            case .Property_Damage:
                return "Enter value"
            case .Secondary_crash_involved:
                return "Enter value"
            case .First_Responder:
                return "Enter value"
            case .First_Responder_Unit_Number:
                return "Enter value"
            case .Road_Surface:
                return "Enter value"
            case .Lane_Location:
                return "Enter value"
            case .Passengers_Transported:
                return "Enter value"
            case .Vendor:
               return "Enter value"
            case .Contract:
                 return "Enter value"
            case .Assist_Type:
                return "Enter value"
            case .Ramplanes:
                return "Enter value"
            case .Number_of_Vehicles:
                return "Enter value"
            case .Comments:
                return "Enter value"
            case .TravelLanesBlocked:
                return "Enter value"
            case .LaneRestorationTime:
                return "Enter value"
            case .IncidentNo:
                return "Enter value"
          
//            case .Description:
//                return "Enter value"

            default:
                return ""
            }
        }
    }
    
    @IBAction func LaneLocaOKButtonAction(_ sender: UIButton) {

        
        let result = selectedArray as! [String]
        //arrayValues = selectedIndexArray as! [String]
        self.arrayPopulate[CELL_CONTENT.Lane_Location.rawValue] = result.joined(separator: ", ")
        self.arrayValues[CELL_CONTENT.Lane_Location.rawValue] = result.joined(separator: ", ")
        self.vw_LaneLocation.isHidden = true
        self.tableIncident.reloadData()
    }
    
    
    @IBAction func LaneLocaCancelButtonAction(_ sender: UIButton) {
        self.vw_LaneLocation.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableIncident.separatorStyle = .none
        self.txtIncidentType.tag = 2000
        viewText.layer.borderWidth = 2.0
        viewText.layer.borderColor = AppthemeColor.cgColor
        viewText.layer.cornerRadius = viewText.frame.height / 2
        self.createPickerView(textField: self.txtIncidentType)
        if pageFor.lowercased() == "update"{
            self.labelTitle.text = "UPDATE INCIDENT"
            //self.labelTitle.text = "Ind#\(self.modelIncidence?.incedent_type_id!)"
            modelIncidence?.traffic_direction = nil //21/09/22
            modelIncidence?.travelLanesBlocked = nil //21/09/22
        }
        DispatchQueue.global(qos: .background).async {
            for _ in 0...CELL_CONTENT.CELL_RESET_CONTENT_TOTAL.rawValue - 1{
                
                self.arrayValues.append("")
                self.arrayPopulate.append("")
            }
            
            //self.callAllIncidenceListApi()
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
            if self.getIncidenceType == ""{
                
            }else{
               
                self.callAllIncidenceListApi()
            }
            
            print(self.arrayValues.count)
            DispatchQueue.main.async {
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.delegate = self
                       if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                           CLLocationManager.authorizationStatus() == .authorizedAlways) {
                        self.locationManager.startUpdatingLocation()
                       }else{
                        self.locationManager.startUpdatingLocation()
                       }
                if let state = UserDefaults.standard.value(forKey: "STATENAME") as? String{
                    
                    if let stateID = UserDefaults.standard.value(forKey: "STATEID") as? String{
                    
                        self.arrayValues[CELL_CONTENT.State.rawValue] = stateID
                    }
                    self.arrayPopulate[CELL_CONTENT.State.rawValue] = state
                }
               
                self.arrayValues[CELL_CONTENT.First_Responder.rawValue] = "No"
                self.arrayPopulate[CELL_CONTENT.First_Responder.rawValue] = "No"
                
                self.arrayPopulate[CELL_CONTENT.Secondary_crash_involved.rawValue] = self.secondaryCrashList[safe:1]?.crash_Inv ?? ""
                self.arrayValues[CELL_CONTENT.Secondary_crash_involved.rawValue] = self.secondaryCrashList[safe:1]?.crash_Inv_id ?? ""
                
               // self.arrayPopulate[CELL_CONTENT.Secondary_crash_involved.rawValue] = "No"
                self.arrayPopulate[CELL_CONTENT.Incident_type.rawValue] = self.getIncidenceType
                self.arrayValues[CELL_CONTENT.Incident_type.rawValue] = self.getIncidentTypeId
                //self.tableIncident.reloadData()
                if self.pageFor.lowercased() == "update"{
                    self.tableIncident.delegate = self
                    self.tableIncident.dataSource = self
                    self.tableIncident.estimatedRowHeight = 130.0
                    self.tableIncident.rowHeight = UITableView.automaticDimension
                    self.populateData()
                }else{
                    self.tableIncident.delegate = self
                    self.tableIncident.dataSource = self
                    self.arrayValues[CELL_CONTENT.Number_of_Vehicles.rawValue] = "0"
                    self.arrayPopulate[CELL_CONTENT.Number_of_Vehicles.rawValue] = "0"
//                    let objVehicle = TotalVehiclesObject()
//                    self.arrayTotalVehicles.append(objVehicle)
                   // self.tableIncident.reloadData()
                    self.tableIncident.estimatedRowHeight = 130.0
                    self.tableIncident.rowHeight = UITableView.automaticDimension
                    
                    
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
        addTimeOutTimer()
        if getIncidenceType == ""{
            self.txtIncidentType.text = "Select"
        }else{
            self.txtIncidentType.text = getIncidenceType
            self.callAllIncidenceListApi()
            if modelIncidence?.lane_location_id != ""{
               let result = modelIncidence?.lane_location_id
                print(result as Any)
                if result != nil{
                    let array = result!.components(separatedBy: ", ")
                    print(array)
                    if array.count > 0{
                        for i in 0...array.count-1{
                            selectedArray.add(array[i])
                            if laneLoc.count > 0{
                                let res = laneLoc.firstIndex(of: array[i])
                                if res != nil{
                                    selectedIndexArray.add(res!)
                                }
                            }
                        }
                    }
                }                
            }
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        let cell = tableIncident.cellForRow(at: IndexPath(row:0 , section: CELL_CONTENT.Comments.rawValue)) as? IncidentButtomCell
//        if cell != nil {
//            cell?.btnNext.roundedView()
//        }
    }
    
    func populateIDs(){
        let latitude = String(MyLocationManager.share.myCurrentLocaton?.latitude ?? 0.0)
        let longitude = String(MyLocationManager.share.myCurrentLocaton?.longitude ?? 0.0)
        arrayValues[CELL_CONTENT.Latitude.rawValue] = latitude
        arrayValues[CELL_CONTENT.Longitude.rawValue] = longitude
        arrayValues[CELL_CONTENT.Call_At.rawValue] = modelIncidence?.call_at ?? ""
        arrayValues[CELL_CONTENT.Call_Started.rawValue] = modelIncidence?.call_started ?? ""
        arrayValues[CELL_CONTENT.Call_Completed.rawValue] = modelIncidence?.call_completed ?? ""
        arrayValues[CELL_CONTENT.Incident_Time.rawValue] = modelIncidence?.incedent_time ?? ""
        arrayValues[CELL_CONTENT.Incident_type.rawValue] = modelIncidence?.incedent_type_id ?? ""
        arrayValues[CELL_CONTENT.Route_1.rawValue] = modelIncidence?.route_id ?? ""
        arrayValues[CELL_CONTENT.Traffic_Direction.rawValue] = modelIncidence?.traffic_direction_id ?? ""
       // arrayValues[CELL_CONTENT.Mileage_In.rawValue] = modelIncidence?.milage_in ?? ""
       // arrayValues[CELL_CONTENT.Mileage_Out.rawValue] = modelIncidence?.milage_out ?? ""
        arrayValues[CELL_CONTENT.Mile_Marker.rawValue] = modelIncidence?.mile_marker ?? ""
        arrayValues[CELL_CONTENT.State.rawValue] = modelIncidence?.state_id ?? ""
        arrayValues[CELL_CONTENT.Property_Damage.rawValue] =  modelIncidence?.property_damage_id ?? "2"
        arrayValues[CELL_CONTENT.Secondary_crash_involved.rawValue] = modelIncidence?.crash_Inv_id ?? "2"
        arrayValues[CELL_CONTENT.First_Responder.rawValue] = modelIncidence?.first_responder_id ?? "2"
        arrayValues[CELL_CONTENT.First_Responder_Unit_Number.rawValue] = modelIncidence?.first_responder_unit_number ?? ""
        arrayValues[CELL_CONTENT.Road_Surface.rawValue] = modelIncidence?.road_surface ?? ""
        arrayValues[CELL_CONTENT.Lane_Location.rawValue] = modelIncidence?.lane_location_name ?? ""
        arrayValues[CELL_CONTENT.Passengers_Transported.rawValue] = modelIncidence?.passenger_transported ?? ""
        arrayValues[CELL_CONTENT.Number_of_Vehicles.rawValue] = modelIncidence?.number_of_vehicle ?? ""
        arrayValues[CELL_CONTENT.Comments.rawValue] = modelIncidence?.comments ?? ""
        arrayValues[CELL_CONTENT.Vendor.rawValue] = modelIncidence?.vendor_id ?? ""
        arrayValues[CELL_CONTENT.Contract.rawValue] = modelIncidence?.contract_id ?? ""
        arrayValues[CELL_CONTENT.Assist_Type.rawValue] = modelIncidence?.assist_type_id ?? ""
        arrayValues[CELL_CONTENT.LaneRestorationTime.rawValue] = modelIncidence?.laneRestorationTime ?? ""
        arrayValues[CELL_CONTENT.TravelLanesBlocked.rawValue] = modelIncidence?.travelLanesBlocked ?? ""
        arrayValues[CELL_CONTENT.IncidentNo.rawValue] = modelIncidence?.incidentNo ?? ""
        arrayValues[CELL_CONTENT.Notes.rawValue] = modelIncidence?.note ?? ""
        self.prepareVehicleObject()
        
    }
    
    func populateData(){
        self.populateIDs()
        let latitude = String(MyLocationManager.share.myCurrentLocaton?.latitude ?? 0.0)
        let longitude = String(MyLocationManager.share.myCurrentLocaton?.longitude ?? 0.0)
        arrayPopulate[CELL_CONTENT.Latitude.rawValue] = latitude
        arrayPopulate[CELL_CONTENT.Longitude.rawValue] = longitude
        arrayPopulate[CELL_CONTENT.Call_At.rawValue] = modelIncidence?.call_at ?? ""
        arrayPopulate[CELL_CONTENT.Call_Started.rawValue] = modelIncidence?.call_started ?? ""
        arrayPopulate[CELL_CONTENT.Call_Completed.rawValue] = modelIncidence?.call_completed ?? ""
        arrayPopulate[CELL_CONTENT.Incident_Time.rawValue] = modelIncidence?.incedent_time ?? ""
        arrayPopulate[CELL_CONTENT.Incident_type.rawValue] = modelIncidence?.incident_type_name ?? ""
        arrayPopulate[CELL_CONTENT.Route_1.rawValue] = modelIncidence?.route_name ?? ""
        arrayPopulate[CELL_CONTENT.Traffic_Direction.rawValue] = modelIncidence?.traffic_direction ?? ""
        arrayPopulate[CELL_CONTENT.Vendor.rawValue] = modelIncidence?.vendor_name ?? ""
        arrayPopulate[CELL_CONTENT.Contract.rawValue] = modelIncidence?.contract_name ?? ""
        arrayPopulate[CELL_CONTENT.Mile_Marker.rawValue] = modelIncidence?.mile_marker ?? ""
        arrayPopulate[CELL_CONTENT.State.rawValue] = modelIncidence?.state_name ?? ""
        arrayPopulate[CELL_CONTENT.Property_Damage.rawValue] = modelIncidence?.property_damage ?? ""
        arrayPopulate[CELL_CONTENT.Secondary_crash_involved.rawValue] = modelIncidence?.secendary_cash_involve ?? ""
        arrayPopulate[CELL_CONTENT.First_Responder.rawValue] = modelIncidence?.first_responder ?? ""
        arrayPopulate[CELL_CONTENT.First_Responder_Unit_Number.rawValue] = modelIncidence?.first_responder_unit_number ?? ""
        arrayPopulate[CELL_CONTENT.Road_Surface.rawValue] = modelIncidence?.road_surface ?? ""
        arrayPopulate[CELL_CONTENT.Lane_Location.rawValue] = modelIncidence?.lane_location_name ?? ""
        arrayPopulate[CELL_CONTENT.Passengers_Transported.rawValue] = modelIncidence?.passenger_transported ?? ""
        arrayPopulate[CELL_CONTENT.Number_of_Vehicles.rawValue] = modelIncidence?.number_of_vehicle ?? ""
        arrayPopulate[CELL_CONTENT.Comments.rawValue] = modelIncidence?.comments ?? ""
//        arrayPopulate[CELL_CONTENT.Color.rawValue] = modelIncidence?.color_name ?? ""
//        arrayPopulate[CELL_CONTENT.Vehicle_Type.rawValue] = modelIncidence?.vehicle_type_name ?? ""
        arrayPopulate[CELL_CONTENT.Assist_Type.rawValue] = modelIncidence?.assist_type ?? ""
        if modelIncidence?.is_dispatched_incedent == "1"{
            isDispatched = true
        }else{
            isDispatched = true
        }
        
        arrayPopulate[CELL_CONTENT.LaneRestorationTime.rawValue] = modelIncidence?.laneRestorationTime ?? ""
        arrayPopulate[CELL_CONTENT.TravelLanesBlocked.rawValue] = modelIncidence?.travelLanesBlocked ?? ""
        arrayPopulate[CELL_CONTENT.IncidentNo.rawValue] = modelIncidence?.incidentNo ?? ""
        arrayPopulate[CELL_CONTENT.Notes.rawValue] = modelIncidence?.note ?? ""
        self.tableIncident.reloadData()
        
    }
    
    func prepareVehicleObject(){
        if let vehicleInform = modelIncidence?.vehicleInformation{
             self.arrayTotalVehicles.removeAll()
            for obj in vehicleInform{
                let objVehicle = TotalVehiclesObject()
                objVehicle.vehicleColorName = obj.color ?? ""
                objVehicle.vehicleType = obj.vehicle_type ?? ""
                objVehicle.vehicleLincense = obj.plate_no ?? ""
                self.arrayTotalVehicles.append(objVehicle)
            }
        }
    }
    
    func prepareVehicleInformationString() ->String {
        
        var arrayVehicle :[[String:AnyObject]] = []
        for objectAddon in arrayTotalVehicles {
            //if objectAddon.vehicleType != ""{
            var param : [String:AnyObject] = [:]
            
            param["companyColor"] = objectAddon.vehicleColorName as AnyObject
            param["plate_no"] = objectAddon.vehicleLincense as AnyObject
            param["vehicleType"] = objectAddon.vehicleType as AnyObject
                
            
            arrayVehicle.append(param)
            //}
        }
        let jsonString = arrayVehicle.toJSONString()
        let trimmedString = jsonString.trimmingCharacters(in: .whitespaces)
        
        do {
            let finalString = try self.json(from: arrayVehicle)
            print(finalString)
            
            
        } catch { print(error) }
        return trimmedString
    }
    func json(from object: [[String:AnyObject]]) throws -> String {
        let data = try JSONSerialization.data(withJSONObject: object)
        return String(data: data, encoding: .utf8)!
    }
    @IBAction func btnCheckMarkAction(_ sender: UIButton) {
        if isSelectLicensePlate == 0{
            isSelectLicensePlate = 1
        }else{
            isSelectLicensePlate = 0
        }
        self.tableIncident.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
    }
    
    @IBAction func btnSelectionAction(_ sender: Any) {
        
    }
    @IBAction func btnSelectLicence(_ sender: Any) {
        PopupCustomView.sharedInstance.display(onView: UIApplication.shared.keyWindow) {
            
        }
    }
    
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            arrayValues[CELL_CONTENT.Latitude.rawValue] = String(location.coordinate.latitude)
            arrayValues[CELL_CONTENT.Longitude.rawValue] = String(location.coordinate.longitude)
            arrayPopulate[CELL_CONTENT.Latitude.rawValue] = String(location.coordinate.latitude)
            arrayPopulate[CELL_CONTENT.Longitude.rawValue] = String(location.coordinate.longitude)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat =  "h:mm a"
            
            if self.pageFor.lowercased() == "update"{
                
            } else {
            
            arrayValues[CELL_CONTENT.Call_At.rawValue] = timeFormatter.string(from: Date())
            arrayPopulate[CELL_CONTENT.Call_At.rawValue] = timeFormatter.string(from: Date())
            arrayValues[CELL_CONTENT.Call_Started.rawValue] = timeFormatter.string(from: Date())
            arrayPopulate[CELL_CONTENT.Call_Started.rawValue] = timeFormatter.string(from: Date())
            arrayPopulate[CELL_CONTENT.Call_Started.rawValue] = timeFormatter.string(from: Date())
            let section2 = Date().adding(minutes: 15)
            arrayPopulate[CELL_CONTENT.Call_Completed.rawValue] = timeFormatter.string(from: section2)
            arrayValues[CELL_CONTENT.Call_Completed.rawValue] = timeFormatter.string(from: section2)
            
            let difference = Calendar.current.dateComponents([.minute], from: Date(), to: section2)
            let formattedString = String(format: "%02ld M", (difference.minute! + 1))
            arrayValues[CELL_CONTENT.Incident_Time.rawValue] = formattedString
            arrayPopulate[CELL_CONTENT.Incident_Time.rawValue] = formattedString
            
            print(formattedString)
            }
            
            locationManager.stopUpdatingLocation()
            self.tableIncident.reloadData()
        }
    }
    
    
    @IBAction func btnNext(_ sender: Any) {
        if self.validatationCheck(){
            
            if arrayFormList[CELL_CONTENT.Photo.rawValue].show == "1" || arrayFormList[CELL_CONTENT.video.rawValue].show == "1" || arrayFormList[CELL_CONTENT.Notes.rawValue].show == "1"{
                let vc = storyboard?.instantiateViewController(withIdentifier: "AddIncidentImageVC") as! AddIncidentImageVC
                vc.pageFor = pageFor
                vc.arrayValues = self.arrayValues
                vc.modelIncidence = self.modelIncidence
                vc.vehicleInformation = self.prepareVehicleInformationString()
                vc.arraySortFormList = self.arrayFormList
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.callAddIncidenceAPI(isUpdate: pageFor)
            }
            
        
        }else{
            self.displayAlert(Header: App_Title, MessageBody: "Please fill the mandatory fields", AllActions: ["Ok":nil], Style: .alert)
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.tag)
        let buttonPosition = textField.convert(CGPoint.zero, to: self.tableIncident)
        if let indexPath = self.tableIncident.indexPathForRow(at:buttonPosition){
            selectedIndexpath = indexPath
        
            if indexPath.section == CELL_CONTENT.TotalVehicles.rawValue{
            isSectionVehicle = true
        }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
         print(textField.tag)
        let buttonPosition = textField.convert(CGPoint.zero, to: self.tableIncident)
        if let indexPath = self.tableIncident.indexPathForRow(at:buttonPosition){
            self.arrayTotalVehicles[safe:indexPath.row]?.vehicleLincense
        }
        isSectionVehicle = false
        //let cell = self.tableIncident.cellForRow(at: indexPath) as! UITableViewCell
    }
    @objc func textFieldValueChanged(_ textField:UITextField) {
        arrayValues[textField.tag] = textField.text!
        arrayPopulate[textField.tag] = textField.text!
        print (arrayValues)
    }
    func validatationCheck() -> Bool{
//        if arrayPopulate[CELL_CONTENT.Incident_type.rawValue] == ""{
//            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill the required field", AllActions: ["Ok":nil], Style: .alert)
//            return false
//        }
//        if arrayPopulate[CELL_CONTENT.Route_1.rawValue] == ""{
//            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill the required field", AllActions: ["Ok":nil], Style: .alert)
//            return false
//        }
//        if arrayPopulate[CELL_CONTENT.Traffic_Direction.rawValue] == ""{
//            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill the required field", AllActions: ["Ok":nil], Style: .alert)
//            return false
//        }
        if arrayPopulate[CELL_CONTENT.Mile_Marker.rawValue] == ""{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill the Mile Marker field", AllActions: ["Ok":nil], Style: .alert)
            return false
        }
        
        if arrayPopulate[CELL_CONTENT.Comments.rawValue] == ""{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill the Resolution field", AllActions: ["Ok":nil], Style: .alert)
            return false
        }
//        
//        if arrayPopulate[CELL_CONTENT.Property_Damage.rawValue] == ""{
//            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill the required field", AllActions: ["Ok":nil], Style: .alert)
//            return false
//        }
//        if arrayPopulate[CELL_CONTENT.Road_Surface.rawValue] == ""{
//            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill the required field", AllActions: ["Ok":nil], Style: .alert)
//            return false
//        }
        if arrayPopulate[CELL_CONTENT.Lane_Location.rawValue] == ""{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill the Lane Location field", AllActions: ["Ok":nil], Style: .alert)
            return false
        }
//        if arrayPopulate[CELL_CONTENT.Number_of_Vehicles.rawValue] == ""{
//            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill the required field", AllActions: ["Ok":nil], Style: .alert)
//            return false
//        }
//        if arrayPopulate[CELL_CONTENT.Assist_Type.rawValue] == ""{
//            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill the required field", AllActions: ["Ok":nil], Style: .alert)
//            return false
//        }
        if arrayFormList[CELL_CONTENT.Number_of_Vehicles.rawValue].show == "1"{
        for obj in arrayTotalVehicles{
           
            if obj.vehicleColorName  == ""{
                return false
            }else if obj.vehicleLincense == ""{
                return false
            }else if obj.vehicleType == ""{
                return false
            }
        }
        }else{
            arrayValues[CELL_CONTENT.Number_of_Vehicles.rawValue] = ""
            arrayPopulate[CELL_CONTENT.Number_of_Vehicles.rawValue] = ""
        }
       
    
        return true
    }
    @objc func textFieldVehicleLicenseValueChanged(_ textField:UITextField) {
        
        self.arrayTotalVehicles[textField.tag].vehicleLincense = textField.text ?? ""
        
    }
    
}
extension AddIncidentFormVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var noOfSection = 0
        if tableView == tbleVw_LaneLocation{
            noOfSection = 1
        }else{
            if arrayFormList.count > 0{
           // return arrayFormList.count - 2//27 - 2
                noOfSection = arrayFormList.count - 2
            }else{
                //return 0
                noOfSection = 0
            }//arrayTitle.count
        }
        return noOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionCount = 0
        if tableView == tbleVw_LaneLocation{
            sectionCount = laneLocArray.count//laneLoc.count
        }
        else{
            if section == CELL_CONTENT.TotalVehicles.rawValue{
                 if arrayFormList[CELL_CONTENT.Number_of_Vehicles.rawValue].show == "1"{
                     //return arrayTotalVehicles.count
                     sectionCount = arrayTotalVehicles.count
                 }else{
                    //return 0
                     sectionCount = 0
                }
               
            }
            else{
                sectionCount = 1
            }
            //return 1
          //
        }
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tbleVw_LaneLocation{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LaneLocTVC", for: indexPath) as! LaneLocTVC
            cell.lbl_LaneLocName.text = "\(laneLocArray[indexPath.row]["lane_location"])"//"\(laneLoc[indexPath.row])"
            
            
            if selectedIndexArray.contains(indexPath.row) {
                cell.imgVw_Check.isHidden = false
            }
            else{
                cell.imgVw_Check.isHidden = true
            }
            return cell
        }
        else{
            if CELL_CONTENT.Photo.rawValue == indexPath.section{
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "IncidentButtomCell", for: indexPath) as! IncidentButtomCell
                if arrayFormList[CELL_CONTENT.Photo.rawValue].show == "1" || arrayFormList[CELL_CONTENT.video.rawValue].show == "1" || arrayFormList[CELL_CONTENT.Notes.rawValue].show == "1"{
                    cell1.btnNext.setTitle("Next", for: .normal)
                }else{
                    cell1.btnNext.setTitle("Submit", for: .normal)
                }
                self.view.setNeedsLayout()
                return cell1
            }else if CELL_CONTENT.Comments.rawValue == indexPath.section{
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell1", for: indexPath) as! IncidentInputCell
                cell2.txtFieldInput.tag = indexPath.section
              //  let cell2 = tableView.dequeueReusableCell(withIdentifier: "IncidentCommentCell", for: indexPath) as! IncidentCommentCell
               // cell2.txtViewComment.tag = indexPath.section
                print("Resolution - \(indexPath.section)")
                print("Resolution - \(indexPath.row)")
                cell2.lblTitle.text = "Resolution *"

                cell2.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
                if arrayPopulate.count > 0{
                    cell2.txtFieldInput.text = arrayPopulate[indexPath.section]
                }
                cell2.viewRound.layer.borderWidth = 2.0
                cell2.viewRound.layer.borderColor = AppthemeColor.cgColor
                cell2.viewRound.layer.cornerRadius = 10

//                if arrayPopulate.last == ""{
//                    cell2.txtViewComment.text = "Write Here..."
//                }else{
//                    cell2.txtViewComment.text = arrayPopulate.last
//                }
//                cell2.txtViewComment.delegate = self
                return cell2
            }
            else if indexPath.section == CELL_CONTENT.Mile_Marker.rawValue{
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell1", for: indexPath) as! IncidentInputCell
                cell2.txtFieldInput.tag = indexPath.section
                if arrayFormList[indexPath.section].title == "Mile Marker"{
                    cell2.lblTitle.text = "Mile Marker *"
                }
                else{
                    cell2.lblTitle.text = arrayFormList[indexPath.section].title ?? ""
                }
                cell2.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
                cell2.txtFieldInput?.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
                cell2.viewRound.layer.borderWidth = 2.0
                cell2.viewRound.layer.borderColor = AppthemeColor.cgColor
                cell2.viewRound.layer.cornerRadius = 10
                cell2.btncheckSelection.tag = indexPath.section
                cell2.txtFieldInput.isUserInteractionEnabled = true
                if arrayPopulate.count > 0{
                    cell2.txtFieldInput.text = arrayPopulate[indexPath.section]
                }
                if isSelectLicensePlate == 1{
                    cell2.imgViewBox.image = UIImage(named: "checked")
                }else{
                    cell2.imgViewBox.image = UIImage(named: "YellowBox")
                }
                return cell2
            }else if indexPath.section == CELL_CONTENT.TotalVehicles.rawValue{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "AddCrashPassengerCell", for: indexPath) as! AddCrashPassengerCell
                    cell.viewRound.roundedViewTheme()
                    //cell.viewRound1.roundedViewTheme()
                    //cell.viewRound2.roundedViewTheme()
                    // cell.viewRound3.roundedViewTheme()
                    
                    cell.txtPassengerName.tag = indexPath.row
                    cell.txtPhonrNumber.tag =   400//indexPath.row
                    //cell.txtPhonrNumber.keyboardType = .numberPad
                    //cell.txtvwAddress.tag =  indexPath.row
                    //cell.txtvwDriverLicenseInfo.tag =  indexPath.row
                    //cell.btnSelection.tag = indexPath.row
                    cell.btnSelection.isHidden = true
                    cell.txtInjuries.tag =  300//indexPath.row
                    cell.txtInjuries.delegate = self
                    
                    cell.txtPassengerName?.addTarget(self, action: #selector(textFieldVehicleLicenseValueChanged(_:)), for: .editingChanged)
                    
                if arrayTotalVehicles.count > 0 {
                
                    self.createPickerView(textField: cell.txtInjuries)
                    self.createPickerView(textField: cell.txtPhonrNumber)
                
                    let pInfo = arrayTotalVehicles[indexPath.row]
                    cell.txtPassengerName.text = pInfo.vehicleLincense
                    cell.txtPhonrNumber.text = pInfo.vehicleColorName
                    cell.txtInjuries.text =  pInfo.vehicleType
                    cell.txtInjuries.placeholder = "Select"
                    cell.txtPhonrNumber.placeholder = "Select"
                    cell.txtPassengerName.placeholder = "Enter License Plate"
                }
                    
                    return cell
            }
            else if CELL_CONTENT.IncidentNo.rawValue == indexPath.section {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentInputWithPrefixCell", for: indexPath) as! IncidentInputWithPrefixCell
                cell.btnSelection.tag = indexPath.section
                cell.btnSelection.isHidden = true
                cell.txtFieldInput.autocapitalizationType = .none
                cell.txtFieldInput.isUserInteractionEnabled = true
                //cell.txtFieldInput.delegate = self
                cell.txtFieldInput.tag = indexPath.section
                cell.lblTitle.text = arrayFormList[indexPath.section].title
                cell.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
                cell.viewRound.roundedView()
                cell.viewRound.layer.borderWidth = 2.0
                cell.viewRound.layer.borderColor = AppthemeColor.cgColor
                cell.txtFieldInput.placeholder = CELL_CONTENT.init(rawValue: indexPath.section)?.getPlaceholder() ?? ""
                cell.txtFieldInput?.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
                cell.txtFieldInput.text = ""
                cell.txtFieldInput.inputAccessoryView = nil
                cell.txtFieldInput.inputView = nil
                cell.txtFieldInput.tintColor = .black
                if arrayPopulate.count > 0{
                    cell.txtFieldInput.text = arrayPopulate[indexPath.section]
                }
                
                let strPrefix = arrayFormList[indexPath.section].incidentPrefix
                cell.lblPrefix.text = strPrefix ?? ""
                if(strPrefix != "") {
                    let starWidth = strPrefix?.widthOfString(usingFont: UIFont.systemFont(ofSize: 14))
                    cell.constLblPrefixWidth.constant = starWidth ?? 0.0
                } else {
                    cell.constLblPrefixWidth.constant = 0.0
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell", for: indexPath) as! IncidentInputCell
                cell.btnSelection.tag = indexPath.section
                cell.btnSelection.isHidden = true
                cell.txtFieldInput.autocapitalizationType = .none
                cell.txtFieldInput.isUserInteractionEnabled = true
                //cell.txtFieldInput.delegate = self
                cell.txtFieldInput.tag = indexPath.section
                cell.lblTitle.text = arrayFormList[indexPath.section].title
                cell.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
                cell.viewRound.roundedView()
                cell.viewRound.layer.borderWidth = 2.0
                cell.viewRound.layer.borderColor = AppthemeColor.cgColor
                cell.txtFieldInput.placeholder = CELL_CONTENT.init(rawValue: indexPath.section)?.getPlaceholder() ?? ""
                cell.txtFieldInput?.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
                cell.imgViewDropDown.isHidden = true
                cell.txtFieldInput.text = ""
                cell.txtFieldInput.inputAccessoryView = nil
                cell.txtFieldInput.inputView = nil
                cell.txtFieldInput.tintColor = .black
                if arrayPopulate.count > 0{
                    cell.txtFieldInput.text = arrayPopulate[indexPath.section]
                }
                if indexPath.section == CELL_CONTENT.Latitude.rawValue || indexPath.section == CELL_CONTENT.Longitude.rawValue {
                    cell.imgViewDropDown.isHidden = true
                    cell.txtFieldInput.isUserInteractionEnabled = false
                    
    //            }else if indexPath.section == CELL_CONTENT.Call_At.rawValue{
    //                cell.imgViewDropDown.isHidden = false
    //                if cell.txtFieldInput.text == ""{
    //                    cell.txtFieldInput.text = "Select"
    //                }
    //                self.createDatePickerView(textField: cell.txtFieldInput)
    //                cell.txtFieldInput.tintColor = .white
    //                if isDispatched{
    //                //cell.txtFieldInput.text = " "
    //                cell.txtFieldInput.isUserInteractionEnabled = true
    //                    cell.btnSelection.isHidden = false
    //                    cell.viewRound.layer.borderColor = UIColor(named: "boaderColor")?.cgColor
    //                }
    //            }else if indexPath.section == CELL_CONTENT.Call_Started.rawValue{
    //                cell.imgViewDropDown.isHidden = false
    //                if cell.txtFieldInput.text == ""{
    //                    cell.txtFieldInput.text = "Select"
    //                }
    //                self.createDatePickerView(textField: cell.txtFieldInput)
    //                cell.txtFieldInput.tintColor = .white
    //                if isDispatched{
    //               // cell.txtFieldInput.text = " "
    //                cell.txtFieldInput.isUserInteractionEnabled = true
    //                    cell.btnSelection.isHidden = false
    //                cell.viewRound.layer.borderColor = UIColor(named: "boaderColor")?.cgColor
    //                }
                }
                else if indexPath.section == CELL_CONTENT.Call_Completed.rawValue || indexPath.section == CELL_CONTENT.Call_Started.rawValue || indexPath.section == CELL_CONTENT.Call_At.rawValue {
                    cell.imgViewDropDown.isHidden = false
                    if cell.txtFieldInput.text == "" {
                        cell.txtFieldInput.text = "Select"
                    }
                    self.createDatePickerView(textField: cell.txtFieldInput)
                    cell.txtFieldInput.tintColor = .white
                }else if indexPath.section == CELL_CONTENT.LaneRestorationTime.rawValue {
                    cell.imgViewDropDown.isHidden = false
                    if cell.txtFieldInput.text == "" {
                        cell.txtFieldInput.text = "Select"
                    }
                    self.createDatePickerView(textField: cell.txtFieldInput)
                    cell.txtFieldInput.tintColor = .white
                }
                else if indexPath.section == CELL_CONTENT.Incident_Time.rawValue{
                    cell.imgViewDropDown.isHidden = true
                    cell.txtFieldInput.isUserInteractionEnabled = false
                    if cell.txtFieldInput.text == ""{
                        cell.txtFieldInput.text = "Select"
                    }
                    self.createDatePickerView(textField: cell.txtFieldInput)
                    cell.txtFieldInput.text = "\(arrayPopulate[indexPath.section])"
                    cell.txtFieldInput.tintColor = .white
                }
                else if indexPath.section == CELL_CONTENT.Incident_type.rawValue{
                    cell.imgViewDropDown.isHidden = true
                    if cell.txtFieldInput.text == ""{
                        cell.txtFieldInput.text = "Select"
                    }
                    cell.txtFieldInput.isUserInteractionEnabled = false
                    self.createPickerView(textField: cell.txtFieldInput)
                    cell.txtFieldInput.tintColor = .white
                }
                else if indexPath.section == CELL_CONTENT.Route_1.rawValue {
                    cell.imgViewDropDown.isHidden = false
                    if cell.txtFieldInput.text == ""{
                        cell.txtFieldInput.text = "Select"
                    }
                    self.createPickerView(textField: cell.txtFieldInput)
                    cell.txtFieldInput.tintColor = .white
                }
                else if indexPath.section == CELL_CONTENT.Traffic_Direction.rawValue{
                    cell.imgViewDropDown.isHidden = false
                    if cell.txtFieldInput.text == ""{
                        cell.txtFieldInput.text = "Select"
                    }
                    self.createPickerView(textField: cell.txtFieldInput)
                    cell.txtFieldInput.tintColor = .white
                    cell.lblTitle.text = "Traffic Direction"
                }else if indexPath.section == CELL_CONTENT.Ramplanes.rawValue{
                    cell.imgViewDropDown.isHidden = false
                    if cell.txtFieldInput.text == ""{
                        cell.txtFieldInput.text = "Select"
                    }
                    self.createPickerView(textField: cell.txtFieldInput)
                    cell.txtFieldInput.tintColor = .white
                    cell.lblTitle.text = "Route"
                }
                else if indexPath.section == CELL_CONTENT.State.rawValue || indexPath.section == CELL_CONTENT.Property_Damage.rawValue || indexPath.section == CELL_CONTENT.Secondary_crash_involved.rawValue || indexPath.section == CELL_CONTENT.First_Responder.rawValue  {
                    cell.txtFieldInput.tag = indexPath.section
                    cell.imgViewDropDown.isHidden = false
                    cell.txtFieldInput.isUserInteractionEnabled = true
                    if cell.txtFieldInput.text == ""{
                        cell.txtFieldInput.text = "None"
                    }
                    if indexPath.section == CELL_CONTENT.State.rawValue{
                        cell.txtFieldInput.isUserInteractionEnabled = false
                        cell.imgViewDropDown.isHidden = true
                    }
                    self.createPickerView(textField: cell.txtFieldInput)
                    cell.txtFieldInput.tintColor = .white
                }
                else if indexPath.section == CELL_CONTENT.Road_Surface.rawValue {
                    cell.btnSelection.tag = indexPath.section
                    cell.imgViewDropDown.isHidden = false
                    if cell.txtFieldInput.text == ""{
                        cell.txtFieldInput.text = "Select"
                    }
                    //self.createPickerView(textField: cell.txtFieldInput)
                    cell.txtFieldInput.tintColor = .white
                    cell.btnSelection.isHidden = false
                    cell.btnSelection.addTarget(self, action: #selector(self.showLaneLocationAlert(sender:)), for: .touchUpInside)
                }else if indexPath.section == CELL_CONTENT.Lane_Location.rawValue{
                    cell.btnSelection.tag = indexPath.section
                    
                    if arrayFormList[indexPath.section].title == "Lane Location"{
                        cell.lblTitle.text = "Lane Location *"
                    }
                    else{
                        cell.lblTitle.text = arrayFormList[indexPath.section].title ?? ""
                    }
                    cell.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
                    cell.imgViewDropDown.isHidden = false
                    if cell.txtFieldInput.text == "" {
                        cell.txtFieldInput.text = "Select"
                    }
                    cell.txtFieldInput.tintColor = .white
                    cell.btnSelection.isHidden = false
                    //cell.btnSelection.removeTarget(nil, action: nil, for: .allEvents)
                    cell.btnSelection.addTarget(self, action: #selector(self.showLaneLocationAlert(sender:)), for: .touchUpInside)
                }
                else if  indexPath.section == CELL_CONTENT.Passengers_Transported.rawValue || indexPath.section == CELL_CONTENT.Vendor.rawValue ||  indexPath.section == CELL_CONTENT.Contract.rawValue || indexPath.section == CELL_CONTENT.Assist_Type.rawValue ||  indexPath.section == CELL_CONTENT.Number_of_Vehicles.rawValue || indexPath.section == CELL_CONTENT.TravelLanesBlocked.rawValue{
                    cell.imgViewDropDown.isHidden = false
                    if cell.txtFieldInput.text == "" {
                        cell.txtFieldInput.text = "Select"
                    }
                    self.createPickerView(textField: cell.txtFieldInput)
                    cell.txtFieldInput.tintColor = .white
                }
                //cell.txtFieldInput.text = arrayValues[indexPath.section]
                return cell
            }
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("============================Screen has been tapped============================")
        TimeService.instance.resetInactivityTimer()
        if tableView == tbleVw_LaneLocation{
            let value = "\(laneLocArray[indexPath.row]["lane_location"])"//laneLoc[indexPath.row]
            
            if selectedArray.contains(value) {
                selectedArray.remove(value)
            }else{
                selectedArray.add(value)
            }
            
            if selectedIndexArray.contains(indexPath.row) {
                selectedIndexArray.remove(indexPath.row)
            }else{
                selectedIndexArray.add(indexPath.row)
            }
            print(selectedArray)
            print(selectedIndexArray)
            self.tbleVw_LaneLocation.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
   /* func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .phone ? 95 : 120
    }*/
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0{
//            return UITableView.automaticDimension
//        }else{
//            return 0.001
//        }
//
//    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell") as? IncidentInputCell
//        if cell != nil {
//            cell?.txtFieldInput.tag = 2000
//            cell?.lblTitle.text = "Incident Type*"
//            if getIncidenceType == ""{
//                cell?.txtFieldInput.text = "Select"
//            }else{
//                cell?.txtFieldInput.text = getIncidenceType
//            }
//            self.createPickerView(textField: cell!.txtFieldInput)
//            cell?.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
//            cell?.imgViewDropDown.isHidden = false
//            return cell
//        }else{
//            return nil
//        }
//
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var floatHeight = 0.0
        if tableView == tbleVw_LaneLocation{
            floatHeight = 60.0
        }
        else{
            let text : String = arrayFormList[indexPath.section].title ?? ""
            print(text," --------",arrayFormList[indexPath.section].show!,"--------", indexPath.section)
            
            if CELL_CONTENT.Photo.rawValue == indexPath.section{
                if arraySortFormList.count > 0{
                return UIDevice.current.userInterfaceIdiom == .phone ? 95 : 120
                }else{
                    //return 0.001
                    floatHeight = 0.001
                }
            }else if CELL_CONTENT.Comments.rawValue == indexPath.section{
                if arrayFormList[CELL_CONTENT.Comments.rawValue].show == "1"{
                    //return 0.001
                    //floatHeight = 0.001
                    return UIDevice.current.userInterfaceIdiom == .phone ? 130 : 150

                }else{
                    //return 0.001
                    floatHeight = 0.001
                }
            }else if CELL_CONTENT.Incident_type.rawValue == indexPath.section{
                if arrayFormList[CELL_CONTENT.Incident_type.rawValue].show == "1"{
                    //return 0.001
                    floatHeight = 0.001
                }else{
                    //return 0.001
                    floatHeight = 0.001
                }
            }
            else if indexPath.section == CELL_CONTENT.Route_1.rawValue{
                if arrayFormList[CELL_CONTENT.Route_1.rawValue].show == "1"{
                    if routeList.count > 0{
                        //return UITableView.automaticDimension
                        floatHeight = UITableView.automaticDimension
                    }else{
                         //return 0.001
                        floatHeight = 0.001
                    }
                }else{
                     //return 0.001
                    floatHeight = 0.001
                }
             }
            else if indexPath.section == CELL_CONTENT.Mile_Marker.rawValue{
                if arrayFormList[CELL_CONTENT.Mile_Marker.rawValue].show == "1"{
                 return UIDevice.current.userInterfaceIdiom == .phone ? 100 : 130
                    }else{
                        //return 0.001
                        floatHeight = 0.001
                    }
               
            }else if indexPath.section == CELL_CONTENT.TotalVehicles.rawValue{
                if arrayFormList[CELL_CONTENT.Number_of_Vehicles.rawValue].show == "1"{
                    if arrayTotalVehicles.count > 0{
                        //return UITableView.automaticDimension
                        floatHeight = UITableView.automaticDimension
                    }else{
                         //return 0.001
                        floatHeight = 0.001
                    }
                }else{
                     //return 0.001
                    floatHeight = 0.001
                }
             }else if indexPath.section == CELL_CONTENT.Assist_Type.rawValue{
                 if arrayFormList[CELL_CONTENT.Assist_Type.rawValue].show == "1"{
                     if asystList.count > 0{
                         //return UITableView.automaticDimension
                         floatHeight = UITableView.automaticDimension
                     }else{
                          //return 0.001
                         floatHeight = 0.001
                     }
                 }else{
                      //return 0.001
                     floatHeight = 0.001
                 }
              }
            else if indexPath.section == CELL_CONTENT.Contract.rawValue{
                if arrayFormList[CELL_CONTENT.Contract.rawValue].show == "1"{
                    if arrayContractList.count > 0{
                        //return UITableView.automaticDimension
                        floatHeight = UITableView.automaticDimension
                    }else{
                         //return 0.001
                        floatHeight = 0.001
                    }
                }else{
                     //return 0.001
                    floatHeight = 0.001
                }
             }
            
            else if indexPath.section == CELL_CONTENT.Ramplanes.rawValue{
                if arrayFormList[CELL_CONTENT.Ramplanes.rawValue].show == "1"{
                    floatHeight = UITableView.automaticDimension

                }else{
                     //return 0.001
                    floatHeight = 0.001

                }
             }
            else if indexPath.section == CELL_CONTENT.TravelLanesBlocked.rawValue{
                if arrayFormList[CELL_CONTENT.TravelLanesBlocked.rawValue].show == "1"{
                    //return UITableView.automaticDimension
                    floatHeight = UITableView.automaticDimension
                }else{
                     //return 0.001
                    floatHeight = 0.001
                }
             } else if indexPath.section == CELL_CONTENT.LaneRestorationTime.rawValue{
                if arrayFormList[CELL_CONTENT.LaneRestorationTime.rawValue].show == "1"{
                    //return UITableView.automaticDimension
                    floatHeight = UITableView.automaticDimension
                }else{
                     //return 0.001
                    floatHeight = 0.001
                }
             } else if indexPath.section == CELL_CONTENT.IncidentNo.rawValue{
                 if arrayFormList[CELL_CONTENT.IncidentNo.rawValue].show == "1"{
                     //return UITableView.automaticDimension
                     floatHeight = UITableView.automaticDimension
                 }else{
                     // return 0.001
                      floatHeight = 0.001
                 }
              }
    //        else if indexPath.section == CELL_CONTENT.Number_of_Vehicles.rawValue{
    //            if arrayFormList[CELL_CONTENT.Number_of_Vehicles.rawValue].show == "1"{
    //             return 70
    //                }else{
    //                    return 0.001
    //                }
    //
    //        }
    //        else if indexPath.section == CELL_CONTENT.First_Responder_Unit_Number.rawValue{
    //            if arrayPopulate[CELL_CONTENT.First_Responder.rawValue].uppercased() == "YES"{
    //                return UITableView.automaticDimension
    //            }else{
    //                return 0.001
    //            }
    //        }
            else{
                 print(indexPath.section)

                if arrayFormList[indexPath.section].show == "1"{
                    //return UITableView.automaticDimension
                    floatHeight = UITableView.automaticDimension
           
                }else{
    //                if indexPath.section == CELL_CONTENT.Incident_type.rawValue{
    //                    return UITableView.automaticDimension
    //                }
                    //return 0.001
                    floatHeight = 0.001
                }
            }

        }
       return floatHeight
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        if CELL_CONTENT.Photo.rawValue == indexPath.section{
//            if arraySortFormList.count > 0{
//            return 95
//            }else{
//                return 0.001
//            }
//        }else if CELL_CONTENT.Comments.rawValue == indexPath.section{
//            if arrayFormList[CELL_CONTENT.Comments.rawValue].show == "1"{
//            return 161
//            }else{
//                return 0.001
//            }
//        }else if indexPath.section == CELL_CONTENT.Mile_Marker.rawValue{
//            if arrayFormList[CELL_CONTENT.Mile_Marker.rawValue].show == "1"{
//             return 100
//                }else{
//                    return 0.001
//                }
//
//        }else if indexPath.section == CELL_CONTENT.TotalVehicles.rawValue{
//            if arrayFormList[CELL_CONTENT.Number_of_Vehicles.rawValue].show == "1"{
//                if arrayTotalVehicles.count > 0{
//             return UITableView.automaticDimension
//                }else{
//                     return 0.001
//                }
//            }else{
//                 return 0.001
//            }
//         }
////        else if indexPath.section == CELL_CONTENT.First_Responder_Unit_Number.rawValue{
////            if arrayPopulate[CELL_CONTENT.First_Responder.rawValue].uppercased() == "YES"{
////                return UITableView.automaticDimension
////            }else{
////                return 0.001
////            }
////        }
//        else{
//             print(indexPath.section)
//            if arrayFormList[indexPath.section].show == "1"{
//                return UITableView.automaticDimension
//
//            }else{
//                return 0.001
//            }
//        }
//
//    }
}
extension AddIncidentFormVC:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return 0
        }
        else if pickerView.tag == CELL_CONTENT.Ramplanes.rawValue{
            return arrayRamplanes.count
        }
        else if pickerView.tag == CELL_CONTENT.Incident_type.rawValue{
            return incidenceTypeList.count
        }
        else if pickerView.tag == CELL_CONTENT.Route_1.rawValue{
            return routeList.count
        }
        else if pickerView.tag == CELL_CONTENT.Traffic_Direction.rawValue {
            return trafficdirectionList.count
        }
        else if pickerView.tag == CELL_CONTENT.State.rawValue{
            return stateList.count
        }
        else if pickerView.tag == CELL_CONTENT.Property_Damage.rawValue{
            return propertyList.count
        }
        else if pickerView.tag == CELL_CONTENT.Secondary_crash_involved.rawValue{
            return secondaryCrashList.count
        }
        else if pickerView.tag == CELL_CONTENT.First_Responder.rawValue{
            return firstResponderList.count
        }
        else if pickerView.tag == CELL_CONTENT.First_Responder_Unit_Number.rawValue{
            return responderUnitList.count
        }
        else if pickerView.tag == CELL_CONTENT.Road_Surface.rawValue{
            return roadSurface.count
        }
            else if pickerView.tag == CELL_CONTENT.Lane_Location.rawValue{
                return laneLoc.count
            }
        else if pickerView.tag == CELL_CONTENT.Passengers_Transported.rawValue{
            return passangerTransported.count
        }
        
        
        else if pickerView.tag == CELL_CONTENT.Number_of_Vehicles.rawValue{
            return numberVehicle.count
        }
        else if pickerView.tag == CELL_CONTENT.Vendor.rawValue{
            return arrayVenderList.count
        }
        else if pickerView.tag == CELL_CONTENT.Contract.rawValue{
            return arrayContractList.count
        }
        else if pickerView.tag == CELL_CONTENT.Assist_Type.rawValue{
            return asystList.count
        }
        else if pickerView.tag == 300{
            return arrayMotoristType.count
        }
        else if pickerView.tag == 400{
            return colorList.count
        }
        else if pickerView.tag == 2000{
            return incidenceTypeList.count
        }else if pickerView.tag == CELL_CONTENT.TravelLanesBlocked.rawValue{
            return 2
        }
        else{
            return 0
        }
        //return arraySamplertext.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return ""
        }
        else if pickerView.tag == CELL_CONTENT.Incident_type.rawValue{
            return incidenceTypeList[row].name
        }
        else if pickerView.tag == CELL_CONTENT.Ramplanes.rawValue{
            return arrayRamplanes[row]
        }
        else if pickerView.tag == CELL_CONTENT.Route_1.rawValue{
            return routeList[row].route_name
        }
        else if pickerView.tag == CELL_CONTENT.Traffic_Direction.rawValue {
            return trafficdirectionList[row].traffic_direction
        }
        else if pickerView.tag == CELL_CONTENT.State.rawValue{
            return stateList[row].state_name
        }
        else if pickerView.tag == CELL_CONTENT.Property_Damage.rawValue{
            return propertyList[row].property_damage
        }
        else if pickerView.tag == CELL_CONTENT.Secondary_crash_involved.rawValue{
            return secondaryCrashList[row].crash_Inv
        }
        else if pickerView.tag == CELL_CONTENT.First_Responder.rawValue{
            return firstResponderList[row]
        }
        else if pickerView.tag == CELL_CONTENT.First_Responder_Unit_Number.rawValue{
            return responderUnitList[row].unit_no
        }
            
            else if pickerView.tag == CELL_CONTENT.Road_Surface.rawValue{
                return roadSurface[row]
            }
                else if pickerView.tag == CELL_CONTENT.Lane_Location.rawValue{
            return laneLoc[row]
                }
            else if pickerView.tag == CELL_CONTENT.Passengers_Transported.rawValue{
                return passangerTransported[row]
            }
            
        else if pickerView.tag == CELL_CONTENT.Number_of_Vehicles.rawValue{
                return numberVehicle[row]
            }
        else if pickerView.tag == CELL_CONTENT.Vendor.rawValue{
            return arrayVenderList[row].vendor_name
        }
        else if pickerView.tag == CELL_CONTENT.Contract.rawValue{
            return arrayContractList[row].contract_name
        }
        else if pickerView.tag == CELL_CONTENT.Assist_Type.rawValue{
            return asystList[row].assist_type
        }
        else if pickerView.tag == CELL_CONTENT.TravelLanesBlocked.rawValue{
            if(row == 0) {
                return "NO"
            } else {
                return "YES"
            }
        }
        else if pickerView.tag == 300{
            return arrayMotoristType[row].type_name
        }
        else if pickerView.tag == 400{
            return colorList[row].color_name
        }
        else if pickerView.tag == 2000{
            return incidenceTypeList[row].name
        }
        else{
            return ""
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        isSelected = true
        // let getArray = self.returnArrayString(tag: pickerView.tag)
        // arrayValues[pickerView.tag] = getArray[row]
        if pickerView.tag == CELL_CONTENT.Latitude.rawValue{
            
        }else if pickerView.tag == CELL_CONTENT.Ramplanes.rawValue{
          
            arrayValues[pickerView.tag] =  arrayRamplanes[row]
            arrayPopulate[pickerView.tag] = arrayRamplanes[row]
        }
        else if pickerView.tag == CELL_CONTENT.Incident_type.rawValue{
            arrayValues[pickerView.tag] =  incidenceTypeList[row].incident_id ?? ""
            arrayPopulate[pickerView.tag] =  incidenceTypeList[row].name ?? ""
        }
        else if pickerView.tag == CELL_CONTENT.Route_1.rawValue{
            if routeList.count > 0{
                arrayValues[pickerView.tag] = routeList[row].route_id ?? ""
                arrayPopulate[pickerView.tag] = routeList[row].route_name ?? ""
            }
        }
        else if pickerView.tag == CELL_CONTENT.Traffic_Direction.rawValue {
            arrayValues[pickerView.tag] = trafficdirectionList[row].traffic_direction_id ?? ""
            arrayPopulate[pickerView.tag] = trafficdirectionList[row].traffic_direction ?? ""
        }
        else if pickerView.tag == CELL_CONTENT.State.rawValue{
            arrayValues[pickerView.tag] = stateList[row].state_id ?? ""
            arrayPopulate[pickerView.tag] = stateList[row].state_name ?? ""
        }
        else if pickerView.tag == CELL_CONTENT.Property_Damage.rawValue{
            
            arrayValues[pickerView.tag] = propertyList[row].property_damage_id ?? ""
            arrayPopulate[pickerView.tag] = propertyList[row].property_damage ?? ""
        }
        else if pickerView.tag == CELL_CONTENT.Secondary_crash_involved.rawValue{
            
            arrayValues[pickerView.tag] = secondaryCrashList[row].crash_Inv_id ?? ""
            arrayPopulate[pickerView.tag] = secondaryCrashList[row].crash_Inv ?? ""
        }
        else if pickerView.tag == CELL_CONTENT.First_Responder.rawValue{
            
            arrayValues[pickerView.tag] = firstResponderList[row]
            arrayPopulate[pickerView.tag] = firstResponderList[row]
        }
        else if pickerView.tag == CELL_CONTENT.First_Responder_Unit_Number.rawValue{
            
            arrayValues[pickerView.tag] = responderUnitList[row].id ?? ""
            arrayPopulate[pickerView.tag] = responderUnitList[row].unit_no ?? ""
        }
        
        else if pickerView.tag == CELL_CONTENT.Road_Surface.rawValue{
            arrayValues[pickerView.tag] = roadSurface[row]
             arrayPopulate[pickerView.tag] = roadSurface[row]
        }
            else if pickerView.tag == CELL_CONTENT.Lane_Location.rawValue{
            
            arrayPopulate[pickerView.tag] = laneLoc[row]
            arrayValues[pickerView.tag] = laneLoc[row]
              
            }
        else if pickerView.tag == CELL_CONTENT.Passengers_Transported.rawValue{
            arrayValues[pickerView.tag] = passangerTransported[row]
             arrayPopulate[pickerView.tag] = passangerTransported[row]
        }
        
        else if pickerView.tag == CELL_CONTENT.Number_of_Vehicles.rawValue{
            arrayValues[pickerView.tag] = numberVehicle[row]
            arrayPopulate[pickerView.tag] = numberVehicle[row]
            let vehicleCount = Int(numberVehicle[row]) ?? 1
           
            self.arrayTotalVehicles.removeAll()
            
            if vehicleCount > 1{
            for _ in 0...vehicleCount - 1{
            let vehicleObj = TotalVehiclesObject()
            self.arrayTotalVehicles.append(vehicleObj)
            }
            }else{
                if vehicleCount == 0{
                    arrayValues[pickerView.tag] = numberVehicle[row]
                    arrayPopulate[pickerView.tag] = numberVehicle[row]
                }else{
                let vehicleObj = TotalVehiclesObject()
                self.arrayTotalVehicles.append(vehicleObj)
                }
            }
        }
        else if pickerView.tag == CELL_CONTENT.Vendor.rawValue{
            arrayValues[pickerView.tag] = arrayVenderList[row].vendor_id ?? ""
            arrayPopulate[pickerView.tag] = arrayVenderList[row].vendor_name ?? ""
        }
        else if pickerView.tag == CELL_CONTENT.Contract.rawValue{
            if arrayContractList.count > 0{
                arrayValues[pickerView.tag] = arrayContractList[row].contract_id ?? ""
                arrayPopulate[pickerView.tag] = arrayContractList[row].contract_name ?? ""
            }
        }
        else if pickerView.tag == CELL_CONTENT.Assist_Type.rawValue{
            arrayValues[pickerView.tag] = asystList[row].assist_id ?? ""
            arrayPopulate[pickerView.tag] = asystList[row].assist_type ?? ""
        }else if pickerView.tag == CELL_CONTENT.TravelLanesBlocked.rawValue {
            if(row == 0) {
                arrayValues[pickerView.tag] = "No"
                arrayPopulate[pickerView.tag] = "NO"
            } else {
                arrayValues[pickerView.tag] = "Yes"
                arrayPopulate[pickerView.tag] = "YES"
            }
        }
        else if pickerView.tag == 300 {
            arrayTotalVehicles[selectedIndexpath.row].vehicleTypeID = arrayMotoristType[row].motorist_vehicle_type_id ?? ""
            arrayTotalVehicles[selectedIndexpath.row].vehicleType = arrayMotoristType[row].type_name ?? ""
        }
        else if pickerView.tag == 400 {
            arrayTotalVehicles[selectedIndexpath.row].vehicleColorID = colorList[row].color_id ?? ""
            arrayTotalVehicles[selectedIndexpath.row].vehicleColorName = colorList[row].color_name ?? ""
        }
        else if pickerView.tag == 2000{
            arrayValues[CELL_CONTENT.Incident_type.rawValue] =  incidenceTypeList[row].incident_id ?? ""
            arrayPopulate[CELL_CONTENT.Incident_type.rawValue] =  incidenceTypeList[row].name ?? ""
            
            self.getIncidenceType =  incidenceTypeList[row].name ?? ""
            self.getIncidentTypeId =  incidenceTypeList[row].incident_id ?? ""
        }
    }
    
    
    func createPickerView(textField:UITextField) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        textField.inputView = pickerView
        pickerView.tag = textField.tag
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.action(sender:)))
        button.tag = textField.tag
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancel,spacer,button], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        
    }
    
    func createDatePickerView(textField:UITextField) {
        let datePicker = UIDatePicker()
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        
        if textField.tag == 4 {
        datePicker.datePickerMode = .time
        datePicker.minimumDate = Date()
        datePicker.minuteInterval = 1
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat =  "dd-MM-yyyy"
            let currentdate = dayFormatter.string(from: Date())
            let getTotalDate = "\(currentdate)" + " \(arrayPopulate[CELL_CONTENT.Call_Started.rawValue])"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat =  "h:mm a"
            
            let timeCFormatter = DateFormatter()
            timeCFormatter.dateFormat =  "dd-MM-yyyy h:mm a"
            
            
            let getTime  = timeCFormatter.date(from: getTotalDate)
            
            if let getTimeString = getTime{
               
                datePicker.minimumDate =  getTimeString.adding(minutes: 1)
            }
        } else if textField.tag == 2 {
            datePicker.datePickerMode = .time
            datePicker.maximumDate = Date()
        } else if textField.tag == 26{
            datePicker.datePickerMode = .dateAndTime
        }
        datePicker.locale = Locale.init(identifier: "en_us")

        textField.inputView = datePicker
        datePicker.tag = textField.tag
        datePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: UIControl.Event.valueChanged)
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done(sender:)))
        button.tag = textField.tag
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelDatePicker))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancel,spacer,button], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        
    }
    
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        if sender.tag == 3 {
          timeFormatter.dateFormat =  "h:mm a"
          let section2 =  sender.date.adding(minutes: 15)
            arrayPopulate[CELL_CONTENT.Call_Completed.rawValue] = timeFormatter.string(from: section2)
            arrayValues[CELL_CONTENT.Call_Completed.rawValue] = timeFormatter.string(from: section2)
            
            
            let difference = Calendar.current.dateComponents([.hour, .minute], from: sender.date, to: section2)
            let formattedString = String(format:  "%02ld H %02ld M", difference.hour!,difference.minute!)
            arrayValues[CELL_CONTENT.Incident_Time.rawValue] = formattedString
            arrayPopulate[CELL_CONTENT.Incident_Time.rawValue] = formattedString
            
            if let cell = self.tableIncident.cellForRow(at: IndexPath(row: 0, section:CELL_CONTENT.Call_Completed.rawValue )) as? IncidentInputCell{
                cell.txtFieldInput.tag = CELL_CONTENT.Call_Completed.rawValue
                self.createDatePickerView(textField: cell.txtFieldInput)
            }
            
           
        }else if sender.tag == 4{
                timeFormatter.dateFormat =  "h:mm a"
                let date1 = timeFormatter.date(from: arrayValues[CELL_CONTENT.Call_Started.rawValue])!
                let date2 = timeFormatter.date(from: arrayValues[CELL_CONTENT.Call_Completed.rawValue])!

                let elapsedTime = date2.timeIntervalSince(date1)

                // convert from seconds to hours, rounding down to the nearest hour
                let hours = floor(elapsedTime / 60 / 60)

                // we have to subtract the number of seconds in hours from minutes to get
                // the remaining minutes, rounding down to the nearest minute (in case you
                // want to get seconds down the road)
                let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
           // let formattedString = String(format: "%ld", minutes)
            
            let difference = Calendar.current.dateComponents([.hour, .minute], from: date1, to: date2)
            let formattedString = String(format: "%02ld H %02ld M", difference.hour!,difference.minute!)
            
            arrayValues[CELL_CONTENT.Incident_Time.rawValue] = formattedString
            arrayPopulate[CELL_CONTENT.Incident_Time.rawValue] = formattedString
        }else if sender.tag == 26 {
            timeFormatter.dateFormat =  "MM-dd-yyyy h:mm a"
            arrayValues[sender.tag] = timeFormatter.string(from: sender.date)
            arrayPopulate[sender.tag] = timeFormatter.string(from: sender.date)
        } else {
            timeFormatter.dateFormat =  "h:mm a"
            arrayValues[sender.tag] = timeFormatter.string(from: sender.date)
            arrayPopulate[sender.tag] = timeFormatter.string(from: sender.date)
        }
        
    }
    
    @objc func done(sender:UIBarButtonItem) {
        
        self.view.endEditing(true)
        if isSelected == false{
            
        }
        self.tableIncident.reloadData()
        isSelected = false
    }
    
    @objc func cancelDatePicker() {
        
        self.view.endEditing(true)
        isSelected = false
    }
    
    
    //    func dismissPickerView() {
    //
    //        //
    //    }
    
    @objc func cancelAction() {
        view.endEditing(true)
        isSelected = false
    }
    @objc func action(sender: UIBarButtonItem) {
        if isSelected == false{
            if sender.tag == 0{
                
            }else if sender.tag == CELL_CONTENT.Ramplanes.rawValue{
                if arrayRamplanes.count > 0{
                arrayValues[sender.tag] =  arrayRamplanes[0]
                arrayPopulate[sender.tag] = arrayRamplanes[0]
                }
            }
            else if sender.tag == CELL_CONTENT.Incident_type.rawValue{
                if incidenceTypeList.count > 0{
                arrayValues[sender.tag] =  incidenceTypeList[0].incident_id ?? ""
                arrayPopulate[sender.tag] = incidenceTypeList[0].name ?? ""
                }
            }
            else if sender.tag == CELL_CONTENT.Route_1.rawValue{
                 if routeList.count > 0{
                arrayValues[sender.tag] = routeList[0].route_id ?? ""
                arrayPopulate[sender.tag] = routeList[0].route_name ?? ""
                }
            }
            else if sender.tag == CELL_CONTENT.Traffic_Direction.rawValue {
                 if trafficdirectionList.count > 0{
                arrayValues[sender.tag] = trafficdirectionList[0].traffic_direction_id ?? ""
                arrayPopulate[sender.tag] = trafficdirectionList[0].traffic_direction ?? ""
                }
            }
            else if sender.tag == CELL_CONTENT.State.rawValue{
                if stateList.count > 0{
                arrayValues[sender.tag] = stateList[0].state_id ?? ""
                arrayPopulate[sender.tag] = stateList[0].state_name ?? ""
                }
            }
            else if sender.tag == CELL_CONTENT.Property_Damage.rawValue{
                if propertyList.count > 0{
                arrayValues[sender.tag] = propertyList[0].property_damage_id ?? ""
                arrayPopulate[sender.tag] = propertyList[0].property_damage ?? ""
                }
            }
            else if sender.tag == CELL_CONTENT.Secondary_crash_involved.rawValue{
                if secondaryCrashList.count > 0{
                arrayValues[sender.tag] = secondaryCrashList[0].crash_Inv_id ?? ""
                arrayPopulate[sender.tag] = secondaryCrashList[0].crash_Inv ?? ""
                }
            }
            else if sender.tag == CELL_CONTENT.First_Responder.rawValue{
                 if firstResponderList.count > 0{
                arrayValues[sender.tag] = firstResponderList[0]
                arrayPopulate[sender.tag] = firstResponderList[0]
                }
            }
            else if sender.tag == CELL_CONTENT.First_Responder_Unit_Number.rawValue{
                if responderUnitList.count > 0{
                arrayValues[sender.tag] = responderUnitList[0].id ?? ""
                arrayPopulate[sender.tag] = responderUnitList[0].unit_no ?? ""
                }
            }
                
                else if sender.tag == CELL_CONTENT.Road_Surface.rawValue{
                if roadSurface.count > 0{
                    arrayValues[sender.tag] = roadSurface[0]
                    arrayPopulate[sender.tag] = roadSurface[0]
                }
                }
                else if sender.tag == CELL_CONTENT.Lane_Location.rawValue{
                if laneLoc.count > 0{
                arrayValues[sender.tag] = laneLoc[0]
                arrayPopulate[sender.tag] = laneLoc[0]
                }
                }
                else if sender.tag == CELL_CONTENT.Passengers_Transported.rawValue{
                if passangerTransported.count > 0{
                    arrayValues[sender.tag] = passangerTransported[0]
                    arrayPopulate[sender.tag] = passangerTransported[0]
                }
                }
                
                
                else if sender.tag == CELL_CONTENT.Number_of_Vehicles.rawValue{
                     if numberVehicle.count > 0{
                        
                    arrayValues[sender.tag] = numberVehicle[0]
                    arrayPopulate[sender.tag] = numberVehicle[0]
                     
                        self.arrayTotalVehicles.removeAll()
                        if numberVehicle[0] == "0"{
                            
                        }else{
                        let vehicleObj = TotalVehiclesObject()
                        self.arrayTotalVehicles.append(vehicleObj)
                        }
                }
                }
            else if sender.tag == CELL_CONTENT.Vendor.rawValue{
                 if arrayVenderList.count > 0{
                arrayValues[sender.tag] = arrayVenderList[0].vendor_id ?? ""
                arrayPopulate[sender.tag] = arrayVenderList[0].vendor_name ?? ""
                }
            }
            else if sender.tag == CELL_CONTENT.Contract.rawValue{
                 if arrayContractList.count > 0{
                arrayValues[sender.tag] = arrayContractList[0].contract_id ?? ""
                arrayPopulate[sender.tag] = arrayContractList[0].contract_name ?? ""
                }
            }
            else if sender.tag == CELL_CONTENT.Assist_Type.rawValue{
                if asystList.count > 0{
                arrayValues[sender.tag] = asystList[0].assist_id ?? ""
                arrayPopulate[sender.tag] = asystList[0].assist_type ?? ""
                }
            }
            else if sender.tag == 300{
                if arrayMotoristType.count > 0{
arrayTotalVehicles[selectedIndexpath.row].vehicleTypeID = arrayMotoristType[0].motorist_vehicle_type_id ?? ""
          arrayTotalVehicles[selectedIndexpath.row].vehicleType = arrayMotoristType[0].type_name ?? ""
                }
            }
            else if sender.tag == 400{
                if colorList.count > 0{
arrayTotalVehicles[selectedIndexpath.row].vehicleColorID = colorList[0].color_id ?? ""
arrayTotalVehicles[selectedIndexpath.row].vehicleColorName = colorList[0].color_name ?? ""
                }
            }
            else if sender.tag == 2000{
                if incidenceTypeList.count > 0{
                arrayValues[CELL_CONTENT.Incident_type.rawValue] =  incidenceTypeList[0].incident_id ?? ""
                arrayPopulate[CELL_CONTENT.Incident_type.rawValue] = incidenceTypeList[0].name ?? ""
                    self.getIncidenceType = incidenceTypeList[0].name ?? ""
                    self.getIncidentTypeId = incidenceTypeList[0].incident_id ?? ""
                    txtIncidentType.text = getIncidenceType
                }
                self.callAllIncidenceListApi()
            }
        }else{
            if sender.tag == 2000{
//                if incidenceTypeList.count > 0{
//                arrayValues[CELL_CONTENT.Incident_type.rawValue] =  incidenceTypeList[0].incident_id ?? ""
//                arrayPopulate[CELL_CONTENT.Incident_type.rawValue] = incidenceTypeList[0].name ?? ""
//                    self.getIncidenceType = incidenceTypeList[0].name ?? ""
//                    self.getIncidentTypeId = incidenceTypeList[0].incident_id ?? ""
//                }
                txtIncidentType.text = getIncidenceType
                self.callAllIncidenceListApi()
            }
        }
        view.endEditing(true)
        isSelected = false
        tableIncident.reloadData()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        let buttonPosition = textView.convert(CGPoint.zero, to: self.tableIncident)
        if let indexPath = self.tableIncident.indexPathForRow(at:buttonPosition){
        let cell = self.tableIncident.cellForRow(at: indexPath) as? IncidentCommentCell
        
     
           
        if cell != nil{
            
            if cell?.txtViewComment.text == "Write Here..." {
                cell?.txtViewComment.text = ""
                
            }
        }
    }
    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//
//        let cell = self.tableIncident.cellForRow(at: IndexPath(row:0 , section: CELL_CONTENT.Comments.rawValue)) as? IncidentCommentCell
//        if cell != nil{
//            if cell?.txtViewComment.text == "" {
//                cell?.txtViewComment.text = "Write Here..."
//            }
//        }
//    }
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        arrayValues[arrayValues.count - 8] =  textView.text
        arrayPopulate[arrayPopulate.count - 8] = textView.text
        print(arrayValues)
    }
    
}
extension UILabel{
    
    
    func setSubTextColor(pSubString : String, pColor : UIColor){
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: self.text!);
        let range = attributedString.mutableString.range(of: pSubString, options:NSString.CompareOptions.caseInsensitive)
        if range.location != NSNotFound {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: pColor, range: range);
        }
        self.attributedText = attributedString
        
    }
}
extension AddIncidentFormVC{
    
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
        
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
                    "Accept": "application/json"]
        

        let url = "https://atims.sspreporter.com/api/getLaneLocation"
        let userId: String = (UserDefaults.standard.value(forKey: "USERID") as? String)!
        let companyID:String = (UserDefaults.standard.value(forKey: "COMPANYID") as? String)!
        
        let params : [String:Any]  = ["source":"MOB","companyId":"\(companyID)","user_id":"\(userId)"]
       
        print("============HEADERS=================")
        print(headers)
        print("============PARAMS=================")
        print(params)
        print("============URL=================")
        print(url)
        Alamofire.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                
                let resultValue = SwiftyJSON.JSON(value)
                print("=============RESPONSE DATA==================")
                print(resultValue)

                let statusStr = resultValue["status"]["error_code"].boolValue
                if statusStr == false{
                    let listArray = resultValue["result"]["data"].arrayValue
                    print(":::::::::::::::::::::LIST ARRAY:::::::::::::::::::::")
                    print(listArray)
                    self.laneLocArray = listArray
                    self.tbleVw_LaneLocation.reloadData()
                    self.vw_LaneLocation.isHidden = false
                }
                else{
                    //errors
                    let message = resultValue["message"].stringValue
                    
                }
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    /*{
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
                                    print(":::::::::::::::::::::LIST ARRAY:::::::::::::::::::::")
                                    print(listArray)
                                }
                                catch {
                                    print(error)
                                    
                                }
                            }
                        }
                    }else {
                        
                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                    }
                }
            }
        }
        appDel.operationQueue.addOperation(opt)
        
    }
    */
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
                                    
                                   let obj =  self.secondaryCrashList.filter { (obj) -> Bool in
                                        obj.crash_Inv == "No"
                                    }
                                    
                                    self.arrayPopulate[CELL_CONTENT.Secondary_crash_involved.rawValue] = obj[safe:0]?.crash_Inv ?? ""
                                    self.arrayValues[CELL_CONTENT.Secondary_crash_involved.rawValue] = obj[safe:0]?.crash_Inv_id ?? ""
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
    func callAllIncidenceListApi(){
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
//            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
//                param["user_id"] = userId as AnyObject
//            }
            param["companyId"] = companyID as AnyObject
            param["incident_type_id"] = self.getIncidentTypeId as AnyObject
            
            
            
        }
        let opt = WebServiceOperation.init((API.IncidenceFormList.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                self.arrayFormList.removeAll()
                self.tableIncident.reloadData()
                print(opt.responseData?.dictionary?.prettyprintedJSON ?? "")
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["data"] as? [[String:Any]] {
                                do {
                                   let getFormList = try JSONDecoder().decode([IncidenceFormList].self,from:(listArray.data)!)
                                    self.arraySortFormList = getFormList.filter {
                                        $0.show == "1"
                                    }
                                    self.arrayFormList = getFormList
                                    let object = IncidenceFormList.init(
                                          id : "28",
                                          fieldType : "dropdown",
                                          show : "0",
                                          title : "totalvehicle",
                                          incidentPrefix : ""
                                        
                                    )
                                    self.arrayFormList.insert(object, at: 28)
                                    //self.arrayFormList.swapAt(9, 18)
//                                    let obj = self.arrayFormList[18]
//                                    self.arrayFormList.insert(obj, at: 9)
//                                    self.arrayFormList.remove(at: 19)
                                   // print(self.arrayFormList)
                                    
                                    
//                                    let jsonString = self.arrayFormList.todJSONString()
//                                    print(jsonString)
//                                    if self.arrayFormList[CELL_CONTENT.Number_of_Vehicles.rawValue].show == "1"{
//                                        self.arrayValues[CELL_CONTENT.Number_of_Vehicles.rawValue] = "1"
//                                        self.arrayPopulate[CELL_CONTENT.Number_of_Vehicles.rawValue] = "1"
//                                    }
                                    self.tableIncident.reloadData()
                                    
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
    func callAddIncidenceAPI(isUpdate:String){
        if Connectivity.isConnectedToInternet {
            var param:[String:AnyObject] = [String:AnyObject]()
//            if let image = self.incidenceImage{
//                let resizeImage = self.resizeImage(image: image, newWidth: 100)!
//                let imageData = resizeImage.jpegData(compressionQuality: 1)
//
//                let imageFileInfo = MultiPartDataFormatStructure.init(key: "incedent_photo", mimeType: .image_jpeg, data: imageData, name: "incedent_photo.jpg")
//                arrayFileInfo.append(imageFileInfo)
//            }
//            if let video = self.videoData{
//
//                let imageFileInfo = MultiPartDataFormatStructure.init(key: "incedent_video", mimeType: .video_mp4, data: video, name: "incidence_video.mp4")
//                arrayFileInfo.append(imageFileInfo)
//            }
//
            if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
                if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                   // param["companyState"] = self.arrayValues[CELL_CONTENT.State.rawValue] as AnyObject as AnyObject
                    //                       param["companyArea"] = "6" as AnyObject//companyID as AnyObject
                    //                       param["companyZone"] = "2" as AnyObject
                    if let shiftID = UserDefaults.standard.value(forKey: "SHIFTID"){
                        param["shift_id"] = shiftID as AnyObject
                    }else{
                        param["shift_id"] = "1" as AnyObject
                    }
//                    if let vID:String = UserDefaults.standard.value(forKey: "VEHICLEID") as? String {
//                        param["vehicle_id"] = vID as AnyObject
//                    }
                    param["vehicle_id"] = TimeService.instance.vechileId as AnyObject?
                    param["companyRoute"] = self.arrayValues[CELL_CONTENT.Ramplanes.rawValue] as AnyObject
                    param["latitude"] = self.arrayValues[CELL_CONTENT.Latitude.rawValue] as AnyObject
                    param["longitude"] = self.arrayValues[CELL_CONTENT.Longitude.rawValue] as AnyObject
                    param["callAt"] =  self.arrayValues[CELL_CONTENT.Call_At.rawValue] as AnyObject
                    param["callStarted"] = self.arrayValues[CELL_CONTENT.Call_Started.rawValue] as AnyObject
                    param["callComplete"] = self.arrayValues[CELL_CONTENT.Call_Completed.rawValue] as AnyObject
                    param["incidentTime"] = self.arrayValues[CELL_CONTENT.Call_Completed.rawValue] as AnyObject
                    param["incidentType"] = self.arrayValues[CELL_CONTENT.Incident_type.rawValue] as AnyObject
                    param["trafficDirection"] = self.arrayValues[CELL_CONTENT.Traffic_Direction.rawValue] as AnyObject
                    param["milageIn"] = "1" as AnyObject //self.arrayValues[CELL_CONTENT.Mileage_In.rawValue] as AnyObject
                    param["milageOut"] = "2" as AnyObject //self.arrayValues[CELL_CONTENT.Mileage_Out.rawValue] as AnyObject
                    param["mileMaker"] = self.arrayValues[CELL_CONTENT.Mile_Marker.rawValue] as AnyObject
                    
                    param["propertyDamage"] = self.arrayValues[CELL_CONTENT.Property_Damage.rawValue] as AnyObject
                    param["crashInvolced"] = self.arrayValues[CELL_CONTENT.Secondary_crash_involved.rawValue] as AnyObject//"2" as AnyObject
                    param["firstResponder"] = self.arrayValues[CELL_CONTENT.First_Responder.rawValue] as AnyObject
                    param["firstResponderUnit"] = self.arrayValues[CELL_CONTENT.First_Responder_Unit_Number.rawValue] as AnyObject as AnyObject
                    param["roadSurver"] = self.arrayValues[CELL_CONTENT.Road_Surface.rawValue] as AnyObject
                    param["laneLocation"] = self.arrayValues[CELL_CONTENT.Lane_Location.rawValue] as AnyObject as AnyObject
                    param["personTransported"] = self.arrayValues[CELL_CONTENT.Passengers_Transported.rawValue] as AnyObject
                    param["companyColor"] = "" as AnyObject//self.arrayValues[CELL_CONTENT.Color.rawValue] as AnyObject
                    param["vehicleType"] = "" as AnyObject //self.arrayValues[CELL_CONTENT.Vehicle_Type.rawValue] as AnyObject
                    param["assistType"] = self.arrayValues[CELL_CONTENT.Assist_Type.rawValue] as AnyObject
                    param["comments"] = self.arrayValues[CELL_CONTENT.Comments.rawValue] as AnyObject
                    param["travel_lanes_blocked"] = self.arrayValues[CELL_CONTENT.TravelLanesBlocked.rawValue] as AnyObject//self.arrayValues[CELL_CONTENT.Comments.rawValue] as AnyObject
                    param["lane_restoration_time"] = self.arrayValues[CELL_CONTENT.LaneRestorationTime.rawValue] as AnyObject
                    param["incident_no"] = self.arrayValues[CELL_CONTENT.IncidentNo.rawValue] as AnyObject
                    
                    param["actionStatus"] = isUpdate as AnyObject
                    param["note"] = "" as AnyObject
                    param["userId"] = userId as AnyObject
                    param["companyId"] = companyID as AnyObject
                    param["plate_no"] = "" as AnyObject
                    param["source"] = "MOB" as AnyObject
                    param["companyState"] = self.arrayValues[CELL_CONTENT.State.rawValue] as AnyObject
                    param["vehicleQty"] = self.arrayValues[CELL_CONTENT.Number_of_Vehicles.rawValue] as AnyObject
                    if isUpdate.lowercased() == "update"{
                        param["incidentReportId"] = modelIncidence?.incidents_report_data_id as AnyObject?
                        param["incident_status"] = "On Scene" as AnyObject?
                    }else{
                        param["incident_status"] = "On Scene" as AnyObject?
                    }
                    //vehicleInformation
                    //vendor_id
                    param["vendor_id"] = self.arrayValues[CELL_CONTENT.Vendor.rawValue] as AnyObject
                    param["contract_id"] = self.arrayValues[CELL_CONTENT.Contract.rawValue] as AnyObject
                    var vehicleInformation:String = self.prepareVehicleInformationString()
                    if vehicleInformation == "[]"{
                        
                    }
                    //ramp_lane
                    param["ramp_lane"] = self.arrayValues[CELL_CONTENT.Ramplanes.rawValue] as AnyObject
                    param["vehicleInformation"] = vehicleInformation as AnyObject
                    param["vehicleQty"] = self.arrayValues[CELL_CONTENT.Number_of_Vehicles.rawValue] as AnyObject
                    //param["direction"] = self.arrayValues[CELL_CONTENT.Direction.rawValue] as AnyObject
                    //param["description"] = self.arrayValues[CELL_CONTENT.Description.rawValue] as AnyObject
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
                    
                    
                }
                
            }
            
            // }
            print(param)
            let opt = WebServiceOperation.init(API.putIncidents.getURL()?.absoluteString ?? "", param, .WEB_SERVICE_MULTI_PART, arrayFileInfo)
            opt.completionBlock = {
                DispatchQueue.main.async {
                    print(opt.responseData?.dictionary?.prettyprintedJSON ?? "")
                    guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                        return
                    }
                    if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                        if errorCode.intValue == 0 {
                            if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0,let dictDetails = dictResult["data"] as? [String:Any] {
                                do{
                                    let okClause = PROJECT_CONSTANT.CLOUS{
                                        for controller in self.navigationController!.viewControllers as Array {
                                            
                                            if controller.isKind(of: IncidentVC.self) {
                                                self.navigationController!.popToViewController(controller, animated: true)
                                                break
                                            }
                                        }
                                    }
                                    
                                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":okClause], Style: .alert)
                                    var paramSave:[String:AnyObject] = [String:AnyObject]()
                                                                           paramSave["lat"] = MyLocationManager.share.myCurrentLocaton?.latitude as AnyObject?
                                                                           paramSave["long"] = MyLocationManager.share.myCurrentLocaton?.longitude as AnyObject?
                                                                           UserDefaults.standard.set(paramSave, forKey: "Petrolling")
                                    
                                    
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
extension AddIncidentFormVC{
    
//    @objc func showRoadSurfaceAlert(sender:UIButton){
//
//    }
    @objc func showLaneLocationAlert(sender:UIButton){
        if sender.tag == CELL_CONTENT.Lane_Location.rawValue{
           // self.showLaneLocation()
            self.callLaneLocApi()
            print(laneLoc.count)
            print(laneLoc)
           // self.vw_LaneLocation.isHidden = false
        }
        if sender.tag == CELL_CONTENT.Road_Surface.rawValue{
            self.showRoadSurface()
        }
        
    }
    func showRoadSurface(style: UIAlertController.Style = .actionSheet, title: String = "Please select Road surface", action: String = "Ok", height: Double = 300.0) {
        let selectionStyle: SelectionStyle = style == .alert ? .single : .multiple
        
        // create menu
        let selectionMenu =  RSSelectionMenu(selectionStyle: selectionStyle, dataSource: roadSurface) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        
        // provide selected items
        selectionMenu.setSelectedItems(items: arraySelectedRoadSurface) { (text, index, isSelected, selectedItems) in
        }
        
        // on dismiss handler
        selectionMenu.onDismiss = { [weak self] items in
            
            self?.arraySelectedRoadSurface = items
            
            if style == .alert {
                //self?.alertRowDetailLabel.text = items.first
            }else {
                self?.arrayPopulate[CELL_CONTENT.Road_Surface.rawValue] = items.joined(separator: ", ")
                self?.arrayValues[CELL_CONTENT.Road_Surface.rawValue] = items.joined(separator: ", ")
                
                //self?.multiSelectActionSheetLabel.text = items.joined(separator: ", ")
            }
            self?.tableIncident.reloadData()
        }
        
        // cell selection style
        selectionMenu.cellSelectionStyle = self.cellSelectionStyle
        
        
        // show - with action (if provided)
        let menuStyle: PresentationStyle = style == .alert ? .alert(title: title, action: action, height: height) : .actionSheet(title: title, action: action, height: height)
        
        selectionMenu.show(style: menuStyle, from: self)
    }
    
    func showLaneLocation(style: UIAlertController.Style = .actionSheet, title: String? = "Please select Lane Location", action: String = "OK", height: Double = 300.0) {
        let selectionStyle: SelectionStyle = style == .alert ? .single : .multiple
        
        // create menu
        let selectionMenu =  RSSelectionMenu(selectionStyle: selectionStyle, dataSource: laneLoc) { (cell, name, indexPath) in
            cell.textLabel?.text = name
        }
        
        // provide selected items
        selectionMenu.setSelectedItems(items: arraySelectedLaneLocation) { (text, index, isSelected, selectedItems) in
        }
        
        // on dismiss handler
        selectionMenu.onDismiss = { [weak self] items in
            
            self?.arraySelectedLaneLocation = items
            
            if style == .alert {
                //self?.alertRowDetailLabel.text = items.first
            }else {
                self?.arrayPopulate[CELL_CONTENT.Lane_Location.rawValue] = items.joined(separator: ", ")
                self?.arrayValues[CELL_CONTENT.Lane_Location.rawValue] = items.joined(separator: ", ")
                
                //self?.multiSelectActionSheetLabel.text = items.joined(separator: ", ")
            }
            self?.tableIncident.reloadData()
        }
        
        // cell selection style
        selectionMenu.cellSelectionStyle = self.cellSelectionStyle
        
        
        // show - with action (if provided)
        let menuStyle: PresentationStyle = style == .alert ? .alert(title: title, action: action, height: height) : .actionSheet(title: title, action: action, height: height)
        
        selectionMenu.show(style: menuStyle, from: self)
    }
    
}
extension Collection where Iterator.Element == [String:AnyObject] {
    func toJSONString(options: JSONSerialization.WritingOptions = .fragmentsAllowed) -> String {
        if let arr = self as? [[String:AnyObject]],
            let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
            let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}
extension Collection where Iterator.Element == IncidenceFormList {
    func todJSONString(options: JSONSerialization.WritingOptions = .fragmentsAllowed) -> String {
        if let arr = self as? [IncidenceFormList],
            let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
            let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}
extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}

extension AddIncidentFormVC { //21/09/22
    
    func addTimeOutTimer() {
        let seconds: Double = 60*30 //30 minutes
        Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { _ in
            let ok = PROJECT_CONSTANT.CLOUS{
//                for controller in self.navigationController!.viewControllers as Array {
//
//                    if controller.isKind(of: IncidentVC.self) {
//                        self.navigationController!.popToViewController(controller, animated: true)
//                        break
//                    }
//                }
                DispatchQueue.main.asyncAfter(deadline:.now() + 0.10, execute: {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "IncidentVC") as! IncidentVC
                            self.navigationController?.popPushToVC(ofKind: IncidentVC.self, pushController: vc)//(vc, animated: true)
                            })
            }
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody:"Incident Form Time Out" , AllActions: ["OK": ok], Style: .alert)
        }
    }
}
