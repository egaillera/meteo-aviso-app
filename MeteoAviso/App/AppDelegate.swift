//
//  AppDelegate.swift
//  MAviso
//
//  Created by Enrique Garcia Illera on 19/04/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import UIKit

let myLocation = LocationDetector()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let myServer = MeteoServer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
        }
        
        // Register with APNs
        UIApplication.shared.registerForRemoteNotifications()
        print("Registered in APN")
        
        //UNCOMMENT JUST FOR TESTING IN SIMULATOR, TO HAVE A RECORD WITH A USER
        //myServer.sendToken(userEmail:"egaillera@gmail.com",tokenStr:"token_de_prueba")
        
        
        return true
    }
    
    // MARK: Notifications boilerplate
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        MeteoServer.globalUserEmail = "fake1@fakemail.com"
        let tokenStr = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        myServer.sendToken(userEmail:MeteoServer.globalUserEmail,tokenStr:tokenStr)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        print(userInfo)
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

