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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupFirebase()
        setupPushNotificationsWith(application: application)
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
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let notificationMessage = extractMessage(fromPushNotificationUserInfo: userInfo) {
            showNotifiation(message: notificationMessage)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    // MARK: - Private Methods
    private func setupInitialVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SplashScreenViewController()
        window?.makeKeyAndVisible()
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
    }
    
    private func setupPushNotificationsWith(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
        }
        
        application.registerForRemoteNotifications()
    }
    
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
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
    
    private func showNotifiation(message: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Master"
        content.body = message
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default
        
        let dateComponents = DateComponents()
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    private func extractMessage(fromPushNotificationUserInfo userInfo: [AnyHashable: Any]) -> String? {
        var message: String?
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? String {
                message = alert
            }
        }
        return message
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
}
