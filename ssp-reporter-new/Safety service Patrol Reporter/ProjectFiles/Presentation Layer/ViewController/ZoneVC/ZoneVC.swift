//
//  ZoneVC.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 20/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class ZoneVC: BaseViewController {
    var model  = ShiftModel()
    @IBOutlet weak var tableZone: UITableView!
    var arrayZone = ["TurnPike Beat -1","TurnPike Beat -2","TurnPike Beat -3"]
    var stateId: String = ""
    var operatioalID: String = ""
    @IBOutlet weak var lblNodata: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableZone.delegate = self
        tableZone.dataSource = self
        tableZone.isHidden = true
        callGetZoneList()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         TimeService.instance.resetInactivityTimer()
     }
    
    func callGetZoneList() {
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            model.callZoneListApi(companyId: companyID, userId: userId, stateId: stateId, operationAreaId: operatioalID) { (status) in
                if status == 0 {
                    self.tableZone.isHidden = false
                    self.lblNodata.isHidden = true
                    self.tableZone.reloadData()
                    
                }else{
                    self.lblNodata.isHidden = false
                    self.tableZone.isHidden = true
                }
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
 
}

//MARK:Table View
extension ZoneVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.model.zoneList?.count ?? 0) + 1
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
            if self.model.zoneList?.count ?? 0 > 0 {
                cell.labelCityName.text = self.model.zoneList?[indexPath.row - 1].beat_zone_name
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TimeService.instance.resetInactivityTimer()

        let vc = storyboard?.instantiateViewController(withIdentifier: "TimeSelectionVC") as! TimeSelectionVC
        if let item = self.model.zoneList?[safe: indexPath.row - 1] {
            
        
        vc.zoneID = item.beats_zone_id ?? ""
        vc.stateId = self.stateId
        vc.operatioalID = self.operatioalID
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

