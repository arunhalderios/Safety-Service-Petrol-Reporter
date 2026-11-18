//
//  NotificationListVC.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 17/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class NotificationListVC: BaseViewController {
    @IBOutlet weak var bgNotificationView: UIView!
    @IBOutlet weak var detailNotificationView: UIView!
    @IBOutlet weak var buttonOldMessage: UIButton!
    @IBOutlet weak var buttonNewMessage: UIButton!
    @IBOutlet weak var tableNotification: UITableView!
    var isNewMessage: Bool = true
    var dicNotificaion :NotificationDataModel?
    
    var readMessage = [MessageModel]()
    var unreadMessage = [MessageModel]()
    var currentArray = [MessageModel]()
    
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var dateTimeLable: UILabel!
    @IBOutlet weak var buttonReadUnread: ButtionX!
    @IBOutlet weak var detailText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.closeDetailsView()
        self.tableNotification.isHidden = true
        tableNotification.delegate = self
        tableNotification.dataSource = self
        if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
            self.notificationApiCall(userID: userId, companyID: companyID)
        }
    }
    
    @IBAction func buttonClose(_ sender: UIButton) {
        closeDetailsView()
    }
    
    @IBAction func buttonReadUnreadApi(_ sender: ButtionX) {
       if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
        if sender.accessibilityIdentifier != "" {
            self.notificationReadUnreadCall(userID: userId, companyID: companyID, isread: self.isNewMessage, notificationID: sender.accessibilityIdentifier ?? "" )
        }
       }
    }
    func closeDetailsView() {
        self.detailText.text = ""
        self.detailTitle.text = ""
        self.dateTimeLable.text = ""
        
        self.bgNotificationView.isHidden = true
        self.detailNotificationView.isHidden = true
    }
    
    func showDetailsView(info:MessageModel) {
        let buttonTitle = self.isNewMessage ? "Mark as read" :  "Mark as unread"
        self.buttonReadUnread.setTitle(buttonTitle, for: .normal)
        self.detailTitle.text = info.title
        self.detailText.text = info.message
        self.dateTimeLable.text = info.created_ts
        self.bgNotificationView.isHidden = false
        self.detailNotificationView.isHidden = false
        self.buttonReadUnread.accessibilityIdentifier = info.notification_master_id
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttClickOldMessage(_ sender: UIButton) {
        isNewMessage =  false
          self.currentArray = self.readMessage
        self.buttonNewMessage.backgroundColor = .lightGray
        self.buttonOldMessage.backgroundColor = AppthemeColor
        self.tableNotification.reloadData()
    }
    
    @IBAction func buttonClickNewMessage(_ sender: UIButton) {
         isNewMessage =  true
        self.currentArray = self.unreadMessage
        self.buttonNewMessage.backgroundColor = AppthemeColor
        self.buttonOldMessage.backgroundColor = .lightGray
        self.tableNotification.reloadData()
    }
}

extension NotificationListVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentArray.count
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificatonCell", for: indexPath) as! NotificatonCell
        if indexPath.section == 0 {
            if self.currentArray.count  > 0{
                let info :MessageModel = self.currentArray[indexPath.row]
                    cell.lableSubTitle.text = "\(info.message ?? " ")"
                    cell.lableTitle .text = "\(info.title ?? " ")"
                    cell.lableTime.text =  "\(info.created_ts ?? " ")"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TimeService.instance.resetInactivityTimer()

       // if isNewMessage == true{
        if self.currentArray.count > 0 {
            self.showDetailsView(info: self.currentArray[indexPath.row])
        }
        //}
    }
    
    
}

extension NotificationListVC {
    func notificationApiCall(userID: String , companyID: String){
        if Connectivity.isConnectedToInternet {
            var param:[String:AnyObject] = [String:AnyObject]()
            param["user_id"] = userID as AnyObject
            param["companyId"] = companyID as AnyObject
            param["source"] = "MOB" as AnyObject
            let opt = WebServiceOperation.init((API.notificationSendListAll.getURL()?.absoluteString ?? ""), param)
            opt.completionBlock = {
                DispatchQueue.main.async {
                    guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                        return
                    }
                    if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                        if errorCode.intValue == 0 {
                            DispatchQueue.main.async {
                                if let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0,let arrDetails = dictResult["data"] as? [String:Any] {
                                    do {
                                        self.dicNotificaion = try JSONDecoder().decode(NotificationDataModel.self,from:(arrDetails.data)!)
                                        if self.dicNotificaion?.unread?.count ?? 0  > 0  || self.dicNotificaion?.read?.count ?? 0 > 0{
                                            self.unreadMessage = self.dicNotificaion?.unread ?? []
                                            self.readMessage = self.dicNotificaion?.read ?? []
                                            self.currentArray = self.isNewMessage ? self.unreadMessage  : self.readMessage
                                            self.tableNotification.isHidden = false
                                            self.tableNotification.reloadData()
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
    
  // For mark as read then pass 1 and for mark as unread then pass 0"
   // {"source":"MOB","user_id":"15","companyId":"2","notification_master_id":"16","is_read":"0"}
    func notificationReadUnreadCall(userID: String , companyID: String, isread: Bool, notificationID: String){
    if Connectivity.isConnectedToInternet {
        var param:[String:AnyObject] = [String:AnyObject]()
        param["user_id"] = userID as AnyObject
        param["companyId"] = companyID as AnyObject
        param["source"] = "MOB" as AnyObject
         param["notification_master_id"] = notificationID as AnyObject
         param["source"] = "MOB" as AnyObject
        param["is_read"] =  Int(self.isNewMessage) as AnyObject
        let opt = WebServiceOperation.init((API.changeNotificationReadStatus.getURL()?.absoluteString ?? ""), param)
        opt.completionBlock = {
            DispatchQueue.main.async {
                guard let dictResponse = opt.responseData?.dictionary, dictResponse.count > 0 else {
                    return
                }
                if let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0, let errorCode = dictStatus["error_code"] as? NSNumber, let msg = dictStatus["message"] as? String {
                    if errorCode.intValue == 0 {
                        DispatchQueue.main.async {
                            self.closeDetailsView()
                            if  let userId: String = UserDefaults.standard.value(forKey: "USERID") as? String  ,  let companyID:String = UserDefaults.standard.value(forKey: "COMPANYID") as? String{
                                self.notificationApiCall(userID: userId, companyID: companyID)
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

extension Int {
    init(_ bool:Bool) {
        self = bool ? 1 : 0
    }
}
