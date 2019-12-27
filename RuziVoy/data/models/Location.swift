import ObjectMapper
import Foundation
class Location: NSObject, Mappable {
    var lat: Float = 0
    var lng: Float = 0
    
    override init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        lat<-map["lat"]
        lng<-map["lng"]
    }
}
