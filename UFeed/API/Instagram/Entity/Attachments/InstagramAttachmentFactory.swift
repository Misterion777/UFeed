//
//  InstagramAttachmentFactory.swift
//  UFeed
//
//  Created by Ilya on 5/3/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class InstagramAttachmentFactory : AttachmentFactory {
    
    static func getAttachment(json: [String : Any], type: String) -> Attachment? {
        
        switch type {
        case "IMAGE":
            return InstagramPhotoAttachment.from(json as NSDictionary)
        case "VIDEO":
            return InstagramVideoAttachment.from(json as NSDictionary)        
        default:
            print("\(type) parsing is not implemented!")
            return nil
        }
    }
}
