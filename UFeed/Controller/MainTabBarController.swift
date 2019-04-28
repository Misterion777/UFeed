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
        if (SocialManager.shared.getAuthorizedSocials().count != 0){
            self.selectedIndex = 1
        }
        
    }
}
