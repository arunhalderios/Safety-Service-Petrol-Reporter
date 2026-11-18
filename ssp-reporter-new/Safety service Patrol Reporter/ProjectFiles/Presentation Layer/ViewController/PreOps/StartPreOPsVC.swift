//
//  StartPreOPsVC.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Mahalik on 30/03/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class StartPreOPsVC: BaseViewController {
 let arrayTitle = ["Vehicle ID","Date","Time","Operator","Odometer Reading"]
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgViewBack: UIImageView!
    var arraySamplertext1 = ["#12345","03/19/2020","10.30AM","Gerad Suppaa","123434"]
    var arraySamplertext = [String]()
    var paramDictionary = Dictionary<String, AnyObject>()
    var odoMeterReadin: String = ""
    var isHome : Bool = true
    @IBOutlet weak var tablepreOps: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateTableWithData()
        self.paramDictionary.removeAll()
        // Do any additional setup after loading the view.
        if isHome == false{
            self.btnBack.isHidden = false//true
            self.imgViewBack.isHidden = false//true
        }else{
            self.btnBack.isHidden = false
            self.imgViewBack.isHidden = false
        }
    }
    
    func populateTableWithData()  {
        self.tablepreOps.isHidden = true
        self.arraySamplertext.removeAll()
        if let vID:String = UserDefaults.standard.value(forKey: "VEHICLENAME") as? String {
            arraySamplertext.append(vID)
        }else{
            arraySamplertext.append(" ")
        }
        arraySamplertext.append(Date().dateStringInDateFormat("MM-dd-yyyy"))
        arraySamplertext.append(Date().dateStringInDateFormat("h:mm:ss a"))
        var modelUser : Userdetails?
        if let user = UserDefaults.standard.value(forKey: "USER") as? [String:Any]{
            do{
                modelUser = try JSONDecoder().decode(Userdetails.self,from:(user.data)!)
                arraySamplertext.append(modelUser?.name ?? " ")
                
            }catch{
                arraySamplertext.append(" ")
                print(error)
            }
        }
        
        arraySamplertext.append("")
        self.tablepreOps.reloadData()
        self.tablepreOps.isHidden = false
    }
    func collectParamiterInfoForPre_ops() -> Dictionary<String, AnyObject> {
       if let vID:String = UserDefaults.standard.value(forKey: "VEHICLEID") as? String {
        self.paramDictionary["vehicleId"] = vID as AnyObject
        }
        let datePass =  Date().dateStringInDateFormat("yyyy-MM-dd")
        self.paramDictionary["date"] = datePass as AnyObject
        self.paramDictionary["time"] = arraySamplertext[2] as AnyObject
        
        
        if let shiftID = UserDefaults.standard.value(forKey: "SHIFTID"){
        self.paramDictionary["operatorShiftTimeDetailsId"] = shiftID as AnyObject
        }
        return  self.paramDictionary
    }
   
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        let cell = tablepreOps.cellForRow(at: IndexPath(row: 0, section: 1)) as? IncidentButtomCell
//        if cell != nil {
//            cell?.btnNext.roundedView()
//        }
    }
    @IBAction func btnBackAction(_ sender: Any) {
        print("BTN BACK CALL")
//        let vc = storyboard?.instantiateViewController(withIdentifier: "TimeSelectionVC") as! TimeSelectionVC
//        self.navigationController?.pushViewController(vc, animated: true)
//        if isHome == true{
           self.navigationController?.popViewController(animated: true)
//        }else{
//            for controller in self.navigationController!.viewControllers as Array {
//
//                if controller.isKind(of: DashboardViewController.self) {
//                    self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }
//            }
      //  }
       }
    
    @IBAction func btnStartPreOpAction(_ sender: Any) {
        self.view.endEditing(true)
        if self.validation(){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPreOpsVC") as! AddPreOpsVC
            vc.isOPS = true
            vc.paramDictionary = self.collectParamiterInfoForPre_ops()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
             PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please Select Odometer Reading", AllActions: ["OK":nil], Style: .alert)
        }
    }
 
    
    func validation() -> Bool {
        if  let odomiterReading: String = self.paramDictionary["odometerReading"] as? String {
            if (!odomiterReading.isEmpty) {
                return true
            }
            return false
        }
        return false
    }

 
    
    @objc fileprivate func textFieldValueChanged(_ txt:UITextField) {
//        if (txt.superview?.superview?.superview?.superview?.isKind(of: IncidentInputCell.self) ?? false ){
//            let cell : IncidentInputCell = txt.superview?.superview?.superview?.superview as! IncidentInputCell
//          print(cell.txtFieldInput.text )
//        }
             if let str = txt.text, str.count > 0 {
                self.odoMeterReadin = str
                self.paramDictionary["odometerReading"] = self.odoMeterReadin as AnyObject
                 print("self.odoMeterReadin",self.odoMeterReadin)
             }else{
                self.odoMeterReadin = ""
                self.paramDictionary["odometerReading"] = self.odoMeterReadin as AnyObject
                
        }
           
         }
}
    extension StartPreOPsVC:UITableViewDelegate,UITableViewDataSource{
        func numberOfSections(in tableView: UITableView) -> Int {
            return 2
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0{
            return arraySamplertext.count
            }else{
                return 1
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if indexPath.section == 1{
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "IncidentButtomCell", for: indexPath) as! IncidentButtomCell
                self.view.setNeedsLayout()
                return cell1
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentInputCell", for: indexPath) as! IncidentInputCell
                cell.txtFieldInput.addRightViewPadding(padding: 10)
                cell.btnSelection.tag = indexPath.row
                cell.btnSelection.isHidden = true
                if indexPath.row == 0{
                cell.txtFieldInput.text = "#\(arraySamplertext[indexPath.row])"
                }else{
                    cell.txtFieldInput.text = arraySamplertext[indexPath.row]
                }
                cell.txtFieldInput.tag = indexPath.row
                cell.lblTitle.text = arrayTitle[indexPath.row]
                cell.lblTitle.setSubTextColor(pSubString: "*", pColor: .red)
                if indexPath.row + 1 == arrayTitle.count{
                //cell.viewRound.roundedView()
                cell.viewRound.layer.borderWidth = 2.0
                cell.viewRound.layer.borderColor = AppthemeColor.cgColor
                    cell.txtFieldInput.isUserInteractionEnabled = true
                    cell.txtFieldInput.keyboardType = .decimalPad
                     cell.txtFieldInput.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
                }else{
                    cell.txtFieldInput.isUserInteractionEnabled = false
                   
                    
                }
                
                
                cell.imgViewDropDown.isHidden = true
                //cell.txtFieldInput.text = ""
                cell.txtFieldInput.inputAccessoryView = nil
                cell.txtFieldInput.inputView = nil
                cell.txtFieldInput.tintColor = .black
        
                return cell
            }
            
            
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.section == 1{
                return 95
            }
            return UITableView.automaticDimension
            
        }
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 0.1
        }
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0.1
        }
    }

  

