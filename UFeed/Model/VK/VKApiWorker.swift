//
//  VKApiWorker.swift
//  UFeed
//
//  Created by Ilya on 3/22/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import VK_ios_sdk

class VKApiWorker {
    
    static func getNewsFeed() {
        let getFeed = VKRequest(method: "newsfeed.get", parameters:["filters": "post,wall_photo", "count": 1])
        
        getFeed?.execute(resultBlock: { response in
            
            guard let jsonResponse = response?.json as? String else {
                print("Error!")
                return
            }
            
            let data = jsonResponse.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Dictionary<String, Any>] {
                    print(jsonArray)
                }
                else {
                    print("bad json")
                }
                
            } catch let error as NSError {
                print(error)
            }
            
        }, errorBlock: { error in
            if error != nil {
                print("Error! \(error)")
            }
        })
    }
    
}
