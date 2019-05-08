//
//  PageTableViewCell.swift
//  UFeed
//
//  Created by Ilya on 4/29/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit


class PageTableViewCell : UITableViewCell {
    
    var page : Page!
    private var mainView : UIView!
    private var header = PageHeaderView()
    private var checkmark = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    private var logoutButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "icons8-exit-50"), for: .normal)
        return button
    }()
    private var mainPageLogout : (()->Void)?
    var checked = false

    func configure(with page: Page, needCheckmark: Bool = true, mainPageLogout: (()->Void)? = nil) {
        self.page = page
        header.configure(with: page)
        checkmark.isHidden = mainPageLogout != nil || !needCheckmark
        logoutButton.isHidden = mainPageLogout == nil
        if (mainPageLogout != nil) {
            self.mainPageLogout = mainPageLogout
            logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        }
    }
    
    @objc private func logout() {
        self.mainPageLogout!()
    }
    
    func toggle(check: Bool? = nil){
        if (check != nil) {
            checked = !check!
        }
        if checked {
            checkmark.image = #imageLiteral(resourceName: "icons8-unchecked-checkbox-50")
            checked = false
        }
        else {
            checkmark.image = #imageLiteral(resourceName: "icons8-checked-checkbox-50")
            checked = true
        }
    }    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        mainView = UIView()
        mainView.backgroundColor = UIColor(rgb: 0xFEFFFF)
        
        mainView.addSubview(header)
        checkmark.image = #imageLiteral(resourceName: "icons8-unchecked-checkbox-50")
        mainView.addSubview(checkmark)
        mainView.addSubview(logoutButton)
        
        header.anchor(top: mainView.topAnchor, left: mainView.leftAnchor, bottom: mainView.bottomAnchor, right: checkmark.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        checkmark.anchor(top: nil, left: nil, bottom: mainView.bottomAnchor, right: mainView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 15, width: 30, height: 30, enableInsets: false)        
        logoutButton.anchor(top: nil, left: nil, bottom: mainView.bottomAnchor, right: mainView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 15, paddingRight: 15, width: 25, height: 25
            , enableInsets: false)
        
        addSubview(mainView)
        mainView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 0, enableInsets: true)
    }
        
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    
    
}
