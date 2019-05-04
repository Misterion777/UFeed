//
//  SetupSocialViewCell.swift
//  UFeed
//
//  Created by Ilya on 5/2/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit


class SetupSocialViewCell : UITableViewCell {
    
    var currentSocial : Social?    
    
    var loginSuccess : (()->Void)?
    var beforeLogIn : (()->Void)?
    func configure(with social: Social?) {
        
        self.currentSocial = social
        subviewFields()
        
    }
    
    @objc func logIn() {
        SocialManager.shared.getDelegate(forSocial: currentSocial!).authorize(onSuccess: success)
    }
    
    func success() {
        SocialManager.shared.updateClients()
        self.loginSuccess!()
    }
    
    func subviewFields() {
        
        let button = UIButton(type: .custom)
        
        button.setTitle("Set up your \(currentSocial!.description)", for: .normal)
        button.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        addSubview(button)
        
        button.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 0, enableInsets: false)
    }
}
