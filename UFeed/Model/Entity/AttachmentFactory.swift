//
//  AttachmentFactory.swift
//  UFeed
//
//  Created by Ilya on 4/1/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

protocol AttachmentFactory {
    static func getAttachment(json : [String:Any], type: String) -> Attachment?
    
}
