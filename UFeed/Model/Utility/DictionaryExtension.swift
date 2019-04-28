//
//  DictionaryExtension.swift
//  UFeed
//
//  Created by Ilya on 4/24/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation


extension Dictionary {
    
    mutating func mergeWithoutClosure(dict: [Key: Value]) {
        for (k,v) in dict {
            updateValue(v, forKey: k)
        }
    }
    
}
