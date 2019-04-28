import UIKit

import VK_ios_sdk
import SafariServices



class SignInCollectionViewController: UIViewController, SFSafariViewControllerDelegate  {
    
    private let reuseIdentifier = "cellId"

    @IBOutlet weak var logOutButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    let networkImgs = [#imageLiteral(resourceName: "71172"), #imageLiteral(resourceName: "ecommerce_100-512") , #imageLiteral(resourceName: "images"), #imageLiteral(resourceName: "facebook")]
    let socials = [Social.vk, Social.twitter, Social.instagram, Social.facebook]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(SignInCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        
        titleLabel.textColor = UIColor.black
        titleLabel.text = "PLEASE, LOGIN"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 30)
        
        logOutButton.addTarget(self, action: #selector(self.logOut), for: .touchUpInside)
        
        SocialManager.shared.setViewController(vc: self)
        
    }
  
    
    
    @objc private func logOut() {
        let action = UIAlertAction(title: "OK", style: .default)
                        
        if VKSdk.isLoggedIn() {
            VKSdk.forceLogout()
        let alertController = UIAlertController(title: "Log outed!", message: "Successfuly log outed from the system", preferredStyle: .alert)
        alertController.addAction(action)
        
        present(alertController, animated: true)
        }
        else {
            let alertController = UIAlertController(title: "You are not signed in!", message: "Sign in first!", preferredStyle: .alert)
            alertController.addAction(action)
            
            present(alertController, animated: true)
        }        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let  padding :CGFloat = 150;
        let cellSize: CGFloat = collectionView.frame.size.width - padding;
        return CGSize(width : cellSize / 2, height : cellSize / 2);
    }
    
}
