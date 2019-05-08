//
//  VkSettings.swift
//  UFeed
//
//  Created by Ilya on 5/6/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class VkSettings : Settings {
    
    override init() {
        super.init()
        let pagesId = UserDefaults.standard.array(forKey: "vkPages") as? [Int]
        if (pagesId != nil) {
            pages = pagesId!.map{VKPage(id: $0)}
            initial = pages
        }
    }
    
    override func save() {
        super.save()
        UserDefaults.standard.set(pages!.map{$0.id}, forKey: "vkPages")
        initial = pages
    }
    
    
    override func hasChanged() -> Bool {
        if (initial == nil){
            return pages != nil && pages!.count != 0
        }
        
        return !(initial! as! [VKPage]).containsSameElements(as: (pages! as! [VKPage]))
    }
    
    
}


