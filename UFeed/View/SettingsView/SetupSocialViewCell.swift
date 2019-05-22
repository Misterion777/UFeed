//
//  SetupSocialViewCell.swift
//  UFeed
//
//  Created by Ilya on 5/2/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit


class SetupSocialViewCell : UITableViewCell {
    
    var button = UIButton(type: .custom)
    
    var onButtonClick : (()->Void)?
    var beforeLogIn : (()->Void)?
    
    func configure(with social: Social, text: String? = nil) {
        if (text != nil) {
            button.setTitle(text, for: .normal)
            return
        }
        switch social {
        case .facebook:
            button.setImage(#imageLiteral(resourceName: "facebook (1)"), for: .normal)
        case .vk:
            button.setImage(#imageLiteral(resourceName: "vk-login"), for: .normal)
        case .twitter:
            button.setImage(#imageLiteral(resourceName: "twitter_login_button"), for: .normal)
        default:            
            button.setImage(#imageLiteral(resourceName: "инста"), for: .normal)
        }
    }
    
    @objc func click() {
        onButtonClick!()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
//        button.backgroundColor = .lightGray
//        button.layer.cornerRadius = 5
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.black.cgColor
        addSubview(button)
        
        button.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 40, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
