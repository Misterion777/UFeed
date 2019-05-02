//
//  ApiClient.swift
//  UFeed
//
//  Created by Ilya on 4/2/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

protocol ApiClient : class {
    
    var posts : [Post] { get }
    var parameters : [String : Any] { get set}
    var nextFrom : String? { get }
    var hasMorePosts : Bool { get }
    
    func fetchPosts(nextFrom: String?, completion: @escaping (Result<PagedResponse<Post>, DataResponseError>)->Void)
    func fetchPages(next: String?, completion: @escaping (Result<PagedResponse<Page>, DataResponseError>) -> Void)
    
}
