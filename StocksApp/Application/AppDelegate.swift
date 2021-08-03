//
//  AppDelegate.swift
//  StocksApp
//
//  Created by Офелия on 25.06.2021.
//

import UIKit
import CoreData
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let tabBarController = UITabBarController()
    
    let coreDataStack = CoreDataStack(modelName: "Model")
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "arrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "arrow")
        let networkingService = Networking()
        
        let dataBase = DataBaseStock(backgroundContext: coreDataStack.backgroundContext, context: coreDataStack.managedContext)
        let tabBarVC = TabBarViewController(dataBase, networkingService: networkingService)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = tabBarVC
//        if let nc = self.window?.rootViewController as? UINavigationController, var vc = nc.topViewController as? StocksViewController {
//            let dataB = DataBaseStock(backgroundContext: coreDataStack.backgroundContext, context: coreDataStack.managedContext)
//            vc = StocksViewController(dataB)!
//        }
        
        return true
    }
    
}

