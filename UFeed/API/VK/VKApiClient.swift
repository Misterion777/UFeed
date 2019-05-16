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
    
    lazy var delegate = SocialManager.shared.getDelegate(forSocial: .vk) as! VKDelegate
    
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
    
    private func delegateError() -> Error? {
        if (delegate.wakeUpError != nil){
            delegate = VKDelegate()
            if (delegate.wakeUpError != nil) {
                return delegate.wakeUpError
            }
            SocialManager.shared.socialDelegates[.vk] = delegate
            return nil
        }
        return nil
    }
    
    func fetchPages(next: String?, completion: @escaping (Result<PagedResponse<Page>, DataResponseError>) -> Void) {
        if let delegateError = delegateError() {
            self.fetchPostsCompletion!(Result.failure(DataResponseError.network(message: "VK error: \(delegateError)")))
        }
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
        
        if let delegateError = delegateError() {
            completion(Result.failure(DataResponseError.network(message: "VK error: \(delegateError)")))
        }
        
        if(!settings.isInitialized() || settings.pages!.count == 0) {
            return completion(Result.success(PagedResponse(social: .vk, objects: [])))
        }
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
                        let posts = VKPost.from(items as NSArray)!
                        
                        for post in posts {
                            let filtered = pages.filter{$0.id == abs(post.ownerPage!.id)}
                            post.ownerPage = filtered[0]
                        }
                        if (self.latestTime == Date.distantPast) {
                            for post in posts {
                                if post.date! > self.latestTime {
                                    self.latestTime = post.date!
                                }
                            }
                            self.latestTime.addTimeInterval(1)
                        }
                        
                        completion(Result.success(PagedResponse(social: .vk, objects: posts, next: next)))
                    }
                }
            }
            
        }, errorBlock: { error in
            if error != nil {
                print(error!)
                completion(Result.failure(DataResponseError.network(message: "Error occured while loading vk posts: \(error)")))
            }
        })
    }

    
    func fetchVideo(by ownerId: Int, _ videoId: Int,
                    completion: @escaping (Result<String, DataResponseError>) -> Void) {
        let parameters = ["owner_id" : "\(ownerId)", "videos": "\(ownerId)_\(videoId)"]
        
        let getFeed = VKRequest(method: "video.get", parameters:parameters)
        
        getFeed?.execute(resultBlock: { response in
            
            if let jsonResponse = response?.json {
                if let dictionary = jsonResponse as? [String:Any] {
                    if let items = dictionary["items"] as? [[String:Any]]{
                        if let player = items[0]["player"] as? String {
                            completion(Result.success(player))
                        }                        
                    }
                }
            }
            
        }, errorBlock: { error in
            if error != nil {
                print(error!)
                self.fetchPostsCompletion!(Result.failure(DataResponseError.network(message: "Error occured while loading vk video: \(error)")))
            }
        })
    }
    
    
    func fetchLatestPosts(completion: @escaping (Result<PagedResponse<Post>, DataResponseError>) -> Void) {
        if(!settings.isInitialized() || settings.pages!.count == 0) {
            return
        }
        self.parameters["source_ids"] = settings.pages!.map{"g\($0.id)"}.joined(separator: ",")
                
        self.parameters["start_time"] = String(latestTime.timeIntervalSince1970)
        
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
                    
                    if let items = dictionary["items"] as? [[String:Any]]{
                        let posts = VKPost.from(items as NSArray)!
                        
                        if (posts.count != 0) {
                        
                            for post in posts {
                                let filtered = pages.filter{$0.id == abs(post.ownerPage!.id)}
                                post.ownerPage = filtered[0]
                            }
//                            posts.max{ $0.date! > $1.date!}
                            for post in posts {
                                if post.date! > self.latestTime {
                                    self.latestTime = post.date!
                                }
                            }
                            
                            print("Some new posts found! Displaying...")
                            completion(Result.success(PagedResponse(social: .vk, objects: posts)))
                        }
                        else {
                            print("No new posts!")
                        }
                    }
                }
            }
            
        }, errorBlock: { error in
            if error != nil {
                print(error!)
                completion(Result.failure(DataResponseError.network(message: "Error occured while loading vk posts: \(error)")))
            }
        })
    }
}



