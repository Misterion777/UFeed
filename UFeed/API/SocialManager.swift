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
    case twitter
    case vk
    case instagram
}

class SocialManager {
    
    static let shared = SocialManager()
    
    private var socialDelegates = [Social : SocialDelegate]()
    private var vc : UIViewController?
    var currentSocial : Social?
    
    var apiManager : ApiClientManager!
    
    private init(){
        socialDelegates[.vk] = VKDelegate()
        socialDelegates[.twitter] = TwitterDelegate()
        socialDelegates[.facebook] = FacebookDelegate()
        apiManager = ApiClientManager(socials: self.getAuthorizedSocials())
    }
    
    func getApiClient(forSocial key:Social) -> ApiClient {
        return apiManager.clients[key]!
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
            self.currentSocial = key
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
    
    func logOut(via key: Social? = nil) {
        if (key == nil) {
            for (_,delegate) in socialDelegates {
                delegate.logOut()
            }
        }
        else{
            if (socialDelegates[key!]!.isAuthorized()) {
                socialDelegates[key!]!.logOut()
            }
        }
        updateClients()
    }
    private func onAuthorizeSuccess() {
        updateClients()
        self.vc?.tabBarController?.selectedIndex = 2                
    }
    
    private func updateClients() {
        self.apiManager.updateApiClients(socials: getAuthorizedSocials())
    }
    
}
