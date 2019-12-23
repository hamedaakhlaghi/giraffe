
import Foundation
import GoogleMaps
import RxCocoa
import RxSwift
class OriginDestinationViewModel:  OriginDestination{
    var destinationAddress = BehaviorRelay<String>(value: "At")
    var originAddress = BehaviorRelay<String>(value: "From")
    
    func getAddress(position: CLLocationCoordinate2D, type: LocationType) {
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(position) {[weak self] response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            let a = lines.joined(separator: "\n")
            switch type {
            case .origin:
                self?.originAddress.accept(a)
            case .destination:
                self?.destinationAddress.accept(a)
            }
        }
    }
}



protocol OriginDestination: class {
    func getAddress(position: CLLocationCoordinate2D, type: LocationType)
}
