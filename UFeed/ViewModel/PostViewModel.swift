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
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    let apiWorker = VKApiWorker()
    
    init(delegate: PostsViewModelDelegate) {
        self.delegate = delegate
    }
    
    var totalCount : Int {
        return total
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
        
        
        
        
    }
    
    private func calculateIndexPathsToReload(from newPosts: [Post]) -> [IndexPath] {
        let startIndex = posts.count - newPosts.count
        let endIndex = startIndex + newPosts.count
        
        return (startIndex..<endIndex).map({IndexPath(row: $0, section: 0)})
    }
    
    
}
