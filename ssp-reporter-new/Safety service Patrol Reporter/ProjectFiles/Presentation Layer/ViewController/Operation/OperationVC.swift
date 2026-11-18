//
//  OperationVC.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 20/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class OperationVC: BaseViewController {
    @IBOutlet weak var tableOperation: UITableView!
    @IBOutlet weak var lblData: UILabel!
    var model = ShiftModel()
    var stateID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableOperation.delegate = self
        tableOperation.dataSource = self
        tableOperation.isHidden = true
        self.callGetOperationList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func callGetOperationList() {
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            
            model.callOperationListApi(companyId: companyID, userId: userId, stateId: stateID) { (status) in
                if status == 0 {
                    self.tableOperation.isHidden = false
                    self.lblData.isHidden = true
                    self.tableOperation.reloadData()
                }else{
                    self.tableOperation.isHidden = true
                    self.lblData.isHidden = false
                }
            }
        }
    }
    
    

}

//MARK:Table View
extension OperationVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.model.operationAreaList?.count ?? 0) + 1
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
            if (self.model.operationAreaList?.count ?? 0) > 0{
                cell.labelCityName.text = self.model.operationAreaList?[indexPath.row - 1].operation_area_name
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TimeService.instance.resetInactivityTimer()

        if self.model.operationAreaList?.count ?? 0 > 0 {
            if let item = self.model.operationAreaList?[safe: indexPath.row-1] {
                 let vc = storyboard?.instantiateViewController(withIdentifier: "ZoneVC") as! ZoneVC
                           vc.stateId = self.stateID
                           vc.operatioalID = item.operationarea_id ?? ""
                          self.navigationController?.pushViewController(vc, animated: true)
            }
          
        }
       }
}
