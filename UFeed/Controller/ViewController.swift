//
//  ViewController.swift
//  UFeed
//
//  Created by Admin on 22/02/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import FacebookLogin

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile])
        
        loginButton.center = view.center
        
        view.addSubview(loginButton)
    }


}

