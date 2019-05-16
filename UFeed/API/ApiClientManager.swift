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
    
    var clients = [Social : ApiClient]()
    
    var responses = [PagedResponse<Post>]()
    var errors : [DataResponseError]?
    
    var activeClients = 0
    
    var fetchPostsCompletion : ((Result<[PagedResponse<Post>], DataResponseError>) -> Void)?
    
    init(socials: [Social]) {
        updateApiClients(socials: socials)
    }
    
    func updateApiClients(socials : [Social]) {
        clients.removeAll()
        for social in socials {
            switch social {
            case .vk:
                clients[.vk] = VKApiClient(count: getCount(clientsCount: socials.count))
            case .twitter:
                clients[.twitter] = TwitterApiClient(count: getCount(clientsCount: socials.count))
            case .facebook:
                clients[.facebook] = FacebookApiClient(count: getCount(clientsCount: socials.count))
            case .instagram:
                clients[.instagram] = InstagramApiClient(count: getCount(clientsCount: socials.count))
            default:
                print("lol")
            }
        }
    }
    
    //TODO: add priority
    private func getCount(clientsCount : Int) -> Int{
        return Int(maxPosts / clientsCount)
    }
    
    func fetchPosts(next: [Social : String], completion: @escaping (Result<[PagedResponse<Post>], DataResponseError>) -> Void) {
        threadsCompleted = 0
        self.responses.removeAll()
        self.errors?.removeAll()
        self.fetchPostsCompletion = completion
        if (clients.count == 0) {            self.fetchPostsCompletion!(Result.failure(DataResponseError.network(message: "You are not signed in any social network!")))
        } else{
            self.activeClients = getActiveClients()
            for (k,v) in clients {
                if (v.hasMorePosts) {
                    DispatchQueue.global(qos: .utility).async {
                        v.fetchPosts(nextFrom: next[k], completion: self.onComplete)
                    }
                }
            }
            
        }
    }
    
    func fetchNewPosts(completion: @escaping (Result<PagedResponse<Post>, DataResponseError>)->Void) {
        self.clients[.vk]!.fetchLatestPosts(completion: completion)
    }

    private func getActiveClients() -> Int {
        var activeClients = 0
        for (_,v) in clients {
            if (v.hasMorePosts){
                activeClients += 1
            }
        }
        return activeClients
    }

    private func onComplete(result: Result<PagedResponse<Post>, DataResponseError>) {
        semaphore.wait()
        switch result {
            case .failure(let error) :
                if (self.errors == nil) {
                    self.errors = [DataResponseError]()
                }
                self.errors!.append(error)
            case .success(let response):
                self.responses.append(response)
        }
        threadsCompleted += 1
        
        if (threadsCompleted == self.activeClients ) {
            if (self.errors == nil || self.errors?.count == 0) {
                
                self.fetchPostsCompletion!(Result.success(responses))
            }
            else {
                let error = self.errors!.map{$0.errorDescription!}.joined(separator: ",")
                self.fetchPostsCompletion!(Result.failure(DataResponseError.network(message: "Error: \(error)")))
            }
        }
        semaphore.signal()
    }
}
