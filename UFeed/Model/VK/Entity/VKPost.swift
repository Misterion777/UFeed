//
//  VKPost.swift
//  UFeed
//
//  Created by Ilya on 3/22/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

import Mapper

enum AttachmentType {
    case photo, audio, video, doc, link, graffiti, note,poll,page, album, market, market_album, sticker, pretty_cards

}

class Attachment:Mappable {
    required init(map: Mapper) throws {
    }
}

class PhotoAttachment : Attachment {
    var url : String?
    var height : Int?
    var width: Int?
    
//    init(url: String, height: Int, width: Int) {
//        self.url = url
//        self.height = height
//        self.width = width
//    }
    required init(map: Mapper) throws {
        try self.url = map.from("url")
        try self.height = map.from("height")
        try self.width = map.from("width")
        
    }
}

class AudioAttachment : Attachment {
    var url: String?
    var title: String?
    var duration: Int?
    var artist : String?
    
    init(url: String, title: String, duration: Int, artist: String) {
        self.url = url
        self.title = title
        self.duration = duration
        self.artist = artist
    }
    override init(){
        
    }
}

class LinkAttachment : Attachment {
    var url: String?
    var title: String?
    var description: String?
    var photo : PhotoAttachment?
    
    init(url: String, title: String, description: String, photo: PhotoAttachment?) {
        self.url = url
        self.title = title
        self.description = description
        self.photo = photo
    }
    override init(){
        
    }
}


class FileAttachment : Attachment {
    var url: String?
    var title: String?
    var size: Int?
    
    init(url: String, title: String, size: Int) {
        self.url = url
        self.title = title
        self.size = size
    }
    override init(){
        
    }
}



struct VKPost : Mappable {
    let id : Int
    let ownerId : Int
    
    let commentsCount : Int
    let likesCount : Int
    let repostsCount : Int
    let date: Date
    
    let type: String
    let text: String?
    
    let attachments : [Attachment]?
    
    init(map: Mapper) throws {
        
        try id = map.from("post_id")
        try ownerId = map.from("source_id")
        try commentsCount = map.from("comments.count")
        try likesCount = map.from("likes.count")
        try repostsCount = map.from("reposts.count")
        try type = map.from("type")
        try date = map.from("date", transformation: extractDate)
        text = map.optionalFrom("text")
        attachments = map.optionalFrom("attachments", transformation: extractAttachments)
    }
}


private func extractAttachments(object: Any?) throws -> [Attachment]? {
    guard let attachments = object as? [[String:Any]] else {
        throw MapperError.convertibleError(value: object, type: String.self)
    }
    
    for attach in attachments {
        let type = attach["type"] as! String
        
        switch type {
        case "photo":
            
            attachObj = PhotoAttachment()
            
        case "audio":
            attachObj = AudioAttachment()
        case "link":
            attachObj = LinkAttachment()
        case "doc":
            attachObj = FileAttachment()
        
        default:
            attachObj = Attachment()
        }
        
    }
    return [Attachment]()

}

private func extractDate(object: Any?) throws -> Date {
    guard let dateValue = object as? Double else {
        throw MapperError.convertibleError(value: object, type: String.self)
    }
    
    return Date(timeIntervalSince1970: dateValue)
}


