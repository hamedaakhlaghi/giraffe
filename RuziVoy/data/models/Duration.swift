

import Foundation
import ObjectMapper
class Duration: NSObject, Mappable {
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
