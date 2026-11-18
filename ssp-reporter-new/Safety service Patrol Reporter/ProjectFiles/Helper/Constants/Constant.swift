//
//  Constant.swift
//  ModelingStudio
//
//  Created by Kaustav Shee on 07/08/17.
//  Copyright © 2017 Kaustav Shee. All rights reserved.
//
// final file
import Foundation
import UIKit
import Alamofire

let deviceBounds:CGRect! = UIScreen.main.bounds
let appDel = (UIApplication.shared.delegate as! AppDelegate)
let keyWindow = UIApplication.shared.connectedScenes
.filter({$0.activationState == .foregroundActive})
.map({$0 as? UIWindowScene})
.compactMap({$0})
.first?.windows
.filter({$0.isKeyWindow}).first


let AppthemeColor:UIColor! = UIColor(red: 0.983, green:0.818, blue: 0.141, alpha: 0.4)

let textFieldBorderColor = UIColor(red: 173.0/255.0, green: 152.0/255.0, blue: 202.0/255.0, alpha: 1.0)
let placeholderColor:UIColor! = UIColor(red: 145.0/255.0, green:
145.0/255.0, blue: 145.0/255.0, alpha: 1.0)
let appOffWhite:UIColor! = UIColor(red: 255/255.0, green:0.989, blue: 0.941, alpha: 1.0)
let darkThemeColor = UIColor(red: 243.0/255.0, green:209.0/255.0, blue: 24.0/255.0, alpha: 1.0)


struct PROJECT_CONSTANT {
    
    static var hasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        
        return false
    }
    
    static var strTimestamp: String {
        let temp = Int64.init(Date().timeIntervalSince1970 * 1000)
        return "\(temp)"
    }
    
    public typealias CLOUS = (()->())?
    
    
    
    public static func getSuperview(OfType type:AnyClass, fromView vw:AnyObject?) -> AnyObject? {
        guard vw != nil else {
            return nil
        }
        
        var myView = vw!
        
        if myView.isKind(of: type) {
            return myView
        }
        
        while myView.superview != nil {
            myView = myView.superview as AnyObject
            if myView.isKind(of: type) {
                return myView
            }
        }
        return nil
    }
    
    
    public static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    
    public static func displayAlert(Header strHeader:String!,MessageBody strMsgBody:String!,AllActions actions:[String:CLOUS],Style style:UIAlertController.Style) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: strHeader, message: strMsgBody, preferredStyle: style)
            
            for (key,val) in actions {
                if key.lowercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "cancel" {
                    let action = UIAlertAction(title: key, style: .cancel, handler: { (action) in
                        alertController.dismiss(animated: true, completion: nil)
                        if let actionHandler = val {
                            actionHandler()
                        }
                    })
                    alertController.addAction(action)
                }else{
                    let action = UIAlertAction(title: key, style: .default, handler: { (action) in

                        alertController.dismiss(animated: true, completion: nil)
                        if let actionHandler = val {
                            actionHandler()
                        }
                    })

                    alertController.addAction(action)
                }
            }
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    public static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    
    
    public static func addInputAccessoryView(_ arrTextFields:[UITextField]) {
        guard arrTextFields.count > 0 else {
            return
        }
        for textField in arrTextFields {
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let flexiableSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: textField, action: #selector(textField.resignFirstResponder))
            toolBar.setItems([flexiableSpace, doneButton], animated: false)
            textField.inputAccessoryView = toolBar
        }
    }
    
}

let NoInterNet:String! = "No Internet connection"
let App_Title:String! = "SSP Reporter"
let NoShift:String! = "You don't have any active shift"
//let BaseUrl:String   = "http://dev.fitser.com:3794/ATIMS/api/"

let BaseUrl:String   = "https://atims.sspreporter.com/api/"

public enum API:Int {
    case Login = 0
    case MenuAccess //new
    case StateList
    case OperationAreaList
    case ZoneList
    case VehicleList
    case StartShift
    case EndShift
    case FuelReportList
    case IncidentsDetails
    case IncidentStatusUpdate
    case forgotPassword
    case logout
    case getProfile
    case shiftListAll //new
    case updateProfile
    case changePassword
    case fuelReportAdd
    case colorList
    case firstresponderList
    case trafficdirectionList
    case getRouteList
    case SecondarycrashList
    case propertydamageList
    case assistList
    case incidenttypeList
    case putIncidents
    case vehicletypeList
    case questionsList
    case getToolsList
    case crashReportUploadImage
    case crashReportAddEdit
    case ResponderUnit
    case FAQ
    case crashReportListAll
    case inspectionList
    case getShiftExtraTimeList
    case savePreOpsReportData
    case preopsUploadimage
    case putsos
    case maintenanceListAll
    case maintenanceListSingle
    case servicTypeListAll
    case vendorListAll
    case maintenanceAddEdit
    //Pritam
    case saveInspectionData
    case uploadInspectionImage
    case inspectionReport
    case inspectionQuestionsList
    case notificationSendListAll
    ///
    case Help
    case Userdetails
    case userprofileEdit
    case extraTimeReasonList
    case saveExtraTimeRequest
    case updateExtraTimeRequest
    case changeNotificationReadStatus
    case getUserList
    case sosReasonListAll
    case resetPasswordOtpSend
    case fuelTypeListAll
    case getShiftReportData
    case gpsData
    case statusIndicator
    case resetPassword
    case startBreak
    case endBreak
    case getOperationShift
    case sendSurvey
    case isLoggedIn
    case version_control
    case getLaneLocation
    case closeIncident
    case VenderList
    case contractList
    case MotorType
    case SurfaceList
    case WazeInfo
    case IncidenceFormList
    case CloseForceIncident
    case SubmitBugReport
    
    func getURL() -> URL? {
        switch self {
        case .Login:
            return URL.init(string: (BaseUrl+"login"))
        case .MenuAccess:
            return URL.init(string: (BaseUrl+"menuaccess"))
        case .StateList:
            return URL.init(string: (BaseUrl+"stateList"))
        case .OperationAreaList:
            return URL.init(string: (BaseUrl+"operationareaList"))
        case .ZoneList:
            return URL.init(string: (BaseUrl+"getZoneArea"))
        case .VehicleList:
            return URL.init(string: (BaseUrl+"vehicleList"))
        case .StartShift:
            return URL.init(string: (BaseUrl+"operatorShiftTimeStart"))
        case .EndShift:
            return URL.init(string: (BaseUrl+"operatorShiftTimeEnd"))
            
        case .FuelReportList:
            return URL.init(string: (BaseUrl+"fuelReportListAll"))
        case .IncidentsDetails:
            return URL.init(string: (BaseUrl+"incidentsDetails"))
        case .IncidentStatusUpdate:
            return URL.init(string: (BaseUrl+"incidentStatusUpdate"))
        case .forgotPassword:
            return URL.init(string: (BaseUrl+"forgotPassword"))
        case .logout:
            return URL.init(string: (BaseUrl+"logout"))
        case .getProfile:
            return URL.init(string: (BaseUrl+"get_profile"))
        case .shiftListAll:
            return URL.init(string: (BaseUrl+"shiftListAll"))
        case .updateProfile:
            return URL.init(string: (BaseUrl+"updateProfile"))
        case .changePassword:
            return URL.init(string: (BaseUrl+"changePassword"))
        case .fuelReportAdd:
            return URL.init(string: (BaseUrl+"fuelReportAdd"))
        case .getRouteList:
            return URL.init(string: (BaseUrl+"getRouteList"))
        case .colorList:
            return URL.init(string: (BaseUrl+"colorList"))
        case .firstresponderList:
            return URL.init(string: (BaseUrl+"firstresponderList"))
        case .trafficdirectionList:
            return URL.init(string: (BaseUrl+"trafficdirectionList"))
        case .SecondarycrashList:
            return URL.init(string: (BaseUrl+"secondarycrashList"))
        case .propertydamageList:
            return URL.init(string: (BaseUrl+"propertydamageList"))
        case .assistList:
            return URL.init(string: (BaseUrl+"assistList"))
        case .incidenttypeList:
            return URL.init(string: (BaseUrl+"incidenttypeList"))
        case .putIncidents:
            return URL.init(string: (BaseUrl+"putIncidents"))
        case .vehicletypeList:
            return URL.init(string: (BaseUrl+"vehicletypeList"))
        case .getToolsList:
            return URL.init(string: (BaseUrl+"getToolsList"))
        case .questionsList:
            return URL.init(string: (BaseUrl+"questionsList"))
        case .crashReportUploadImage:
            return URL.init(string: (BaseUrl+"crashReportUploadImage"))
        case .crashReportAddEdit:
            return URL.init(string: (BaseUrl+"crashReportAddEdit"))
        case .ResponderUnit:
            return URL.init(string: (BaseUrl+"getResponderUnit"))
        case .FAQ:
            return URL.init(string: (BaseUrl+"get/faq/list"))
        case .crashReportListAll:
            return URL.init(string: (BaseUrl+"crashReportListAll"))
        case .inspectionList:
            return URL.init(string: (BaseUrl+"inspectionList"))
        case .getShiftExtraTimeList:
            return URL.init(string: (BaseUrl+"getShiftExtraTimeList"))
        case .savePreOpsReportData:
            return URL.init(string: (BaseUrl+"savePreOpsReportData"))
        case .preopsUploadimage:
            return URL.init(string: (BaseUrl+"preopsUploadimage"))
        case .putsos:
            return URL.init(string: (BaseUrl+"putsos"))
        case .maintenanceListSingle:
            return URL.init(string: (BaseUrl+"maintenanceListSingle"))
        case .servicTypeListAll:
            return URL.init(string: (BaseUrl+"servicTypeListAll"))
        case .vendorListAll:
            return URL.init(string: (BaseUrl+"vendorListAll"))
        case .maintenanceListAll:
            return URL.init(string: (BaseUrl+"maintenanceListAll"))
        case .maintenanceAddEdit:
            return URL.init(string: (BaseUrl+"maintenanceAddEdit"))
        //Pritam
        case .saveInspectionData:
            return URL.init(string: (BaseUrl+"saveInspectionData"))
        case  .uploadInspectionImage:
            return URL.init(string: (BaseUrl+"uploadInspectionImage"))
        case .inspectionReport:
            return URL.init(string: (BaseUrl+"inspectionReport"))
        case .inspectionQuestionsList:
            return URL.init(string: (BaseUrl+"inspectionQuestionsList"))
        case .notificationSendListAll:
            return URL.init(string: (BaseUrl+"notificationSendListAll"))
            
        case .Help:
            return URL.init(string: (BaseUrl+"get/help/save"))
        case .Userdetails:
            return URL.init(string: (BaseUrl+"userinfo"))
        case .userprofileEdit:
            return URL.init(string: (BaseUrl+"userprofileEdit"))
        case .extraTimeReasonList:
            return URL.init(string: (BaseUrl+"extraTimeReasonList"))
        case .saveExtraTimeRequest:
            return URL.init(string: (BaseUrl+"saveExtraTimeRequest"))
        case .getShiftReportData:
            return URL.init(string: (BaseUrl+"getShiftReportData"))
        case .updateExtraTimeRequest:
            return URL.init(string: (BaseUrl+"updateExtraTimeRequest"))
        case .changeNotificationReadStatus:
            return URL.init(string: (BaseUrl+"changeNotificationReadStatus"))
        case .getUserList:
            return URL.init(string: (BaseUrl+"getUserList"))
        case .sosReasonListAll:
            return URL.init(string: (BaseUrl+"sosReasonListAll"))
        case .resetPasswordOtpSend:
            return URL.init(string: (BaseUrl+"resetPasswordOtpSend"))
        case .fuelTypeListAll:
            return URL.init(string: (BaseUrl+"fuelTypeListAll"))
        case .gpsData:
            return URL.init(string: (BaseUrl+"gpsData/put"))
        case .statusIndicator:
            return URL.init(string: (BaseUrl+"statusIndicator/put"))
        case .resetPassword:
            return URL.init(string: (BaseUrl+"resetPassword"))
        case .startBreak:
            return URL.init(string: (BaseUrl+"saveBreakTime"))
        case .endBreak:
            return URL.init(string: (BaseUrl+"updateBreakTime"))
        case .getOperationShift:
            return URL.init(string: (BaseUrl+"getOperationShift"))
        case .sendSurvey:
            return URL.init(string: (BaseUrl+"sendSurvey"))
        case .isLoggedIn:
            return URL.init(string: (BaseUrl+"isLoggedIn"))
        case .version_control:
            return URL.init(string: (BaseUrl+"validate-version"))
        case .getLaneLocation:
             return URL.init(string: (BaseUrl+"getLaneLocation"))
        case .closeIncident:
            return URL.init(string: (BaseUrl+"close-incident"))
        case .VenderList:
            return URL.init(string: (BaseUrl+"get/vendor/list"))
            
        case .contractList:
            return URL.init(string: (BaseUrl+"get/contract/list"))
        case .MotorType:
            return URL.init(string: (BaseUrl+"get-motorist-type-list"))
            
        case .SurfaceList:
            return URL.init(string: (BaseUrl+"get-surface-list"))
            
        case .WazeInfo:
            return URL.init(string: (BaseUrl+"save-waze-info"))
            
        case .IncidenceFormList:
            return URL.init(string: (BaseUrl+"v2/get-incident-form-fields"))
            //
            
        case .CloseForceIncident:
            return URL.init(string: (BaseUrl+"close-incident-force"))
        
        case .SubmitBugReport:
            return URL.init(string: (BaseUrl+"submit-bug-report"))
        }
    }
}

public enum POST_MULTIPART_TYPE:Int {
    
    case POST_MULTIPART_TYPE_Image = 0
    case POST_MULTIPART_TYPE_Video
    case POST_MULTIPART_TYPE_Audio
    
    static func  get(_ str:String) -> POST_MULTIPART_TYPE? {
        if str == "1" {
            return POST_MULTIPART_TYPE(rawValue: 0)
        }
        if str == "2" {
            return POST_MULTIPART_TYPE(rawValue: 1)
        }
        if str == "3" {
            return POST_MULTIPART_TYPE(rawValue: 2)
        }
        return nil
    }
    
    func getServerEndIdentifier() -> String {
        switch self {
        case .POST_MULTIPART_TYPE_Image:
            return "1"
        case .POST_MULTIPART_TYPE_Video:
            return "2"
        case .POST_MULTIPART_TYPE_Audio:
            return "3"
        }
    }
}

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
    
        case "iPhone6":             return "iPhone 6"
        case "iPhone6Plus":         return "iPhone 6 Plus"
        case "iPhone6S":            return "iPhone 6S"
        case "iPhone6SPlus":        return "iPhone 6S Plus"
        case "iPhoneSE":            return "iPhone SE"
        case "iPhone7":             return "iPhone 7"
        case "iPhone7Plus":         return "iPhone 7 Plus"
        case "iPhone8":             return "iPhone 8"
        case "iPhone8Plus":         return "iPhone 8 Plus"
        case "iPhoneX":             return "iPhone X"
        case "iPhoneXS":            return "iPhone XS"
        case "iPhoneXSMax":         return "iPhone XS Max"
        case "iPhoneXR":            return "iPhone XR"
        default:                   return identifier
        }
    }
    
}
