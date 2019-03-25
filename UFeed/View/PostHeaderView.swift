//
//  PostHeaderView.swift
//  UFeed
//
//  Created by Ilya on 3/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

import SDWebImage

class PostHeaderView: UIView {

    lazy var ownerImage: UIImageView = {

        let imageURL = "https://is5-ssl.mzstatic.com/image/thumb/Purple118/v4/42/9a/45/429a4561-abc7-04d1-22d1-9c9dd5d5f6c5/source/256x256bb.jpg"
                    
        let imageView = UIImageView()
        
        // Resize image on download
        
//        let manager = SDWebImageManager.shared()
//        manager.imageDownloader?.downloadImage(with: URL(string: imageURL), options: [], progress: nil, completed: { image, error, cacheType, finished in
//            if image != nil {
//                imageView.image = self.imageWithImage(image: image!, scaledToSize: CGSize(width: 50, height: 50))
//            }
//
//        })
//
        
        
        
        imageView.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        
        
        return imageView
    }()
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    lazy var ownerNameLabel: UILabel = {
        let ownerName = UILabel()
        ownerName.text = "The Header"
        return ownerName
    }()

    lazy var dateLabel: UILabel = {
        let date = UILabel()
        date.textColor = .black
        date.font = UIFont.boldSystemFont(ofSize: 16)
        date.textAlignment = .left
        
        date.text = "21.02.2019"
        return date
    }()
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    init(){
        super.init(frame: CGRect.zero)
        setup()
    }
    
    private func setup(){
        
        addSubview(ownerImage)
        addSubview(ownerNameLabel)
        addSubview(dateLabel)
        
        
        ownerImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50, enableInsets: false)
        
        
        ownerNameLabel.anchor(top: topAnchor, left: ownerImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        dateLabel.anchor(top: ownerNameLabel.bottomAnchor, left: ownerImage.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
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
