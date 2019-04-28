//
//  SocialManager.swift
//  UFeed
//
//  Created by Ilya on 4/24/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit

enum Social:String, CodingKey {
    case vk = "vk"
    case twitter = "twitter"
    case facebook = "facebook"
    case instagram = "instagram"
}

class SocialManager {
    
    static let shared = SocialManager()
    
    private var socialDelegates = [Social : SocialDelegate]()
    
    private var vc : UIViewController?
    
    var apiManager : ApiClientManager!
    
    private init(){
        socialDelegates[Social.vk] = VKDelegate()
        socialDelegates[Social.twitter] = TwitterDelegate()
        apiManager = ApiClientManager(socials: self.getAuthorizedSocials())
    }
    
    func getDelegate(forSocial key : Social) -> SocialDelegate? {
        return socialDelegates[key]
    }
    
    func setViewController(vc : UIViewController) {
        self.vc = vc
        for (_, value) in socialDelegates {
            value.viewController = vc
        }
    }
    
    func isAuthorized(forSocial key: Social) -> Bool {
        return socialDelegates[key]!.isAuthorized()
    }
    
    
    func authorize(via key: Social) {
        if (!socialDelegates[key]!.isAuthorized()) {
            socialDelegates[key]!.authorize(onSuccess: onAuthorizeSuccess)
        }
        else {
            self.vc?.tabBarController?.selectedIndex = 1
        }        
    }
    
    func getAuthorizedSocials() -> [Social]{
        var keys = [Social]()
        for (key,value) in socialDelegates {
            if (value.isAuthorized()) {
                keys.append(key)
            }
        }
        return keys
    }
    
    func logOut(via key: Social) {
        if (socialDelegates[key]!.isAuthorized()) {
            socialDelegates[key]!.logOut()
        }
    }
    
    private func onAuthorizeSuccess() {
        self.apiManager.updateApiClients(socials: getAuthorizedSocials())
        self.vc?.tabBarController?.selectedIndex = 1        
    }
    
    
}
