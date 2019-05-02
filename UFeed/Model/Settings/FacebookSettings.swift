//
//  FacebookSettings.swift
//  UFeed
//
//  Created by Ilya on 4/30/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class FacebookSettings : Settings {
    private var initialId : [Int]?
    var pagesId: [Int]?
    
    init() {
        pagesId = UserDefaults.standard.array(forKey: "facebookPages") as? [Int]
        initialId = pagesId
    }
    
    func save() {
        UserDefaults.standard.set(pagesId, forKey: "facebookPages")
        initialId = pagesId
    }
    
    
    
    func isInitialized() -> Bool {
        return pagesId != nil
    }
    
    func hasChanged() -> Bool {
        return !initialId!.containsSameElements(as: pagesId!)
    }
    
}
