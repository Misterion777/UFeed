//
//  CommonApiClient.swift
//  UFeed
//
//  Created by Ilya on 4/22/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit


class ApiClientManager {
    
    let semaphore = DispatchSemaphore(value: 1)
    let maxPosts = 10
    
    var isError = false
    var threadsCompleted = 0
    var posts = [Post]()
    var clients = [Social : ApiClient]()
    var nextFrom = [String : String]()
    
    var fetchPostsCompletion : ((Result<PagedPostResponse, DataResponseError>) -> Void)?
    
    init(socials: [Social]) {
        updateApiClients(socials: socials)
    }
    
    func updateApiClients(socials : [Social]) {
        for social in socials {
            switch social {
            case .vk:
                clients[.vk] = VKApiClient(count: getCount(clientsCount: socials.count))
            case .twitter:
                clients[.twitter] = TwitterApiClient(count: getCount(clientsCount: socials.count))
            default:
                print("\(social.rawValue) api is not implemented")
            }
        }
        
    }
    
    //TODO: add priority
    private func getCount(clientsCount : Int) -> Int{
        return Int(maxPosts / clientsCount)
    }
    
    func fetchPosts(nextFrom: [String : String], completion: @escaping (Result<PagedPostResponse, DataResponseError>) -> Void) {
        threadsCompleted = 0
        self.posts.removeAll()
        self.fetchPostsCompletion = completion
        for (k,v) in clients {
            DispatchQueue.global(qos: .utility).async {
                v.fetchPosts(nextFrom: nextFrom[k.rawValue], completion: self.onComplete)
            }
        }
    }
    

    private func onComplete(result: Result<PagedPostResponse, DataResponseError>) {
        semaphore.wait()
        switch result {
            case .failure(_) :
                isError = true
            case .success(let response):
                self.posts.append(contentsOf: response.posts)
                self.nextFrom.mergeWithoutClosure(dict: response.nextFrom)
        }
        threadsCompleted += 1
        semaphore.signal()
        if (threadsCompleted == clients.count ) {
            if (self.isError) {
                self.fetchPostsCompletion!(Result.failure(DataResponseError.network))
            }
            else {
                self.fetchPostsCompletion!(Result.success(PagedPostResponse(posts: posts, nextFrom: self.nextFrom)))
            }
        }
    }
}
