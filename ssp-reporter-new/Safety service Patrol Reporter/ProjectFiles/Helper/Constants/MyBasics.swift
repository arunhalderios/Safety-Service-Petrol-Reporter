//
//  MyBasics.swift
//  TryWrongPlace
//
//  Created by Prakash Metia on 11/05/17.
//  Copyright © 2017 MET. All rights reserved.
//

import UIKit

//var listV = ListPickerView()
var listV = ListPickerView()
//var dtPickerView = DatePickerView()
var shadowView = UIView()
var dtPickerView = DatePickerView()

class MyBasics: NSObject {
    
    
    
    class func showPopup(Title:String?, Message:String?, InViewC:UIViewController?) {
        
        let popUpAlert = UIAlertController(title: Title!, message: Message!, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        popUpAlert.addAction(okAction)
        InViewC?.present(popUpAlert, animated: true, completion: nil)
        
    }
    
    class func showPopupOnSubView(Title:String?, Message:String?, InViewC:UIView?) {
        
        let popUpAlert = UIAlertController(title: Title!, message: Message!, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        popUpAlert.addAction(okAction)
        
        //InViewC?.present(popUpAlert, animated: true, completion: nil)
        
        
    }
    public typealias CLOUS = (()->())?
    
    public static func displayAlert(Header strHeader:String!,MessageBody strMsgBody:String!,AllActions actions:[String:CLOUS],Style style:UIAlertController.Style) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: strHeader, message: strMsgBody, preferredStyle: style)
            for (key,val) in actions {
                if key.lowercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "cancel" {
                    let action = UIAlertAction(title: key, style: .cancel, handler: { (action) in
                        alertController.dismiss(animated: true, completion: nil)
                        if let actionHandler = val {
                            actionHandler()
                        }
                    })
                    alertController.addAction(action)
                }else{
                    let action = UIAlertAction(title: key, style: .default, handler: { (action) in
                        alertController.dismiss(animated: true, completion: nil)
                        if let actionHandler = val {
                            actionHandler()
                        }
                    })
                    alertController.addAction(action)
                }
            }
//            if let rootVC = UIApplication.shared.keyWindow?.rootViewController, let vc = appDel.topViewControllerWithRootViewController(rootViewController: rootVC) {
//                vc.present(alertController, animated: true, completion: nil)
//            }
        }
    }
    
    class func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
//    class func isValidPhoneNumber(numberStr:String) -> Bool {
//        
//        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
//        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
//        let result =  phoneTest.evaluate(with: numberStr)
//        return result
//        
//    }
    
    
    class func removeHTMLTag(sourceStr:String!) -> String {
        return sourceStr.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    class func ShowLoginAlert(parentVC:UIViewController) {
        
        let loginAlert = UIAlertController(title: App_Title, message: "Please login to proceed", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
            parentVC.navigationController?.pushViewController((parentVC.storyboard?.instantiateViewController(withIdentifier: "ViewController"))!, animated: true)
            
        }
        loginAlert.addAction(cancelAction)
        loginAlert.addAction(okAction)
        parentVC.present(loginAlert, animated: true, completion: nil)
        
    }
    
//    class func heightForText(text:String!, viewWidth:CGFloat, font:UIFont) -> CGFloat {
//
//        let constraintRect = CGSize(width: viewWidth, height: .greatestFiniteMagnitude)
//     //   let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
//       //return boundingBox.height + 4
//    }
    
    //var listV = ListPickerView()
   // var dtPickerView = DatePickerView()
   // var shadowView = UIView()
    
    class func showDatePickerDropDown(PickerType:UIDatePicker.Mode, ParentViewC:UIViewController) {
        
        shadowView = UIView(frame: deviceBounds)
        shadowView.backgroundColor = UIColor.black
        shadowView.alpha = 0.0
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(hideDatePickerView))
        tapGes.numberOfTapsRequired = 1
        shadowView.addGestureRecognizer(tapGes)
        dtPickerView = Bundle.main.loadNibNamed("ListPickerView", owner: ParentViewC, options: nil)?[1] as! DatePickerView
        dtPickerView.frame = CGRect(x: 0, y: deviceBounds.size.height, width: deviceBounds.size.width, height: 227.0)
        dtPickerView.dtPicker.datePickerMode = PickerType
        ParentViewC.view.addSubview(shadowView)
        ParentViewC.view.addSubview(dtPickerView)
        ParentViewC.view.endEditing(true)
        dtPickerView.delegate = ParentViewC as? DatePickerDelegate
        UIView.animate(withDuration: 0.3, animations: {
            
            shadowView.alpha = 0.3
            dtPickerView.frame = CGRect(x: 0, y: deviceBounds.size.height - 227.0, width: deviceBounds.size.width, height: 227.0)
            
        }, completion: nil)
        
    }
//    @objc class func hideListView() {
//        
//        UIView.animate(withDuration: 0.3, animations: {
//            
//            shadowView.alpha = 0.0
//           // listV.frame = CGRect(x: 0, y: deviceBounds.size.height, width: deviceBounds.size.width, height: 227.0)
//            
//        }) { (Bool) in
//            
//            //listV.myDelegate?.ListDidHide!()
//            shadowView.removeFromSuperview()
//           // listV.removeFromSuperview()
//            
//        }
//    }
    
    @objc class func hideDatePickerView() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            shadowView.alpha = 0.0
            dtPickerView.frame = CGRect(x: 0, y: deviceBounds.size.height, width: deviceBounds.size.width, height: 227.0)
            
        }) { (Bool) in
            
            //listV.myDelegate?.ListDidHide!()
            shadowView.removeFromSuperview()
            dtPickerView.removeFromSuperview()
            
        }
    }
    
    
    class func showListDropDown(Items:Array<String>, ParentViewC:UIViewController) {
        
        shadowView = UIView(frame: deviceBounds)
        shadowView.backgroundColor = UIColor.black
        shadowView.alpha = 0.0
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(hideListView))
        tapGes.numberOfTapsRequired = 1
        shadowView.addGestureRecognizer(tapGes)
        listV = Bundle.main.loadNibNamed("ListPickerView", owner: ParentViewC, options: nil)?.first as! ListPickerView
        listV.frame = CGRect(x: 0, y: deviceBounds.size.height, width: deviceBounds.size.width, height: 227.0)
        ParentViewC.view.addSubview(shadowView)
        ParentViewC.view.addSubview(listV)
        ParentViewC.view.endEditing(true)
        listV.myDelegate = ParentViewC as? CustomListDelegate
        listV.ReloadPickerView(dataArray: Items)
        UIView.animate(withDuration: 0.3, animations: {
            
            shadowView.alpha = 0.3
            listV.frame = CGRect(x: 0, y: deviceBounds.size.height - 227.0, width: deviceBounds.size.width, height: 227.0)
            
        }, completion: nil)
        
    }
    
    @objc class func hideListView() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            shadowView.alpha = 0.0
            listV.frame = CGRect(x: 0, y: deviceBounds.size.height, width: deviceBounds.size.width, height: 227.0)
            
        }) { (Bool) in
            
            //listV.myDelegate?.ListDidHide!()
            shadowView.removeFromSuperview()
            listV.removeFromSuperview()
            
        }
    }
    
    
    
}


   /* class func POSTServiceCall(serviceUrl:String, serviceParam:NSDictionary?, parentViewC:UIViewController?, willShowLoader:Bool?,  ServiceCompletion:@escaping (_ response:Any?, _ isDone:Bool?, _ errMessage:String?) -> Void) {
        
        if AFNetworkReachabilityManager.shared().networkReachabilityStatus == .reachableViaWiFi || AFNetworkReachabilityManager.shared().networkReachabilityStatus == .reachableViaWWAN {
            
            if parentViewC != nil && willShowLoader == true {
                MBProgressHUD.showAdded(to: (parentViewC?.view)!, animated: true)
            }
            
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.timeoutInterval = ServiceTimeout
            
            var parameters:String? = nil
            
            
            // This section is to send parameter as 'Raw payload'(Check ARC). Comment this section if parameter to send as 'Data form'
            if serviceParam != nil {
                
                manager.requestSerializer.setQueryStringSerializationWith({ (Req:URLRequest, parameters1:Any, error:NSErrorPointer) -> String in
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: serviceParam!, options: .prettyPrinted)
                        parameters = String.init(data: jsonData, encoding: .utf8)
                        
                    } catch {
                        print("JSON Param error")
                    }
                    
                    return parameters!
                })
            }
            
            
            manager.post(serviceUrl, parameters: serviceParam, progress: nil, success: { (sessionDataTask:URLSessionDataTask, response:Any?) in
                
                if parentViewC != nil && willShowLoader == true {
                    MBProgressHUD.hide(for: (parentViewC?.view)!, animated: true)
                }
                
                let responseDic = response as! NSDictionary
                
                if response != nil{
                    
                    let status = responseDic["status"] as! NSDictionary
                    let message = status["message"] as? String
                    //print("responseDic = \(responseDic)")
                    
                    if "\(status["error_code"]!)" == "0" {
                        ServiceCompletion(responseDic["result"], true, message!)
                    }
                    else {
                        MyBasics.showPopup(Title: App_Title, Message: message!, InViewC: parentViewC)
                    }
                        
                }
                else {
                    MyBasics.showPopup(Title: App_Title, Message: "No data found", InViewC: parentViewC)
                }
                
            }, failure: { (sessionDataTask:URLSessionDataTask?, error:Error) in
                                
                if parentViewC != nil && willShowLoader == true {
                    MBProgressHUD.hide(for: (parentViewC?.view)!, animated: true)
                }
                
                if (parentViewC != nil) {
                    
                    let alertController = UIAlertController(title: App_Title, message: "Something went wrong, please try again", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    let tryAction = UIAlertAction(title: "Try again", style: .default, handler: { (UIAlertAction) in
                        
                        self.POSTServiceCall(serviceUrl: serviceUrl, serviceParam: serviceParam, parentViewC: parentViewC, willShowLoader:willShowLoader, ServiceCompletion: ServiceCompletion)
                        
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(tryAction)
                    parentViewC?.present(alertController, animated: true, completion: nil)
                    
                }
    
            })
            
        }
        else {
            
            self.showPopup(Title: App_Title, Message: "Please check your internet connection", InViewC: parentViewC)
            
        }
   
    }/*

}
 */*/

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let year = 365 * 24 * hour
        if secondsAgo < minute {
            if secondsAgo < 0 {
                return "1 seconds ago"
            }
            
            return "\(secondsAgo) seconds ago"
           
        }
            
        else if secondsAgo < hour {
            if (secondsAgo / minute) > 1 {
                return "\(secondsAgo / minute) minutes ago"
            } else {
                return "\(secondsAgo / minute) minute ago"
            }
        }
        else if secondsAgo < day {
            if (secondsAgo / hour) > 1 {
                return "\(secondsAgo / hour) hours ago"
            } else {
                return "\(secondsAgo / hour) hour ago"
            }
        }
        else if secondsAgo < week {
            if (secondsAgo / day) > 1 {
                return "\(secondsAgo / day) days ago"
            } else {
                return "\(secondsAgo / day) day ago"
            }
        }
        else if secondsAgo < year {
            if (secondsAgo / week) > 1 {
                return "\(secondsAgo / week) weeks ago"
            } else {
                return "\(secondsAgo / week) week ago"
            }
        }
        
        if (secondsAgo / year) > 1 {
            return "\(secondsAgo / year) years ago"
        } else {
            return "\(secondsAgo / year) year ago"
        }
        
    }
}

public class EdgeShadowLayer: CAGradientLayer {
    
    public enum Edge {
        case Top
        case Left
        case Bottom
        case Right
    }
    
    public init(forView view: UIView,
                edge: Edge = Edge.Top,
                shadowRadius radius: CGFloat = 20.0,
                toColor: UIColor = UIColor.white,
                fromColor: UIColor = UIColor.lightGray) {
        super.init()
        self.colors = [fromColor.cgColor, toColor.cgColor]
        self.shadowRadius = radius
        
        let viewFrame = view.frame
        
        switch edge {
        case .Top:
            startPoint = CGPoint(x: 0.5, y: 0.0)
            endPoint = CGPoint(x: 0.5, y: 1.0)
            self.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: shadowRadius)
        case .Bottom:
            startPoint = CGPoint(x: 0.5, y: 1.0)
            endPoint = CGPoint(x: 0.5, y: 0.0)
            self.frame = CGRect(x: 0.0, y: viewFrame.height - shadowRadius, width: viewFrame.width, height: shadowRadius)
        case .Left:
            startPoint = CGPoint(x: 0.0, y: 0.5)
            endPoint = CGPoint(x: 1.0, y: 0.5)
            self.frame = CGRect(x: 0.0, y: 0.0, width: shadowRadius, height: viewFrame.height)
        case .Right:
            startPoint = CGPoint(x: 1.0, y: 0.5)
            endPoint = CGPoint(x: 0.0, y: 0.5)
            self.frame = CGRect(x: viewFrame.width - shadowRadius, y: 0.0, width: shadowRadius, height: viewFrame.height)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
