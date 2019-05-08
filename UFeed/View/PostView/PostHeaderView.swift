import UIKit

import SDWebImage

class PostHeaderView: UIView {
    
    lazy var ownerImage : UIImageView = {
        let ownerImage = UIImageView()
        ownerImage.layer.cornerRadius = 25
        ownerImage.layer.masksToBounds = true
        ownerImage.layer.borderWidth = 0
        return ownerImage
    }()
    
    lazy var ownerNameLabel: UILabel = {
        let ownerName = UILabel()
        ownerName.textColor = .black
        ownerName.font = UIFont.boldSystemFont(ofSize: 16)
        ownerName.textAlignment = .left
        return ownerName
    }()

    lazy var dateLabel: UILabel = {
        let date = UILabel()
        date.textColor = .lightGray
        date.font = UIFont.systemFont(ofSize: 16)
        date.textAlignment = .left
        return date
    }()
    private var mediaIcon = UIImageView()
    
    private func parseDate(date: Date) -> String{                
        return date.timeAgo(numericDates: true)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        addSubview(ownerImage)
        addSubview(ownerNameLabel)
        addSubview(dateLabel)
        addSubview(mediaIcon)
                
        ownerImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50, enableInsets: false)
        
        ownerNameLabel.anchor(top: topAnchor, left: ownerImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        dateLabel.anchor(top: ownerNameLabel.bottomAnchor, left: ownerImage.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
                
        mediaIcon.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 30, height: 30, enableInsets: false)

    }
    
    func configure(post : Post) {
        ownerImage.sd_setImage(with: URL(string: post.ownerPage!.photo!.url), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        ownerNameLabel.text = post.ownerPage!.name
        
        dateLabel.text = parseDate(date: post.date!)
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
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
