//
//  Page.swift
//  UFeed
//
//  Created by Ilya on 4/29/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Mapper

protocol Page : class, Mappable {
    var id : Int { get }
    
    var photo : PhotoAttachment? { get set}
    var link : String {get }
    var name : String { get set}
    
    init(id: Int)        
}
