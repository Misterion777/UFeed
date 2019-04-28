//
//  SocialDelegate.swift
//  UFeed
//
//  Created by Ilya on 4/24/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit

protocol SocialDelegate : class {
    var viewController : UIViewController? { get set }
    
    func authorize(onSuccess: @escaping ()->Void)
    func logOut()
    
    func isAuthorized() -> Bool
}
