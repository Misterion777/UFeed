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
//import ReadMoreTextView

class PostTableViewCell : UITableViewCell {
    
    
    private var picWidth = 0
    private var picHeight = 0
    private var postHeader : PostHeaderView?
    private var fileViews = [PostFileView]()
    private var audioViews = [PostAudioView]()
    private var likesLabel = UILabel()
    private var commentsLabel = UILabel()
    private var repostsLabel = UILabel()
    private var imageSlideShow : ImageSlideshow?
    private var indicatorView = UIActivityIndicatorView()
    
    private let postTextView : UITextView? = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    private func initFields(post : Post){
        fileViews.removeAll()
        audioViews.removeAll()
        imageSlideShow = nil
//        readmoreTextView.maximumNumberOfLines = 5
//        readmoreTextView.shouldTrim = true
//        readmoreTextView.attributedReadMoreText = NSAttributedString(string: "... Read more")
//        readmoreTextView.attributedReadLessText = NSAttributedString(string: " Read less")
//
//        readmoreTextView.text = post.text
        postTextView!.text = post.text
        
        likesLabel.text = String(post.likesCount) + " likes "
        repostsLabel.text = String(post.repostsCount) + " reposts "
        commentsLabel.text = String(post.commentsCount) + " comments"
        
        postHeader = PostHeaderView(ownerImage: post.ownerPhoto!.url, ownerName: post.ownerName!,date: post.date!)                
        
        
        var imageInputs = [SDWebImageSource]()
        if post.attachments != nil {
            
            for attach in post.attachments! {
//                if let videoAttach = attach as? VideoAttachment{
//                    //videoAttach.append()
//                }
                
                if let photoAttach = attach as? PhotoAttachment{
                    imageInputs.append(SDWebImageSource(urlString: photoAttach.url)!)
                    if (photoAttach.height > picHeight) {
                        picHeight = photoAttach.height
                        picWidth = photoAttach.width
                    }
                    
                }
                else if let audioAttach = attach as? AudioAttachment{
                    audioViews.append(PostAudioView(audioName: audioAttach.title, audioUrl: audioAttach.url, duration: audioAttach.duration))
                }
                else if let fileAttach = attach as? FileAttachment{                    
                    fileViews.append(PostFileView(fileName: fileAttach.title, fileSize:   fileAttach.size, fileLink: fileAttach.url))
                }
            }
            if imageInputs.count != 0 {
                imageSlideShow = ImageSlideshow()
                imageSlideShow!.activityIndicator = DefaultActivityIndicator(style: .whiteLarge, color: .green)
                imageSlideShow!.setImageInputs(imageInputs as [InputSource])
            }
            
        }
        
        
        subviewFields()
    }
    
    private func clearSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    private func subviewFields() {
        
        
        var previousView : UIView
        
        addSubview(postHeader!)
        
        postHeader!.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
//        addSubview(readmoreTextView)
//        readmoreTextView.anchor(top: postHeader?.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        addSubview(postTextView!)
        postTextView!.anchor(top: postHeader?.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        previousView = postTextView!
        
        if (imageSlideShow != nil) {
            addSubview(imageSlideShow!)
            //TODO: CHANGE SIZE!
//            let screenWidth = UIScreen.main.bounds.width
//            let coeff = screenWidth / CGFloat(picWidth)
//            let newHeight = CGFloat(picHeight) * coeff
            
            imageSlideShow!.anchor(top: previousView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 400, enableInsets: false)
            previousView = imageSlideShow!
        }
        if fileViews.count != 0 {
            
            for fileView in fileViews{
                addSubview(fileView)
                
                fileView.anchor(top: previousView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
                
                previousView = fileView
            }
            
        }
        
        if audioViews.count != 0 {
            for audioView in audioViews {
                addSubview(audioView)
                audioView.anchor(top: previousView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
                
                previousView = audioView
            }
        }
        
        addSubview(likesLabel)
        addSubview(repostsLabel)
        addSubview(commentsLabel)
        
        likesLabel.anchor(top: previousView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        repostsLabel.anchor(top: previousView.bottomAnchor, left: likesLabel.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        commentsLabel.anchor(top: previousView.bottomAnchor, left: repostsLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        configure(with: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        indicatorView.hidesWhenStopped = true
        indicatorView.color = .green
        indicatorView.startAnimating()
                
        addSubview(indicatorView)
        indicatorView.center = self.center
    }

    
    func configure(with post: Post?) {
        
        clearSubviews()
        if let post = post {
            initFields(post: post)
            subviewFields()
            indicatorView.stopAnimating()
        } else {
            addSubview(indicatorView)
            indicatorView.center = self.center
            indicatorView.startAnimating()
        }
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.layer.addBorder(edge: .bottom, color: .white, thickness: 20)
//    }

}

//protocol Resizable {
//    func onResize()
//}

//extension ReadMoreTextView : Resizable{
//
//    var cell : PostTableViewCell {
//        get {
//        }
//        set {
//        }
//    }
//    convenience init (cell: PostTableViewCell) {
//        self.init()
//        self.cell = cell
//    }
//    func onResize() {
//        self.cell.sizeToFit()
//    }
//
//}
