//
//  VKApiWorker.swift
//  UFeed
//
//  Created by Ilya on 3/22/19.
//  Copyright © 2019 Admin. All rights reserved.

import Foundation
import VK_ios_sdk

class VKApiClient : ApiClient {
    
    let settings = SettingsManager.shared.getSettings(for: .vk)
    
    var posts = [Post]()
    var latestTime = Date.distantPast
    var parameters : [String : Any]
    var nextFrom : String?
    var hasMorePosts = true
    
    var fetchPostsCompletion : ((Result<PagedResponse<Post>, DataResponseError>) -> Void)?
    
    init(count: Int) {
        self.parameters = ["filters": "post", "count": count]
    }
    init() {
        self.parameters = ["filters": "post"]
    }
    
    func fetchPages(next: String?, completion: @escaping (Result<PagedResponse<Page>, DataResponseError>) -> Void) {
        let parameters = ["extended": "1", "count" : "200", "fields" : "screen_name,name,photo_50"]
        let getUser = VKRequest(method: "users.getSubscriptions", parameters: parameters)
        
        getUser?.execute(resultBlock: { response in
            if let jsonResponse = response?.json {
                if let dictionary = jsonResponse as? [String:Any] {
                    
                    if let items = dictionary["items"] as? [[String:Any]]{
                        let pages = VKPage.from(items as NSArray)!
                        completion(Result.success(PagedResponse(social: .vk, objects: pages)))
                    }
                    
                }
            }
        }, errorBlock: { error in
            if error != nil {
                print(error!)
                self.fetchPostsCompletion!(Result.failure(DataResponseError.network(message: "Error occured while loading vk user: \(error!)")))
            }
        })
    }    
    
    func fetchOwnerPage(completion: @escaping (Result<Page, DataResponseError>) -> Void) {
        
        let parameters = ["fields": "photo_50,screen_name"]
        let getUser = VKRequest(method: "users.get", parameters: parameters)
        
        getUser?.execute(resultBlock: { response in
            if let jsonResponse = response?.json {
                if let dictionary = jsonResponse as? [[String:Any]] {
                    let page = VKPage.from(dictionary as NSArray)!
                    completion(Result.success(page[0]))
                }
            }
        }, errorBlock: { error in
            if error != nil {
                print(error!)
                self.fetchPostsCompletion!(Result.failure(DataResponseError.network(message: "Error occured while loading vk user: \(error!)")))
            }
        })
        
    }
    
    func fetchPosts(nextFrom: String?, completion: @escaping (Result<PagedResponse<Post>, DataResponseError>) -> Void) {
        fetchPostsCompletion = completion
//        self.nextFrom = nextFrom
//        fetchNextPosts()
        if(!settings.isInitialized()) {
            return completion(Result.success(PagedResponse(social: .facebook, objects: [])))
        }
        
        var earliestDate = Date.distantFuture
        
        self.parameters["source_ids"] = settings.pages!.map{"g\($0.id)"}.joined(separator: ",")
        if nextFrom != nil {
            self.parameters["start_from"] = nextFrom
        }
        
        let getFeed = VKRequest(method: "newsfeed.get", parameters:self.parameters)
        
        getFeed?.execute(resultBlock: { response in
            
            if let jsonResponse = response?.json {
                if let dictionary = jsonResponse as? [String:Any] {                    
                    
                    var pages = [Page]()
                    
                    
                    if let groups = dictionary["groups"] as? [[String:Any]]{
                        pages.append(contentsOf: VKPage.from(groups as NSArray)!)
                    }
                    if let users = dictionary["profiles"] as? [[String:Any]]{
                        pages.append(contentsOf: VKPage.from(users as NSArray)!)
                    }
                    let next = dictionary["next_from"] as? String
                    
                    if let items = dictionary["items"] as? [[String:Any]]{
                        print(items[1])
                        let posts = VKPost.from(items as NSArray)!
                        
                        for post in posts {
                            let filtered = pages.filter{$0.id == abs(post.ownerPage!.id)}
                            post.ownerPage = filtered[0]
                        }
//                        let minDate = posts.min{a, b in a.date! < b.date!}!.date!
//                        if (minDate < earliestDate ) {
//                            earliestDate = minDate
//                        }
                        completion(Result.success(PagedResponse(social: .vk, objects: posts, next: next)))
                        
//                        if (earliestDate == Date.distantFuture) {
//                            self.hasMorePosts = false
//                            completion(Result.success(PagedResponse(social: .vk, objects: [])))
//                        }
//                        else {
//                            let next = String(earliestDate.addingTimeInterval(-1).timeIntervalSince1970).components(separatedBy: ".")[0]
//
//                        }
                    }
                }
            }
            
        }, errorBlock: { error in
            if error != nil {
                print(error!)
                self.fetchPostsCompletion!(Result.failure(DataResponseError.network(message: "Error occured while loading vk posts: \(error)")))
            }
        })
        
        
    }

    
    
//    private func fetchLatestPosts() {
//        var newParameters = parameters!
//        if latestTime != Date.distantPast {
//            newParameters["start_time"] = latestTime.addingTimeInterval(1).timeIntervalSince1970
//        }
//
//        let getFeed = VKRequest(method: "newsfeed.get", parameters:newParameters)
//
//        getFeed?.execute(resultBlock: { response in
//
//            if let jsonResponse = response?.json {
//                if let dictionary = jsonResponse as? [String:Any] {
//
//                    if self.latestTime == Date.distantPast {
//                        if let nextFrom = dictionary["next_from"] as? String {
//                            self.nextFrom = nextFrom
//                        }
//                    }
//
//                    if let items = dictionary["items"] as? [[String:Any]]{
//                        self.posts = VKPost.from(items as NSArray)
//
//                        if self.posts!.count == 0 {
//                            self.fetchNextPosts()
//                        }
//                        else {
//
//                            for post in self.posts! {
//                                if post.date! > self.latestTime {
//                                    self.latestTime = post.date!
//                                }
//                                self.getOwnerInfo(post: post, onResponse: self.setupPostOwnerInfo)
//                            }
//                        }
//
//                    }
//                }
//            }
//
//        }, errorBlock: { error in
//            if error != nil {
//                print(error!)
//                self.fetchPostsCompletion!(Result.failure(DataResponseError.network))
//            }
//        })
//    }
}



