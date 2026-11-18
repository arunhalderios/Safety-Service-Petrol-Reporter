//
//  StartShiftVC.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 14/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class StartShiftVC: BaseViewController {
  let model = ShiftModel()
    @IBOutlet weak var lblData: UILabel!
    
    @IBOutlet weak var tableStartShift: UITableView!
    var arrayState = ["New York","Florida","Ohio"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableStartShift.delegate = self
        self.tableStartShift.dataSource = self
        self.tableStartShift.isHidden = true
        self.callGetStateList()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
//MARK:Table View
extension StartShiftVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.model.stateList?.count ?? 0) + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShiftNameCell", for: indexPath) as! ShiftNameCell
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShiftTypeCell", for: indexPath) as! ShiftTypeCell
            cell.labelCityName.text = self.model.stateList?[indexPath.row - 1].state_name
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TimeService.instance.resetInactivityTimer()

        if self.model.stateList?.count ?? 0 > 0 {
             if let item = self.model.stateList?[safe: indexPath.row - 1] {
            let vc = storyboard?.instantiateViewController(withIdentifier: "OperationVC") as! OperationVC
            vc.stateID = item.state_id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}


//MARK: - API Call -
extension StartShiftVC {
    func callGetStateList() {
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            model.callStateListApi(companyId: companyID, userId: userId) { (status) in
                if status == 0 {
                    self.tableStartShift.isHidden = false
                    self.lblData.isHidden = true
                    self.tableStartShift.reloadData()
                }else{
                    self.lblData.isHidden = false
                    self.tableStartShift.isHidden = true
                    
                }
            }
        }
    }
    
}
