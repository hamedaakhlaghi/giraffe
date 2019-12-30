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
   
    typealias PhotoCompletion = (UIImage?) -> Void
    private var photoCache: [String: UIImage] = [:]
    private var session: URLSession {
        return URLSession.shared
    }
    func fetchPhotoFromReference(_ reference: String, completion: @escaping PhotoCompletion) -> Void {
        if let photo = photoCache[reference] {
            completion(photo)
        } else {
            let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=\(reference)&key=\(ApiKey.key)"
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            
            session.downloadTask(with: url) { url, response, error in
                var downloadedPhoto: UIImage? = nil
                defer {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        completion(downloadedPhoto)
                    }
                }
                guard let url = url else {
                    return
                }
                guard let imageData = try? Data(contentsOf: url) else {
                    return
                }
                downloadedPhoto = UIImage(data: imageData)
                self.photoCache[reference] = downloadedPhoto
                }
                .resume()
        }
    }
}
