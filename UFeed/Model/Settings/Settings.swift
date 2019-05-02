//
//  Settings.swift
//  UFeed
//
//  Created by Ilya on 4/30/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

protocol Settings {
    
    var pagesId : [Int]? {get set}
 
    func save()
    func isInitialized() -> Bool    
    func hasChanged() -> Bool
}
