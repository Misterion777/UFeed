//
//  TwitterApiClient.swift
//  UFeed
//
//  Created by Ilya on 4/21/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit

class TwitterApiClient : ApiClient {
    
    lazy var twitterDelegate = SocialManager.shared.getDelegate(forSocial: .twitter) as! TwitterDelegate
    
    var posts = [Post]()
    
    var parameters: [String : Any]
    
    var nextFrom: String?
    
    init(count : Int) {
        self.parameters = ["count": count]
    }
    
    init() {
        self.parameters = [String:Any]()
    }
    
    func fetchPosts(nextFrom: String?, completion: @escaping (Result<PagedPostResponse, DataResponseError>) -> Void) {
        
        twitterDelegate.swifter.getHomeTimeline(count: self.parameters["count"] as! Int, maxID: nextFrom, success: {json in
            
            let jsonString = String(describing: json)
            let jsonData = jsonString.data(using: .utf8)!
            
            if let dictionary = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions()) as? [[String:Any]] {
                self.posts = TwitterPost.from(dictionary as NSArray)!
                completion(Result.success(PagedPostResponse(posts: self.posts, nextFrom:
                    ["twitter" : String(self.posts[self.posts.count - 1].id)])))
            }            
            
        }, failure: { error in
            
            print(error)
            completion(Result.failure(DataResponseError.network))
            
        })
        
        
    }
}

