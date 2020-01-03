
import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt
import GoogleMaps

class LocationsViewModel {
    let disposeBag = DisposeBag()
    var place = BehaviorSubject<Place?>(value: nil)
    var placeMarker = BehaviorSubject<GMSMarker?>(value: nil)
    var originMarker = BehaviorSubject<GMSMarker?>(value: nil)
    var destinationMarker = BehaviorSubject<GMSMarker?>(value: nil)
    init(place: Place, origin: Location, destination: Location ) {
        
        self.place.onNext(place)
        let placeLocation = CLLocationCoordinate2D(latitude: place.location.lat, longitude: place.location.lng)
        let placeM = GMSMarker(position: placeLocation)
        placeMarker.onNext(placeM)
        
        let originLocation = CLLocationCoordinate2D(latitude: origin.lat, longitude: origin.lng)
        let originM = GMSMarker(position: originLocation)
        originMarker.onNext(originM)
        
       
        let destinationLocation = CLLocationCoordinate2D(latitude: destination.lat, longitude: destination.lng)
        let destinationM = GMSMarker(position: destinationLocation)
        destinationMarker.onNext(destinationM)
    }
}
