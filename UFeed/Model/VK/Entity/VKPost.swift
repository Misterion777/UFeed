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
    let id : String
    let type: String
    let text: String
    let date: NSDate
    
    
    init(map: Mapper) throws {
        try id = map.from("post_id")
        try type = map.from("type")
        try text = map.from("text")
        try date = map.from("date", transformation: extractDate)
    }
    
}

private func extractDate(object: Any?) throws -> NSDate {
    guard let date = object as? String else {
        throw MapperError.convertibleError(value: object, type: String.self)
    }
    
    return NSDate(timeIntervalSince1970: Double(date)!)
    
}
