//
//  AddShiftTruckVC.swift
//  ATIMS
//
//  Created by Mahesh Prasad Mahaliik on 19/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit
import DropDown

class AddShiftTruckVC: BaseViewController {
    var model = ShiftModel()
    var zoneID = ""
    var stateID = ""
    var operationID = ""
    var vehicleID = ""
    var timeID = ""
    var shiftTimeDetailsIDStr = ""
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var viewSelect: UIView!
    @IBOutlet weak var lblSearch : UILabel!
    let dropDown = DropDown()
    
    @IBOutlet weak var txtFieldVehicle: UITextField!
    @IBOutlet weak var buttonDropDown: UIButton!
    var dataVehicleArray = [ShiftVehileList]()
    var searchdataVehicleArray = [ShiftVehileList]()
    var dataSourceArray = [String]()
    var searchDataSourceArray = [String]()
    
    @IBOutlet var bgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        btnStart.roundedView()
//        viewSelect.roundedView()
        self.bgView.isHidden = true
        self.createPickerView(textField: txtFieldVehicle)
        
        self.buttonDropDown.isUserInteractionEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callGetVehicleList()
        TimeService.instance.resetInactivityTimer()
    }
    
    @IBAction func btnOkAction(_ sender: UIButton) {
        self.bgView.isHidden = true
            let vc = self.storyboard?.instantiateViewController(identifier: "StartPreOPsVC") as! StartPreOPsVC
            vc.isHome = false
            self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func buttonClickShowHideDropDown(_ sender: UIButton) {
        self.dropDown.show()
    }
    //MARK: DROP DOWN configuration
       func configureDropDown(){
           dropDown.anchorView = buttonDropDown

           searchdataVehicleArray = dataVehicleArray
           dataSourceArray  =  searchdataVehicleArray.map {$0.iD!}
           searchDataSourceArray = dataSourceArray
           dropDown.dataSource = searchDataSourceArray
           dropDown.direction = .bottom
           dropDown.bottomOffset = CGPoint(x: self.viewSelect.frame.origin.x, y:(dropDown.anchorView?.plainView.bounds.height)!)
           dropDown.width = self.buttonDropDown.bounds.size.width - 20

           // Action triggered on selection
        dropDown.selectionAction = { [ self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.lblSearch.text = item
            let vehicle  = self.searchdataVehicleArray[index]
            self.vehicleID = vehicle.vehicle_id ?? ""
            print("self.vehicleID ", self.vehicleID)
            self.dropDown.hide()
        }
       }
    
    func callGetVehicleList() {
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            model.callVehicleListListApi(companyId: companyID, userId: userId, stateID: self.stateID, operationID: self.operationID) { (status) in
                if status == 0 {
                    self.dataVehicleArray = self.model.vehileList ?? []
                    self.dataVehicleArray = self.dataVehicleArray.reversed()
                    self.configureDropDown()
                    self.buttonDropDown.isUserInteractionEnabled = true
                    if self.dataVehicleArray.count == 0{
                         PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "No vehicle is found", AllActions: ["OK":nil], Style: .alert)
                    }
                }else{
                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "No vehicle is found", AllActions: ["OK":nil], Style: .alert)
                }
            }
        }
    }
    
    @IBAction func buttonStartShift(_ sender: Any) {
        //pop to dash board
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            model.callStartShiftApi(companyId: companyID, userId: userId, vehicleID: self.vehicleID, stateId: self.stateID, operationarea: self.operationID, bitaZoneID: self.zoneID, shiftTimeID: self.timeID) { (status) in
                if status == 0 {
                    
                    DispatchQueue.main.async {
                        UserDefaults.standard.removeObject(forKey: "PREOPSSAVED")
                        UserDefaults.standard.set(self.vehicleID, forKey: "VEHICLEID")
                        self.bgView.isHidden = false
                    }
                    
                    
                }
            }
        }
    }
    
    
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   

}
extension AddShiftTruckVC:UIPickerViewDelegate,UIPickerViewDataSource{
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
       
            if self.vehicleID == ""{
                //txtDirection.text = arrayDirection[0]
                if dataSourceArray.count > 0{
                self.lblSearch.text = dataSourceArray[0]
                let vehicle  = self.searchdataVehicleArray[0]
                self.vehicleID = vehicle.vehicle_id ?? ""
                print("self.vehicleID ", self.vehicleID)
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
        return dataSourceArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      
            return dataSourceArray[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard dataSourceArray.count > 0 else {
            return
        }
        self.lblSearch.text = dataSourceArray[row]
        let vehicle  = self.searchdataVehicleArray[row]
        self.vehicleID = vehicle.vehicle_id ?? ""
        print("self.vehicleID ", self.vehicleID)
    }
    
}
