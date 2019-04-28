//
//  TwitterAttachmentFactory.swift
//  UFeed
//
//  Created by Ilya on 4/22/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class TwitterAttachmentFactory: AttachmentFactory {
    
    static func getAttachment(json : [String:Any], type: String) -> Attachment?{
        
        switch type {
        case "photo":
            return TwitterPhotoAttachment.from(json as NSDictionary)
//        case "link":
//            return TwitterLinkAttachment.from(attach)
//        case  "video":
//                return 1
        default:
            print("\(type) parsing is not implemented!")
            return nil
        }
    }
    
//    static func getPhoto(json : NSDictionary) -> TwitterPhotoAttachment?{
//        let url = json["media_url_https"] as! String
//
//        let photoSizes = json["sizes"] as! [[String:Any]]
//
//        let lastSize = photoSizes["large"] as! [String:Any]
//
//
//        return TwitterPhotoAttachment.from(lastSize)
//    }
    

}
