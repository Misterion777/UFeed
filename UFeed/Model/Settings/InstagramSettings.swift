//
//  InstagramSettings.swift
//  UFeed
//
//  Created by Ilya on 4/30/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class InstagramSettings : Settings {
    private var initial : [Page]?
    var pages: [Page]?    
    
    init() {
        initial = [Page]()
        if let data = UserDefaults.standard.object(forKey: "instagramPages") as? Data {
            let decoder = JSONDecoder()
            pages = try? decoder.decode([InstagramPage].self, from: data)
            
            
            initial = pages
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(pages as! [InstagramPage]) {
            UserDefaults.standard.set(encoded, forKey: "instagramPages")
            initial = pages
        }
    }
    
    func isInitialized() -> Bool {
        return pages != nil
    }
    
    func hasChanged() -> Bool {
        if (initial == nil) {
            return pages != nil
        }
        
        return !(initial! as! [InstagramPage]).containsSameElements(as: (pages! as! [InstagramPage]))
    }
    
    func appendPage(page: Page) {
        if (pages == nil) {
            pages = [InstagramPage]()
        }
        pages!.append(page)
    }
    
    func removePage(at index: Int) {
        
        pages?.remove(at: index)
    }
    
}
