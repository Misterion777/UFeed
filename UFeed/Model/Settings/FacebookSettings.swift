//
//  FacebookSettings.swift
//  UFeed
//
//  Created by Ilya on 4/30/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class FacebookSettings : Settings {
            
    private var initial : [Page]?
    var pages: [Page]?
    
    init() {
        let pagesId = UserDefaults.standard.array(forKey: "facebookPages") as? [Int]
        pages = pagesId!.map{FacebookPage(id: $0)}
        initial = pages
    }
    
    func save() {
        UserDefaults.standard.set(pages!.map{$0.id}, forKey: "facebookPages")
        initial = pages
    }
    
    func isInitialized() -> Bool {
        return pages != nil
    }
    
    func hasChanged() -> Bool {
        return !(initial! as! [FacebookPage]).containsSameElements(as: (pages! as! [FacebookPage]))
    }
    
    
    func appendPage(page: Page) {
        if (pages == nil) {
            pages = [Page]()
        }
        pages?.append(page)
    }
    
    func removePage(at index: Int) {
        pages?.remove(at: index)
    }
}
