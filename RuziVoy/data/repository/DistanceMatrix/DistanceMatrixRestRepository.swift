
import Foundation
import Alamofire
class DistanceMatrixRestRepository: DistanceMatrixRepositoryProtocol {
   
    func getDistanceMatrix(origins: [Location], destinations: [Location], onDone: ((RepositoryResponse<DistanceMatrix>) -> ())?) {
        
        let urlComponent = ApiHelper.instance.newUrlComponentsInstance(path: ApiHelper.DISTANCE_MATRIX_PATH)
        
        var queryItems = [URLQueryItem]()
        let originQuery = URLQueryItem(name: "origins", value: getLocationQueryValue(locs: origins))
        queryItems.append(originQuery)
        let destinationQuery = URLQueryItem(name: "destinations", value: getLocationQueryValue(locs: destinations))
        queryItems.append(destinationQuery)
        let apnQuery = URLQueryItem(name: "key", value: ApiKey.key)
        queryItems.append(apnQuery)
        let unitQuery = URLQueryItem(name: "units", value: "imperial")
        queryItems.append(unitQuery)
        urlComponent.queryItems = queryItems
        
        let request = URLRequest(url: urlComponent.url!)
        ApiHelper.instance.alamofire.request(request).intercept().responseObject {(dataRespone: DataResponse<DistanceMatrix>) in
            
            if let error = dataRespone.error {
                onDone?(RepositoryResponse(error:error))
                return
            }
            onDone?(RepositoryResponse(restDataResponse: dataRespone))
        }
    }
    
    func getLocationQueryValue(locs: [Location])->String {
        var locationStrings:[String] = []
        for loc in locs {
            let locString = "\(loc.lat),\(loc.lng)"
            locationStrings.append(locString)
        }
        let value = locationStrings.joined(separator: "|")
        return value
    }
}
