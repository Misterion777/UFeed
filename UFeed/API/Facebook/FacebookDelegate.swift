//
//  FacebookDelegate.swift
//  UFeed
//
//  Created by Ilya on 4/28/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

let userIdKey = "fbUserId"
class FacebookDelegate: SocialDelegate {
    
    let loginManager = LoginManager()
    let readPermissions : [ReadPermission] = [ .publicProfile]
    
    var viewController: UIViewController?
    var userId = UserDefaults.standard.string(forKey: userIdKey)
    
    func getUserLikesPermissions (onSuccess: @escaping () -> Void) {
        loginManager.logIn(readPermissions: [.userLikes], viewController: viewController, completion: {result in
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
    
    func authorize(onSuccess: @escaping () -> Void) {
    
        loginManager.logIn(readPermissions: readPermissions, viewController: viewController, completion: {result in
            switch result {
            case .failed(let error):
                self.viewController?.alert(title: "Facebook Error", message: "Authentication error : \(error)")
            case .cancelled:
                self.viewController?.alert(title: "Facebook Canceled", message: "user cancelled login")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.userId = accessToken.userId!
                UserDefaults.standard.set(self.userId, forKey: userIdKey)
                onSuccess()
            }
        })
    }
    
    func logOut() {
        loginManager.logOut()
        AccessToken.current = nil
        userId = nil
        UserDefaults.standard.removeObject(forKey: userIdKey)
    }
    
    func isAuthorized() -> Bool {        
        return AccessToken.current != nil && userId != nil
    }
    

}
