//
//  FacebookPage.swift
//  UFeed
//
//  Created by Ilya on 4/29/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Mapper

class FacebookPage: Page {
    
    var id: Int
    
    var photo: PhotoAttachment?
    
    var link: String
    
    var name: String
    
    required init(map: Mapper) throws {
        let stringId : String = try map.from("id")
        id = Int(stringId)!
        try name = map.from("name")
        try link = map.from("link")
        
        let photoUrl : String = try map.from("picture.data.url")
        let photoWidth : Int = try map.from("picture.data.width")
        let photoHeight : Int = try map.from("picture.data.height")
        photo = FacebookPhotoAttachment(url: photoUrl, height: photoHeight, width: photoWidth)
    }    

//    static func == (lhs: FacebookPage, rhs: FacebookPage) -> Bool {
//        return lhs.id == rhs.id
//    }
//    
    
    
}
