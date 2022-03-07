//
//  ViewController.swift
//  OrderApp
//
//  Created by Amr Hossam on 25/02/2022.
//

import UIKit

class MainTabbarViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = UINavigationController(rootViewController: CategoryViewController())
        let vc2 = UINavigationController(rootViewController: YourOrderViewController())
        
        
        vc1.tabBarItem.image = UIImage(systemName: "menucard")
        vc1.tabBarItem.selectedImage = UIImage(systemName: "menucard.fill")
        vc1.tabBarItem.title = "Menu"
        vc2.tabBarItem.image = UIImage(systemName: "bag")
        vc2.tabBarItem.selectedImage = UIImage(systemName: "bag.fill")
        vc2.tabBarItem.title = "Your Order"
        

        
        
        
        setViewControllers([vc1, vc2], animated: true)
        
        
    }


}

