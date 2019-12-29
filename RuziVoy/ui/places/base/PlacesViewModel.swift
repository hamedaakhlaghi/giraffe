
import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

class PlacesViewModel {
    var placesResponse = PublishRelay<PlacesResponse>()
    var places: Observable<[Place]> {
        return placesResponse.asObservable().map{ data in
            return data.results
        }
    }
    
    init() {
        
    }
    
    func getPlaces(location: Location) {
        let placeRepository = PlaceRepository()
        let dataResponse: ((RepositoryResponse<PlacesResponse>)->())? = { [weak self] repoResponse in
            guard let  error = repoResponse.error else {
                let statusCode = repoResponse.restDataResponse?.response?.statusCode
                switch statusCode {
                case 200:
                    if let placesResponse = repoResponse.restDataResponse?.result.value {
                    self?.placesResponse.accept(placesResponse)
                    
                    }
                    print("response problem")
                default:
                    print("problem")
                }
                return
            }
            print(error)
        }
        let locQuery = URLQueryItem(name: "location", value: "\(location.lat),\(location.lng)")
        let types = ["Cafe","Restaurant"]
        let typesQuery = URLQueryItem(name: "types", value: types.joined(separator: "|"))
        let keyQuery = URLQueryItem(name: "key", value: ApiKey.key)
        let radiusQuery = URLQueryItem(name: "radius", value: "1000")
        let queryItems: [URLQueryItem] = [locQuery, typesQuery, keyQuery, radiusQuery]
        placeRepository.getAll(query: queryItems, onDone: dataResponse)
    }
}
