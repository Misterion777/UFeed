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
}

final class PostsViewModel {
    private weak var delegate: PostsViewModelDelegate?
    
    private var posts: [Post] = []
    private var isFetchInProgress = false
    
    private var next = [Social:String]()
    
    let apiClient = SocialManager.shared.apiManager!
    
    init(delegate: PostsViewModelDelegate) {
        self.delegate = delegate
    }
    
    var currentCount: Int {
        return posts.count
    }
    
    func post(at index: Int) -> Post {
        return posts[index]
    }
    
    func fetchPosts() {
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        apiClient.fetchPosts(next: next) { result in
            
            switch result {
            case .failure(let error) :
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.errorDescription! )
                }
            case .success(let responses):
                DispatchQueue.main.async {
                    
                    self.isFetchInProgress = false
                                        
//                    self.posts.append(contentsOf: responses.flatMap {$0.objects} )
                    for responce in responses {
                        let filtered = responce.objects.filter {
                            let element = $0
                            return !self.posts.contains{$0.id == element.id}
                        }
                        
                        self.posts.append(contentsOf: filtered)
                        self.next[responce.social] = responce.next
                    }
                        
                    self.delegate?.onFetchCompleted(with: .none)
                    
                    // 3
//                    if self.next.isEmpty {
//                        self.next = response.next
//                        self.delegate?.onFetchCompleted(with: .none)
//                    } else {
//                        self.next = response.next
//                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.posts)
//                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
//                    }
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
