
import Foundation
import GoogleMaps
import GooglePlaces
import RxCocoa
import RxSwift
class OriginDestinationViewModel:  OriginDestination{
    var destinationAddress = BehaviorRelay<String>(value: "At")
    var originAddress = BehaviorRelay<String>(value: "From")
    var originLocation: Location!
    var date = BehaviorRelay<Date?>(value: nil)
    var destinationLocation: Location!
    var isDinnerActive: Observable<Bool> {
        return date.asObservable().map {[weak self]date in
            if let date = date, self?.originLocation != nil, self?.destinationLocation != nil {
                return true
            } else {
                return false
            }
        }
    }
    func getAddress(position: CLLocationCoordinate2D, type: LocationType) {
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(position) {[weak self] response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                
                switch type {
                case .origin:
                    self?.originLocation = Location(lat: position.latitude, lng: position.longitude)
                    self?.originAddress.accept("\(position.latitude), \(position.longitude)" )
                case .destination:
                    self?.destinationLocation = Location(lat: position.latitude, lng: position.longitude)
                    self?.destinationAddress.accept("\(position.latitude), \(position.longitude)" )
                }
                return
            }
            let addss = lines.joined(separator: "\n")
            switch type {
            case .origin:
                self?.originLocation = Location(lat: position.latitude, lng: position.longitude)
                self?.originAddress.accept(addss)
            case .destination:
                self?.destinationLocation = Location(lat: position.latitude, lng: position.longitude)
                self?.destinationAddress.accept(addss)
            }
        }
    }
    
}



protocol OriginDestination: class {
    func getAddress(position: CLLocationCoordinate2D, type: LocationType)
}
