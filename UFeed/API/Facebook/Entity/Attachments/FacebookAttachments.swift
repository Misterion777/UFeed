//
//  FacebookAttachments.swift
//  UFeed
//
//  Created by Ilya on 4/29/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Mapper


class FacebookPhotoAttachment : PhotoAttachment {
    
    var url : String
    var height : Int
    var width: Int
    
    required init(map: Mapper) throws {
        try self.url = map.from("media.image.src")
        try self.height = map.from("media.image.height")
        try self.width = map.from("media.image.width")
    }
    
    init(url:String, height:Int, width:Int){
        self.url = url
        self.height = height
        self.width = width
    }
    
}
private func extractPhoto(object: Any?) throws -> PhotoAttachment? {
    guard let photo = object as? NSDictionary else {
        throw MapperError.convertibleError(value: object, type: String.self)
    }
    
    return VKAttachmentFactory.getPhoto(json: photo)
}

//
//class VKVideoAttachment : VideoAttachment {
//    var url: String
//    var title: String
//    var platform: String
//    var duration : Int
//
//    required init(map: Mapper) throws {
//        try self.url = map.from("player")
//        try self.title = map.from("title")
//        try self.platform = map.from("platform")
//        try self.duration = map.from("duration")
//    }
//}
