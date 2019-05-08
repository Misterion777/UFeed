//
//  Settings.swift
//  UFeed
//
//  Created by Ilya on 4/30/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

protocol Reloadable {
    func settingsDidSaved()
}

class Settings {
    //CHANGE TO SET
    var pages : [Page]?
    var initial : [Page]?
    var reloadable : Reloadable?
    
    func save() {
        reloadable!.settingsDidSaved()
    }
    
    func isInitialized() -> Bool {
        return pages != nil
    }
    
    func hasChanged() -> Bool {
        return false
    }
    
    func appendPage(page: Page) {
        if (pages == nil) {
            pages = [Page]()
        }
        if (!pages!.contains{$0.id == page.id}) {
            pages!.append(page)
        }
    }
    func removePage(by id:Int) {
        pages = pages?.filter {$0.id != id}
    }
}
