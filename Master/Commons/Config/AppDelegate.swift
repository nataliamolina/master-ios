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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupInitialVC()
        disableDarkMode()
        setupLang()

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}
    
    func applicationDidEnterBackground(_ application: UIApplication) {}
    
    func applicationWillEnterForeground(_ application: UIApplication) {}
    
    func applicationDidBecomeActive(_ application: UIApplication) {}
    
    func applicationWillTerminate(_ application: UIApplication) {}
    
    // MARK: - Private Methods
    private func setupInitialVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SplashScreenViewController()
        window?.makeKeyAndVisible()
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
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

