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
    let date: NSDate
    let text: String?
    
    
    init(map: Mapper) throws {
        try id = map.from("post_id")
        try type = map.from("type")
        try date = map.from("date", transformation: extractDate)
        text = map.optionalFrom("text")
    }
    
}

private func extractDate(object: Any?) throws -> NSDate {
    guard let date = object as? String else {
        throw MapperError.convertibleError(value: object, type: String.self)
    }
    
    return NSDate(timeIntervalSince1970: Double(date)!)
    
}
