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
    var id : Int
    var url : String
    var height : Int
    var width: Int
    
    required init(map: Mapper) throws {
        try self.id = map.from("id")
        try self.url = map.from("media_url_https")
        try self.height = map.from("sizes.large.h")
        try self.width = map.from("sizes.large.w")
    }
    
    init(url:String, height:Int, width:Int){
        id = 0
        self.url = url
        self.height = height
        self.width = width
    }
}

class TwitterVideoAttachment : VideoAttachment {
    var id : Int
    var url: String?
    var platform: String
    
    var thumbnail: PhotoAttachment
        
    var duration : Int
    
    required init(map: Mapper) throws {
        try self.id = map.from("id")
        platform = "file"
        thumbnail = try TwitterPhotoAttachment.init(map: map)
        
        let info : NSDictionary? = map.optionalFrom("video_info")
        if (info == nil) {
            platform = "web"
            url = try map.from("expanded_url")
            duration = 0
        }
        else {
            duration = try map.from("video_info.duration_millis")
            url = try map.from("video_info.variants", transformation: extractUrl)
        }
    }
    private func extractUrl(object: Any?) throws -> String {
        guard let variants = object as? [[String : Any]] else {
            throw MapperError.convertibleError(value: object, type: String.self)
        }
        
        var url :String?
        var webUrl:String?
        var highestBitrate = 0
        for variant in variants {
            if let bitrate = variant["bitrate"] as? Int {
                if (bitrate > highestBitrate){
                    highestBitrate = bitrate
                    url = variant["url"] as? String
                }
            }
            else {
                webUrl = variant["url"] as? String
            }
        }
        if (highestBitrate == 0){
            self.platform = "web"
            return webUrl!
        }
        else {
            return url!
        }
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

//
