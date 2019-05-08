//
//  MainTabBarController.swift
//  UFeed
//
//  Created by Ilya on 4/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import  UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.hidesBottomBarWhenPushed = true
        if (SocialManager.shared.getAuthorizedSocials().count != 0){
            self.selectedIndex = 1
            self.viewControllers?.removeFirst(1)
        }
        else {
            self.tabBar.isHidden = true
        }
    }

}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let feedVc = viewController as? FeedViewController {
            feedVc.reload()            
        }
    }
}
