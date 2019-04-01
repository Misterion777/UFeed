//
//  VKApiWorker.swift
//  UFeed
//
//  Created by Ilya on 3/22/19.
//  Copyright © 2019 Admin. All rights reserved.

import Foundation
import VK_ios_sdk

class VKApiWorker {
    
    static func getNewsFeed() {
        let getFeed = VKRequest(method: "newsfeed.get", parameters:["filters": "post,wall_photo", "count": 1])
        
        getFeed?.execute(resultBlock: { response in
            
            if let jsonResponse = response?.json {

                if let dictionary = jsonResponse as? [String:Any] {
                    
                    if let items = dictionary["items"] as? [[String:Any]]{
                        
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
    
    static func getPageInfo(pageId: Int, onResponse: @escaping ([String:Any])->Void ) {
        
        var getInfo : VKRequest
        if (pageId < 0) {
            getInfo = VKRequest(method:"groups.getById", parameters: ["group_id" : abs(pageId)])
        }
        else {
            getInfo = VKRequest(method:"users.get", parameters: ["user_id" : pageId, "fields" : "photo_50"])
        }
//        let semaphore = DispatchSemaphore(value: 0)
//        let group = DispatchGroup()
//        var result : [String:Any]?

        getInfo.execute(resultBlock: { response in
            
            if let jsonResponse = response?.json {
                
                if let dictionary = jsonResponse as? [[String:Any]] {
                    onResponse(dictionary[0])
                }
            }
            
        }, errorBlock: { error in
            if error != nil {
                print("Error! \(String(describing: error))")                
            }
            
        })

        
    }
    
}
