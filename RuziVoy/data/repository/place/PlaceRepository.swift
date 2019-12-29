

import Foundation
class PlaceRepository: PlaceRepositoryProtocl {
    let placeRestRepository = PlaceRestRepository()
    func getAll(onDone: ((RepositoryResponse<[Place]>) -> ())?) {
        placeRestRepository.getAll(onDone: onDone)
    }

    func getAll(query: [URLQueryItem], onDone: ((RepositoryResponse<PlacesResponse>) -> ())?) {
        placeRestRepository.getAll(query: query, onDone: onDone)
        
    }
    
    func get(identifier: Int, onDone: ((RepositoryResponse<Place>) -> ())?) {
        placeRestRepository.get(identifier: identifier, onDone: onDone)
    }
}
