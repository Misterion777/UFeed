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
    
    private func parseDate(date: Date) -> String{                
        return date.timeAgo(numericDates: true)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        addSubview(ownerImage)
        addSubview(ownerNameLabel)
        addSubview(dateLabel)
                
        ownerImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50, enableInsets: false)
        
        ownerNameLabel.anchor(top: topAnchor, left: ownerImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        dateLabel.anchor(top: ownerNameLabel.bottomAnchor, left: ownerImage.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
    }
    
    func configure(page : Page, date: Date){
        ownerImage.sd_setImage(with: URL(string: page.photo!.url), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        ownerNameLabel.text = page.name
        dateLabel.text = parseDate(date: date)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
