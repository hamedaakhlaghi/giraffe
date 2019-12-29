import ObjectMapper
import Foundation
class Location: NSObject, Mappable {
    var lat: Double = 0
    var lng: Double = 0
    
    override init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
    
    func mapping(map: Map) {
        lat<-map["lat"]
        lng<-map["lng"]
    }
}
