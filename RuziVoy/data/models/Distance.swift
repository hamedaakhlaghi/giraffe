//
//  Distance.swift
//  RuziVoy
//
//  Created by Hamed on 2/11/20.
//  Copyright © 2020 Hamed. All rights reserved.
//

import Foundation
import ObjectMapper
class Distance: NSObject, Mappable {
    var text: String!
    var value: Int!
    
    override init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        text <- map["text"]
        value <- map["value"]
    }
    
}
