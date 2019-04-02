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
class VKDelegate : NSObject, VKSdkDelegate, VKSdkUIDelegate {

    static let SCOPE = ["friends", "wall"]
    let VK_APP_ID = "6908309"
    //https://vk.com/dev/versions
    let LATEST_VERSION = "5.92"
    
    override init() {
        super.init()
        let vkInstance = VKSdk.initialize(withAppId: VK_APP_ID, apiVersion: LATEST_VERSION)
        vkInstance?.register(self)
        vkInstance?.uiDelegate = self
                
        VKSdk.wakeUpSession(VKDelegate.SCOPE, complete: { state, error in
            if state == VKAuthorizationState.authorized {
                print("Allready authorized")
            } else if error != nil {
                print("Error: \(error)")
            } else {
                print ("Initialized!")
            }
            
        })
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        
        if let topVC = UIApplication.getTopMostViewController() {
            topVC.present(controller, animated: true, completion: nil)
        }
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print("captcha")
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if ((result?.token) != nil) {
            print("Token: \(result.token) \n User id: \(result.token.userId)")
        }
        else {
            print("Error: \(result?.error)")
        }
        
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("Authorization failed!")
    }
    
}
