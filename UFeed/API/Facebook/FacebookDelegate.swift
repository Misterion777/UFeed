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

class FacebookDelegate: SocialDelegate {
    
    let loginManager = LoginManager()
    let readPermissions : [ReadPermission] = [ .publicProfile]
    
    var viewController: UIViewController?    
    
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
                onSuccess()
            }
        })
    }
    
    func logOut() {
        loginManager.logOut()
        AccessToken.current = nil
    }
    
    func isAuthorized() -> Bool {        
        return AccessToken.current != nil
    }
    

}
