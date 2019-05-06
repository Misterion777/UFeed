//
//  SetupSocialViewCell.swift
//  UFeed
//
//  Created by Ilya on 5/2/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit


class SetupSocialViewCell : UITableViewCell {
    
    var buttonTitle : String?
    
    var onButtonClick : (()->Void)?
    var beforeLogIn : (()->Void)?
    func configure(with title: String) {
        
        self.buttonTitle = title
        subviewFields()
        
    }
    
    @objc func click() {
        onButtonClick!()
    }
    
    func subviewFields() {
        
        let button = UIButton(type: .custom)
        
        button.setTitle(buttonTitle!, for: .normal)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
        
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        addSubview(button)
        
        button.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 0, enableInsets: false)
    }
}
