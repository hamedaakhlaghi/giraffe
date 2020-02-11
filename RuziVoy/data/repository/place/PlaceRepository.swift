

import Foundation
class PlaceRepository: PlaceRepositoryProtocl {
    let placeRestRepository = PlaceRestRepository()
    

    func getAll(query: [URLQueryItem], onDone: ((RepositoryResponse<PlacesResponse>) -> ())?) {
        placeRestRepository.getAll(query: query, onDone: onDone)
        
    }
    
}
