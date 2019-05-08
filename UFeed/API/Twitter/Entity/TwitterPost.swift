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
    
    var ownerPage: Page?
    
    var commentsCount: Int
    
    var likesCount: Int
    
    var repostsCount: Int
    
    var date: Date?
    
    var type: String
    
    var text: String?
    
    var attachments: [Attachment?]?
    
    required init(map: Mapper) throws {
        type = "twitter"
        try id = map.from("id")
        
//        try commentsCount = map.from("reply_count")
        commentsCount = 0
        try likesCount = map.from("favorite_count")
        try repostsCount = map.from("retweet_count")
        try date = map.from("created_at", transformation: extractDate)
        try ownerPage = map.from("user", transformation: extractOnwerPage)
        attachments = map.optionalFrom("entities", transformation: extractAttachments)
        text = map.optionalFrom("text")        
    }

    private func extractOnwerPage(object: Any?) throws -> Page {
        guard let userValue = object as? [String : Any] else {
            throw MapperError.convertibleError(value: object, type: String.self)
        }
        return TwitterPage.from(userValue as NSDictionary)!
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



