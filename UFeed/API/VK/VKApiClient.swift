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
    
    var nextFrom : String?
    var posts : [Post]?
    var fetchPostsCompletion : ((Result<PagedPostResponse, DataResponseError>) -> Void)?
    var ownersInfoFetched = 0 {
        didSet {
            print("Owners info changed: \(ownersInfoFetched)")
            if ownersInfoFetched == VKApiClient.feedSize {
                ownersInfoFetched = 0
                fetchPostsCompletion!(Result.success(PagedPostResponse(posts: posts!, nextFrom: nextFrom!)))
            }
        }
    }
    
    func fetchPosts(nextFrom: String?, completion: @escaping (Result<PagedPostResponse, DataResponseError>) -> Void) {
        var parameters = ["filters": "post", "count": VKApiClient.feedSize] as [String : Any]
        if nextFrom != nil {
            parameters["start_from"]=nextFrom
        }
        
        let getFeed = VKRequest(method: "newsfeed.get", parameters:parameters)
        
        fetchPostsCompletion = completion
        getFeed?.execute(resultBlock: { response in
            
            if let jsonResponse = response?.json {
                if let dictionary = jsonResponse as? [String:Any] {
                    if let nextFrom = dictionary["next_from"] as? String {
                        self.nextFrom = nextFrom
                    }
                    
                    if let items = dictionary["items"] as? [[String:Any]]{
                        self.posts = VKPost.from(items as NSArray)
                        
                        for post in self.posts! {
                            self.getOwnerInfo(post: post, onResponse: self.setupPostOwnerInfo)
                        }
                    }
                }
            }
            
        }, errorBlock: { error in
            if error != nil {
                print(error!)
                completion(Result.failure(DataResponseError.network))
            }
        })
        
        
    }
    
    private func setupPostOwnerInfo(ownerInfo: [String:Any], post: Post) {
        
        var pageName : String?
        var photo : VKPhotoAttachment?
        
        if let name = ownerInfo["name"] as? String {
            pageName = name
        }
        else if let first_name = ownerInfo["first_name"] as? String,
            let last_name = ownerInfo["last_name"] as? String {
            pageName = first_name + " " + last_name
        }
        
        if let photoUrl = ownerInfo["photo_50"] as? String {
            photo = VKPhotoAttachment(url: photoUrl, height: 50, width: 50)
        }
        
        post.ownerPhoto = photo
        post.ownerName = pageName
        
        ownersInfoFetched += 1
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
