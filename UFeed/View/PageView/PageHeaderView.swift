
//
//  PageHeaderView.swift
//  UFeed
//
//  Created by Ilya on 5/2/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import SDWebImage

class PageHeaderView: UIView {

    lazy var pageImage = UIImageView()
    lazy var nameLabel: UILabel = {
        let ownerName = UILabel()
        ownerName.textColor = .black
        ownerName.font = UIFont.boldSystemFont(ofSize: 16)
        ownerName.textAlignment = .left
        return ownerName
    }()
    
    
    init(page : Page) {
        super.init(frame: CGRect.zero)
        pageImage.sd_setImage(with: URL(string: page.photo!.url), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        nameLabel.text = page.name
        nameLabel.numberOfLines = 0
        
        addSubview(pageImage)
        addSubview(nameLabel)
        
        
        pageImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50, enableInsets: false)
        
        
        nameLabel.anchor(top: topAnchor, left: pageImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 50, width: 0, height: 0, enableInsets: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
