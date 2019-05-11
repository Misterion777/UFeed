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
    let settings = SettingsManager.shared.getSettings(for: .vk)
    
    var posts = [Post]()
    
    var parameters: [String : Any]
    
    var nextFrom: String?
    var hasMorePosts = true
    
    init(count : Int) {
        self.parameters = ["count": count]
    }
    
    init() {
        self.parameters = [String:Any]()
    }
    
    func fetchOwnerPage(completion: @escaping (Result<Page, DataResponseError>) -> Void) {
        let userId = twitterDelegate.userId!
        twitterDelegate.swifter.showUser(.id(userId), success: { json in
            let jsonString = String(describing: json)
            let jsonData = jsonString.data(using: .utf8)!
            
            if let dictionary = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions()) as? [String:Any] {
                let page = TwitterPage.from(dictionary as NSDictionary)!
                completion(Result.success(page))
            }
            
        }, failure: { error in
            completion(Result.failure(DataResponseError.network(message: "Error occured while loading twitter page: \(error)")))
        })
    }
    
    func fetchPages(next: String?, completion: @escaping (Result<PagedResponse<Page>, DataResponseError>) -> Void) {
        let userId = twitterDelegate.userId!
        twitterDelegate.swifter.getUserFollowing(for: .id(userId), count: 200, success: { json, prev, next in
            let jsonString = String(describing: json)
            let jsonData = jsonString.data(using: .utf8)!
            
            if let users = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions()) as? [[String:Any]] {
//                if let users = dictionary["users"] as? [[String:Any] {
                    let pages = TwitterPage.from(users as NSArray)!
                    completion(Result.success(PagedResponse(social: .twitter, objects: pages)))
//                }
            }
            
        }) { error in
            completion(Result.failure(DataResponseError.network(message: "Error occured while loading twitter pages: \(error)") ))
        }
    }
    
    func fetchPosts(nextFrom: String?, completion: @escaping (Result<PagedResponse<Post>, DataResponseError>) -> Void) {
        let ids = settings.pages!.map{$0.id}
        
//        for id in ids {
//            twitterDelegate.swifter.getTimeline(for: .id("\(id)"), count: <#T##Int?#>, sinceID: <#T##String?#>, maxID: <#T##String?#>, trimUser: <#T##Bool?#>, excludeReplies: <#T##Bool?#>, includeRetweets: <#T##Bool?#>, contributorDetails: <#T##Bool?#>, includeEntities: <#T##Bool?#>, tweetMode: <#T##TweetMode#>, success: <#T##Swifter.SuccessHandler?##Swifter.SuccessHandler?##(JSON) -> Void#>, failure: <#T##Swifter.FailureHandler?##Swifter.FailureHandler?##(Error) -> Void#>)
//        }
        
        twitterDelegate.swifter.getHomeTimeline(count: self.parameters["count"] as? Int, maxID: nextFrom, success: {json in
            
            let jsonString = String(describing: json)
            let jsonData = jsonString.data(using: .utf8)!
            
            if let dictionary = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions()) as? [[String:Any]] {
                print(dictionary)
                var posts = TwitterPost.from(dictionary as NSArray)!
                let lastId = posts[posts.count - 1].id
                
//                posts = posts.filter{
//                    let element = $0
//                    return self.settings.pages!.contains{element.ownerPage!.id == $0.id}
//                }
                
                let responce = PagedResponse(social: .twitter, objects: posts as [Post], next:
                    String(lastId))
                
                completion(Result.success(responce))
            }            
            
        }, failure: { error in
            
            print(error)
            completion(Result.failure(DataResponseError.network(message: "Error occured while loading twitter posts: \(error)") ))
            
        })
    }
    
}

