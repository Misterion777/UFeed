//
//  VKApiWorker.swift
//  UFeed
//
//  Created by Ilya on 3/22/19.
//  Copyright © 2019 Admin. All rights reserved.

import Foundation
import VK_ios_sdk

class VKApiClient : ApiClient {
    
    static let feedSize = 10
    let postMapper = VKPostMapper()
    var ownersInfoFetched = 0
    
    func fetchPosts(page: Int, completion: @escaping (Result<PagedPostResponse, DataResponseError>) -> Void) {
        let getFeed = VKRequest(method: "newsfeed.get", parameters:["filters": "post", "count": VKApiClient.feedSize])
        getFeed?.execute(resultBlock: { response in
            
            if let jsonResponse = response?.json {
                if let dictionary = jsonResponse as? [String:Any] {
                    if let items = dictionary["items"] as? [[String:Any]]{
                        var posts = self.postMapper.jsonArrayToPostsArray(items)
                        
                        for post in posts! {
                            self.getOwnerInfo(post: post, onResponse: self.postMapper.setupPostOwnerInfo)
                        }
                        
                        onResponse(items)
                    }
                }
            }
            
        }, errorBlock: { error in
            if error != nil {
                print(error)
                completion(Result.failure(DataResponseError.network))
            }
        })
        
        
    }
    
    func getNewsFeed(onResponse: @escaping ([[String:Any]])-> Void) {
        
        
    }
    
    private func getOwnerInfo(post: Post, onResponse: @escaping ([String:Any], Post)->Void ) {
        
        var getInfo : VKRequest
        if (post.ownerId < 0) {
            getInfo = VKRequest(method:"groups.getById", parameters: ["group_id" : abs(post.ownerId)])
        }
        else {
            getInfo = VKRequest(method:"users.get", parameters: ["user_id" : post.ownerId, "fields" : "photo_50"])
        }

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
