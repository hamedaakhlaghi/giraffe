import Foundation
import Alamofire

struct RepositoryResponse<Model> {
    
    var restDataResponse: DataResponse<Model>?
    var error: Error?
    
    init(restDataResponse: DataResponse<Model>? = nil, error: Error? = nil) {
        self.restDataResponse = restDataResponse
        self.error = error
    }
    
    func getStatus() -> Status{
        if(error == nil){
            return Status.Success
        }
        return Status.Failure
    }
    
    enum Status{
        case Success
        case Failure
    }
}
