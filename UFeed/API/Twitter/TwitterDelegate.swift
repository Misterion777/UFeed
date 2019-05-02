//
//  TwitterDelegate.swift
//  UFeed
//
//  Created by Ilya on 4/21/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import SwifteriOS
import UIKit

class TwitterDelegate : SocialDelegate {
    
    private let key = "tLxVnNmgOkWYeCEfOzJjPIza4"
    private let secret = "QLdeuQIpuUQOEIOXgfhPpYZaw7REulMajWTWZebULfppKjHuH2"
    
    private var oauthToken = UserDefaults.standard.string(forKey: "oauthToken")
    private var oauthSecret = UserDefaults.standard.string(forKey: "oauthSecret")
    
    var swifter : Swifter!
    var viewController: UIViewController?
    
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
        self.oauthToken = nil
        self.oauthSecret = nil
        swifter = Swifter(consumerKey: key, consumerSecret: secret)
    }
    
    func authorize(onSuccess: @escaping ()->Void) {
        let url = URL(string: "ufeed://success")!
        swifter.authorize(withCallback: url, presentingFrom: viewController, success: { accessToken, _ in
            self.oauthToken = accessToken?.key
            self.oauthSecret = accessToken?.secret
            UserDefaults.standard.set(accessToken?.key, forKey: "oauthToken")
            UserDefaults.standard.set(accessToken?.secret, forKey: "oauthSecret")
            onSuccess()            
        }, failure: { _ in
            self.viewController?.alert(title: "Twitter authorization error", message: "Authorization error")
        })
    }
    
    func isAuthorized() -> Bool {
        return oauthToken != nil && oauthSecret != nil
    }
    
}
