//
//  TabBarViewController.swift
//  StocksApp
//
//  Created by Офелия on 21.07.2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private var dataBase: DataBaseProtocol
    private var networkingService: NetworkingProtocol
    
    init(_ database: DataBaseProtocol, networkingService: NetworkingProtocol ) {
        self.dataBase = database
        self.networkingService = networkingService
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let favoriteVC = FavoritesViewController()
        let stockVC = StocksViewController(dataBase, networkingService: networkingService)
        favoriteVC.tabBarItem = UITabBarItem()
        favoriteVC.tabBarItem.image = UIImage(named: "starIcon")
        UITabBar.appearance().tintColor = .black

        stockVC.tabBarItem = UITabBarItem()
        stockVC.tabBarItem.image = UIImage(named: "searchIcon")
        let controllers = [stockVC, favoriteVC]
        viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
       
    }
    
}
