//
//  AppDelegate.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 09/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setUpLandingScreen()
        return true
    }
    
    // MARK: - Landing screen for application.
    
    func setUpLandingScreen() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard.init(storyboard: .main)
        let viewController: ArticlesViewController = storyboard.instantiateViewController()
        viewController.viewModel = ArticlesViewModel(articleServices: Dependencies.articlesServices)
        guard let appWindow = self.window else { return }
        appWindow.makeKeyAndVisible()
        appWindow.rootViewController = UINavigationController(rootViewController: viewController)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}
    
    func applicationDidEnterBackground(_ application: UIApplication) {
         NetworkConnectionServices.shared.stopMonitoring()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) { }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
         NetworkConnectionServices.shared.startMonitoring()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}
