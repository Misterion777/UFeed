//
//  AttachmentFactory.swift
//  UFeed
//
//  Created by Admin on 31/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class VKAttachmentFactory :AttachmentFactory {
    
    static func getAttachment(json : [String:Any], type: String) -> Attachment?{
        
        guard let attach = json[type] as? NSDictionary else {
            print("No such type!")
            return nil
        }
        
        switch type {
        case "photo":
            return getPhoto(json: attach)
        case "audio":
            return VKAudioAttachment.from(attach)
        case "link":
            return VKLinkAttachment.from(attach)
        case "doc":
            return VKFileAttachment.from(attach)
        case  "video":
            return VKVideoAttachment.from(attach)
        default:
            print("\(type) parsing is not implemented!")
            return nil
        }
    }
    
    static func getPhoto(json : NSDictionary) -> VKPhotoAttachment?{
        let photoSizes = json["sizes"] as! [NSDictionary]
        
        let lastSize = photoSizes[photoSizes.count-1]
        
        return VKPhotoAttachment.from(lastSize)
    }
}

