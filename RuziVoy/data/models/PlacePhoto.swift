import ObjectMapper
import Foundation
class PlacePhoto: NSObject, Mappable {
    var height: Double?
    var htmlAttributions: String?
    var photoReference: String?
    override init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        height<-map["height"]
        htmlAttributions<-map["html_attributions"]
        photoReference<-map["photo_reference"]
    }
}
