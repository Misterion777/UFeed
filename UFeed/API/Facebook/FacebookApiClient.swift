//
//  FacebookApiClient.swift
//  UFeed
//
//  Created by Ilya on 4/28/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import FacebookCore


class FacebookApiClient: ApiClient {
    func fetchLatestPosts(completion: @escaping (Result<PagedResponse<Post>, DataResponseError>) -> Void) {
//     
    }
    
    
//    let connection = GraphRequestConnection()
    let settings = SettingsManager.shared.getSettings(for: .facebook)
//    var pages
    
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
    
    func fetchPages(next : String?,completion: @escaping (Result<PagedResponse<Page>, DataResponseError>) -> Void) {
        
        var parameters = ["fields":"picture{height,width,url},name,link", "limit" : "100", "summary" : "total_count"]
        if (next != nil) {
            parameters["after"] = next
        }
        let connection = GraphRequestConnection()
        
        // accounts/likes
        connection.add(GraphRequest(graphPath: "me/likes", parameters: parameters)) { httpResponse, result in
            switch result {
            case .success(let response):
                if let dictionary = response.dictionaryValue {
                    
                    var newNext : String?
                    var totalCount : Int?
                    if let paging = dictionary["paging"] as? [String : Any] {
                        if paging["next"] != nil {
                            if let cursors = paging["cursors"] as? [String : Any] {
                                if let after = cursors["after"] as? String {
                                    newNext = after
                                }
                            }
                        }
                    }
                    
                    if let summary = dictionary["summary"] as? [String : Any] {
                        if let count = summary["total_count"] as? Int {
                            totalCount = count
                        }
                    }                    
                    
                    if let data = dictionary["data"] as? [[String: Any]] {
                        let pages = FacebookPage.from(data as NSArray)! as [Page]
                        let responce = PagedResponse(social: .facebook, objects: pages, next: newNext, totalCount: totalCount)
                        completion(Result.success(responce))
                    }
                }
            case .failed(let error):
                print(error)
                completion(Result.failure(DataResponseError.network(message: "Error occured while loading facebook posts: \(error)")))
            }            
        }
        
        connection.start()        
    }
    
    func fetchOwnerPage(completion: @escaping (Result<Page, DataResponseError>) -> Void) {
        let parameters = ["fields" : "picture,name"]
        
        let connection = GraphRequestConnection()
        
        connection.add(GraphRequest(graphPath: "me", parameters: parameters)) { httpResponse, result in
            switch result {
            case .success(let response):
                if let dictionary = response.dictionaryValue {
                    let page = FacebookPage.from(dictionary as NSDictionary)!
                    completion(Result.success(page as Page))
                }
            case .failed(let error):
                print(error)
                completion(Result.failure(DataResponseError.network(message: "\(error)")))
            }
        }
        
        connection.start()
    }
    
    
    func fetchPosts(nextFrom: String?, completion: @escaping (Result<PagedResponse<Post>, DataResponseError>) -> Void) {
        
        if(!settings.isInitialized() || settings.pages!.count == 0 ) {
            return completion(Result.success(PagedResponse(social: .facebook, objects: [])))
        }
        let ids = settings.pages!.map{String($0.id)}.joined(separator: ",")
                        
        let feedParameters =
            ["ids": ids, "fields": "name,link,picture,feed.limit(\(parameters["count"] as! Int))" + (nextFrom != nil ? ".until(\(nextFrom!))" : "") + "{message,created_time,attachments,shares,likes.summary(total_count),comments.summary(total_count)}"]
        
        var posts = [Post]()
        let connection = GraphRequestConnection()
        let feedRequest = GraphRequest(graphPath: "", parameters: feedParameters)
        var earliestDate = Date.distantFuture
        
        connection.add(feedRequest) { httpResponse, result in
            switch result{
            case .success(let response):
                
                if let dictionary = response.dictionaryValue {
                    for (_, page) in dictionary {
                        let pageDictionary = page as! [String : Any]
                        let currentPage = FacebookPage.from(pageDictionary as NSDictionary)
                        
                        if let feed = pageDictionary["feed"] as? [String: Any] {
                            if let feedData = feed["data"] as? [[String: Any]] {
                                var pagePosts = FacebookPost.from(feedData as NSArray)!
                                pagePosts = pagePosts.map {
                                    $0.ownerPage = currentPage                                    
                                    return $0
                                }
                                let minDate = pagePosts.min{a, b in a.date! < b.date!}!.date!
                                if (minDate < earliestDate ) {
                                    earliestDate = minDate
                                }
                                posts.append(contentsOf: pagePosts)
                            }
                        }
                    }
                    if (earliestDate == Date.distantFuture) {
                        self.hasMorePosts = false
                        completion(Result.success(PagedResponse(social: .facebook, objects: [])))
                    }
                    else {
                        let next = String(earliestDate.addingTimeInterval(-1).timeIntervalSince1970).components(separatedBy: ".")[0]
                        completion(Result.success(PagedResponse(social: .facebook, objects: posts, next: next)))
                    }
                }
            case .failed(let error):
                
                print(error)
                completion(Result.failure(DataResponseError.network(message: "Error occured while loading facebook posts: \(ErrorsParser.parse(error: error))")))            }
        }
        connection.start()
    }
    
//    func fetchPosts2(nextFrom: String?, completion: @escaping (Result<PagedResponse<Post>, DataResponseError>) -> Void) {
//
//        let pageParameters = ["ids":settings.pagesId!.map {String($0)}.joined(separator: ","), "fields":"name,link,picture,feed"]
//        let pagesRequest = GraphRequest(graphPath: "", parameters: pageParameters)
//
//        let feedParameters = ["ids": "{result=pages:$.*.feed.data.*.id}", "fields": "message,created_time,attachments,shares,likes.summary(total_count),comments.summary(total_count)"]
//        let feedRequest = GraphRequest(graphPath: "", parameters: feedParameters)
//
//        var posts = [Post]()
//
//        connection.add(pagesRequest, batchParameters: ["name": "pages"]) { response, result in
//            switch result{
//            case .success(let response):
//
////                print(response.dictionaryValue)
//                print(response)
////                print(response.arrayValue)
//
//
//            case .failed(let error):
//                print(error)
//
//            }
//        }
//        connection.add(feedRequest, batchParameters: ["depends_on" : "pages"]) { httpResponse, result in
//            switch result{
//            case .success(let response):
//
//                if let dictionary = response.dictionaryValue {
//                    for (_, v) in dictionary {
//                        posts.append(FacebookPost.from(v as! NSDictionary)!)
//                    }
//                }
//
//                completion(Result.success(PagedResponse(social: .facebook, objects: [])))
//            case .failed(let error):
//                print(error)
//                completion(Result.failure(DataResponseError.network))
//            }
//
//        }
//        connection.start()
//
//    }
    
}
