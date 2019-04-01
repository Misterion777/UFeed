//
//  SignInCollectionViewCell.swift
//  UFeed
//
//  Created by Admin on 31/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class SignInCollectionViewCell: UICollectionViewCell {
    
    //let image  =  UIImage()
    
    var image : UIImage? {
        didSet {
            imageView.image = image
            subviewFields()
        }
    }
    
    let imageView = UIImageView()
    
    
    private func subviewFields() {
        addSubview(imageView)
        
        imageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70, enableInsets: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
