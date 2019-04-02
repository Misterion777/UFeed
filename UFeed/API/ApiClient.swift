//
//  ApiClient.swift
//  UFeed
//
//  Created by Ilya on 4/2/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

protocol ApiClient : class {
    func fetchPosts(page: Int, completion: @escaping (Result<PagedPostResponse, DataResponseError>)->Void)
}
