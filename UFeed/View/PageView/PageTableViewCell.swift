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
    
    var page : Page?
    

    func configure(with page: Page?) {
    
        self.page = page
        subviewFields()
        
    }
    
    private func clearSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func subviewFields() {
        
        clearSubviews()
        let header = PageHeaderView(page: self.page!)
        
        addSubview(header)
        
        header.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)   
    }
    
}
