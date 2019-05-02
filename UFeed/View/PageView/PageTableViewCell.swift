//
//  PageTableViewCell.swift
//  UFeed
//
//  Created by Ilya on 4/29/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class PageTableViewCell : UITableViewCell {
    
    var page : Page?
    
    lazy var pageImage = UIImageView()
    lazy var nameLabel: UILabel = {
        let ownerName = UILabel()
        ownerName.textColor = .black
        ownerName.font = UIFont.boldSystemFont(ofSize: 16)
        ownerName.textAlignment = .left        
        return ownerName
    }()
    
    func configure(with page: Page?) {
        
        self.page = page
        subviewFields()
        
        
    }
    
    func subviewFields() {
        
        pageImage.sd_setImage(with: URL(string: self.page!.photo!.url), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        nameLabel.text = self.page!.name
        nameLabel.numberOfLines = 0
        
        addSubview(pageImage)
        addSubview(nameLabel)
        
        
        pageImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50, enableInsets: false)
        
        
        nameLabel.anchor(top: topAnchor, left: pageImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 50, width: 0, height: 0, enableInsets: false)
        
    }
    
}
