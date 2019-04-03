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
    private var currentPage = ""
    private var isFetchInProgress = false
    
    let apiClient = VKApiClient()
    
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
        
        apiClient.fetchPosts(nextFrom: currentPage) { result in
            
            switch result {
            case .failure(let error) :
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let response):
                
                DispatchQueue.main.async {
                    // 1
                    self.isFetchInProgress = false
                    // 2
                    self.posts.append(contentsOf: response.posts)
                    
                    // 3
                    
                    if self.currentPage == "" {
                        self.currentPage = response.nextFrom
                        self.delegate?.onFetchCompleted(with: .none)
                    } else {
                        self.currentPage = response.nextFrom
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.posts)                        
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    }
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
