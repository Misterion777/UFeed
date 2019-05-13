//
//  Attachments.swift
//  UFeed
//
//  Created by Admin on 31/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import Mapper

//class Attachment:Mappable {
//    required init(map: Mapper) throws {
//    }
//}

class VKPhotoAttachment : PhotoAttachment {
    
    var url : String
    var height : Int
    var width: Int
    
    required init(map: Mapper) throws {
        try self.url = map.from("url")
        try self.height = map.from("height")
        try self.width = map.from("width")
    }
    
    init(url:String, height:Int, width:Int){
        self.url = url
        self.height = height
        self.width = width
    }
    
}

class VKAudioAttachment : AudioAttachment {
    var url: String
    var title: String
    var duration: Int
    var artist : String
    
    required init(map: Mapper) throws {
        try self.url = map.from("url")
        try self.title = map.from("title")
        try self.duration = map.from("duration")
        try self.artist = map.from("artist")       
    }
}

class VKLinkAttachment : LinkAttachment {
    var url: String
    var title: String?
    var description: String?
    var photo : PhotoAttachment?
    
    required init(map: Mapper) throws {
        try self.url = map.from("url")
        try self.title = map.from("title")
        try self.description = map.from("description")
        self.photo = map.optionalFrom("photo", transformation: extractPhoto)
        
    }
}
private func extractPhoto(object: Any?) throws -> PhotoAttachment? {
    guard let photo = object as? NSDictionary else {
        throw MapperError.convertibleError(value: object, type: String.self)
    }
    
    return VKAttachmentFactory.getPhoto(json: photo)
}

class VKFileAttachment : FileAttachment {
    var url: String
    var title: String
    var size: Int
    
    required init(map: Mapper) throws {
        try self.url = map.from("url")
        try self.title = map.from("title")
        try self.size = map.from("size")
    }
}

class VKVideoAttachment : VideoAttachment {
    var url: String?
    var platform: String
    var duration : Int
    var thumbnail: PhotoAttachment
    
    required init(map: Mapper) throws {
        platform = "web"
        try self.duration = map.from("duration")
        let photo800 :String? = map.optionalFrom("photo_800")
        if let photo = photo800 {
            thumbnail = VKPhotoAttachment(url: photo, height: 450, width: 800)
        }
        else {
            let photo640 :String? = map.optionalFrom("photo_640")
            if let photo = photo640 {
                thumbnail = VKPhotoAttachment(url: photo, height: 480, width: 640)
            }
            else {
                let photo320 :String = try map.from("photo_640")
                thumbnail = VKPhotoAttachment(url: photo320, height: 240, width: 320)
            }
        }
        self.url = map.optionalFrom("player")
        if (url == nil) {
            let id :Int = try map.from("id")
            let ownerId : Int = try map.from("owner_id")
            getVideoUrl(by: ownerId, id)
        }
    }
    
    
    func getVideoUrl(by ownerId : Int, _ videoId : Int){
        let client = SocialManager.shared.getApiClient(forSocial: .vk) as! VKApiClient
        client.fetchVideo(by: ownerId, videoId) { result in
            switch result {
            case .success(let url):
                self.url = url
            case .failure(let error):
                print(error)
                self.url = nil
            }
        }
    }
}
