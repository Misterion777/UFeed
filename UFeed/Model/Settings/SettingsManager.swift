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
    private var generalSettings = GeneralSettings()
    
    private init(){
        socialSettings[.facebook] = FacebookSettings()
        socialSettings[.instagram] = InstagramSettings()
        socialSettings[.twitter] = TwitterSettings()
        socialSettings[.vk] = VkSettings()
    }
    
    func getSettings(for social: Social) -> Settings {
        return socialSettings[social]!
    }
    func getGeneralSettings() -> GeneralSettings {
        return generalSettings
    }
    
    func save(for social: Social) {
        socialSettings[social]!.save()
    }
    
    func setReloadable(reloadable : Reloadable ) {
        for (_,v) in socialSettings{
            v.reloadable = reloadable
        }
        generalSettings.reloadable = reloadable
    }
    
    func removeDeletedPages(posts: [Post]) -> [Post]{
        var filteredPosts = posts
        for (social, setting) in socialSettings {
            if (setting.isInitialized()) {                
                filteredPosts = filteredPosts.filter {
                    let element = $0
                    if (social == element.type){
                        return setting.pages!.contains {
                            $0.id == element.ownerPage!.id
                        }
                    }else {
                        return true
                    }
                }
            }            
        }
        return filteredPosts
    }
    
}
