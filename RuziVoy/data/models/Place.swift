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
    var name: String!
    var photos: [PlacePhoto]?
    var distanceFromOrigin: Distance?
    var durationFromOrigin: Duration?
    var distanceFromDestination: Distance?
    var durationFromDestination: Duration?
    
    
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
        name <- map["name"]
        photos<-map["photos"]
    }
    
    func getOriginDistanceValue()->String {
        if let dis = distanceFromOrigin, let dur = durationFromOrigin{
            let value = "\(dis.text ?? "") in \(dur.text ?? "")"
            return value
        }
        return ""
    }
    
    func getDestinationDistance()->String {
        if let dis = distanceFromDestination, let dur = durationFromDestination {
            let value = "\(dis.text ?? "") in \(dur.text ?? "")"
            return value
        }
        return ""
    }
}
