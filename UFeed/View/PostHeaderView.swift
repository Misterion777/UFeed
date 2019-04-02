import UIKit

import SDWebImage

class PostHeaderView: UIView {
    
    lazy var ownerImage = UIImageView()
    
//    lazy var ownerImage: UIImageView = {
//
//        let imageView = UIImageView()
//
//        // Resize image on download
//
////        let manager = SDWebImageManager.shared()
////        manager.imageDownloader?.downloadImage(with: URL(string: imageURL), options: [], progress: nil, completed: { image, error, cacheType, finished in
////            if image != nil {
////                imageView.image = self.imageWithImage(image: image!, scaledToSize: CGSize(width: 50, height: 50))
////            }
////
////        })
////
//
//        return imageView
//    }()
//
//    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
//        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
//        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        return newImage
//    }
    
    
    lazy var ownerNameLabel: UILabel = {
        let ownerName = UILabel()
        ownerName.textColor = .black
        ownerName.font = UIFont.boldSystemFont(ofSize: 16)
        ownerName.textAlignment = .left
        
        return ownerName
    }()

    lazy var dateLabel: UILabel = {
        let date = UILabel()
        date.textColor = .black
        date.font = UIFont.systemFont(ofSize: 16)
        date.textAlignment = .left
        
        return date
    }()
    
    private func parseDate(date: Date) -> String{                
        return date.timeAgo(numericDates: true)
    }
    
//    override init(frame: CGRect){
//        super.init(frame: frame)
//        setup()
//    }
    
    init(ownerImage : String, ownerName: String, date: Date){
        super.init(frame: CGRect.zero)
        setup(ownerImg: ownerImage,ownerName: ownerName, date: date)
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    private func setup(ownerImg : String, ownerName: String, date: Date){
        
        ownerImage.sd_setImage(with: URL(string: ownerImg), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        ownerNameLabel.text = ownerName
        dateLabel.text = parseDate(date: date)
        
        
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
    
}
