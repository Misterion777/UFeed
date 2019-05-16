//
//  FacebookPost.swift
//  UFeed
//
//  Created by Ilya on 4/29/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import Mapper

class FacebookPost : Post {
    
    var id: Int
    
    var ownerPage: Page?
    
    var commentsCount: Int
    
    var likesCount: Int
    
    var repostsCount: Int
    
    var date: Date?
    
    var type: Social
    
    var text: String?
    
    var attachments: [Attachment?]?
    
    required init(map: Mapper) throws {
        type = .facebook
        
        let joinedId : String = try map.from("id")
        let splitted = joinedId.components(separatedBy: "_")
        id = Int(splitted[1])!        
        
        let shares : Int? = map.optionalFrom("shares.count")
        repostsCount = shares != nil ? shares! : 0
        commentsCount = try map.from("comments.summary.total_count")
        likesCount = try map.from("likes.summary.total_count")
        
        text = map.optionalFrom("message")
        attachments = map.optionalFrom("attachments.data", transformation: extractAttachments)
        try date = map.from("created_time", transformation: extractDate)        
    }
    
    private func extractDate(object: Any?) throws -> Date {
        guard let dateValue = object as? String else {
            throw MapperError.convertibleError(value: object, type: String.self)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        
        return dateFormatter.date(from: dateValue)!
    }
    
    private func extractAttachments(object: Any?) throws -> [Attachment?]? {
        guard let attachmentData = object as? [[String:Any]] else {
            throw MapperError.convertibleError(value: object, type: String.self)
        }
        
        var attachments = [Attachment?]()
        
        for attachmentDatum in attachmentData {
            if let subattachments = attachmentDatum["subattachments"] as? [String:Any]  {
                if let data = subattachments["data"] as? [[String : Any]] {
                    for datum in data {
                        let type = datum["type"] as! String
                        let attachment = FacebookAttachmentFactory.getAttachment(json: datum, type: type)
                        attachments.append(attachment)
                    }
                    
                }
            } else {
                let type = attachmentDatum["type"] as! String
                let attachment = FacebookAttachmentFactory.getAttachment(json: attachmentDatum, type: type)
                attachments.append(attachment)
            }
        }
        
        return attachments
    }
    
}
