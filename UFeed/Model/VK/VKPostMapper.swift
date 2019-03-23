//
//  VKPostMapper.swift
//  UFeed
//
//  Created by Admin on 22/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class VKPostMapper: NSObject {
    
    static func jsonArrayToPostsArray (_ jsonArray: [[String:Any]]) -> [VKPost?] {
        
        var posts : [VKPost?] = []
        for item in jsonArray {
            let nsItem =  item as NSDictionary
            posts.append(VKPost.from(nsItem))
        }
        
        return posts
    }

}
