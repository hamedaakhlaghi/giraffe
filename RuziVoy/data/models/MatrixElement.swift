
import Foundation
import ObjectMapper
class MatrixElement: NSObject, Mappable {
    var distance: Distance!
    var duration: Duration!
    var status: String!
    
    override init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        distance <- map["distance"]
        duration <- map["duration"]
        status <- map["status"]
    }
}
