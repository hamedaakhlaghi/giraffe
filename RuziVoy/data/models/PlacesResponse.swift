
import Foundation
import ObjectMapper
class PlacesResponse: NSObject, Mappable {
    
    var nextPageToken: String?
    var results = [Place]()
    required init?(map: Map) {
        
    }
    
    override init() {
        
    }
    
    func mapping(map: Map) {
        nextPageToken <- map["next_page_token"]
        results <- map["results"]
    }
}
