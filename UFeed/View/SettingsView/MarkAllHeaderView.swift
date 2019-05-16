//
//  MarkAllHeaderView.swift
//  UFeed
//
//  Created by Ilya on 5/5/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit

class MarkAllHeaderView : UITableViewHeaderFooterView {
    
    lazy var markButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "epty"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "icons8-check-all-50"), for: .selected)
        return button
    }()
    
    lazy var label: UILabel = {
        let ownerName = UILabel()
        ownerName.textColor = .black
        ownerName.font = UIFont.boldSystemFont(ofSize: 16)
        ownerName.textAlignment = .left
        return ownerName
    }()
    
    var buttonPressed : (()->Void)!
    
    func configure(selected: Bool, buttonPressed : @escaping ()->Void) {
        markButton.isSelected = selected
        self.buttonPressed = buttonPressed
        self.markButton.addTarget(self, action: #selector(toggleButton), for: .touchUpInside)
        subviewFields()
    }
    
    @objc private func toggleButton() {
        markButton.isSelected = !markButton.isSelected
        self.buttonPressed()
    }
    
    
    func subviewFields() {
        
        addSubview(label)
        label.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        addSubview(markButton)
        markButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 30, height: 30, enableInsets: false)
    }
}
