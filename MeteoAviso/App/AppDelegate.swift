//
//  AppDelegate.swift
//  MAviso
//
//  Created by Enrique Garcia Illera on 19/04/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let myTokenManager = TokenManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("D'oh: \(error.localizedDescription)")
            } else {
                print("Notifications request granted")
            }
        }
        
        print("Starting Google SDK")
        //GADMobileAds.sharedInstance().start(completionHandler: nil)

        // Register with APNs
        UIApplication.shared.registerForRemoteNotifications()
        //print("Registered in APN")
        
        //UNCOMMENT JUST FOR TESTING IN SIMULATOR, TO HAVE A RECORD WITH A USER
        //myTokenManager.sendToken(userEmail:"egaillera@gmail.com",tokenStr:"token_de_prueba")
        
        // Check if launched from notification
        let notificationOption = launchOptions?[.remoteNotification]

        // 1
        if
          let notification = notificationOption as? [String: AnyObject],
          let aps = notification["aps"] as? [String: AnyObject] {
            print("Launched by notification")
        }
        
        return true
    }
    
    // MARK: Notifications boilerplate
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        let globalUserEmail = "fake1@fakemail.com"
        let tokenStr = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        myTokenManager.sendToken(userEmail:globalUserEmail,tokenStr:tokenStr)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print(error)
    }
    
    // Treat notification if the app is already running
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
          }
        
        print(userInfo)
        print("Received notification about station with code <\(userInfo["station_code"] as! String)> and name <\(userInfo["station_name"] as! String)> ")
        NotificationArrived.shared.stationCodeToNavigationTo = (userInfo["station_code"] as! String)
    }
    
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

class NotificationArrived: ObservableObject {
    static let shared = NotificationArrived()
    @Published var stationCodeToNavigationTo : String?
}

