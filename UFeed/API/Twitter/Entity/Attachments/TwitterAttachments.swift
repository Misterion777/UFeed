//
//  Attachments.swift
//  UFeed
//
//  Created by Admin on 22/04/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import Mapper

class TwitterPhotoAttachment : PhotoAttachment {
    
    var url : String
    var height : Int
    var width: Int
    
    required init(map: Mapper) throws {
        try self.url = map.from("media_url_https")
        try self.height = map.from("sizes.large.h")
        try self.width = map.from("sizes.large.w")
    }
    
    init(url:String, height:Int, width:Int){
        self.url = url
        self.height = height
        self.width = width
    }
    
}

//class TwitterLinkAttachment : LinkAttachment {
//    var url: String
//    var title: String?
//    var description: String?
//    var photo : PhotoAttachment?
//    
//    required init(map: Mapper) throws {
//        try self.url = map.from("url")
//        try self.title = map.from("title")
//        try self.description = map.from("description")
//        self.photo = map.optionalFrom("photo", transformation: extractPhoto)
//        
//    }
//}
//private func extractPhoto(object: Any?) throws -> PhotoAttachment? {
//    guard let photo = object as? NSDictionary else {
//        throw MapperError.convertibleError(value: object, type: String.self)
//    }
//    
//    return VKAttachmentFactory.getPhoto(json: photo)
//}


class TwitterVideoAttachment : VideoAttachment {
    var url: String
    var title: String
    var platform: String
    var duration : Int
    
    required init(map: Mapper) throws {
        try self.url = map.from("player")
        try self.title = map.from("title")
        try self.platform = map.from("platform")
        try self.duration = map.from("duration")
    }
}
