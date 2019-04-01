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
        
        try id = map.from("post_id")
        try ownerId = map.from("source_id")
        
        try commentsCount = map.from("comments.count")
        try likesCount = map.from("likes.count")
        try repostsCount = map.from("reposts.count")
        try type = map.from("type")
        try date = map.from("date", transformation: extractDate)
        text = map.optionalFrom("text")
        attachments = map.optionalFrom("attachments", transformation: extractAttachments)
        
        VKApiWorker.getPageInfo(pageId: ownerId, onResponse: setOwnerInfo)
    }
    
    private func setOwnerInfo(pageInfo: [String:Any]){
        
        var pageName : String?
        var photo : PhotoAttachment?
        
        if let name = pageInfo["name"] as? String {
            pageName = name
        }
        else if let first_name = pageInfo["first_name"] as? String,
            let last_name = pageInfo["last_name"] as? String {
            pageName = first_name + " " + last_name
        }
        
        if let photoUrl = pageInfo["photo_50"] as? String {
            photo = VKPhotoAttachment(url: photoUrl, height: 50, width: 50)
        }
        
        self.ownerPhoto = photo
        self.ownerName = pageName
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








