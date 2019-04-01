//
//  VKPost.swift
//  UFeed
//
//  Created by Ilya on 3/22/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

import Mapper

struct VKPost : Mappable {
    let id : Int
    let ownerId : Int
    
    let commentsCount : Int
    let likesCount : Int
    let repostsCount : Int
    let date: Date
    
    let type: String
    let text: String?
    
    let attachments : [Attachment?]?
    
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


private func extractAttachments(object: Any?) throws -> [Attachment?]? {
    guard let attachmentsJson = object as? [[String:Any]] else {
        throw MapperError.convertibleError(value: object, type: String.self)
    }
    
    var attachments = [Attachment?]()
    
    for attach in attachmentsJson {
        let type = attach["type"] as! String
        let attachment = AttachmentFactory.getAttachment(json: attach, type: type)
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


