//
//  InstagramSettings.swift
//  UFeed
//
//  Created by Ilya on 4/30/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class InstagramSettings : Settings {        
    
    override init() {
        super.init()
        if let data = UserDefaults.standard.object(forKey: "instagramPages") as? Data {
            let decoder = JSONDecoder()
            pages = try? decoder.decode([InstagramPage].self, from: data)                        
            initial = pages
        }
    }
    
    override func save() {
        super.save()
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(pages as! [InstagramPage]) {
            UserDefaults.standard.set(encoded, forKey: "instagramPages")
            initial = pages
        }
    }
    
    
    override func hasChanged() -> Bool {
        if (initial == nil) {
            return isInitialized()
        }
        
        return !(initial! as! [InstagramPage]).containsSameElements(as: (pages! as! [InstagramPage]))
    }       
}
