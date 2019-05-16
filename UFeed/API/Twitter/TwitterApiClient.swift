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
    func fetchLatestPosts(completion: @escaping (Result<PagedResponse<Post>, DataResponseError>) -> Void) {
//        
    }
    
    
    lazy var twitterDelegate = SocialManager.shared.getDelegate(forSocial: .twitter) as! TwitterDelegate
    let settings = SettingsManager.shared.getSettings(for: .twitter)
    
    var pagesFetched = 0
    var maxLastId = 0
    var posts = [Post]() {
        didSet {
            if (pagesFetched == settings.pages!.count) {
                pagesFetched = 0
                let responce = PagedResponse(social: .twitter, objects: posts as [Post], next:
                    String(maxLastId))
                fetchPostsCompletion!(Result.success(responce))
            }
        }
    }
    var fetchPostsCompletion : ((Result<PagedResponse<Post>, DataResponseError>) -> Void)?
    private var error : DataResponseError?
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
                    let pages = TwitterPage.from(users as NSArray)!
                    completion(Result.success(PagedResponse(social: .twitter, objects: pages)))
            }
            
        }) { error in
            completion(Result.failure(DataResponseError.network(message: "Error occured while loading twitter pages: \(error)") ))
        }
    }
    
    func fetchPosts(nextFrom: String?, completion: @escaping (Result<PagedResponse<Post>, DataResponseError>) -> Void) {
        fetchPostsCompletion = completion
        
        if(!settings.isInitialized() || settings.pages!.count == 0) {
            return completion(Result.success(PagedResponse(social: .twitter, objects: [])))
        }
        
        let ids = settings.pages!.map{$0.id}
        maxLastId = 0
        self.error = nil
        self.posts.removeAll()
        for id in ids {
            twitterDelegate.swifter.getTimeline(for: .id("\(id)"), count: self.parameters["count"] as? Int, maxID: nextFrom, tweetMode: .extended, success: { json in
                
                let jsonString = String(describing: json)
                let jsonData = jsonString.data(using: .utf8)!
                
                if let dictionary = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions()) as? [[String:Any]] {
                    print(dictionary)
                    print("##############################")
                    print(dictionary[0])
                    var posts = TwitterPost.from(dictionary as NSArray)!
                    let lastId = posts[posts.count - 1].id
                    if (lastId > self.maxLastId) {
                        self.maxLastId = lastId
                    }
                    self.pagesFetched += 1
                    self.posts.append(contentsOf: posts)
                }
            }) { error in
                print(error)
                if (self.error == nil) {
                    self.error = DataResponseError.network(message: "Error occured while loading twitter posts: \(error)")
                    completion(Result.failure(self.error!))
                }
            }
            if (error != nil) {
                break
            }
        }
    }
    
}

