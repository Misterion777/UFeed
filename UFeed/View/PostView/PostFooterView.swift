//
//  PostFooterView.swift
//  UFeed
//
//  Created by Ilya on 5/8/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit

class PostFooterView : UIView {
    
    private var likesLabel = UILabel()
    private var commentsLabel = UILabel()
    private var repostsLabel = UILabel()
    
    init(){
        super.init(frame: CGRect.zero)
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        
        addSubview(lineView)
        addSubview(likesLabel)
        addSubview(repostsLabel)
        addSubview(commentsLabel)
        
        lineView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1, enableInsets: false)
        
        likesLabel.anchor(top: lineView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        repostsLabel.anchor(top: lineView.bottomAnchor, left: nil, bottom: bottomAnchor, right: commentsLabel.leftAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 5, paddingRight: 20, width: 0, height: 0, enableInsets: false)

        commentsLabel.anchor(top: lineView.bottomAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 0, enableInsets: false)
    }
    
    func configure(with post:Post){
        likesLabel.attributedText = createAttributedText(with: #imageLiteral(resourceName: "icons8-heart-outline-64"), text: String(post.likesCount))
        commentsLabel.attributedText = createAttributedText(with: #imageLiteral(resourceName: "icons8-topic-64 (1)"), text: String(post.commentsCount))
        repostsLabel.attributedText = createAttributedText(with: #imageLiteral(resourceName: "icons8-undo-64"), text: String(post.repostsCount))
    }
    
    private func createAttributedText(with image : UIImage, text: String) -> NSMutableAttributedString{
        let imageAttachment = NSTextAttachment()
        let imageOffsetY:CGFloat = -5.0;
        imageAttachment.image = image
        
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 30, height: 30)
        let textAfterIcon = NSMutableAttributedString(string: " \(text)",
            attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)])
        completeText.append(textAfterIcon)
        return completeText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
