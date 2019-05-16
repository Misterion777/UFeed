//
//  VKPost.swift
//  UFeed
//
//  Created by Ilya on 3/22/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

import Mapper

class VKPost : Post {
    
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
        type = .vk
        
        try id = map.from("post_id")
        let ownerId : Int = try map.from("source_id")
        ownerPage = VKPage(id: ownerId)
        
        try commentsCount = map.from("comments.count")
        try likesCount = map.from("likes.count")
        try repostsCount = map.from("reposts.count")
        
        try date = map.from("date", transformation: extractDate)
        text = map.optionalFrom("text")
        let copyHistory = map.optionalFrom("copy_history", transformation: extractHistoryAttachments)
        attachments = map.optionalFrom("attachments", transformation: extractAttachments)
        if (copyHistory != nil) {
            if (attachments == nil) {
                attachments = copyHistory!
            }
            else {
                attachments!.append(contentsOf: copyHistory!)
            }
            
        }        
//        VKApiWorker.getPageInfo(pageId: ownerId, onResponse: setOwnerInfo)
    }

    private func extractHistoryAttachments(object: Any?) throws -> [Attachment?]? {
        guard let historyJson = object as? [[String:Any]] else {
            throw MapperError.convertibleError(value: object, type: String.self)
        }
        var attachments = [Attachment?]()
        for history in historyJson {
            attachments.append(contentsOf: try extractAttachments(object: history["attachments"])!)
        }
        return attachments
    }
    
    
    private func extractAttachments(object: Any?) throws -> [Attachment?]? {
        guard let attachmentsJson = object as? [[String:Any]] else {
            throw MapperError.convertibleError(value: object, type: String.self)
        }
        
        var attachments = [Attachment?]()
        
        for attach in attachmentsJson {
            let type = attach["type"] as! String
            let attachment = VKAttachmentFactory.getAttachment(json: attach, type: type)
            attachments.append(attachment)
            
        }
        return attachments
        
    }
    private func extractDate(object: Any?) throws -> Date {
        guard let dateValue = object as? Double else {
            throw MapperError.convertibleError(value: object, type: String.self)
        }
        
        return Date(timeIntervalSince1970: dateValue)
    }

}








