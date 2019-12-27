
import Foundation
import Alamofire
import ObjectMapper

class RequestInterceptor: RequestAdapter {
//    public var jwtPersistable: JwtPersistable? = UserDefaultsJwtPersistor()
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 10
        return urlRequest
    }
}

extension DataRequest {
    func intercept() -> Self {
        let serializedResponse = DataResponseSerializer<Any?> { request, response, data, error in
            guard error == nil else { return .failure(error!) }
            return .success(data)
        }
        return response(responseSerializer: serializedResponse) { _ in }
    }
}
