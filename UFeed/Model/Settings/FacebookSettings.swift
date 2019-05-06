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
        if (pagesId != nil) {
            pages = pagesId!.map{FacebookPage(id: $0)}
            initial = pages
        }
    }
    
    func save() {
        UserDefaults.standard.set(pages!.map{$0.id}, forKey: "facebookPages")
        initial = pages
    }
    
    func isInitialized() -> Bool {
        return pages != nil
    }
    
    func hasChanged() -> Bool {
        if (initial == nil){            
            return pages != nil && pages!.count != 0
        }
        
        return !(initial! as! [FacebookPage]).containsSameElements(as: (pages! as! [FacebookPage]))
    }
    
    
    func appendPage(page: Page) {
        if (pages == nil) {
            pages = [Page]()
        }
        if (!pages!.contains{$0.id == page.id}) {
            pages!.append(page)
        }
    }
    
    func removePage(by id: Int) {
        pages = pages?.filter {$0.id != id}
    }
}
