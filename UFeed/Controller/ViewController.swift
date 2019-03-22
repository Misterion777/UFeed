//
//  ViewController.swift
//  UFeed
//
//  Created by Admin on 22/02/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

import Foundation

import VK_ios_sdk

class ViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        print("clicked")
        if !VKSdk.isLoggedIn() {
            VKSdk.authorize(VKDelegate.SCOPE)
        }
        
        VKApiWorker.getNewsFeed()
    }
    
    
    

}

