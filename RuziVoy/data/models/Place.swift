import ObjectMapper
import Foundation
class Place: NSObject, Mappable {
    
    var location: Location!
    var id: String!
    var placeId: String!
    var priceLevel: Int = 0
    var rating: Double = 0
    var types = [String]()
    var vicinity: String!
    override init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        location <- map["geometry.location"]
        id <- map["id"]
        placeId <- map["place_id"]
        priceLevel <- map["price_level"]
        rating <- map["rating"]
        types <- map["types"]
        vicinity <- map["vicinity"]
    }
}
