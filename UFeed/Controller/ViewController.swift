//
//  ViewController.swift
//  UFeed
//
//  Created by Admin on 22/02/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import FacebookLogin
import Foundation
import FacebookCore

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
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController: self) { loginResult in
            self.loginManagerDidComplete(loginResult)
            
        }
        
    }
    
    func loginManagerDidComplete(_ result: LoginResult){
        let alertController: UIAlertController
        switch result {
        case .cancelled:
            alertController = UIAlertController(title: "Canceled", message: "Canceled by user", preferredStyle: .alert)
        case .failed(let error):
            alertController = UIAlertController(title: "Failed", message: "Error: \(error)", preferredStyle: .alert)
        case .success(_, _, let accessToken):
            alertController = UIAlertController(title: "Success", message: "Cool, token: \(accessToken.userId ?? "no user id")", preferredStyle: .alert)
        }
        self.present(alertController, animated:true, completion: nil)
    }
    

}

