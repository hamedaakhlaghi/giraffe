import Foundation
import Alamofire
class PlaceRestRepository: PlaceRepositoryProtocl {
    func get(identifier: Int, onDone: ((RepositoryResponse<Place>) -> ())?) {
        
    }
    
    func getAll(onDone: ((RepositoryResponse<[Place]>) -> ())?) {
        
    }
    
    func getAll(query: [URLQueryItem], onDone: ((RepositoryResponse<[PlacesResponse]>) -> ())?) {
        let apiHelper = ApiHelper.instance
        let urlComponents = ApiHelper.newUrlComponentsInstance(path: ApiHelper.PLSCES_PATH)
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = ApiHelper.GET_VERB
        apiHelper.alamofire.request(request).intercept().responseArray {(dataResponse:DataResponse<[PlacesResponse]>) in
            if let error = dataResponse.error {
                onDone?(RepositoryResponse(error: error))
                return
            }
            onDone?(RepositoryResponse(restDataResponse: dataResponse))
        }
    }
    
    
}
