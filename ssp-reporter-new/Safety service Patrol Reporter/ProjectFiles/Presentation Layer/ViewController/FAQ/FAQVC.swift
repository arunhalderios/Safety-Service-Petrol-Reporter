//
//  NotificationVC.swift
//  HMS
//
//  Created by Dipika on 09/01/20.
//  Copyright © 2020 MET Technologies. All rights reserved.
//

import UIKit


class FAQVC: BaseViewController {
   private var dateCellExpanded: Bool = false
    private var dateCellExpandedIndexPath: [IndexPath] = []
    @IBOutlet weak var tableNotification: UITableView!
    @IBOutlet weak var viewTabbar: UIView!
    var arrayFaq : [FAQ] = []
    @IBOutlet var viewRound: ViewX!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        tableNotification.delegate = self
        tableNotification.dataSource = self
        
        

        // Do any additional setup after loading the view.
    }
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       TimeService.instance.resetInactivityTimer()
        if let childVC = self.children.first as? TabbarVC {
            childVC.selectedIndex = 1
            childVC.tabBarCollectionView.reloadData()
        }
      //viewRound.addShadow(location: .top)
    self.callFAQListApi()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        let rectShape = CAShapeLayer()
//        rectShape.bounds = self.viewTabbar.frame
//        rectShape.position = self.viewTabbar.center
//        rectShape.path = UIBezierPath(roundedRect: self.viewTabbar.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 30, height: 30)).cgPath
//        //self.viewRoundedCorner.layer.backgroundColor = UIColor.green.cgColor
//        self.viewRound.layer.mask = rectShape
    }
    
    
    
    

}

extension FAQVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayFaq.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! notificationCell
        cell.lblHeading.text =  arrayFaq[indexPath.row].faq_questions
        cell.lblHeading.textColor = darkThemeColor
        cell.buttomConstraints.constant = 0
        cell.lblNotification.text = ""
        cell.viewNotificatrion.backgroundColor = UIColor.white
        cell.imageUpDownArrow.image = UIImage(named: "DownArrow")
        if dateCellExpandedIndexPath.contains(indexPath){
            cell.buttomConstraints.constant = 18
            cell.imageUpDownArrow.image = UIImage(named: "UpArrow")
            cell.viewNotificatrion.backgroundColor = appOffWhite
            cell.lblNotification.text = arrayFaq[indexPath.row].faq_answer
        }
       
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TimeService.instance.resetInactivityTimer()

        if dateCellExpandedIndexPath.contains(indexPath){
            dateCellExpanded = false
            dateCellExpandedIndexPath.removeAll()
        }else{
            dateCellExpanded = true
            dateCellExpandedIndexPath.removeAll()
            dateCellExpandedIndexPath.append(indexPath)
        }
        tableView.reloadData()
        
    }
    
}

class notificationCell : UITableViewCell {
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var viewNotificatrion: UIView!
    @IBOutlet weak var buttomConstraints: NSLayoutConstraint!
    @IBOutlet weak var imageUpDownArrow: UIImageView!
    
    
}
extension FAQVC{
    func callFAQListApi(){
         if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        param["source"] = "MOB" as AnyObject
        if let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String{
                param["user_id"] = userId as AnyObject
            }
            param["companyId"] = companyID as AnyObject
            
            
        }
        let opt = WebServiceOperation.init((API.FAQ.getURL()?.absoluteString ?? ""), param)
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
                                    self.arrayFaq = try JSONDecoder().decode([FAQ].self,from:(listArray.data)!)
                                    self.tableNotification.reloadData()
                                    
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
