//
//  PostFileView.swift
//  UFeed
//
//  Created by Ilya on 3/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class PostFileView: UIView {

    lazy var fileIcon = UIImageView(image: #imageLiteral(resourceName: "document-file-icon"))
    
//    lazy var fileIcon: UIImageView = {
//
//        let imageView = UIImageView(image: #imageLiteral(resourceName: "document-file-icon"))
//
//        return imageView
//    }()
//
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var sizeLabel: UILabel = {
        let size = UILabel()
        size.textColor = .black
        size.font = UIFont.boldSystemFont(ofSize: 16)
        size.textAlignment = .left
        
        return size
    }()
    
    
    init(fileName: String, fileSize: Int, fileLink: String ){
        super.init(frame: CGRect.zero)
        setup(fileName: fileName, fileSize: fileSize, fileLink: fileLink)
    }
    
    private func bytesToHumanReadable(bytes: Int) -> String {
        return "ololololo"
    }
    
    private func setup(fileName: String, fileSize: Int, fileLink: String){
        
        nameLabel.text = fileName        
        sizeLabel.text = bytesToHumanReadable(bytes: fileSize)
        
        addSubview(fileIcon)
        addSubview(nameLabel)
        addSubview(sizeLabel)
        
        
        fileIcon.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50, enableInsets: false)
        
        
        nameLabel.anchor(top: topAnchor, left: fileIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        sizeLabel.anchor(top: nameLabel.bottomAnchor, left: fileIcon.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */


}
