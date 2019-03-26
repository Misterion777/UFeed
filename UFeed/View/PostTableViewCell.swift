//
//  PostTableViewCell.swift
//  UFeed
//
//  Created by Ilya on 3/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//


import UIKit

//import ReadMoreTextView
import AVFoundation
import SDWebImage
import ImageSlideshow

class PostTableViewCell : UITableViewCell {
    let imageURL = "https://is5-ssl.mzstatic.com/image/thumb/Purple118/v4/42/9a/45/429a4561-abc7-04d1-22d1-9c9dd5d5f6c5/source/256x256bb.jpg"
    
    let imageInputs = [SDWebImageSource(urlString: "https://is5-ssl.mzstatic.com/image/thumb/Purple118/v4/42/9a/45/429a4561-abc7-04d1-22d1-9c9dd5d5f6c5/source/256x256bb.jpg"), SDWebImageSource(urlString: "https://article.images.consumerreports.org/prod/content/dam/CRO%20Images%202018/Health/April/CR-Health-Inlinehero-bananas-good-for-you-0418"),
        SDWebImageSource(urlString: "https://images.unsplash.com/photo-1528825871115-3581a5387919?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80")]
    
    let audioPlayer = AVPlayer()    
    
    var post : Post? {
        didSet {
            postTextView.text = post?.text
        }
    }
    
    private let postHeader : PostHeaderView = {
        let header = PostHeaderView()
        
        return header
    }()

    private let imageSlideShow : ImageSlideshow = {
        let instance = ImageSlideshow()
        instance.backgroundColor = .black
        return instance
    }()
    
    
    private let postTextView : UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        
        
//        textView.shouldTrim = false
//        textView.maximumNumberOfLines = 4
//        textView.attributedReadMoreText = NSAttributedString(string: "... lol")
//        textView.attributedReadLessText = NSAttributedString(string: "kek")
//
        
        return textView
    }()
    
    
    private let fileView : PostFileView = {
        let view = PostFileView()
        return view
    }()
    
    private let audioView : PostAudioPlayerView = {
        let view = PostAudioPlayerView()
        return view
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageSlideShow.setImageInputs(imageInputs as! [InputSource])
        addSubview(postHeader)
        addSubview(postTextView)
        addSubview(imageSlideShow)
        addSubview(fileView)
        addSubview(audioView)
        
        postHeader.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
                
        postTextView.anchor(top: postHeader.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        //TODO: CHANGE SIZE!
        imageSlideShow.anchor(top: postTextView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 400, enableInsets: false)
        
        fileView.anchor(top: imageSlideShow.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
       
        audioView.anchor(top: fileView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

