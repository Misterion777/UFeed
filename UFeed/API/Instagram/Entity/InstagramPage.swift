//
//  InstagramPage.swift
//  UFeed
//
//  Created by Ilya on 5/2/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Mapper

class InstagramPage: Page, Decodable{
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case link
        case name
        case photoUrl
        case photoWidth
        case photoHeight
    }
    
    var id: Int
    
    var photo: PhotoAttachment?
    
    var link: String
    
    var name: String
    
    var nextFrom : String?
    
    required init(map: Mapper) throws {
        let stringId : String = try map.from("id")
        id = Int(stringId)!
        try name = map.from("name")
        let url : String = try map.from("profile_picture_url")
        try link = map.from("username")
        photo = InstagramPhotoAttachment(url: url, height: 50, width: 50)        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        link = try values.decode(String.self, forKey: .link)
        let url = try values.decode(String.self, forKey: .photoUrl)
        let width = try values.decode(Int.self, forKey: .photoWidth)
        let height = try values.decode(Int.self, forKey: .photoHeight)
        photo = InstagramPhotoAttachment(url: url, height: height, width: width)
    }
    
    required init(id: Int) {
        self.id = id
        self.link = ""
        self.name = ""
    }
}
extension InstagramPage : Comparable {
    static func < (lhs: InstagramPage, rhs: InstagramPage) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func == (lhs: InstagramPage, rhs: InstagramPage) -> Bool {
        return lhs.id == rhs.id
    }
}

extension InstagramPage : Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(link, forKey: .link)
        try container.encode(name, forKey: .name)
        try container.encode(photo!.url, forKey: .photoUrl)
        try container.encode(photo!.width, forKey: .photoWidth)
        try container.encode(photo!.height, forKey: .photoHeight)
    }
}

