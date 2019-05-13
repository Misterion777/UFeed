//
//  InstagramAttachments.swift
//  UFeed
//
//  Created by Ilya on 5/2/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Mapper


class InstagramPhotoAttachment : PhotoAttachment {
    
    var url : String
    var height : Int
    var width: Int
    
    required init(map: Mapper) throws {
        try self.url = map.from("media_url")
        self.height = 0
        self.width = 0
    }
    
    init(url:String, height:Int, width:Int){
        self.url = url
        self.height = height
        self.width = width
    }
}

class InstagramVideoAttachment : VideoAttachment {
    var url: String?
    var platform: String
    var duration : Int
    var thumbnail: PhotoAttachment
    
    
    required init(map: Mapper) throws {
        platform = "file"
        try self.url = map.from("media_url")
        duration = 0
        thumbnail = InstagramPhotoAttachment(url: "", height: 0, width: 0)
    }
    

    
}
