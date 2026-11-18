//
//  PreOPSToolsVC.swift
//  Safety service Patrol Reporter
//
//  Created by Abhik on 02/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class PreOPSToolsVC: BaseViewController {
    var isOPS :Bool  = true
    @IBOutlet weak var lblNodata: UILabel!
    var paramDictionary = Dictionary<String, AnyObject>()
    var arrayImageInfoPreOps : [MultiPartDataFormatStructure]?
    @IBOutlet weak var lblTitleHeader: UILabel!
    @IBOutlet weak var tableIncident: UITableView!
    var selectedIndex = 0
    let arraySamplertext = ["Present","Missing","Broken"]
    //var arrayImageInspections : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
    var arrayTools:[PreOpsTools] = []
    var modelPreOPSTools:[PreOpsModelTools] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print(paramDictionary)
        if isOPS == false{
            lblTitleHeader.text = "INSPECTIONS - TOOLS"
        }
        self.callToolsListApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let cell = tableIncident.cellForRow(at: IndexPath(row: self.modelPreOPSTools.count, section: 0)) as? IncidentButtomCell
        if cell != nil {
            cell?.btnNext.roundedView()
        }
    }
    
    func loadDataIntoModel(apiData:[PreOpsTools])  {
        self.modelPreOPSTools.removeAll()
        for info in apiData {
            let modelObject = PreOpsModelTools()
            modelObject.answerTool = "Present"
            modelObject.number = Int(info.tool_qty ?? "0") ?? 0
            modelObject.preOpsToosID = info.tool_id
            modelObject.preOpsToosName = info.tool_name
            self.modelPreOPSTools.append(modelObject)
        }
        self.tableIncident.reloadData()
    }
    
    func createParam() -> Dictionary<String, AnyObject> {
        var preOpsTools:[Dictionary<String,String>] = []
        for item in modelPreOPSTools {
            var dict = [String:String]()
            dict["tool_id"] = item.preOpsToosID
            dict["tool_quantity"] = "\(item.number)"
            if isOPS  {
                dict["answer"] = item.answerTool
            }else{
                dict["tool_status"] = item.answerTool
                
            }
            preOpsTools.append(dict)
        }
        if isOPS == false {
            self.paramDictionary["inspectionsTools"] = preOpsTools as AnyObject
        }else{
            self.paramDictionary["preOpsTools"] = preOpsTools as AnyObject
        }
        return  self.paramDictionary
    }
    
    
    @IBAction func btnNext(_ sender: Any) {
      //  if validation() {
            let vc = storyboard?.instantiateViewController(withIdentifier: "PreOPSSummaryVC") as! PreOPSSummaryVC
            vc.isOPS = self.isOPS
            vc.modelPreOPSTools = self.modelPreOPSTools
            vc.paramDictionary = self.createParam()
        if self.isOPS == false{
            vc.inspectionNew = true
            //vc.arrayImageInspect = self.arrayImageInspections
        }else{
            vc.arrayQuestionsImages = self.arrayImageInfoPreOps ?? []
        }
            self.navigationController?.pushViewController(vc, animated: true)
//        }else{
//            PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please fill up all of the field", AllActions: ["OK":nil], Style: .alert)
//        }
    }
    
    func validation() -> Bool  {
        for item in modelPreOPSTools {
            if item.answerTool?.isEmpty ?? true {
                return false
            }
        }
        return true
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btnSelectionOptionAction(_ sender: UIButton) {
        let tag = sender.superview?.superview?.tag ?? -1
        if let _ = self.modelPreOPSTools[safe: tag] {
            self.modelPreOPSTools[tag].answerTool = self.arraySamplertext[sender.tag]
               self.tableIncident.reloadData()
        }
        
    }
    
}

extension PreOPSToolsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelPreOPSTools.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.modelPreOPSTools.count  == indexPath.row{
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "IncidentButtomCell", for: indexPath) as! IncidentButtomCell
            cell1.btnNext.layer.cornerRadius = cell1.btnNext.frame.size.height / 2
            
            self.view.setNeedsLayout()
            return cell1
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell", for: indexPath) as! IncidentInputCell
            if self.modelPreOPSTools.count > 0{
                cell.btnSelection.tag = indexPath.row
                cell.btnSelection.isHidden = true
                cell.viewStackContainer.tag = indexPath.row
                cell.txtFieldInput.tag = indexPath.row
                cell.lblTitle.text = self.modelPreOPSTools[indexPath.row].preOpsToosName ?? ""
                cell.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
                //cell.viewRound.roundedView()
               // cell.viewRound.layer.borderWidth = 2.0
                //cell.viewRound.layer.borderColor = AppthemeColor.cgColor
                cell.txtFieldInput.inputAccessoryView = nil
                cell.txtFieldInput.inputView = nil
                cell.txtFieldInput.tintColor = .black
//                cell.imgMissing.tintColor = .yellow
//                cell.imgBroken.tintColor = .red
//                cell.imgPresent.tintColor = .green
                
                cell.imgViewDropDown.isHidden = false
                if self.modelPreOPSTools[indexPath.row].answerTool == "Broken"{
                    //cell.imgBroken.image = UIImage(named: "selectedIndex")
                    //cell.imgPresent.image = UIImage(named: "UnselectedIndex")
                    //cell.imgMissing.image = UIImage(named: "UnselectedIndex")
                    cell.imgBroken.backgroundColor = .systemRed
                    cell.imgPresent.backgroundColor = .clear
                    cell.imgMissing.backgroundColor = .clear
                    cell.btnBroken.setTitleColor(.white, for: .normal)
                    cell.btnMissing.setTitleColor(darkThemeColor, for: .normal)
                    cell.btnPresent.setTitleColor(.systemGreen, for: .normal)
                    
                }else if self.modelPreOPSTools[indexPath.row].answerTool == "Missing"{
//                    cell.imgBroken.image = UIImage(named: "UnselectedIndex")
//                    cell.imgPresent.image = UIImage(named: "UnselectedIndex")
//                    cell.imgMissing.image = UIImage(named: "selectedIndex")
                    
                    cell.imgBroken.backgroundColor = .clear
                    cell.imgPresent.backgroundColor = .clear
                    cell.imgMissing.backgroundColor = darkThemeColor
                    cell.btnBroken.setTitleColor(.red, for: .normal)
                    cell.btnMissing.setTitleColor(.white, for: .normal)
                    cell.btnPresent.setTitleColor(.systemGreen, for: .normal)
                    
                    
                }else if self.modelPreOPSTools[indexPath.row].answerTool == "Present"{
//                    cell.imgBroken.image = UIImage(named: "UnselectedIndex")
//                    cell.imgPresent.image = UIImage(named: "selectedIndex")
//                    cell.imgMissing.image = UIImage(named: "UnselectedIndex")
                    cell.imgBroken.backgroundColor = .clear
                    cell.imgPresent.backgroundColor = .systemGreen
                    cell.imgMissing.backgroundColor = .clear
                    cell.btnBroken.setTitleColor(.red, for: .normal)
                    cell.btnMissing.setTitleColor(darkThemeColor, for: .normal)
                    cell.btnPresent.setTitleColor(.white, for: .normal)
                }else{
//                    cell.imgBroken.image = UIImage(named: "UnselectedIndex")
//                    cell.imgPresent.image = UIImage(named: "UnselectedIndex")
//                    cell.imgMissing.image = UIImage(named: "UnselectedIndex")
                    
                    cell.imgBroken.backgroundColor = .clear
                    cell.imgPresent.backgroundColor = .clear
                    cell.imgMissing.backgroundColor = .clear
                    cell.btnBroken.setTitleColor(.red, for: .normal)
                    cell.btnMissing.setTitleColor(darkThemeColor, for: .normal)
                    cell.btnPresent.setTitleColor(.systemGreen, for: .normal)
                    
                }
                
                
                cell.txtFieldInput.text =  (self.modelPreOPSTools[indexPath.row].answerTool == "") ?  "Select" : self.modelPreOPSTools[indexPath.row].answerTool
                self.createPickerView(textField: cell.txtFieldInput)
                cell.txtFieldInput.tintColor = .white
                cell.lblCounter.text = "\(self.modelPreOPSTools[indexPath.row].number)"
                cell.btnPlus.tag = indexPath.row
                cell.btnMinus.tag = indexPath.row
                cell.btnPlus.addTarget(self, action: #selector(btnToolsIncerementPressed(_:)), for: .touchUpInside)
                cell.btnMinus.addTarget(self, action: #selector(btnToolsDecerementPressed(_:)), for: .touchUpInside)
            }
            return cell
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.modelPreOPSTools.count + 1 == indexPath.row + 1{
             if self.arrayTools.count > 0{
            return 85
             }else{
                return 0.01
            }
        }else{
            if self.arrayTools.count > 0{
        return UITableView.automaticDimension
            }else{
                return 0.01
            }
        }
        
    }
}
extension PreOPSToolsVC{
    
    @objc func btnToolsIncerementPressed(_ sender: UIButton!){
        var val =   self.modelPreOPSTools[sender.tag].number
        val += 1
        self.modelPreOPSTools[sender.tag].number  = val
        tableIncident.reloadData()
    }
    @objc func btnToolsDecerementPressed(_ sender: UIButton!){
        var val = self.modelPreOPSTools[sender.tag].number
        if(val > 0){
            val -= 1
            self.modelPreOPSTools[sender.tag].number    = val
        }
        tableIncident.reloadData()
    }
}
extension PreOPSToolsVC:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arraySamplertext.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arraySamplertext[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedIndex = row
    }
    
    func createPickerView(textField:UITextField) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        textField.inputView = pickerView
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
    
    func dismissPickerView() {
        
        //
    }
    
    @objc func cancelAction() {
        self.selectedIndex =  0
        view.endEditing(true)
    }
    
    @objc func action(sender: UIBarButtonItem) {
        if self.selectedIndex >= 0{
            self.modelPreOPSTools[sender.tag].answerTool = self.arraySamplertext[self.selectedIndex]
            self.tableIncident.reloadData()
        }
        
        self.view.endEditing(true)
        self.selectedIndex =  0
        view.endEditing(true)
    }
}
extension PreOPSToolsVC{
    func callToolsListApi(){
        if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["user_id"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.getToolsList.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                self.lblNodata.isHidden = false
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["data"] as? [[String:Any]] {
                                do {
                                    self.arrayTools = try JSONDecoder().decode([PreOpsTools].self,from:(listArray.data)!)
                                    DispatchQueue.main.async {
                                        self.loadDataIntoModel(apiData: self.arrayTools)
                                        
                                    }
                                    
                                    if self.arrayTools.count > 0{
                                        self.lblNodata.isHidden = true
                                    }
                                    
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
}
