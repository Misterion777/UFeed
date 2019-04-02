//
//  VKApiWorker.swift
//  UFeed
//
//  Created by Ilya on 3/22/19.
//  Copyright © 2019 Admin. All rights reserved.

import Foundation
import VK_ios_sdk

class VKApiWorker {
    
    static let feedSize = 10
    
    static func getNewsFeed(onResponse: @escaping ([[String:Any]])-> Void) {
        let getFeed = VKRequest(method: "newsfeed.get", parameters:["filters": "post", "count": feedSize])
        
        getFeed?.execute(resultBlock: { response in
            
            if let jsonResponse = response?.json {

                if let dictionary = jsonResponse as? [String:Any] {
                    
                    if let items = dictionary["items"] as? [[String:Any]]{
                        
                        onResponse(items)
//                        VKPostMapper.jsonArrayToPostsArray(items)
                    }
                }
            }
            
        }, errorBlock: { error in
            if error != nil {
                print("Error! \(error)")
            }
        })
    }
    
    static func getOwnerInfo(post: Post, onResponse: @escaping ([String:Any], Post)->Void ) {
        
        var getInfo : VKRequest
        if (post.ownerId < 0) {
            getInfo = VKRequest(method:"groups.getById", parameters: ["group_id" : abs(post.ownerId)])
        }
        else {
            getInfo = VKRequest(method:"users.get", parameters: ["user_id" : post.ownerId, "fields" : "photo_50"])
        }
//        let semaphore = DispatchSemaphore(value: 0)
//        let group = DispatchGroup()
//        var result : [String:Any]?

        getInfo.execute(resultBlock: { response in
            
            if let jsonResponse = response?.json {
                
                if let dictionary = jsonResponse as? [[String:Any]] {
                    onResponse(dictionary[0], post)
                }
            }
            
        }, errorBlock: { error in
            if error != nil {
                print("Error! \(String(describing: error))")                
            }
            
        })

        
    }
    
}
