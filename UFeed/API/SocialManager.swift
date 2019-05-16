//
//  SocialManager.swift
//  UFeed
//
//  Created by Ilya on 4/24/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit
import SideMenuSwift

enum Social:Int, CodingKey {
    case facebook = 1
    case instagram
    case twitter
    case vk
    
    var description: String {
        switch self {
        case .facebook:
            return "Facebook"
        case .twitter:
            return "Twitter"
        case .vk:
            return "Vk"
        case .instagram:
            return "Instagram"
        }
    }
}

class SocialManager {
    
    static let shared = SocialManager()
    
    var socialDelegates = [Social : SocialDelegate]()
    private var vc : UIViewController?
    var currentSocial : Social?
    
    var apiManager : ApiClientManager!
    
    private init(){
        socialDelegates[.vk] = VKDelegate()
        socialDelegates[.twitter] = TwitterDelegate()
        socialDelegates[.facebook] = FacebookDelegate()
        socialDelegates[.instagram] = InstagramDelegate()
        apiManager = ApiClientManager(socials: self.getAuthorizedSocials())
    }
    
    func getApiClient(forSocial key:Social) -> ApiClient {
        return apiManager.clients[key]!
    }
    
    func getDelegate(forSocial key : Social) -> SocialDelegate {
        return socialDelegates[key]!
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
        self.currentSocial = key
        socialDelegates[key]!.authorize(onSuccess: onAuthorizeSuccess)
//        if (!socialDelegates[key]!.isAuthorized()) {
//            
//        }
//        else {
//            self.vc?.tabBarController?.selectedIndex = 2
//        }        
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
    
    func logOut(via key: Social? = nil) {
        if (key == nil) {
            for (_,delegate) in socialDelegates {
                delegate.logOut()
            }
            self.apiManager.updateApiClients(socials: [])
        }
        else{
            if (socialDelegates[key!]!.isAuthorized()) {
                socialDelegates[key!]!.logOut()
                self.apiManager.clients.removeValue(forKey: key!)
            }
        }
    }
    private func onAuthorizeSuccess() {
        updateClients()
        self.vc?.tabBarController?.selectedIndex = 2                
    }
    
    func updateClients() {
        self.apiManager.updateApiClients(socials: getAuthorizedSocials())
    }
    
}
