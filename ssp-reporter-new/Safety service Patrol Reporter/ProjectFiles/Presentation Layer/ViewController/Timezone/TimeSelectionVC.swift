
import UIKit

class TimeSelectionVC: BaseViewController {
    @IBOutlet weak var lblNodata: UILabel!
    var model  = ShiftModel()
    @IBOutlet weak var tableZone: UITableView!
    var arrayZone = ["TurnPike Beat -1","TurnPike Beat -2","TurnPike Beat -3"]
    var stateId: String = ""
    var operatioalID: String = ""
    var zoneID:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableZone.delegate = self
        tableZone.dataSource = self
        tableZone.isHidden = true
        callGetTimeList()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }
    
    func callGetTimeList() {
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            model.callTimeListApi(companyId: companyID, userId: userId) { (status) in
                if status == 0 {
                    self.lblNodata.isHidden = true
                    self.tableZone.isHidden = false
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
extension TimeSelectionVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.model.timelist?.count ?? 0) + 1
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
            if self.model.timelist?.count ?? 0 > 0 {
                cell.labelCityName.text = self.model.timelist?[indexPath.row - 1].operation_shifts_name
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TimeService.instance.resetInactivityTimer()
        if let item = self.model.timelist?[safe: indexPath.row - 1] {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddShiftTruckVC") as! AddShiftTruckVC
        vc.timeID = item.operation_shifts_id ?? ""
        vc.stateID = self.stateId
        vc.operationID = self.operatioalID
        vc.zoneID = self.zoneID
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

