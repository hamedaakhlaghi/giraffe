
import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt
import GooglePlaces
import ObjectMapper

class PlacesViewModel {
    
    var originLocation: Location!
    var destinationLocation: Location!
    var placesResponse = BehaviorSubject<PlacesResponse>(value: PlacesResponse())
    var destinationDistanceResponse = BehaviorSubject<DistanceMatrix?>(value: nil)
    var originDistanceResponse = BehaviorSubject<DistanceMatrix?>(value: nil)
    var places: Observable<[Place]> {
        return Observable.combineLatest(placesResponse.asObservable(), originDistanceResponse.asObservable(), destinationDistanceResponse.asObservable()).map{ [weak self] data, originDistance, destinationDistance in
            var places = data.results
            if let self = self {
                if data.results.count > 0  && (originDistance == nil && destinationDistance == nil) {
                    var placesLocation = [Location]()
                    for place in data.results {
                        placesLocation.append(place.location)
                    }
                    self.getOriginToPlacesMatrix(origins: [self.originLocation], places:  placesLocation)
                    self.getPlacesFromDestination(places: placesLocation, destination: [self.destinationLocation])
                    places = data.results
                } else if data.results.count > 0  && (originDistance != nil && destinationDistance != nil) {
                    places = self.addDistance(to: places, origin: originDistance!, destination: destinationDistance!)
                }
            }
            return places
        }
    }
    
    init() {
        
    }
    
    func getPlaces(location: Location) {
        #if DEBUG
        let places = Mapper<PlacesResponse>().map(JSONfile: "PlacesResponse.json")!
        placesResponse.onNext(places)
        #else
        let placeRepository = PlaceRepository()
        let dataResponse: ((RepositoryResponse<PlacesResponse>)->())? = { [weak self] repoResponse in
            guard let  error = repoResponse.error else {
                let statusCode = repoResponse.restDataResponse?.response?.statusCode
                switch statusCode {
                case 200:
                    if let placesResponse = repoResponse.restDataResponse?.result.value {
                        self?.placesResponse.onNext(placesResponse)
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
        let types = ["restaurant"]
        let typesQuery = URLQueryItem(name: "types", value: types.joined(separator: "|"))
        let keyQuery = URLQueryItem(name: "key", value: ApiKey.key)
        let radiusQuery = URLQueryItem(name: "radius", value: "1000")
        let queryItems: [URLQueryItem] = [locQuery, typesQuery, keyQuery, radiusQuery]
        placeRepository.getAll(query: queryItems, onDone: dataResponse)
        #endif
    }
    
    func getOriginToPlacesMatrix(origins:[Location], places:[Location]) {
        let distanceMatrixRepository = DistanceMatrixRepository()
        
        let dataResponse: ((RepositoryResponse<DistanceMatrix>)->()) = { [weak self] repoResponse in
            guard let error = repoResponse.error else {
                let statusCode = repoResponse.restDataResponse?.response?.statusCode
                switch statusCode {
                case 200:
                    self?.originDistanceResponse.onNext(repoResponse.restDataResponse?.result.value)
                default:
                    print("failed")
                }
                return
            }
            print(error)
        }
        
        distanceMatrixRepository.getDistanceMatrix(origins:origins, destinations: places, onDone: dataResponse)
    }
    
    func getPlacesFromDestination(places: [Location], destination: [Location]) {
        let distanceMatrixRepository = DistanceMatrixRepository()
        
        let dataResponse: ((RepositoryResponse<DistanceMatrix>)->()) = { [weak self] repoResponse in
            guard let error = repoResponse.error else {
                let statusCode = repoResponse.restDataResponse?.response?.statusCode
                switch statusCode {
                case 200:
                    self?.destinationDistanceResponse.onNext(repoResponse.restDataResponse?.result.value)
                default:
                    print("failed")
                }
                return
            }
            print(error)
        }
        
        distanceMatrixRepository.getDistanceMatrix(origins: places, destinations: destination, onDone: dataResponse)
    }
    
    func addDistance(to places: [Place], origin: DistanceMatrix,destination: DistanceMatrix) -> [Place]{
        // origin distance to places matrix 1Xn
        let originFirstRowColumns = origin.rows[0].columns
        for i in 0 ..< originFirstRowColumns!.count {
            places[i].distanceFromOrigin = originFirstRowColumns![i].distance
            places[i].durationFromOrigin = originFirstRowColumns![i].duration
        }
        // places distance to destination matrix nX1
        let destinationRows = destination.rows!
        for i in 0 ..< destinationRows.count {
            places[i].distanceFromDestination = destinationRows[i].columns[0].distance
            places[i].durationFromDestination = destinationRows[i].columns[0].duration
        }
        return places
    }
}
