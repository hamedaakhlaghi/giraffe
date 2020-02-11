import Foundation

import ObjectMapper
class MatrixRows: NSObject, Mappable {
    var columns: [MatrixElement]!
    
    
    override init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        columns <- map["elements"]
    }
    
}
