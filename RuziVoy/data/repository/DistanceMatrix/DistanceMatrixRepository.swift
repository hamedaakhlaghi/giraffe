
import Foundation
class DistanceMatrixRepository: DistanceMatrixRepositoryProtocol {
    let restRepo = DistanceMatrixRestRepository()
    func getDistanceMatrix(origins: [Location], destinations: [Location], onDone: ((RepositoryResponse<DistanceMatrix>) -> ())?) {
        restRepo.getDistanceMatrix(origins: origins, destinations: destinations, onDone: onDone)
    }
}
