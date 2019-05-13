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
    
    private var stackView : UIStackView!
    private var mainView : UIView!
    
    private var fileViews = [PostFileView]()
        
    private var imageSlideShow : ImageSlideshow = {
        let imageSlideshow = ImageSlideshow()
        imageSlideshow.activityIndicator = DefaultActivityIndicator(style: .whiteLarge, color: UIColor(rgb: 0x8860D0))
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor(rgb: 0x5680E9)
        pageIndicator.pageIndicatorTintColor = .lightGray
        imageSlideshow.pageIndicator = pageIndicator
        imageSlideshow.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .under)
        
//        imageSlideshow.contentScaleMode = UIView.ContentMode.scaleToFill
        return imageSlideshow
    }()
    
    private var postHeader = PostHeaderView()
    private var postFooter = PostFooterView()
    private var postVideoView = PostVideoView()
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
        textView.dataDetectorTypes = .link
        textView.isSelectable = true
        return textView
    }()
    
    func configureVideo(with viewController: UIViewController){
        postVideoView.presentingViewController = viewController
    }
    
    func setShadowColor(post: Post){
        if (post.type == "vk") {
            mainView.layer.shadowColor = UIColor(rgb: 0x5AB9EA).cgColor
        } else if (post.type == "twitter") {
            mainView.layer.shadowColor = UIColor(rgb: 0x84CEEB).cgColor
        } else if (post.type == "facebook") {
            mainView.layer.shadowColor = UIColor(rgb: 0x5680E9).cgColor
        } else if (post.type == "instagram") {
            mainView.layer.shadowColor = UIColor(rgb: 0x8860D0).cgColor
        }
    }
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    func configure(with post: Post?) {
        if let post = post {
            setShadowColor(post: post)
            
            indicatorView.stopAnimating()
            stackView.isHidden = false
            
            fileViews.removeAll()
            postVideoView.clear()
            
            postTextView.text = post.text
            postHeader.configure(post: post)
            postFooter.configure(with: post)
            
            var imageInputs = [InputSource]()
            if post.attachments != nil {
                for attach in post.attachments! {
                    if let videoAttach = attach as? VideoAttachment{
                        if (post.type == "instagram") {
                            imageInputs.append(ImageSource(image: generateThumbnail(path: URL(string: videoAttach.url!)!)!))
                        }
                        else {
                            imageInputs.append(SDWebImageSource(urlString: videoAttach.thumbnail.url)!)
                        }
                        postVideoView.addVideo(pageIndex: imageInputs.count - 1, video: videoAttach)
                    }
                    else if let photoAttach = attach as? PhotoAttachment{
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
                imageSlideShow.setImageInputs(imageInputs)
            }
        }
        else {
            indicatorView.startAnimating()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        imageSlideShow.currentPageChanged = postVideoView.slideShowPageChanged
                
        mainView = UIView()
        mainView.backgroundColor = UIColor(rgb: 0xFEFFFF)
        mainView.layer.masksToBounds = false;
        mainView.layer.cornerRadius = 10;
        mainView.layer.shadowOffset = CGSize(width: -1, height: -1)
        mainView.layer.shadowOpacity = 1;
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .clear
        
        mainView.addSubview(indicatorView)
        indicatorView.center = mainView.center
        indicatorView.hidesWhenStopped = true

        subviewFields()
  
        mainView.addSubview(stackView)
        stackView.anchor(top: mainView.topAnchor, left: mainView.leftAnchor, bottom: mainView.bottomAnchor, right: mainView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0, enableInsets: true)
        
        addSubview(mainView)
        mainView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 0, enableInsets: true)
    }
    
    private func subviewFields() {
        
        stackView.addArrangedSubview(postHeader)
        stackView.addArrangedSubview(postTextView)
        
        stackView.addArrangedSubview(imageSlideShow)
        imageSlideShow.heightAnchor.constraint(equalToConstant: 400.0).isActive = true
        imageSlideShow.addSubview(postVideoView)
        
        postVideoView.anchor(top: nil, left: imageSlideShow.leftAnchor, bottom: nil, right: imageSlideShow.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50, enableInsets: false)
    
        postVideoView.centerYAnchor.constraint(equalTo: imageSlideShow.centerYAnchor).isActive = true
        
        stackView.addArrangedSubview(postFooter)
        
        //        if fileViews.count != 0 {
        //            for fileView in fileViews {
        //                addSubview(fileView)
        //
        //                fileView.anchor(top: previousView.bottomAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        //                previousView = fileView
        //            }
        //        }
    
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
