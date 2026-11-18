//
//  ExtraTimeReportVC.swift
//  Safety service Patrol Reporter
//
//  Created by Pritam Dey on 31/03/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class ExtraTimeReportVC: BaseViewController {
    
    @IBOutlet var txtIncident: UITextField!
    @IBOutlet var txtTotalTime: UITextField!
    @IBOutlet var txtEndTime: UITextField!
    @IBOutlet var textStartTime: UITextField!
    @IBOutlet weak var lblNodata: UILabel!
    @IBOutlet weak var txtTmc: UITextField!
    @IBOutlet weak var txtEventID: UITextField!
    var arrayExtraTimes: [ExtraTime] = []
    var isselected = false
    @IBOutlet weak var btnSelectReason: UIButton!
    @IBOutlet weak var btnWrite: UIButton!
    @IBOutlet weak var txtWriteReason: UITextField!
    @IBOutlet weak var viewWriteReason: ViewX!
    @IBOutlet weak var txtReason: UITextField!
    @IBOutlet weak var viewSelectReason: ViewX!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var viewFilter: ViewX!
    @IBOutlet weak var btnEndTime: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var viewOption: ViewX!
    @IBOutlet weak var buttonApply: UIButton!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var tableExtraTimeReport: UITableView!
    var isFilter :Bool = false
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblEnd: UILabel!
    var startDate:String = ""
    var endDate:String = ""
    var isStartDate = 0
    var reasonList :[Reason] = []
    var selectedReasonID :String = ""
    @IBOutlet weak var txtEnd: TextFieldX!
    @IBOutlet weak var txtStart: TextFieldX!
    var extraTimeReportID:String = ""
    var shiftID :String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        btnStart.addborder()
        btnEndTime.addborder()
        viewFilter.isHidden = true
        txtStart.tag = 0
        txtEnd.tag = 1
        txtEnd.addLeftViewPadding(padding: 8, placeholderText: "")
        txtStart.addLeftViewPadding(padding: 8, placeholderText: "")
        self.createDatePickerView(textField: txtEnd)
        self.createDatePickerView(textField: txtStart)
        self.createDatePickerView(textField: textStartTime)
        self.createDatePickerView(textField: txtEndTime)
        self.createPickerView(textField:self.txtReason)
       // self.createPickerView(textField:self.txtIncident)
        self.callExtratimeListApi()
        self.callReasonListApi()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialSetUp()
        TimeService.instance.resetInactivityTimer()
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        btnStart.roundedView()
        btnEndTime.roundedView()
        btnApply.roundedView()
    }
    func initialSetUp()  {
        self.viewOption.isHidden = true
        self.viewShadow.isHidden = true
    }
    
    @IBAction func btnSelectYourReason(_ sender: Any) {
        view.endEditing(true)
        btnSelectReason.backgroundColor = darkThemeColor
        btnWrite.backgroundColor = .clear
        viewWriteReason.isHidden = true
        viewSelectReason.isHidden = false
    }
    @IBAction func btnWriteReasonAction(_ sender: Any) {
        view.endEditing(true)
        btnWrite.backgroundColor = darkThemeColor
        btnSelectReason.backgroundColor = .clear
        viewWriteReason.isHidden = false
        viewSelectReason.isHidden = true
    }
    @IBAction func buttonCloseOptionView(_ sender: UIButton) {
        self.initialSetUp()
    }
    
    @IBAction func buttonSubmitOption(_ sender: ButtionX) {
        
        // self.testArray[sender.tag] = true
        
        self.validate()
        
        
        //self.tableExtraTimeReport.reloadData()
        
        
    }
    
    func validate() {
        guard !(txtIncident.text?.isEmpty ?? false) else {
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Enter Incident Number", AllActions: ["OK":nil], Style: .alert)
            return
        }
        guard !(txtTmc.text?.isEmpty ?? false) else {
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Enter TMC Authorization", AllActions: ["OK":nil], Style: .alert)
            return
        }
        
        guard !(textStartTime.text?.isEmpty ?? false) else {
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Select Start Time", AllActions: ["OK":nil], Style: .alert)
            return
        }
        guard !(txtEndTime.text?.isEmpty ?? false) else {
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Select End Time", AllActions: ["OK":nil], Style: .alert)
            return
        }
//        guard !(txtTotalTime.text?.isEmpty ?? false) else {
//            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please select valid start tiem and end time", AllActions: ["OK":nil], Style: .alert)
//            return
//        }
        
        self.addExtraTimeApiCall()
    }
    @objc func btnTapRequest( _ sender: UIButton)  {
        self.viewOption.isHidden = false
        self.viewShadow.isHidden = false
        buttonApply.tag  = sender.tag
        if let _ = arrayExtraTimes[exist: sender.tag] {
           self.extraTimeReportID = arrayExtraTimes[sender.tag].extraTimeReportId ?? ""
                  self.shiftID = arrayExtraTimes[sender.tag].shiftId ?? ""
        }
        
    }
    
    @IBAction func btnShowPickerAction(_ sender: UIButton) {
        isStartDate = sender.tag
        
    }
    @IBAction func btnApplyAction(_ sender: UIButton) {
        self.viewFilter.isHidden = true
        btnFilter.isSelected = false
        isFilter =  true
        guard !(txtStart.text?.isEmpty ?? false) else {
            return
        }
        guard !(txtEnd.text?.isEmpty ?? false) else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        guard let start = formatter.date(from: self.startDate) else { return }
        let end = formatter.date(from: self.endDate)
        if end?.isSmallerThan(start) == true{
            displayAlert(Header: App_Title, MessageBody: "End time should be gretter than start time", AllActions: ["OK":nil], Style: .alert)
            return
        }
        
        
        if let _ = arrayExtraTimes[exist: sender.tag] {
           self.extraTimeReportID = arrayExtraTimes[sender.tag].extraTimeReportId ?? ""
                  self.shiftID = arrayExtraTimes[sender.tag].shiftId ?? ""
        }
        self.arrayExtraTimes.removeAll()
        self.callExtratimeListApi()
    }
    @IBAction func btnFilterAction(_ sender: Any) {
        if let button = sender as? UIButton {
            if button.isSelected {
                self.viewFilter.isHidden = true
                button.isSelected = false
            } else {
                self.viewFilter.isHidden = false
                button.isSelected = true
            }
        }
    }
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //    func createDatePickerView() {
    //
    //        self.datePickerView.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: UIControl.Event.valueChanged)
    //
    //        toolBar.sizeToFit()
    //        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done(sender:)))
    //        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelDatePicker))
    //        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    //        toolBar.setItems([cancel,spacer,button], animated: true)
    //        toolBar.isUserInteractionEnabled = true
    //        toolBar.frame = CGRect(x: self.datePickerView.frame.origin.x, y: self.datePickerView.frame.origin.y - 40, width: self.datePickerView.frame.width, height: 40)
    //        self.datePickerView.addSubview(toolBar)
    //        toolBar.isHidden = true
    //
    //
    //    }
    
    
    func createDatePickerView(textField:UITextField) {
        let datePicker = UIDatePicker()
        if textField.tag == 1000{
            datePicker.datePickerMode = .time
        }else if textField.tag == 2000{
            datePicker.datePickerMode = .time
        }else{
            datePicker.datePickerMode = .date
        }
       
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
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
        if sender.tag == 1000{
        timeFormatter.dateFormat =  "h:mm a"
        }else if sender.tag == 2000{
            timeFormatter.dateFormat =  "h:mm a"
        }else{
            timeFormatter.dateFormat =  "MM-dd-yyyy"
        }
        if sender.tag == 0{
            self.startDate = timeFormatter.string(from: sender.date)
            self.txtStart.text = self.startDate
        }else{
            self.endDate = timeFormatter.string(from: sender.date)
            self.txtEnd.text = self.endDate
        }
        if sender.tag == 1000{

                let startDate = timeFormatter.string(from: sender.date)
                self.textStartTime.text = startDate
            self.txtTotalTime.text = ""

        }else if sender.tag == 2000{
            let endDate = timeFormatter.string(from: sender.date)
            self.txtEndTime.text = endDate
            if  let section2 =  timeFormatter.date(from: self.textStartTime.text ?? ""){
                if let endDate = timeFormatter.date(from: self.txtEndTime.text ?? ""){
                //if section2 > sender.date{
            let difference = Calendar.current.dateComponents([.hour, .minute], from: section2, to: endDate)
            let formattedString = String(format:  "%02ld H %02ld M", difference.hour!,difference.minute!)
                    txtTotalTime.text = formattedString
               // }
                }else{
                    txtTotalTime.text = ""
                }
            }else{
                txtTotalTime.text = ""
            }
            
            
        }else{

        }
        isselected = true
        
        
    }
    
    
    @objc func done(sender:UIBarButtonItem) {
        let timeFormatter = DateFormatter()
        if sender.tag == 1000{
            timeFormatter.dateFormat =  "h:mm a"
        }else  if sender.tag == 2000{
            timeFormatter.dateFormat =  "h:mm a"
        }else{
        timeFormatter.dateFormat =  "MM-dd-yyyy"
        }
        self.view.endEditing(true)
        if isselected == false{
            if sender.tag == 0{
                self.startDate = timeFormatter.string(from: Date())
                self.txtStart.text = self.startDate
            }else{
                self.endDate = timeFormatter.string(from: Date())
                self.txtEnd.text = self.endDate
            }
        }
        if sender.tag == 1000{
        if isselected == false{
            let startDate = timeFormatter.string(from: Date())
            self.textStartTime.text = startDate
        }
        }else if sender.tag == 2000{
            if isselected == false{
                let startDate = timeFormatter.string(from: Date())
                self.txtEndTime.text = startDate
                
                if  let section2 =  timeFormatter.date(from: self.textStartTime.text ?? ""){
                    if let endDate = timeFormatter.date(from: self.txtEndTime.text ?? ""){
                    //if section2 > sender.date{
                let difference = Calendar.current.dateComponents([.hour, .minute], from: section2, to: endDate)
                let formattedString = String(format:  "%02ld H %02ld M", difference.hour!,difference.minute!)
                        txtTotalTime.text = formattedString
                   // }
                    }else{
                        txtTotalTime.text = ""
                    }
                }
            }
        }
        isselected = false
        
    }
    
    @objc func cancelDatePicker() {
        
        isselected = false
        self.view.endEditing(true)
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
    @objc func cancelAction() {
        isselected = false
        view.endEditing(true)
    }
    @objc func action(sender: UIBarButtonItem) {
        
        if txtReason.text == ""{
            guard reasonList.count > 0 else {
                return
            }
            txtReason.text = reasonList[0].extra_time_reason ?? ""
            selectedReasonID = reasonList[0].extra_time_reason_id ?? ""
        }
       
        
        
        view.endEditing(true)
        isselected = false
    }
    
    
}
extension ExtraTimeReportVC:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return reasonList.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return reasonList[row].extra_time_reason ?? ""
        
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        isselected = true
        guard reasonList.count > 0 else {
            return
        }
        txtReason.text = reasonList[row].extra_time_reason ?? ""
        selectedReasonID = reasonList[row].extra_time_reason_id ?? ""
    }
}

extension ExtraTimeReportVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayExtraTimes.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FuelCell
        cell.buttonShowDetails.isUserInteractionEnabled = true
        if  arrayExtraTimes[indexPath.row].statusId == "0"{
            //let status = name.uppercased()
            cell.buttonShowDetails.setTitle("Request", for: .normal)
            cell.buttonShowDetails.isUserInteractionEnabled = true
            cell.buttonShowDetails.backgroundColor = .black//darkThemeColor
            cell.buttonShowDetails.setTitleColor(.white, for: .normal)
        }else if arrayExtraTimes[indexPath.row].statusId == "3"{
            cell.buttonShowDetails.setTitle("Request Sent", for: .normal)
            cell.buttonShowDetails.isUserInteractionEnabled = false
            cell.buttonShowDetails.backgroundColor = .clear
            cell.buttonShowDetails.setTitleColor(.systemGreen, for: .normal)
        }else if arrayExtraTimes[indexPath.row].statusId == "1"{
            cell.buttonShowDetails.setTitle("Approved", for: .normal)
            cell.buttonShowDetails.isUserInteractionEnabled = false
            cell.buttonShowDetails.backgroundColor = .clear
            cell.buttonShowDetails.setTitleColor(.systemGreen, for: .normal)
        }else if arrayExtraTimes[indexPath.row].statusId == "2"{
            cell.buttonShowDetails.setTitle("Denied", for: .normal)
            cell.buttonShowDetails.isUserInteractionEnabled = false
            cell.buttonShowDetails.backgroundColor = .clear
            cell.buttonShowDetails.setTitleColor(.systemRed, for: .normal)
        }else{
            cell.buttonShowDetails.setTitle("Request", for: .normal)
            cell.buttonShowDetails.isUserInteractionEnabled = true
            cell.buttonShowDetails.backgroundColor = .black
            cell.buttonShowDetails.setTitleColor(.white, for: .normal)
        }
        //cell.buttonShowDetails.backgroundColor =   testArray[indexPath.row] ? appOangeColor : appYellowColor
        cell.buttonShowDetails.tag = indexPath.row
        cell.buttonShowDetails.addTarget(self, action: #selector(btnTapRequest(_:)), for: .touchUpInside)
        cell.lableOne.text = arrayExtraTimes[indexPath.row].shiftId ?? " "
        cell.lableTwo.text = arrayExtraTimes[indexPath.row].date ?? " "
        cell.lableRefulingDate.text = arrayExtraTimes[indexPath.row].endShiftTime ?? " "
        cell.lableRefulingTime.text = arrayExtraTimes[indexPath.row].startShiftTime ?? " "
        //cell.lableFuleQuantity.text = arrayExtraTimes[indexPath.row].shiftDuration ?? " "
        //cell.lableCostPerLtr.text = arrayExtraTimes[indexPath.row].overTime ?? " "
        if arrayExtraTimes[indexPath.row].total_extra_time == ""{
            cell.lableFuleQuantity.text = "-"
        }else{
            cell.lableFuleQuantity.text = arrayExtraTimes[indexPath.row].total_extra_time ?? "-"
        }
        if arrayExtraTimes[indexPath.row].approved_extra_time == ""{
            cell.lableCostPerLtr.text =  "-"
        }else{
            cell.lableCostPerLtr.text = arrayExtraTimes[indexPath.row].approved_extra_time ?? "-"
        }
       // cell.lableCostPerLtr.text = arrayExtraTimes[indexPath.row].approved_extra_time ?? "-"
       // cell.lableFuleQuantity.text = arrayExtraTimes[indexPath.row].total_extra_time ?? "-"
        return cell
    }
    
    
}


extension ExtraTimeReportVC{
    func callExtratimeListApi(){
         if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["source"] = "MOB" as AnyObject
                param["companyId"] = companyID as AnyObject
                param["userId"] = userId as AnyObject
                if isFilter == true{
                    param["startDate"] = startDate as AnyObject
                    param["endDate"] = endDate as AnyObject
                }
                
            }
            
        }
            print(param)
        let opt = WebServiceOperation.init((API.getShiftExtraTimeList.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                self.lblNodata.isHidden = false
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                print(dictResponse)
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["data"] as? [[String:Any]] {
                                do {
                                    self.arrayExtraTimes = try JSONDecoder().decode([ExtraTime].self,from:(listArray.data)!)
                                    if self.arrayExtraTimes.count > 0{
                                        self.lblNodata.isHidden = true
                                    }
                                    self.tableExtraTimeReport.reloadData()
                                    
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
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
        }
    }
    func callReasonListApi(){
         if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        //param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["userId"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.extraTimeReasonList.getURL()?.absoluteString ?? ""), param)
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
                                    self.reasonList = try JSONDecoder().decode([Reason].self,from:(listArray.data)!)
                                    
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
        }else{
            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: NoInterNet, AllActions: ["OK":nil], Style: .alert)
        }
        
    }
    
    func addExtraTimeApiCall(){
         if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["userId"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject
            
            
        }
        
        param["shiftId"] = self.shiftID as AnyObject
        param["selectedReasonId"] = self.selectedReasonID as AnyObject
        param["tmcAuthorisation"] = txtTmc.text as AnyObject
        param["userDefinedReason"] = txtWriteReason.text as AnyObject
        param["extraTimeReportId"] = extraTimeReportID as AnyObject
        param["incident_id"] = txtIncident.text as AnyObject
        param["shift_start"] = txtIncident.text as AnyObject
        param["shift_end"] = txtIncident.text as AnyObject
        param["total_extra_time"] = txtTotalTime.text as AnyObject
        param["eventId"] = "100" as AnyObject
   
        
        
        let opt = WebServiceOperation.init((API.updateExtraTimeRequest.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        self.initialSetUp()
                        let okClause = PROJECT_CONSTANT.CLOUS{
                            self.navigationController?.popViewController(animated: true)
                        }
                        PROJECT_CONSTANT.displayAlert(Header: "Success", MessageBody: msg, AllActions: ["OK":okClause], Style: .alert)
                        
                        //                               if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                        //                                   if  let listArray = dictResult["data"] as? [[String:Any]] {
                        //                                       do {
                        //                                           //self.reasonList = try JSONDecoder().decode([Reason].self,from:(listArray.data)!)
                        //
                        //                                       }
                        //                                       catch {
                        //                                           print(error)
                        //
                        //                                       }
                        //                                   }
                        //                               }
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
extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
extension Date {

  func isEqualTo(_ date: Date) -> Bool {
    return self == date
  }

  func isGreaterThan(_ date: Date) -> Bool {
     return self > date
  }

  func isSmallerThan(_ date: Date) -> Bool {
     return self < date
  }
}
