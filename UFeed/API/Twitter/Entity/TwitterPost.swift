//
//  TwitterPost.swift
//  UFeed
//
//  Created by Ilya on 4/21/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import Mapper

class TwitterPost : Post {
    
    var id: Int
    
    var ownerId: Int
    
    var ownerPhoto: PhotoAttachment?
    
    var ownerName: String?
    
    var commentsCount: Int
    
    var likesCount: Int
    
    var repostsCount: Int
    
    var date: Date?
    
    var type: String
    
    var text: String?
    
    var attachments: [Attachment?]?
    
    required init(map: Mapper) throws {
        type = "tweet"
        try id = map.from("id")
        try ownerId = map.from("user.id")
        try ownerName = map.from("user.name")
        let photoUrl : String = try map.from("user.profile_image_url_https")
        ownerPhoto = TwitterPhotoAttachment(url: photoUrl, height: 50, width: 50)
        
//        try commentsCount = map.from("reply_count")
        commentsCount = 0
        try likesCount = map.from("favorite_count")
        try repostsCount = map.from("retweet_count")
        try date = map.from("created_at", transformation: extractDate)
        text = map.optionalFrom("text")
        
        attachments = map.optionalFrom("entities", transformation: extractAttachments)
    }

    private func extractDate(object: Any?) throws -> Date {
        guard let dateValue = object as? String else {
            throw MapperError.convertibleError(value: object, type: String.self)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        
        return dateFormatter.date(from: dateValue)!
    }
    
    private func extractAttachments(object: Any?) throws -> [Attachment?]? {
        guard let attachmentsJson = object as? [String:Any] else {
            throw MapperError.convertibleError(value: object, type: String.self)
        }
        
        var attachments = [Attachment?]()
        
        guard let media = attachmentsJson["media"] as? [[String:Any]] else {
            return attachments
        }
        
        for attach in media {
            let type = attach["type"] as! String
            let attachment = TwitterAttachmentFactory.getAttachment(json: attach, type: type)
            attachments.append(attachment)        
        }
        return attachments
        
    }
}



