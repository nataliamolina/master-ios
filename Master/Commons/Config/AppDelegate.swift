//
//  AppDelegate.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit
import Firebase
import Localize
import GoogleSignIn
import UserNotifications
import Paymentez

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var appNavigationController = MNavigationController()
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupFirebase()
        setupPushNotifications(application)
        setupPaymentez()
        setupInitialVC()
        disableDarkMode()
        setupLang()
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        return GIDSignIn.sharedInstance()?.handle(url) ?? false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}
    
    func applicationDidEnterBackground(_ application: UIApplication) {}
    
    func applicationWillEnterForeground(_ application: UIApplication) {}
    
    func applicationDidBecomeActive(_ application: UIApplication) {}
    
    func applicationWillTerminate(_ application: UIApplication) {}
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        PushNotifications.shared.handle(userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        PushNotifications.shared.handle(userInfo: userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // MARK: - Private Methods
    private func setupPaymentez() {
        guard
            let prodPayment = (Utils.plist?.value(forKey: "PROD_PAYMENT") as? Bool),
            let appKey = Utils.plist?.value(forKey: "PaymentezAppKey") as? String,
            let appCode = Utils.plist?.value(forKey: "PaymentezAppCode") as? String else {
                
                return
        }
        
        PaymentezSDKClient.setEnvironment(appKey, secretKey: appCode, testMode: !prodPayment)
    }
    
    private func setupInitialVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SplashScreenViewController(viewModel: SplashScreenViewModel(),
                                                                router: MainRouter(navigationController: appNavigationController,
                                                                                   delegate: nil))
        window?.makeKeyAndVisible()
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
    }
    
    private func setupPushNotifications(_ app: UIApplication) {
        Messaging.messaging().delegate = self
        
        var config: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        if #available(iOS 13.0, *) {
            config = [.alert, .announcement, .sound, .badge, .providesAppNotificationSettings]
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: config) { (isDone: Bool, error: Error?) in
            guard isDone, error == nil else {
                print(error?.localizedDescription ?? "")
                
                return
            }
            
            DispatchQueue.main.async {
                app.registerForRemoteNotifications()
            }
        }
    }
    
    private func disableDarkMode() {
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
    }
    
    private func setupLang() {
        let localize = Localize.shared
        localize.update(provider: .strings)
        localize.update(language: "en")
    }
}

// MARK: - Push Notification methods
extension AppDelegate {
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("TOKEN!: " + getStringFrom(token: deviceToken))
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print(error)
    }
    
    func getStringFrom(token: Data) -> String {
        return token.reduce("") { $0 + String(format: "%02.2hhx", $1) }
    }
}

// MARK: - Push Notification methods
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
}
