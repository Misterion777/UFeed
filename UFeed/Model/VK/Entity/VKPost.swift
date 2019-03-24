//
//  VKPost.swift
//  UFeed
//
//  Created by Ilya on 3/22/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import Mapper

enum AttachmentType {
    case photo, audio, video, doc, link, graffiti, note,poll,page, album, market, market_album, sticker, pretty_cards

}

struct VKPost : Mappable {
    let id : Int
    let ownerId : Int
    
    let commentsCount : Int
    let likesCount : Int
    let repostsCount : Int
    let date: Date
    
    let type: String
    let text: String?
    
    
    
    init(map: Mapper) throws {
        
        try id = map.from("post_id")
        try ownerId = map.from("source_id")
        try commentsCount = map.from("comments.count")
        try likesCount = map.from("likes.count")
        try repostsCount = map.from("reposts.count")
        try type = map.from("type")
        try date = map.from("date", transformation: extractDate)
        text = map.optionalFrom("text")
        
    }
    
}

private func extractDate(object: Any?) throws -> Date {
    guard let dateValue = object as? Double else {
        throw MapperError.convertibleError(value: object, type: String.self)
    }
    
    return Date(timeIntervalSince1970: dateValue)
}
