//
//  ViewController.swift
//  UFeed
//
//  Created by Admin on 22/02/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

import Foundation

import SwiftyVK

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = UIButton(type: .custom)
        
        
        loginButton.frame = CGRect(x: 0, y: 0, width: 180, height: 40)
        loginButton.backgroundColor = UIColor.darkGray
        loginButton.setTitle("Login Button", for: .normal)
        loginButton.center = view.center;
        
        loginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        
        view.addSubview(loginButton)
    }
    
    @objc func loginButtonClicked() {
        
        VK.sessions.default.logIn(
            onSuccess: { info in
                print("SwiftyVK: success authorize with", info)
        },
            onError: { error in
                print("SwiftyVK: authorize failed with", error)
        }
        )
        
        VK.API.Users.get(.empty)
            .onSuccess {
                print("result: \n \($0	)")
                
            }
            .onError {
                print("Fail: \($0)")
            }
            .send()
        
    }

}

