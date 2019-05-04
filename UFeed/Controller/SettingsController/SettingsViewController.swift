//
//  SettingsViewController.swift
//  UFeed
//
//  Created by Ilya on 4/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var settings : Settings?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let burger = UIBarButtonItem(image: #imageLiteral(resourceName: "burger"), style: .plain, target: self, action: #selector(burgerButtonClicked))
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonClicked))
        saveButton.isEnabled = false
        self.navigationItem.leftBarButtonItem = burger
        self.navigationItem.rightBarButtonItem = saveButton
        SocialManager.shared.setViewController(vc: self)
    }
    
    func toggleSaveButton() {
        if (settings!.hasChanged()){
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }        
    }
    
    @objc func saveButtonClicked() {
        settings!.save()
        self.alert(title: "Cool", message: "Saved")
        print(self.settings!.pages!)
        toggleSaveButton()
    }
    
    @objc func burgerButtonClicked() {
        sideMenuController?.revealMenu()
    }

}
