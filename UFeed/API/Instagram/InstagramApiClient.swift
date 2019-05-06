//
//  InstagramApiClient.swift
//  UFeed
//
//  Created by Ilya on 5/2/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import FacebookCore

class InstagramApiClient: ApiClient {
    
    var parameters = [String : Any]()
    
    var nextFrom: String?
    
    var hasMorePosts = true
    var hasNext = false
    
    private lazy var instagramDelegate = SocialManager.shared.getDelegate(forSocial: .instagram) as? InstagramDelegate
    let settings = SettingsManager.shared.getSettings(for: .instagram)
    
    var onFecthPostsCompleted : ((Result<PagedResponse<Post>, DataResponseError>) -> Void)?
    
    var resultSend = false
    var posts =  [Post]() {
        didSet {
            if (!resultSend) {
                sendResult()
            }
        }
    }
    
    var pagesFetched = 0 {
        didSet{
            if(pagesFetched == settings.pages!.count) {
                hasMorePosts = hasNext
            }
        }
    }
    
    
    init(count : Int) {
        self.parameters = ["count": count]
    }
    
    init() {
        self.parameters = [String:Any]()
    }
    
    private func sendResult() {
        resultSend = true
        let count = self.parameters["count"]! as! Int
        let leftSplit = Array(posts[0..<count])
        let rightSplit = Array(posts[count ..< posts.count])
        posts = rightSplit
        onFecthPostsCompleted!(Result.success(PagedResponse(social: .instagram, objects: leftSplit)))
    }
    
    
    func fetchPosts(nextFrom: String?, completion: @escaping (Result<PagedResponse<Post>, DataResponseError>) -> Void) {
        
        if(!settings.isInitialized()) {
            return completion(Result.success(PagedResponse(social: .instagram, objects: [])))
        }
        
        resultSend = false
        onFecthPostsCompleted = completion
        
        if (!resultSend && posts.count >= self.parameters["count"]! as! Int) {
            return sendResult()
        }
        
        let connection = GraphRequestConnection()
        hasNext = false
        
        for page in (settings.pages! as! [InstagramPage]) {
            let parameters = ["fields" : "business_discovery.username(\(page.link)){media.limit(\(self.parameters["count"] as! Int))" + (page.nextFrom != nil ? ".after(\(page.nextFrom!))" : "") + "{caption,comments_count,like_count,media_type,media_url,timestamp,children{media_url} }}"]
            connection.add(GraphRequest(graphPath: "\(instagramDelegate!.instagramPageId!)",parameters: parameters)) { httpResponse, result in
                
                switch result {
                case .success(let response):
                    if let discovery = response.dictionaryValue!["business_discovery"] as? [String:Any] {
                        
                        if let media = discovery["media"] as? [String : Any] {
                            if let paging = media["paging"] as? [String : Any]{
                                if let cursors = paging["cursors"] as? [String : Any] {
                                    page.nextFrom = cursors["after"] as? String
                                }
                            }
                            self.hasNext = self.hasNext || (page.nextFrom != nil)
                            
                            if let data = media["data"] as? [[String : Any]] {
                                
                                var newPosts = InstagramPost.from(data as NSArray)!
                                newPosts = newPosts.map {
                                    $0.ownerId = page.id
                                    $0.ownerName = page.name
                                    $0.ownerPhoto = page.photo
                                    return $0
                                }
                                self.posts.append(contentsOf: newPosts)
                                self.pagesFetched += 1
                                
//                                let responce = PagedResponse(social: .instagram, objects: self.posts as [Post], next: newNext)
//                                completion(Result.success(responce))
                            }
                        }
                    }
                    
                case .failed(let error):
                    print(error)
                    completion(Result.failure(DataResponseError.network(message: "\(error)")))
                }
            }
        }
        connection.start()
    }
    
    
    
    func fetchPages(next: String?, completion: @escaping (Result<PagedResponse<Page>, DataResponseError>) -> Void) {
        // cannot get followings of instagram user
    }
    
    
    func fetchPage(by pageName: String, completion: @escaping (Result<Page, DataResponseError>) -> Void) {
        let parameters = ["fields" : "business_discovery.username(\(pageName.lowercased())){name,username,profile_picture_url}"]
        
        let connection = GraphRequestConnection()
    
        let pageId = String(instagramDelegate!.instagramPageId!)
        
        connection.add(GraphRequest(graphPath: pageId, parameters: parameters)) { httpResponse, result in
            switch result {
            case .success(let response):
                if let dictionary = response.dictionaryValue {
                    
                    if let discovery = dictionary["business_discovery"] as? [String : Any] {
                        let page = InstagramPage.from(discovery as NSDictionary)!
                        completion(Result.success(page as Page))
                    }
                }
            case .failed(let error):
                print(error)
                completion(Result.failure(DataResponseError.network(message: "\(error)")))
            }
        }
        
        connection.start()
    }

}
