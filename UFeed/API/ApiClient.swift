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
    
    func fetchPosts(nextFrom: String?, completion: @escaping (Result<PagedPostResponse, DataResponseError>)->Void)
}
