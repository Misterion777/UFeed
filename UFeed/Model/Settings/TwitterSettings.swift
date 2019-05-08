//
//  TwitterSettings.swift
//  UFeed
//
//  Created by Ilya on 5/6/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class TwitterSettings : Settings {
    
    override init() {
        super.init()
        let pagesId = UserDefaults.standard.array(forKey: "twitterPages") as? [Int]
        if (pagesId != nil) {
            pages = pagesId!.map{TwitterPage(id: $0)}
            initial = pages
        }
    }
    
    override func save() {
        super.save()
        UserDefaults.standard.set(pages!.map{$0.id}, forKey: "twitterPages")
        initial = pages
    }
    
    
    override func hasChanged() -> Bool {
        if (initial == nil){
            return pages != nil && pages!.count != 0
        }
        
        return !(initial! as! [TwitterPage]).containsSameElements(as: (pages! as! [TwitterPage]))
    }
    
    
}
