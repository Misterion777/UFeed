//
//  SettingsViewController.swift
//  UFeed
//
//  Created by Ilya on 4/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let menuItem = UIBarButtonItem(image: #imageLiteral(resourceName: "burger"), style: .plain, target: self, action: #selector(menuButtonDidClicked))
        self.navigationItem.leftBarButtonItem = menuItem
    }
    
    @objc func menuButtonDidClicked() {
        sideMenuController?.revealMenu()
    }

}
