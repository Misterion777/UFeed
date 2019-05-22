//
//  PostViewModel.swift
//  UFeed
//
//  Created by Ilya on 4/2/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

protocol PostsViewModelDelegate : class {
    func onFetchCompleted(with newIndexPathToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
    func getIndexToInsertNewPosts() -> Int
}

final class PostsViewModel {
    private weak var delegate: PostsViewModelDelegate?
    
    private var posts: [Post] = []
    private var isFetchInProgress = false
    private let generalSettings = SettingsManager.shared.getGeneralSettings()
    
    private var next = [Social:String]()
    
    let apiClient = SocialManager.shared.apiManager!
    let timer = RepeatingTimer(timeInterval: 30)
    
    init(delegate: PostsViewModelDelegate) {
        self.delegate = delegate
        timer.eventHandler = fetchNewPosts
    }
    
    var currentCount: Int {
        return posts.count
    }
    
    func post(at index: Int) -> Post {
        return posts[index]
    }
    
    func fetchNewPosts() {
        apiClient.fetchNewPosts(completion: { result in
            switch result {
            case .failure(_):
                print("fail")
            case .success(let response):
                let index = self.delegate!.getIndexToInsertNewPosts()
                let filtered = response.objects.filter {
                    let element = $0
                    return !self.posts.contains{$0.id == element.id}
                }
                self.posts.insert(contentsOf: filtered, at: index)
                self.delegate!.onFetchCompleted(with: .none)
            }
            
        })
        
    }
    
    func fetchPosts(reload: Bool = false) {
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true
        
        if (reload) {
            print(posts.map{$0.type})
            posts = SettingsManager.shared.removeDeletedPages(posts: posts)
        }        
        
        apiClient.fetchPosts(next: next) { result in
            switch result {
            case .failure(let error) :
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: ErrorsParser.parse(error: error))
                }
            case .success(let responses):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
//                    self.posts.append(contentsOf: responses.flatMap {$0.objects} )
                    var newPosts = [Post]()
                    for responce in responses {
                        let filtered = responce.objects.filter {
                            let element = $0
                            return !self.posts.contains{$0.id == element.id}
                        }
                        newPosts.append(contentsOf: filtered)
                        self.next[responce.social] = responce.next
                    }
                    
                    if (self.generalSettings.get(key: .feedSortedByDate)) {
                        self.posts.append(contentsOf: newPosts)
                        self.posts.sort(by: {return $0.date! > $1.date! })
                    }
                    else {
                        newPosts.sort(by: {return $0.date! > $1.date! })
                        self.posts.append(contentsOf: newPosts)
                    }
                    
                    self.timer.resume()
                    self.delegate?.onFetchCompleted(with: .none)
                }
            }
        }
    }
    
    
    
    private func calculateIndexPathsToReload(from newPosts: [Post]) -> [IndexPath] {
        let startIndex = posts.count - newPosts.count
        let endIndex = startIndex + newPosts.count
        
        return (startIndex..<endIndex).map({IndexPath(row: $0, section: 0)})
    }
    
    
}
