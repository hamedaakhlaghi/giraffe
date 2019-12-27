import Foundation
protocol PlaceRepositoryProtocl: Repository where Model == Place, Identifier == Int  {
    func getAll(query: [URLQueryItem],onDone: ((RepositoryResponse<[PlacesResponse]>) -> ())?)
}
