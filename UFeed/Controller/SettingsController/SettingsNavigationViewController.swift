//
//  SettingsNavigationViewController.swift
//  UFeed
//
//  Created by Ilya on 4/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class SettingsNavigationViewController: UINavigationController {
    

    open override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    
}
