//
//  VKPage.swift
//  UFeed
//
//  Created by Ilya on 5/6/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import Mapper

class VKPage : Page {
    var id: Int
    
    var photo: PhotoAttachment?
    
    var link: String
    
    var name: String
    
    required init(id: Int) {
        self.id = id
        link = ""
        name = ""
    }
    
    required init(map: Mapper) throws {
        id = try map.from("id")
        link = try map.from("screen_name")
        
        let publicName:String? = map.optionalFrom("name")
        
        if let publicName = publicName{
            name = publicName
        }
        else {
            let firstName : String = try map.from("first_name")
            let lastName : String = try map.from("last_name")
            name = "\(firstName) \(lastName)"
        }        
        let url : String = try map.from("photo_50")
        photo = VKPhotoAttachment(url: url, height: 50, width: 50)
    }
    
}

extension VKPage : Comparable {
    static func < (lhs: VKPage, rhs: VKPage) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func == (lhs: VKPage, rhs: VKPage) -> Bool {
        return lhs.id == rhs.id
    }
}

