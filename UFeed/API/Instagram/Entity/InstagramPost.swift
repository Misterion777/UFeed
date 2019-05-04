//
//  InstagramPost.swift
//  UFeed
//
//  Created by Ilya on 5/3/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import Mapper


class InstagramPost : Post {
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
        
        type = "instagram"
        
        let stringId : String = try map.from("id")
        id = Int(stringId)!
        ownerId = 0
        
        repostsCount = 0
        commentsCount = try map.from("comments_count")
        likesCount = try map.from("like_count")
        
        text = map.optionalFrom("caption")
        
        try attachments = extractAttachments(map: map)
        try date = map.from("timestamp", transformation: extractDate)
    }
    
    private func extractAttachments(map: Mapper) throws -> [Attachment?]?{
        
        var attachments = [Attachment?]()
        
        let type : String = try map.from("media_type")
        
        if (type == "CAROUSEL_ALBUM") {
            let children = (try map.from("children.data", transformation: extractChildren))!
            attachments.append(contentsOf: children)
        }
        else {
            let url : String = try map.from("media_url")
            attachments.append(InstagramPhotoAttachment(url: url, height: 0, width: 0))
        }
        return attachments
    }
    
    private func extractDate(object: Any?) throws -> Date {
        guard let dateValue = object as? String else {
            throw MapperError.convertibleError(value: object, type: String.self)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        
        return dateFormatter.date(from: dateValue)!
    }
    
    private func extractChildren(object: Any?) throws -> [Attachment?]? {
        guard let attachmentData = object as? [[String:Any]] else {
            throw MapperError.convertibleError(value: object, type: String.self)
        }
        
        var attachments = [Attachment?]()
        
        for attachmentDatum in attachmentData {
            attachments.append(InstagramPhotoAttachment(url: attachmentDatum["media_url"] as! String, height: 0, width: 0))
        }
        
        return attachments
    }
    
}
