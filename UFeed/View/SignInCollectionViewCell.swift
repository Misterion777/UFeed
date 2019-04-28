//
//  SignInCollectionViewCell.swift
//  UFeed
//
//  Created by Admin on 31/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit


class SignInCollectionViewCell: UICollectionViewCell {
    
    var currentSocial : Social?
    
    var image : UIImage? {
        didSet {
            imageView.image = image
            subviewFields()
        }
    }
    
    let imageView = UIImageView()
    let loginButton = UIButton(type: .custom)
    
    
    private func subviewFields() {
        loginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        
        loginButton.setImage(imageView.image, for: .normal)
        addSubview(loginButton)
        
        loginButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70, enableInsets: false)
    }
    
    @objc func loginButtonClicked() {
        SocialManager.shared.authorize(via: currentSocial!)        
//        
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let tabBar = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
//
//        tabBar?.selectedIndex = 1
        
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
