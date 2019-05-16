
//
//  GeneralSettings.swift
//  UFeed
//
//  Created by Ilya on 5/16/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class GeneralSettings : Settings  {
    enum GeneralKeys : String, CaseIterable {
        case feedSortedByDate = "feedSortedByDate"
    }
    var boolSettings = [GeneralKeys:Bool]()
    var initBoolSettings = [GeneralKeys:Bool]()
    
    override init() {
        super.init()
        boolSettings[.feedSortedByDate] = UserDefaults.standard.bool(forKey: GeneralKeys.feedSortedByDate.rawValue)
        initBoolSettings = boolSettings
    }
    
    override func save(){
        super.save()
        for (k,v) in boolSettings {
            UserDefaults.standard.set(v, forKey: k.rawValue)
        }
    }
    
    func set(key: GeneralKeys, value: Bool) {
        boolSettings[key] = value
    }
    
    func get(key: GeneralKeys) -> Bool{
        return boolSettings[key]!
    }
    
    override func hasChanged() -> Bool {
        return initBoolSettings != boolSettings
    }
}
