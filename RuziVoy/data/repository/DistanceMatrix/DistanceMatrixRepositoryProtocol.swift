
import Foundation
protocol DistanceMatrixRepositoryProtocol: Repository where Model == DistanceMatrix, Identifier == Int{
    func getDistanceMatrix(origins: [Location], destinations:[Location], onDone: ((RepositoryResponse<DistanceMatrix>)->())?)
}
