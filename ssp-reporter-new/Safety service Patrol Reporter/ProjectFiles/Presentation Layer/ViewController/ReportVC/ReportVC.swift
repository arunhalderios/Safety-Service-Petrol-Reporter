//
//  ReportVC.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 18/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit


struct ReportDataModel : Codable {
    let operator_shift_time_details_id : String?
    let shiftStart : String?
    let shiftEnd : String?
    let totalDuration : String?
    let incidentData : [IncidentData]?
    let status :StatusDetails?

    enum CodingKeys: String, CodingKey {

        case operator_shift_time_details_id = "operator_shift_time_details_id"
        case shiftStart = "shiftStart"
        case shiftEnd = "shiftEnd"
        case totalDuration = "totalDuration"
        case incidentData = "incidentData"
        case status = "status"
    }
}


struct IncidentData : Codable {
    let totalDispatchIncident : Int?
    let totalDispatchTime : String?
    let totalSelfCount : Int?
    let totalSelfTime : String?
    let totalTime : String?

    enum CodingKeys: String, CodingKey {

        case totalDispatchIncident = "totalDispatchIncident"
        case totalDispatchTime = "totalDispatchTime"
        case totalSelfCount = "totalSelfCount"
        case totalSelfTime = "totalSelfTime"
        case totalTime = "totalTime"
    }

    
}
struct StatusDetails : Codable {
    let totalpatrolling : Int?
    let onScene : Int?

    enum CodingKeys: String, CodingKey {

        case totalpatrolling = "totalpatrolling"
        case onScene = "onScele"
    }

    
}



class ReportVC: BaseViewController {

    @IBOutlet var viewRound: ViewX!
    @IBOutlet weak var tableReport: UITableView!
    @IBOutlet weak var viewTabbar: UIView!
    var arrayReport = [ReportDataModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableReport.delegate = self
        tableReport.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.isTabbarClick = true
        
        if let childVC = self.children.first as? TabbarVC {
            childVC.selectedIndex = 2
            childVC.tabBarCollectionView.reloadData()
        }
     // viewTabbar.addShadow(location: .top)
        self.callReportListApi()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        let rectShape1 = CAShapeLayer()
//        rectShape1.bounds = self.viewRound.frame
//        rectShape1.position = self.viewRound.center
//        rectShape1.path = UIBezierPath(roundedRect: self.viewRound.bounds, byRoundingCorners: [.topRight , .topLeft], cornerRadii: CGSize(width: 40, height: 40)).cgPath
//        self.viewRound.layer.mask = rectShape1
    }
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   

}

extension ReportVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayReport.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
        if  self.arrayReport.count > 0 {
            cell.populateData(cellInfo: self.arrayReport[indexPath.row])
        }
        
        return cell
    }

}

extension ReportVC{
    func callReportListApi(){
         if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["userId"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject

        }
        let opt = WebServiceOperation.init((API.getShiftReportData.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                print(opt.responseData?.dictionary)
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0{
                            if  let listArray = dictResult["data"] as? [[String:Any]] {
                                do {
                                    self.arrayReport = try JSONDecoder().decode([ReportDataModel].self,from:(listArray.data)!)
                                    self.tableReport.reloadData()
                                    
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


