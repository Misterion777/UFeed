//
//  Settings.swift
//  UFeed
//
//  Created by Ilya on 4/30/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

protocol Settings {
    //CHANGE TO SET
    var pages : [Page]? {get set}
 
    func save()
    func isInitialized() -> Bool    
    func hasChanged() -> Bool
    func appendPage(page: Page)
    func removePage(by id:Int)
}
