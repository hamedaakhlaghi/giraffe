import Foundation
import Alamofire
class PlaceRestRepository: PlaceRepositoryProtocl {
    
    func getAll(query: [URLQueryItem], onDone: ((RepositoryResponse<PlacesResponse>) -> ())?) {
        let apiHelper = ApiHelper.instance
        let urlComponents = apiHelper.newUrlComponentsInstance(path: ApiHelper.PLSCES_PATH)
        urlComponents.queryItems = query
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = ApiHelper.GET_VERB
        apiHelper.alamofire.request(request).intercept().responseObject {(dataResponse:DataResponse<PlacesResponse>) in
            if let error = dataResponse.error {
                onDone?(RepositoryResponse(error: error))
                return
            }
            onDone?(RepositoryResponse(restDataResponse: dataResponse))
        }
    }
}

