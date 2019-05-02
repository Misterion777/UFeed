import UIKit

import VK_ios_sdk
import SafariServices



class SignInCollectionViewController: UIViewController, SFSafariViewControllerDelegate  {
    
    private let reuseIdentifier = "cellId"

    @IBOutlet weak var logOutButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    let networkImgs = [#imageLiteral(resourceName: "facebook (1)") , #imageLiteral(resourceName: "twitter_login_button") , #imageLiteral(resourceName: "vk-login")]
    let socials = [Social.facebook, Social.twitter, Social.vk]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(SignInCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        
        titleLabel.textColor = UIColor.black
        titleLabel.text = "Welcome to UFeed\nLog in via one of the network to get feed!"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 30)
        
        logOutButton.addTarget(self, action: #selector(self.logOut), for: .touchUpInside)
        
        SocialManager.shared.setViewController(vc: self)
        
    }
  
    
    
    @objc private func logOut() {
        
        SocialManager.shared.logOut()
        alert(title: "Log out", message: "Success")
    }
}


extension SignInCollectionViewController : UICollectionViewDataSource{
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return networkImgs.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SignInCollectionViewCell
        let currentLastItem = networkImgs[indexPath.row]
        cell.image = currentLastItem
        cell.currentSocial = socials[indexPath.row]
        return cell
    }
}

extension SignInCollectionViewController: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10.0
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let  padding :CGFloat = 70;
        let cellSize: CGFloat = collectionView.frame.size.width - padding;
        
        
        return CGSize(width : cellSize , height : 67);
    }
    
}
