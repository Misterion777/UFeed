//
//  TwitterPage.swift
//  UFeed
//
//  Created by Ilya on 5/6/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import Mapper

class TwitterPage : Page {
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
        name = try map.from("name")
        let url : String = try map.from("profile_image_url_https")
        photo = TwitterPhotoAttachment(url: url, height: 50, width: 50)        
    }
}

extension TwitterPage : Comparable {
    static func < (lhs: TwitterPage, rhs: TwitterPage) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func == (lhs: TwitterPage, rhs: TwitterPage) -> Bool {
        return lhs.id == rhs.id
    }
}

