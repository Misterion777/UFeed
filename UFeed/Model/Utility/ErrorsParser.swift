//
//  ErrorsParser.swift
//  UFeed
//
//  Created by Ilya on 5/6/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation


class ErrorsParser {
    static func parse (error : Error ) -> String{
        
        if ("\(error)".contains("Page Public Content Access")){
            return "You don't have Page Public Content Access feature activated!"
        }
        else if ("\(error)".contains("Too many IDs")){
            return "Too many pages! Maximum: 50."
        }
        else if ("\(error)".contains("offline")){
            return "Wooooo!\nNo internet connection.\nWaiting for network..."
        }
        return "\(error)"
    }
}
