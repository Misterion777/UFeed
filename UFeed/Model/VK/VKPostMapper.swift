//
//  VKPostMapper.swift
//  UFeed
//
//  Created by Admin on 22/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class VKPostMapper: NSObject {
    
    static func jsonArrayToPostsArray (_ jsonArray: [[String:Any]]) -> [VKPost]? {
        
//        var posts : [VKPost?] = []
//        for item in jsonArray {
//            let nsItem =  item as NSDictionary
//            print(String(describing: nsItem["post_id"]!)  )
//            print(nsItem)
//
//            posts.append(VKPost.from(item as NSDictionary))
//        }
//

        print(jsonArray[0])
        let posts = VKPost.from(jsonArray as NSArray)
        
        return posts
    }

}
