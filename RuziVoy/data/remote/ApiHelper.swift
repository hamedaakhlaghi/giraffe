
import Foundation
import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
class ApiHelper {
    
   
    static let PLSCES_PATH = "maps/api/place/nearbysearch/json"
    static let DISTANCE_MATRIX_PATH = "maps/api/distancematrix/json"
    
    static let GET_VERB = "GET"
    var alamofire: SessionManager!
    
    fileprivate var requestInterceptor: RequestInterceptor = RequestInterceptor()
    
    static let instance: ApiHelper = {
        let instance = ApiHelper()
        return instance
    }()
    
    private init() {
        alamofire = Alamofire.SessionManager.default
        alamofire.adapter = RequestInterceptor()
    }
    
    public func newUrlComponentsInstance(path: String) -> NSURLComponents {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "maps.googleapis.com"
        urlComponents.port = 443
        urlComponents.path = "/"+path
        return urlComponents
    }
    
    func stopTheRequests() {
        if #available(iOS 9.0, *) {
            Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
                tasks.forEach { $0.cancel() }
            }
        } else {
            Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
                sessionDataTask.forEach { $0.cancel() }
                uploadData.forEach { $0.cancel() }
                downloadData.forEach { $0.cancel() }
            }
        }
    }
}


