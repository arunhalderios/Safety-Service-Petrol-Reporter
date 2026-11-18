//
//  AppDelegate.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 10/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import UserNotifications
import FirebaseMessaging
import IQKeyboardManagerSwift

@main

class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate, UIGestureRecognizerDelegate {
    
    var window: UIWindow?
    var timer: Timer?
    
    
    lazy var operationQueue:OperationQueue = {
         let queue = OperationQueue()
         queue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
         queue.name = "ServerInteractionQueue"
         queue.qualityOfService = .background
         return queue
     }()
     lazy var operationQueueBG:OperationQueue = {
         let queue = OperationQueue()
         queue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
         queue.name = "ServerInteractionQueue"
         queue.qualityOfService = .background
         return queue
     }()
     static var kQueueOperationsChanged = "kQueueOperationsChanged"
     static var kQueueOperationsChangedBG = "kQueueOperationsChangedBG"
     
//    var window:UIWindow? = {
//         return UIWindow.init(frame: UIScreen.main.bounds)
//     }()
    let gcmMessageIDKey = "gcm.message_id"
    let gcmData = "gcm.notification.data"
    var isIgnore:Bool = false
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        self.registerNotificationStart(application: application)
        
       // self.callVersionChecking()
        /// Operation Que for Api Call Structure
        self.operationQueue.addObserver(self, forKeyPath: "operations", options: NSKeyValueObservingOptions(rawValue: 0), context: &AppDelegate.kQueueOperationsChanged)
        
        ///Chakeck User ALready logged in or Not
        if let _ = UserDefaults.standard.value(forKey: "USERID") {
            let rootViewController = self.window!.rootViewController as! UINavigationController
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
            rootViewController.pushViewController(profileViewController, animated: true)
            
            
        }
        else {
            let rootViewController = self.window!.rootViewController as! UINavigationController
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            rootViewController.pushViewController(profileViewController, animated: true)
        }
        
        return true
    }
    

    
    


    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //
        print("=====================applicationDidBecomeActive=====================")

    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //3
        print("=====================applicationDidEnterBackground=====================")
    }

    
    func applicationWillEnterForeground(_ application: UIApplication) {
        //2
        print("=====================applicationWillEnterForeground=====================")

    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        //
        print("=====================applicationWillResignActive=====================")

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        //UserDefaults.standard.removeObject(forKey: "ShiftShatCalLed")1
        print("=====================applicationWillTerminate=====================")
       // TimeService.instance.timer = 20.0
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        print("CurrentTime: \(time)")

      //  timer = Timer.scheduledTimer(timeInterval: TimeService.instance.timer!, target: self, selector: #selector(self.timeOut), userInfo: nil, repeats: true)

    }
    
    // must be internal or public.
//    @objc func update() {
//        // Something cool
//        print("")
//    }
    
    
    
    func registerNotificationStart(application:UIApplication){
        FirebaseApp.configure()
               Messaging.messaging().delegate = self
               
               UNUserNotificationCenter.current().delegate = self
               
               let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
               
               UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, error) in
                   guard error == nil else{
                       print(error!.localizedDescription)
                       return
                   }
                   
                   
                   //Solicit permission from the user to receive notifications
                   UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, error) in
                       guard error == nil else{
                           print(error!.localizedDescription)
                           return
                       }
                   }
                   
                   //get application instance ID
//                InstanceID.InstanceID.instanceID().instanceID { (result, error) in
//                       if let error = error {
//                           print("Error fetching remote instance ID: \(error)")
//                       } else if let result = result {
//                           print("Remote instance ID token: \(result.token)")
//                           UserDefaults.standard.set(result.token, forKey: "TOKEN")
//                       }
//                   }
//                   DispatchQueue.main.async {
//                       application.registerForRemoteNotifications()
//                   }
                   
                   
                   
               }
               
               application.registerForRemoteNotifications()
        
    }
    
    

    // MARK: UISceneSession Lifecycle

   // MARK: - NAVIGATION
   internal func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
       
       if (rootViewController == nil) { return nil }
       
       if (rootViewController.isKind(of: (UITabBarController).self)) {
           
           
           return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
           
       } else if (rootViewController.isKind(of:(UINavigationController).self)) {
           
           return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
           
       } else if (rootViewController.presentedViewController != nil) {
           return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
       }
       return rootViewController
   }
   

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "Safety_service_Patrol_Reporter")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
//    @objc func applicationDidTimeout(notification: NSNotification) {
//
//        print("application did timeout, perform actions")
//
//    }

}

//class TimerApplication: UIApplication {
//
//    // the timeout in seconds, after which should perform custom actions
//    // such as disconnecting the user
//    private var timeoutInSeconds: TimeInterval {
//        // 2 minutes
//        return 1 * 60
//    }
//
//    private var idleTimer: Timer?
//
//    // resent the timer because there was user interaction
//    private func resetIdleTimer() {
//        print("======================Reset Idle Timer======================")
//        if let idleTimer = idleTimer {
//            print("======================Timer Invalid======================")
//            idleTimer.invalidate()
//        }
//
//        idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds,
//                                         target: self,
//                                         selector: #selector(TimerApplication.timeHasExceeded),
//                                         userInfo: nil,
//                                         repeats: false
//        )
//    }
//
//    // if the timer reaches the limit as defined in timeoutInSeconds, post this notification
//    @objc private func timeHasExceeded() {
//        print("======================Timer Has Exceeded======================")
//        NotificationCenter.default.post(name: Notification.Name("appTimeout"), object: nil)
//    }
//
//    override func sendEvent(_ event: UIEvent) {
//
//        super.sendEvent(event)
//
//        if idleTimer != nil {
//            self.resetIdleTimer()
//        }
//
//        if let touches = event.allTouches {
//            for touch in touches where touch.phase == UITouch.Phase.began {
//                self.resetIdleTimer()
//            }
//        }
//    }
//}


extension AppDelegate {
    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//           print("Firebase registration token: \(fcmToken)")
//           
//           
//           UserDefaults.standard.set(fcmToken, forKey: "FCM")
//           UserDefaults.standard.synchronize()
//          
//       }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

        if let FCMTOKEN = fcmToken{
      UserDefaults.standard.set(FCMTOKEN, forKey: "FCM")
                UserDefaults.standard.synchronize()
        }
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
       func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
           if UIApplication.shared.applicationState == UIApplication.State.active {
               
               
           } else {
               
               
           }
           
           // Print message ID.
           if let messageID = userInfo[gcmMessageIDKey] {
               print("Message ID: \(messageID)")
           }
           
           // Print full message.
           print(userInfo)
       }
       func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
           print("Unable to register for remote notifications: \(error.localizedDescription)")
       }
       func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
           // If you are receiving a notification message while your app is in the background,
           // this callback will not be fired till the user taps on the notification launching the application.
           // TODO: Handle data of notification
           
           // With swizzling disabled you must let Messaging know about the message, for Analytics
           // Messaging.messaging().appDidReceiveMessage(userInfo)
           
           // Print message ID.
           if let messageID = userInfo[gcmMessageIDKey] {
               print("Message ID: \(messageID)")
           }
           
           // Print full message.
           print(userInfo)
           
           completionHandler(UIBackgroundFetchResult.newData)
       }
       
       func userNotificationCenter(_ center: UNUserNotificationCenter,
                                   willPresent notification: UNNotification,
                                   withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           let userInfo = notification.request.content.userInfo
           
           // With swizzling disabled you must let Messaging know about the message, for Analytics
           // Messaging.messaging().appDidReceiveMessage(userInfo)
           
           // Print message ID.
           if let messageID = userInfo[gcmMessageIDKey] {
               print("Message ID: \(messageID)")
           }
           
           // Print full message.
           print(userInfo)
           
           

           let messageDetaisl = userInfo[AnyHashable(gcmMessageIDKey)]!
           
           print(messageDetaisl)
           completionHandler([.alert,.sound,.badge])
       }
       
       func userNotificationCenter(_ center: UNUserNotificationCenter,
                                   didReceive response: UNNotificationResponse,
                                   withCompletionHandler completionHandler: @escaping () -> Void) {
           let userInfo = response.notification.request.content.userInfo
           // Print message ID.
           if let messageID = userInfo[gcmMessageIDKey] {
               print("Message ID: \(messageID)")
           }
           
           // Print full message.
           print(userInfo)
           
           

           
           completionHandler()
       }
       func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
       {
           debugPrint("didRegisterForRemoteNotificationsWithDeviceToken: DATA")
           let token = String(format: "%@", deviceToken as CVarArg)
           debugPrint("*** deviceToken: \(token)")
           let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
           debugPrint("deviceTokenString: \(deviceTokenString)")
           //Messaging.messaging().apnsToken = deviceToken
           //        debugPrint("Firebase Token:",InstanceID.instanceID().token() as Any)
       }




    
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (((object as? OperationQueue) === self.operationQueue) && (keyPath == "operations") && (context == &AppDelegate.kQueueOperationsChanged)) {
            DispatchQueue.main.async {
                
                if self.operationQueue.operationCount > 0 {
                    
                    CustomActivityIndicator.sharedInstance.display(onView: UIApplication.shared.windows[0], done: {
                        
                    })
                    
                }else{
                    CustomActivityIndicator.sharedInstance.hide {
                        
                    }
                }
                
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            CustomActivityIndicator.sharedInstance.hide {
                
            }
        }
    }
    func callVersionChecking(){
       //let myGroup = DispatchGroup()
       // myGroup.enter()
        var param:[String:AnyObject] = [String:AnyObject]()
       if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                 param["version"] = version as AnyObject
             }
          param["device"] = "1" as AnyObject
        
        //print(param)
        let operation = WebServiceOperation.init((API.version_control.getURL()?.absoluteString ?? ""), param, .WEB_SERVICE_POST, nil)
        operation.completionBlock = {
            print(operation.responseData?.dictionary?.prettyprintedJSON ?? "")
           
                guard let dictResponse = operation.responseData?.dictionary, dictResponse.count > 0 else {
                   
                    return
                }
                guard let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0 else {
                   
                    return
                }
                
                
                guard let statusCode = dictStatus["error_code"] as? NSNumber else {
                    
                   
                    return
                }
                if statusCode.intValue == 0 {
                    if let responseDict = dictResponse["result"] as? [String:Any] {
                        if let updateRespponse = responseDict["data"] as? [String:Any] {
                             let require = updateRespponse["update_type"] as? String
                            //let severity = updateRespponse["severity"] as? String
                            let dialog_message = updateRespponse["dialog_message"] as? String
                            let okClause =   PROJECT_CONSTANT.CLOUS{
                               // myGroup.leave()
                               // myGroup.notify(queue: DispatchQueue.main) {

                                    ////// do your remaining work
                                //}
                            }
                           
                            
                           // if require?.uppercased() == "yes".uppercased(){
                                if require?.uppercased() == "critical".uppercased(){
                                    
                                    DispatchQueue.main.async {
                                        
                                        let updatePop = PROJECT_CONSTANT.CLOUS{
                                                                                       if let url = URL(string: "itms-apps://apple.com/app/id1531322285") {
                                                                                           UIApplication.shared.open(url)
                                                                                       }
                                                                                   }
                                        PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please update the latest version from app store", AllActions: ["Update":updatePop], Style: .alert)
                                    }
                                   
                                }else{
                                    let updatePop = PROJECT_CONSTANT.CLOUS{
                                                                                                                          if let url = URL(string: "itms-apps://apple.com/app/id1531322285") {
                                                                                                                              UIApplication.shared.open(url)
                                                                                                                          }
                                                                                                                      }
                                    PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Please update the latest version from app store", AllActions: ["Update":updatePop,"Later":nil], Style: .alert)
                                }
//                            }else if require?.uppercased() == "no".uppercased(){
//                                //myGroup.leave()
//                            }
                            
                        }
                      
                    }else{
                       
                    }
                   
                }else{
                   
                }
                
            
        }
        
        self.operationQueueBG.addOperation(operation)
    }
}
