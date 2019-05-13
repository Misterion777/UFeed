//
//  ErrorView.swift
//  UFeed
//
//  Created by Ilya on 5/13/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit

class ErrorView : UIView {
    
    private var errorLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private var errorImage : UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "ff28b16ff577438"))
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(errorLabel)
        addSubview(errorImage)
        errorImage.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150 , height: 200, enableInsets: false)
        errorImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        errorLabel.anchor(top: errorImage.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
    }
    
    func setErrorMessage (with errorText: String) {
        errorLabel.text = errorText        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
