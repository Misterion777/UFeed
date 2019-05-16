//
//  TwitterDelegate.swift
//  UFeed
//
//  Created by Ilya on 4/21/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import Swifter
import UIKit



class TwitterDelegate : SocialDelegate {
        
    private let key = "tLxVnNmgOkWYeCEfOzJjPIza4"
    private let secret = "QLdeuQIpuUQOEIOXgfhPpYZaw7REulMajWTWZebULfppKjHuH2"
    
    private var oauthToken = UserDefaults.standard.string(forKey: "oauthToken")
    private var oauthSecret = UserDefaults.standard.string(forKey: "oauthSecret")
    
    var swifter : Swifter!
    var viewController: UIViewController?
    var userId = UserDefaults.standard.string(forKey: "twitterUserId")
    
    init() {
        if oauthSecret != nil && oauthToken != nil {
            swifter = Swifter(consumerKey: key, consumerSecret: secret, oauthToken: oauthToken!, oauthTokenSecret: oauthSecret!)
        } else {
            swifter = Swifter(consumerKey: key, consumerSecret: secret)
        }        
    }
    
    func logOut() {
        UserDefaults.standard.removeObject(forKey: "oauthToken")
        UserDefaults.standard.removeObject(forKey: "oauthSecret")
        UserDefaults.standard.removeObject(forKey: "twitterUserId")
        self.oauthToken = nil
        self.oauthSecret = nil
        self.userId = nil
        swifter = Swifter(consumerKey: key, consumerSecret: secret)
    }
    
    func authorize(onSuccess: @escaping ()->Void) {
        let url = URL(string: "ufeed://success")!
        swifter.authorize(withCallback: url, presentingFrom: viewController, success: { accessToken, _ in
            
            self.oauthToken = accessToken?.key
            self.oauthSecret = accessToken?.secret
            self.userId = accessToken?.userID
            UserDefaults.standard.set(accessToken?.key, forKey: "oauthToken")
            UserDefaults.standard.set(accessToken?.secret, forKey: "oauthSecret")
            UserDefaults.standard.set(accessToken?.userID, forKey: "twitterUserId")
            onSuccess()            
        }, failure: { _ in
            self.viewController?.alert(title: "Twitter authorization error", message: "Authorization error")
        })
    }
    
    func isAuthorized() -> Bool {
        return oauthToken != nil && oauthSecret != nil
    }
    
}
