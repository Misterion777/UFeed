//
//  Attachments.swift
//  UFeed
//
//  Created by Admin on 31/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import Mapper

class Attachment:Mappable {
    required init(map: Mapper) throws {
    }
}

class PhotoAttachment : Attachment {
    
    var url : String
    var height : Int
    var width: Int
    
    required init(map: Mapper) throws {
        try self.url = map.from("url")
        try self.height = map.from("height")
        try self.width = map.from("width")
        try super.init(map:map)
    }
    
}

class AudioAttachment : Attachment {
    var url: String
    var title: String
    var duration: Int
    var artist : String
    
    required init(map: Mapper) throws {
        try self.url = map.from("url")
        try self.title = map.from("title")
        try self.duration = map.from("duration")
        try self.artist = map.from("artist")
        try super.init(map:map)
    }
}

class LinkAttachment : Attachment {
    var url: String
    var title: String?
    var description: String?
    var photo : PhotoAttachment?
    
    required init(map: Mapper) throws {
        try self.url = map.from("url")
        try self.title = map.from("title")
        try self.description = map.from("description")
        self.photo = map.optionalFrom("photo", transformation: extractPhoto)
        
        try super.init(map:map)
        
    }
}
private func extractPhoto(object: Any?) throws -> PhotoAttachment? {
    guard let photo = object as? NSDictionary else {
        throw MapperError.convertibleError(value: object, type: String.self)
    }
    
    return AttachmentFactory.getPhoto(json: photo)
}

class FileAttachment : Attachment {
    var url: String
    var title: String
    var size: Int
    
    required init(map: Mapper) throws {
        try self.url = map.from("url")
        try self.title = map.from("title")
        try self.size = map.from("size")
        try super.init(map:map)
    }
}

