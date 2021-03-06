//
//  Post.swift
//  UFeed
//
//  Created by Ilya on 4/1/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Mapper

protocol Post : class, Mappable {
    var id : Int { get }
    
    var ownerPage : Page? {get set}
    
    var commentsCount : Int { get }
    var likesCount : Int { get }
    var repostsCount : Int { get }
    var date: Date? { get }
    
    var type: Social { get }
    var text: String? { get }
    
    var attachments : [Attachment?]? {get}
    
}
