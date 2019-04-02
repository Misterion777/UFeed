//
//  SignInCollectionViewCell.swift
//  UFeed
//
//  Created by Admin on 31/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import VK_ios_sdk

class SignInCollectionViewCell: UICollectionViewCell {
    
    //let image  =  UIImage()
    
    var image : UIImage? {
        didSet {
            imageView.image = image
            subviewFields()
        }
    }
    
    let imageView = UIImageView()
    
    
    private func subviewFields() {
//        addSubview(imageView)
//
//        imageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70, enableInsets: false)
        
        let loginButton = UIButton(type: .custom)
        
        loginButton.backgroundColor = UIColor.darkGray
        loginButton.setTitle("Login Button", for: .normal)
        loginButton.center = self.center;
        
        loginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        
        addSubview(loginButton)
        
        loginButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70, enableInsets: false)
    }
    
    @objc func loginButtonClicked() {
        print("clicked")
        if !VKSdk.isLoggedIn() {
            VKSdk.authorize(VKDelegate.SCOPE)
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
        
        tabBar?.selectedIndex = 1
        
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
