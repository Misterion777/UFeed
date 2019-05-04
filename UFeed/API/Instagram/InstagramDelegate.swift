
//
//  TwitterDelegate.swift
//  UFeed
//
//  Created by Ilya on 5/2/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin


fileprivate let userDefaultsKey = "instagramPageId"

class InstagramDelegate: SocialDelegate {
    
    var viewController: UIViewController?
    
    private var page : Page?
    var instagramPageId : String? = UserDefaults.standard.string(forKey: userDefaultsKey)
    private lazy var facebookDelegate = SocialManager.shared.getDelegate(forSocial: .facebook) as! FacebookDelegate
    private let readPermissions : [ReadPermission] = [ .pagesShowList, .custom("instagram_basic"), .custom("instagram_manage_insights") ]
    private let publishPermissions : [PublishPermission] = [ .managePages]
    
    
    private func getPermissions (onSuccess: @escaping () -> Void) {
        facebookDelegate.loginManager.logIn(publishPermissions: publishPermissions, viewController: viewController, completion: {result in
            switch result {
            case .failed(let error):
                self.viewController?.alert(title: "Facebook Error", message: "Authentication error : \(error)")
            case .cancelled:
                self.viewController?.alert(title: "Facebook Canceled", message: "user cancelled login")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.facebookDelegate.loginManager.logIn(readPermissions: self.readPermissions, viewController: self.viewController, completion: {result in
                    switch result {
                    case .failed(let error):
                        self.viewController?.alert(title: "Facebook Error", message: "Authentication error : \(error)")
                    case .cancelled:
                        self.viewController?.alert(title: "Facebook Canceled", message: "user cancelled login")
                    case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                        onSuccess()
                    }
                })
            }
        })
    }
    
   
    func authorize(onSuccess: @escaping () -> Void) {
        if (!facebookDelegate.isAuthorized()){
            return (self.viewController?.alert(title: "Error", message: "You should authorize via facebook first!"))!
        }
        
        getPermissions {
            let connection = GraphRequestConnection()
            let parameters = ["fields" : "instagram_business_account{name,profile_picture_url}"]
            connection.add(GraphRequest(graphPath: "me/accounts", parameters: parameters)) { httpResponse, result in
                
                switch result {
                case .success(let response):
                    if let dictionary = response.dictionaryValue{
                        if let data = dictionary["data"] as? [[String:Any]] {
                            for datum in data {
                                if let instagramAccount = datum["instagram_business_account"] as? [String : Any] {
                                    
                                    self.page = InstagramPage.from(instagramAccount as NSDictionary)
                                    
                                    self.instagramPageId = instagramAccount["id"] as? String
                                    UserDefaults.standard.set(self.instagramPageId!, forKey: userDefaultsKey)
                                    return onSuccess()
                                }
                            }
                            self.viewController?.alert(title: "No business account", message: "Not found any business instagram account connected to facebook")
                        }
                    }
                case .failed(let err):
                    self.viewController?.alert(title: "Instagram error", message: "Authorization error: \(err)")
                }
            }
            connection.start()
        }
    }
    
    func getPage(success: @escaping (Page) -> Void ) {
        
        if (self.page != nil) {
          success(self.page!)
        }
        getCurrentPage(success: success)
    }
    
    private func getCurrentPage (success: @escaping (Page) -> Void) {
        
        let connection = GraphRequestConnection()
        let parameters = ["fields" : "name,username,profile_picture_url"]
     
        connection.add(GraphRequest(graphPath: "\(instagramPageId!)", parameters: parameters)) { httpResponse, result in
            switch result {
            case .success(let response):
                if let dictionary = response.dictionaryValue{
                    self.page = InstagramPage.from(dictionary as NSDictionary)
                    success(self.page!)
                }
            case .failed(let err):
                self.viewController?.alert(title: "Instagram error", message: "Authorization error: \(err)")
            }
        }
        
        connection.start()
    }
    
    func logOut() {
        self.instagramPageId = nil
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
    
    func isAuthorized() -> Bool {
        //facebookDelegate.isAuthorized() && 
        return instagramPageId != nil
    }
    
}
