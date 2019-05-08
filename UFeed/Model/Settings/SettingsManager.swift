//
//  SettingsManager.swift
//  UFeed
//
//  Created by Ilya on 4/30/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class SettingsManager {
    
    static let shared = SettingsManager()
    
    private var socialSettings = [Social : Settings]()
    
    private init(){
        socialSettings[.facebook] = FacebookSettings()
        socialSettings[.instagram] = InstagramSettings()
        socialSettings[.twitter] = TwitterSettings()
        socialSettings[.vk] = VkSettings()
    }
    
    func getSettings(for social: Social) ->Settings {
        return socialSettings[social]!
    }
    
    func save(for social: Social) {
        socialSettings[social]!.save()
    }
    
    func setReloadable(reloadable : Reloadable ) {
        for (_,v) in socialSettings{
            v.reloadable = reloadable
        }
    }
    
//    func getSavedPagesId(for social: Social) -> [Int]?{
//        return socialSettings[social]!.pages
//    }
//    
//    func setPagesId(for social: Social, pagesId : [Int]) {
//        socialSettings[social]!.pagesId = pagesId
//    }
    
}
