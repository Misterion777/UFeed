//
//  Attachment.swift
//  UFeed
//
//  Created by Ilya on 4/1/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Mapper


protocol Attachment : Mappable {    
}

protocol PhotoAttachment : Attachment {
    var url : String { get }
    var height : Int { get }
    var width: Int { get }
}

protocol AudioAttachment : Attachment {
    var url: String { get }
    var title: String { get }
    var duration: Int { get }
    var artist : String { get }
}

protocol LinkAttachment : Attachment {
    var url: String { get }
    var title: String? { get }
    var description: String? { get }
    var photo : PhotoAttachment? { get }
}

protocol FileAttachment : Attachment {
    var url: String { get }
    var title: String { get }
    var size: Int { get }        
}

protocol VideoAttachment : Attachment {
    var url: String { get }
    var title: String { get }
    var platform: String {get}
    var duration : Int {get}
}
