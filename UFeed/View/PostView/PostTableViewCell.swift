//
//  PostTableViewCell.swift
//  UFeed
//
//  Created by Ilya on 3/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//


import UIKit

import AVFoundation
import SDWebImage
import ImageSlideshow

class PostTableViewCell : UITableViewCell {
    
    private var mainView : UIView!
    
    private var fileViews = [PostFileView]()
    private var likesLabel : UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        return label
    }()
    
    private var mediaIcon = UIImageView()
    
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
    
    private var commentsLabel = UILabel()
    private var repostsLabel = UILabel()
    
    private var imageSlideShow : ImageSlideshow = {
        let imageSlideshow = ImageSlideshow()
        imageSlideshow.activityIndicator = DefaultActivityIndicator(style: .whiteLarge, color: .green)
        return imageSlideshow
    }()
    
    private var postHeader = PostHeaderView()
    private var indicatorView : UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.hidesWhenStopped = true
        indicatorView.color = .green
        return indicatorView
    }()
    private let postTextView : UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    private func toggleSubviews(hide : Bool) {
        for sv in mainView.subviews {
            sv.isHidden = hide
        }
        indicatorView.isHidden = !hide
    }
    
    func configure(with post: Post?) {
        if let post = post {
            toggleSubviews(hide: false)
            fileViews.removeAll()
            postTextView.text = post.text
            
            if (post.type == "vk"){
                mediaIcon.image = #imageLiteral(resourceName: "icons8-vk-circled-50")
            }
            else if (post.type == "twitter"){
                mediaIcon.image = #imageLiteral(resourceName: "icons8-twitter-circled-50")
            }
            else if (post.type == "facebook"){
                mediaIcon.image = #imageLiteral(resourceName: "icons8-facebook-circled-50")
            }
            else if (post.type == "instagram"){
                mediaIcon.image = #imageLiteral(resourceName: "icons8-instagram-50")
            }
            
            likesLabel.attributedText = createAttributedText(with: #imageLiteral(resourceName: "icons8-heart-outline-64"), text: String(post.likesCount))
            commentsLabel.attributedText = createAttributedText(with: #imageLiteral(resourceName: "icons8-topic-64 (1)"), text: String(post.commentsCount))
            repostsLabel.attributedText = createAttributedText(with: #imageLiteral(resourceName: "icons8-undo-64"), text: String(post.repostsCount))
            postHeader.configure(page: post.ownerPage!, date: post.date!)
            
            var imageInputs = [SDWebImageSource]()
            if post.attachments != nil {
                for attach in post.attachments! {
                    //                if let videoAttach = attach as? VideoAttachment{
                    //                    //videoAttach.append()
                    //                }
                    
                    if let photoAttach = attach as? PhotoAttachment{
                        imageInputs.append(SDWebImageSource(urlString: photoAttach.url)!)
                    }
                    else if let fileAttach = attach as? FileAttachment{
                        fileViews.append(PostFileView(fileName: fileAttach.title, fileSize:   fileAttach.size, fileLink: fileAttach.url))
                    }
                }
            }
            if imageInputs.count == 0 {
                imageSlideShow.isHidden = true
            }
            else {
                imageSlideShow.isHidden = false
                imageSlideShow.setImageInputs(imageInputs as [InputSource])
            }            
        }
        else {
            toggleSubviews(hide: true)
            indicatorView.startAnimating()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        mainView = UIView()
        mainView.backgroundColor = UIColor(rgb: 0xFEFFFF)
        mainView.layer.masksToBounds = false;
        mainView.layer.cornerRadius = 10;
        mainView.layer.shadowOffset = CGSize(width: -1, height: -1)
        mainView.layer.shadowOpacity = 0.5;
        mainView.layer.shadowColor = UIColor.blue.cgColor
        
        mainView.addSubview(indicatorView)
        indicatorView.center = mainView.center
        indicatorView.isHidden = true
        
        subviewFields()
        
        addSubview(mainView)
        mainView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 0, enableInsets: true)
    }
    
    private func subviewFields() {
        
        var previousView : UIView
        mainView.addSubview(postHeader)
        postHeader.anchor(top: mainView.topAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        mainView.addSubview(mediaIcon)
        mediaIcon.anchor(top: mainView.topAnchor, left: nil, bottom: nil, right: mainView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 30, height: 30, enableInsets: false)
                        
        mainView.addSubview(postTextView)
        postTextView.anchor(top: postHeader.bottomAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        previousView = postTextView
        
        mainView.addSubview(imageSlideShow)
        
        imageSlideShow.anchor(top: previousView.bottomAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 400, enableInsets: false)
        previousView = imageSlideShow
        
        //        if fileViews.count != 0 {
        //            for fileView in fileViews {
        //                addSubview(fileView)
        //
        //                fileView.anchor(top: previousView.bottomAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        //                previousView = fileView
        //            }
        //        }
        
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        
        mainView.addSubview(lineView)
        lineView.anchor(top: previousView.bottomAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 1, enableInsets: false)
        
        previousView = lineView
        
        mainView.addSubview(likesLabel)
        mainView.addSubview(repostsLabel)
        mainView.addSubview(commentsLabel)
        
        likesLabel.anchor(top: previousView.bottomAnchor, left: mainView.leftAnchor, bottom: mainView.bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 5, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        
        repostsLabel.anchor(top: previousView.bottomAnchor, left: nil, bottom: mainView.bottomAnchor, right: commentsLabel.leftAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 5, paddingRight: 15, width: 0, height: 0, enableInsets: false)
        
        commentsLabel.anchor(top: previousView.bottomAnchor, left: nil, bottom: mainView.bottomAnchor, right: mainView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 5, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
