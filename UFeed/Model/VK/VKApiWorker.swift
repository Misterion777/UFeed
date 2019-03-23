//
//  VKApiWorker.swift
//  UFeed
//
//  Created by Ilya on 3/22/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import VK_ios_sdk

class VKApiWorker {
    
    static func getNewsFeed() {
        let getFeed = VKRequest(method: "newsfeed.get", parameters:["filters": "post,wall_photo", "count": 1])
        
        getFeed?.execute(resultBlock: { response in
            
            if let jsonResponse = response?.json {

                if let dictionary = jsonResponse as? [String:Any] {
                    
                    if let items = dictionary["items"] as? [[String:Any]]{
                        print(items)
                        VKPostMapper.jsonArrayToPostsArray(items)
                    }
                }
            }
            
        }, errorBlock: { error in
            if error != nil {
                print("Error! \(error)")
            }
        })
    }
    
}
