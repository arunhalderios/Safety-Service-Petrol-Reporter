//
//  IncidentVC.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 20/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class IncidentVC: BaseViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    var shiftStatus :Bool = false
    @IBOutlet weak var txtIncidentType: TextFieldX!
    @IBOutlet weak var viewDirection: ViewX!
    @IBOutlet weak var transperentBlackView: UIView!
    @IBOutlet weak var txtFieldDescription: TextFieldX!
    @IBOutlet weak var txtfieldDirection: TextFieldX!
    @IBOutlet weak var lblNodata: UILabel!
    @IBOutlet weak var viewMain: CustomView!
    @IBOutlet weak var viewSelfInitiated: CustomView!
    @IBOutlet weak var viewDispatched: CustomView!
    @IBOutlet weak var tableIncident: UITableView!
    var incidenceTypeList:[IncidenceType] = []
    var reporterID:String = ""
    var comments: String = ""
    var model = IncidentModel()
    var incidentID:String = ""
    var arrayDescription = ["Motor Vehicle Accident", "Safety Service Operator-Roadside Assistance","Debris in Road","Disabled Vehicle"]
    var arrayDirection = ["One Direction", "Both Directions"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableIncident.delegate = self
        self.tableIncident.dataSource = self
        self.tableIncident.reloadData()
        self.callIncidenceTypeListApi()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        TimeService.instance.resetInactivityTimer()
        self.hidePopupPetrolling()
        self.callIncidentListApi()
    }
    
    override func viewDidLayoutSubviews(){
        viewMain.layer.cornerRadius = viewMain.frame.size.height / 2
        viewSelfInitiated.layer.cornerRadius = viewSelfInitiated.frame.size.height / 2
        viewDispatched.layer.cornerRadius = viewDispatched.frame.size.height / 2
    }
    fileprivate func hidePopupPetrolling(){
        self.transperentBlackView.isHidden = true
        self.viewDirection.isHidden = true
    }
    
    fileprivate func showPopupPetrolling() {
           txtFieldDescription.text = ""
           txtfieldDirection.text = ""
           txtIncidentType.tag = 2
           self.createPickerView(textField: txtfieldDirection)
           self.createPickerView(textField: txtFieldDescription)
           self.createPickerView(textField: txtIncidentType)
        
           txtfieldDirection.addLeftViewPadding(padding: 9, placeholderText: "Select")
           txtFieldDescription.addLeftViewPadding(padding: 9, placeholderText: "Select")
           txtFieldDescription.addRightViewPadding(padding: 20)
           txtfieldDirection.addRightViewPadding(padding: 20)
           txtIncidentType.addLeftViewPadding(padding: 9, placeholderText: "Select")
           txtIncidentType.addRightViewPadding(padding: 20)
           self.transperentBlackView.isHidden = false
           self.viewDirection.isHidden = false
       }
    
    @IBAction func btnSubmitPopup(_ sender: ButtionX) {
        if txtfieldDirection.text?.count ?? 0 < 1  {
            let message = "Please select direction"
           
                PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody:message , AllActions: ["OK":nil], Style: .alert)
                return
            
            
        }
        
        
        guard txtFieldDescription.text?.count ?? 0 > 0 else {
            let message = "Please select description"
            
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: message, AllActions: ["OK":nil], Style: .alert)
            return
        }
//        guard txtIncidentType.text?.count ?? 0 > 0 else {
//            let message = "Please select incident type"
//            
//            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: message, AllActions: ["OK":nil], Style: .alert)
//            return
//        }
        
        self.callWazeApi()
        
       }
    @IBAction func btnCancelPopup(_ sender: ButtionX) {
        self.hidePopupPetrolling()
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
    @objc func action(sender: UIBarButtonItem) {
        if sender.tag == 0{
            if txtfieldDirection.text?.count == 0{
                txtfieldDirection.text = arrayDirection[0]
            }
        }else if sender.tag == 1{
            if txtFieldDescription.text?.count == 0{
                txtFieldDescription.text = arrayDescription[0]
            }
        }else if sender.tag == 2{
            if txtIncidentType.text?.count == 0{
                txtIncidentType.text = incidenceTypeList[0].name
                incidentID = incidenceTypeList[0].incident_id ?? "" //arrayDescription[0]
            }
        }
        self.view.endEditing(true)
        
    }
    @objc func cancelAction() {
        self.view.endEditing(true)
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return arrayDirection.count
        }else if pickerView.tag == 1{
            return arrayDescription.count
        }else if pickerView.tag == 2{
            return incidenceTypeList.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return arrayDirection[row]
        }else if pickerView.tag == 1{
            return arrayDescription[row]
        }else if pickerView.tag == 2{
            return  incidenceTypeList[row].name ?? ""//""
        }else{
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{
            txtfieldDirection.text = arrayDirection[row]
        }else if pickerView.tag == 1{
            txtFieldDescription.text =  arrayDescription[row]
        }else if pickerView.tag == 2{
            txtIncidentType.text =  incidenceTypeList[row].name
            self.incidentID = incidenceTypeList[row].incident_id ?? ""
        }
        
    }
    func callIncidentListApi()  {
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String , let operationid:String = UserDefaults.standard.value(forKey: "OPERATIONID") as? String {
            model.callIncidentDetails(companyId: companyID, userId: userId, operationId: operationid) { (status) in
                if status == 0{
                    if self.model.incidentdetailsArray?.count ?? 0 > 0{
                        self.lblNodata.isHidden = true
                    }else{
                        self.lblNodata.isHidden = false
                    }
                    DispatchQueue.main.async {
                        self.tableIncident.reloadData()
                    }
                    
                }else{
                    self.lblNodata.isHidden = false
                }
            }
        }else{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String {
            let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String ?? ""
            model.callIncidentDetails(companyId: companyID, userId: userId, operationId: "") { (status) in
                if status == 0{
                    if self.model.incidentdetailsArray?.count ?? 0 > 0{
                        self.lblNodata.isHidden = true
                    }else{
                        self.lblNodata.isHidden = false
                    }
                    DispatchQueue.main.async {
                        self.tableIncident.reloadData()
                    }
                    
                }else{
                    self.lblNodata.isHidden = false
                }
            }
            }
        }
    }
    func callWazeApi(){
        /*Request params: {
            "companyId": 2,
            "user_id": 58,
            "lat": 22.5726,
            "lng": 88.3639,
            "direction": "One Direction",
            "description": "Demo",
            "timeUTC": "2020-10-28T21:11:10+05:30"
        }
*/
        var param:[String:AnyObject] = [String:AnyObject]()
        //param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            
            param["companyId"] = companyID as AnyObject
            
            
        }
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
            
            param["user_id"] = userId as AnyObject
        }
        let latitude = MyLocationManager.share.myCurrentLocaton?.latitude ?? 0.0
        let longitude = MyLocationManager.share.myCurrentLocaton?.longitude ?? 0.0
        
        param["lat"] = latitude as AnyObject
        param["lng"] = longitude as AnyObject
        param["direction"] = txtfieldDirection.text as AnyObject
        param["description"] = txtFieldDescription.text as AnyObject
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
        print(param)

        let opt = WebServiceOperation.init((API.WazeInfo.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber {
                    if errorCode.intValue == 0 {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddIncidentFormVC") as! AddIncidentFormVC
                        vc.pageFor = "insert"
                        vc.getIncidentTypeId = self.incidentID
                        vc.getIncidenceType = self.txtIncidentType.text ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                    }
                }else{

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
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - popUp for Denied
    
    func openPopUp(tag: Int) {
        PopupCustomView.sharedInstance.reSetPopUp()
        PopupCustomView.sharedInstance.lableTop.text = "Please Provide your reason"
        PopupCustomView.sharedInstance.textView?.setBorder(width: 2.0, borderColor: AppthemeColor, cornerRadious: 10.0)
        PopupCustomView.sharedInstance.textView?.isSelectable = true
        PopupCustomView.sharedInstance.textView?.isEditable = true
        PopupCustomView.sharedInstance.textView?.textAlignment = .left
        PopupCustomView.sharedInstance.textView?.isUserInteractionEnabled = true
        PopupCustomView.sharedInstance.textView?.text = ""
        PopupCustomView.sharedInstance.btnLeft.addTarget(self, action: #selector(btnYesPressed1(_:)), for: .touchUpInside)
        PopupCustomView.sharedInstance.btnLeft.tag = tag
        PopupCustomView.sharedInstance.btnRight.addTarget(self, action: #selector(btnNoPressed1), for: .touchUpInside)
        PopupCustomView.sharedInstance.display(onView: UIApplication.shared.keyWindow) {
            
        }
    }
    
    @objc func btnYesPressed1(_ sender: UIButton){
        comments = PopupCustomView.sharedInstance.textView?.text ?? ""
        if comments != "" {
            self.reporterID =  self.model.incidentdetailsArray?[sender.tag].incidents_report_data_id ?? ""
            self.acceptAndDeclinedApiCalled(status: "Denied", IncidentsReportId: self.reporterID, denyReason:comments )
              self.reSetPopUp()
        }
      
    }
    @objc func btnNoPressed(_ sender: UIButton){
         PopupCustomView.sharedInstance.reSetPopUp()
           
       }
    
    @objc func btnNoPressed1(_ sender: UIButton){
        self.reSetPopUp()
        
    }
   
    func reSetPopUp() {
        PopupCustomView.sharedInstance.lableTop.text = ""
        PopupCustomView.sharedInstance.btnLeft.tag = 0
        PopupCustomView.sharedInstance.textView?.isUserInteractionEnabled = false
        PopupCustomView.sharedInstance.textView?.isEditable = false
        PopupCustomView.sharedInstance.textView?.isSelectable = false
        PopupCustomView.sharedInstance.hide()
        PopupCustomView.sharedInstance.btnLeft.removeTarget(self, action: #selector(btnYesPressed1(_:)), for: .touchUpInside)
        PopupCustomView.sharedInstance.btnRight.removeTarget(self, action: #selector(btnNoPressed1), for: .touchUpInside)
        PopupCustomView.sharedInstance.textView?.setBorder(width: 0.0, borderColor: .white, cornerRadious: 0.0)
        PopupCustomView.sharedInstance.textView?.textAlignment = .center
        comments = ""
        
    }
    
    @IBAction func BbtnSelfInitiated(_ sender: Any) {
        viewMain.bringSubviewToFront(viewSelfInitiated)
        self.viewSelfInitiated.backgroundColor = UIColor.init(red: 251/255, green: 209/255, blue: 36/255, alpha: 1)
        self.viewDispatched.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
    }
    
    @IBAction func btnDispatched(_ sender: Any) {
        viewMain.bringSubviewToFront(viewSelfInitiated)
        self.viewDispatched.backgroundColor = UIColor.init(red: 251/255, green: 209/255, blue: 36/255, alpha: 1)
        self.viewSelfInitiated.backgroundColor =  UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
    }
    
    
    @IBAction func buttonAddIncident(_ sender: Any) {
       // if self.shiftStatus == true{
        self.showPopupPetrolling()
       // }else{
            //self.displayAlert(Header: App_Title, MessageBody: "You don't have any active shift", AllActions: ["OK":nil], Style: .alert)
       // }
    }
    
    @objc func btnYesPressed(_ sender: UIButton){
        self.reSetPopUp()
        self.apiChaneToOnSceam(status: "On Scene", IncidentsReportId: self.reporterID, tag: sender.tag)
    }
    
    
    @objc func btnUpdateIncident(_ sender:UIButton){
        self.reporterID  = self.model.incidentdetailsArray?[sender.tag].incidents_report_data_id ?? ""
        if  let type = sender.accessibilityIdentifier {
            switch type {
            case "Assigned":
                print("Api call")
                self.acceptAndDeclinedApiCalled(status: "En-Route", IncidentsReportId: self.reporterID)
                
            case "On Scene":
               
                self.callCloseIncident(incidentID: self.reporterID)
                
            case "En-Route":
                let vc = storyboard?.instantiateViewController(withIdentifier: "AddIncidentFormVC") as! AddIncidentFormVC
                    vc.pageFor = "Update"
                    vc.modelIncidence = self.model.incidentdetailsArray?[sender.tag]
                    self.incidentID = "\(self.model.incidentdetailsArray?[sender.tag].incedent_type_id ?? "0")"
                    vc.getIncidentTypeId = self.incidentID
                    vc.getIncidenceType = "\(self.model.incidentdetailsArray?[sender.tag].incident_type_name ?? "0")"
                self.navigationController?.pushViewController(vc, animated: true)
                
//                PopupCustomView.sharedInstance.reSetPopUp()
//                PopupCustomView.sharedInstance.textView?.text = "Have you Arrived on the scene"
//                PopupCustomView.sharedInstance.btnLeft.addTarget(self, action: #selector(btnYesPressed(_:)), for: .touchUpInside)
//                 PopupCustomView.sharedInstance.btnRight.addTarget(self, action: #selector(btnNoPressed1), for: .touchUpInside)
//                PopupCustomView.sharedInstance.display(onView: UIApplication.shared.keyWindow) {
//
//                }
                
            case "Close":
                let vc = storyboard?.instantiateViewController(identifier: "IncidentDetailsVC") as! IncidentDetailsVC
                vc.modelIncidence = self.model.incidentdetailsArray?[sender.tag]
                self.navigationController?.pushViewController(vc, animated: true)
                
            default:
                print("")
            }
        }
        
    }
    
    @objc func btnDeclinedApicall(_ sender:UIButton){
        if self.model.incidentdetailsArray?[sender.tag].is_dispatched_incedent == "0"{
            let vc = storyboard?.instantiateViewController(withIdentifier: "AddIncidentFormVC") as! AddIncidentFormVC
                                       vc.pageFor = "Update"
                                       vc.modelIncidence = self.model.incidentdetailsArray?[sender.tag]
                                       self.incidentID = "\(self.model.incidentdetailsArray?[sender.tag].incedent_type_id ?? "0")"
                                       vc.getIncidentTypeId = self.incidentID
                                       vc.getIncidenceType = "\(self.model.incidentdetailsArray?[sender.tag].incident_type_name ?? "0")"
                                   self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.openPopUp(tag: sender.tag)
        }
       
        
       
        
    }
    func callCloseIncident(incidentID:String){
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
                        self.callIncidentListApi()
                    }else{
                        
                        //PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: msg, AllActions: ["OK":nil], Style: .alert)
                    }
                }
            }
        }
        appDel.operationQueue.addOperation(opt)
        
    }
    
    func acceptAndDeclinedApiCalled(status: String, IncidentsReportId: String, denyReason:String = "") {
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            model.callIncidentStatusUpdate(companyId: companyID, userId: userId, IncidentsReportId: IncidentsReportId, Status: status, denyReason:denyReason) { (status) in
                if status == 0{
                    DispatchQueue.main.async {
                        self.callIncidentListApi()
                    }
                }
            }
        }
        
        
    }
    
    func apiChaneToOnSceam(status: String, IncidentsReportId: String, tag: Int) {
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            model.callIncidentStatusUpdate(companyId: companyID, userId: userId, IncidentsReportId: IncidentsReportId, Status: status) { (status) in
                if status == 0{
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddIncidentFormVC") as! AddIncidentFormVC
                        vc.pageFor = "update"
                        vc.modelIncidence = self.model.incidentdetailsArray?[tag]
                        self.incidentID = "\(self.model.incidentdetailsArray?[tag].incedent_type_id ?? "0")"
                        vc.getIncidentTypeId = "\(self.model.incidentdetailsArray?[tag].incedent_type_id ?? "0")"
                        vc.getIncidenceType = "\(self.model.incidentdetailsArray?[tag].incident_type_name ?? "")"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
            }
        }
        
        
    }
    
}


extension IncidentVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.incidentdetailsArray?.count ?? 0
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentCell", for: indexPath) as! IncidentCell
        cell.labelTruckStatus.backgroundColor = .systemGreen
        //cell.labelTruckStatus.layer.cornerRadius =  cell.labelTruckStatus.frame.height
            /// 2
        cell.labelTruckStatus.textColor = .white
        if self.model.incidentdetailsArray?.count ?? 0 > 0 {
            let type:String = (self.model.incidentdetailsArray?[indexPath.row].incident_status)?.uppercased() ?? ""
            
            print(self.model.incidentdetailsArray?[indexPath.row].incidents_report_data_id ?? "")
            print("TYpe", type)
            switch type {
            case  "Assigned".uppercased():
                //Arun
                cell.heightConstraintViewIncident.constant = 40.0
                cell.btnViewIncident.isHidden = false
                cell.btnViewIncident.accessibilityIdentifier = "Close"
                cell.btnViewIncident.addTarget(self, action: #selector(btnUpdateIncident(_:)), for: .touchUpInside)

                cell.labelTruckStatus.textColor = UIColor.init(red: 252/255, green: 198/255, blue: 69/255, alpha: 1)
                cell.info = self.model.incidentdetailsArray?[indexPath.row]
                cell.btnUpdateIncident.tag = indexPath.row
                cell.btnDecline.tag = indexPath.row
                cell.labelTruckStatus.text = "  Assigned  "
                cell.labelTruckStatus.textColor = .white
                cell.labelTruckStatus.backgroundColor = .systemGreen
                cell.btnDecline.isHidden = false
                cell.btnDecline.setTitleColor(.white, for: .normal)
                cell.btnDecline.setTitle("Decline", for: .normal)
                cell.btnUpdateIncident.isHidden = false
                cell.btnDecline.backgroundColor = .red
                cell.btnUpdateIncident.backgroundColor = .green
                cell.btnUpdateIncident.setTitle("Accept", for: .normal)
                cell.btnUpdateIncident.accessibilityIdentifier = "Assigned"
                cell.btnDecline.setTitleColor(.white, for: .normal)
                cell.btnDecline.removeTarget(nil, action: nil, for: .allEvents)
                cell.btnDecline.addTarget(self, action: #selector(btnDeclinedApicall(_:)), for: .touchUpInside)
                cell.heightConstraint.constant = 35
                cell.btnUpdateIncident.addTarget(self, action: #selector(btnUpdateIncident(_:)), for: .touchUpInside)
                break
                
            case "Denied".uppercased():
                cell.heightConstraintViewIncident.constant = 40.0
                cell.btnViewIncident.isHidden = false
                cell.btnViewIncident.accessibilityIdentifier = "Close"
                cell.btnViewIncident.addTarget(self, action: #selector(btnUpdateIncident(_:)), for: .touchUpInside)

                cell.info = self.model.incidentdetailsArray?[indexPath.row]
                cell.labelTruckStatus.textColor = UIColor.init(red: 252/255, green: 198/255, blue: 69/255, alpha: 1)
               
                cell.btnUpdateIncident.tag = indexPath.row
                cell.labelTruckStatus.text = "  Declined  "
                cell.labelTruckStatus.textColor = .white
                //cell.labelTruckStatus.textColor = .black
                cell.btnUpdateIncident.isHidden = true
                cell.btnDecline.isHidden = true
                cell.heightConstraint.constant = 0
                cell.labelTruckStatus.backgroundColor = .systemRed
                cell.btnUpdateIncident.addTarget(self, action: #selector(btnUpdateIncident(_:)), for: .touchUpInside)
                break
                
            case "En-Route".uppercased():
                cell.heightConstraintViewIncident.constant = 40.0
                cell.btnViewIncident.isHidden = false
                cell.btnViewIncident.accessibilityIdentifier = "Close"
                cell.btnViewIncident.addTarget(self, action: #selector(btnUpdateIncident(_:)), for: .touchUpInside)

                cell.info = self.model.incidentdetailsArray?[indexPath.row]
                cell.btnUpdateIncident.tag = indexPath.row
                cell.btnDecline.isHidden = true
                cell.btnUpdateIncident.isHidden = false
                cell.labelTruckStatus.text = "  EN-Route  "
                cell.labelTruckStatus.textColor = UIColor.init(red: 252/255, green: 198/255, blue: 69/255, alpha: 1)
                cell.btnUpdateIncident.setTitle("Arrived On Scene", for: .normal)
                cell.btnUpdateIncident.backgroundColor = darkThemeColor
                cell.btnUpdateIncident.accessibilityIdentifier = "En-Route"
                cell.heightConstraint.constant = 35
                cell.btnUpdateIncident.addTarget(self, action: #selector(btnUpdateIncident(_:)), for: .touchUpInside)
                cell.btnUpdateIncident.setTitleColor(.black, for: .normal)
                break
                
            case "On Scene".uppercased():
                cell.heightConstraintViewIncident.constant = 40.0
                cell.btnViewIncident.isHidden = false
                cell.btnViewIncident.accessibilityIdentifier = "Close"
                cell.btnViewIncident.addTarget(self, action: #selector(btnUpdateIncident(_:)), for: .touchUpInside)
                
                cell.info = self.model.incidentdetailsArray?[indexPath.row]
                cell.btnUpdateIncident.tag = indexPath.row
                cell.btnDecline.isHidden = true
                cell.btnDecline.tag = indexPath.row
                cell.btnUpdateIncident.isHidden = false
                cell.labelTruckStatus.text = "  On Scene  "
                cell.labelTruckStatus.textColor = UIColor.init(red: 252/255, green: 198/255, blue: 69/255, alpha: 1)
                cell.btnUpdateIncident.setTitle("Close Incident", for: .normal)
                cell.btnUpdateIncident.backgroundColor = .black
                cell.btnUpdateIncident.accessibilityIdentifier = "On Scene"
                cell.btnUpdateIncident.setTitleColor(.white, for: .normal)
                cell.heightConstraint.constant = 35
                if self.model.incidentdetailsArray?[indexPath.row].is_dispatched_incedent == "0"{
                    cell.btnDecline.isHidden = false
                    cell.btnDecline.removeTarget(nil, action: nil, for: .allEvents)
                    cell.btnDecline.addTarget(self, action: #selector(btnDeclinedApicall(_:)), for: .touchUpInside)
                    cell.btnDecline.backgroundColor = .black
                    cell.btnDecline.setTitle("Edit Incident", for: .normal)
                    cell.btnDecline.setTitleColor(.black, for: .normal)
                    cell.labelTruckStatus.text = "  Open  "
                    cell.labelTruckStatus.textColor = .white
                    cell.labelTruckStatus.backgroundColor = .systemRed
                    cell.btnDecline.setTitleColor(.white, for: .normal)
                    
                }else{
                    cell.btnDecline.backgroundColor = .systemRed
                    cell.btnDecline.setTitle("Decline", for: .normal)
                    cell.btnDecline.setTitleColor(.white, for: .normal)
                    //cell.labelTruckStatus.textColor = .systemRed
                }
                cell.btnUpdateIncident.addTarget(self, action: #selector(btnUpdateIncident(_:)), for: .touchUpInside)
                break

            case "Closed".uppercased():
                cell.heightConstraintViewIncident.constant = 0.0
                cell.btnViewIncident.isHidden = true
                cell.info = self.model.incidentdetailsArray?[indexPath.row]
                cell.labelTruckStatus.text = "  Closed  "
                cell.btnDecline.isHidden = true
                cell.btnUpdateIncident.isHidden = false
                cell.labelTruckStatus.textColor = UIColor.init(red: 227/255, green: 122/255, blue: 70/255, alpha: 1)
                cell.btnUpdateIncident.setTitle("View Incident", for: .normal)
                cell.btnUpdateIncident.accessibilityIdentifier = "Close"
                cell.btnUpdateIncident.backgroundColor = .black
                cell.btnUpdateIncident.setTitleColor(.white, for: .normal)//darkThemeColor
                cell.heightConstraint.constant = 35
                cell.labelTruckStatus.textColor = .white
                cell.labelTruckStatus.backgroundColor = .systemGreen
                cell.btnUpdateIncident.addTarget(self, action: #selector(btnUpdateIncident(_:)), for: .touchUpInside)
                break
            default:
                cell.heightConstraintViewIncident.constant = 40.0
                cell.btnViewIncident.isHidden = false
                cell.btnViewIncident.accessibilityIdentifier = "Close"
                cell.btnViewIncident.addTarget(self, action: #selector(btnUpdateIncident(_:)), for: .touchUpInside)
                
                cell.info = self.model.incidentdetailsArray?[indexPath.row]
                cell.btnUpdateIncident.tag = indexPath.row
                cell.btnDecline.isHidden = true
                cell.btnUpdateIncident.isHidden = false
                cell.labelTruckStatus.text = "  On Scene  "
                cell.labelTruckStatus.textColor = UIColor.init(red: 252/255, green: 198/255, blue: 69/255, alpha: 1)
                cell.btnUpdateIncident.setTitle("Close Incident", for: .normal)
                cell.btnUpdateIncident.backgroundColor = .black
                cell.btnUpdateIncident.accessibilityIdentifier = "On Scene"
                cell.heightConstraint.constant = 35
                cell.btnUpdateIncident.setTitleColor(.white, for: .normal)
                if self.model.incidentdetailsArray?[indexPath.row].is_dispatched_incedent == "0"{
                                    cell.btnDecline.isHidden = false
                    cell.btnDecline.removeTarget(nil, action: nil, for: .allEvents)
                                    cell.btnDecline.addTarget(self, action: #selector(btnDeclinedApicall(_:)), for: .touchUpInside)
                                    cell.btnDecline.backgroundColor = darkThemeColor
                                    cell.btnDecline.setTitle("Edit Incident", for: .normal)
                                    cell.btnDecline.setTitleColor(.black, for: .normal)
                                    cell.labelTruckStatus.text = "  Open  "
                                    cell.labelTruckStatus.textColor = .white
                    cell.btnUpdateIncident.setTitleColor(.white, for: .normal)
                    cell.labelTruckStatus.backgroundColor = .systemRed
                                }else{
                                    cell.btnDecline.backgroundColor = .systemRed
                                    cell.btnDecline.setTitle("Decline", for: .normal)
                                    cell.btnDecline.setTitleColor(.white, for: .normal)
                                }
                cell.btnUpdateIncident.addTarget(self, action: #selector(btnUpdateIncident(_:)), for: .touchUpInside)
                break
            }
        }
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TimeService.instance.resetInactivityTimer()

    }
  
}
