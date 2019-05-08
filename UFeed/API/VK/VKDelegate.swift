//
//  VKDelegate.swift
//  UFeed
//
//  Created by Admin on 21/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import VK_ios_sdk
//
class VKDelegate : NSObject, VKSdkDelegate, VKSdkUIDelegate, SocialDelegate {
    
    private let SCOPE = ["friends", "wall"]
    private let VK_APP_ID = "6908309"
    //https://vk.com/dev/versions
    private let LATEST_VERSION = "5.92"
    
    var viewController: UIViewController?
    var onAuthorizeSuccess : (()->Void)?
    var userId: String? 
    
    
    override init() {
        super.init()
        let vkInstance = VKSdk.initialize(withAppId: VK_APP_ID, apiVersion: LATEST_VERSION)
        vkInstance?.register(self)
        vkInstance?.uiDelegate = self
                
        VKSdk.wakeUpSession(SCOPE, complete: { state, error in
            if state == VKAuthorizationState.authorized {
                print("Allready authorized")
            } else if error != nil {
                print("Error: \(error)")
            } else {
                print ("Initialized!")
            }
            
        })
    }
    
    func authorize(onSuccess: @escaping () -> Void) {
        self.onAuthorizeSuccess = onSuccess
        VKSdk.authorize(SCOPE)
    }
    
    func isAuthorized() -> Bool{
        return VKSdk.isLoggedIn()
    }
    
    func logOut() {
        VKSdk.forceLogout()
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        if viewController == nil {
            if let topVC = UIApplication.getTopMostViewController() {
                topVC.present(controller, animated: true, completion: nil)
            }
        }
        else {
            viewController!.present(controller, animated: true, completion: nil)
        }
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print("captcha")
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if ((result?.token) != nil) {
            self.onAuthorizeSuccess!()
            print("Token: \(result.token) \n User id: \(result.token.userId)")
        }
        else {
            print("Error: \(result?.error)")
        }
        
    }
    
    func vkSdkUserAuthorizationFailed() {
        if (viewController != nil) {
            viewController!.alert(title: "VK authorization failed", message: "Authorization failed!")
        }
        print("VK Authorization failed!")
    }
    
}

