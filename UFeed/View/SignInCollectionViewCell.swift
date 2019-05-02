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
//        loginButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 200)
//        loginButton.clipsToBounds = false
////        loginButton.frame = CGRect(x: 0,y: 0,width: 180,height: 40)
//        
//        loginButton.backgroundColor = .blue
//        loginButton.setTitle("Login via", for: .normal)
//        loginButton.setTitleColor(.black, for: .normal)
//        loginButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
        
        addSubview(loginButton)
        
        loginButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
    }
    
    @objc func loginButtonClicked() {
        SocialManager.shared.authorize(via: currentSocial!)
        
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
