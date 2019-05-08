//
//  FacebookSettings.swift
//  UFeed
//
//  Created by Ilya on 4/30/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class FacebookSettings : Settings {
    
    override init() {
        super.init()
        let pagesId = UserDefaults.standard.array(forKey: "facebookPages") as? [Int]
        if (pagesId != nil) {
            pages = pagesId!.map{FacebookPage(id: $0)}
            initial = pages
        }
    }
    
    override func save() {
        super.save()
        UserDefaults.standard.set(pages!.map{$0.id}, forKey: "facebookPages")
        initial = pages
    }
    
    
    override func hasChanged() -> Bool {
        if (initial == nil){            
            return pages != nil && pages!.count != 0
        }
        
        return !(initial! as! [FacebookPage]).containsSameElements(as: (pages! as! [FacebookPage]))
    }
}
