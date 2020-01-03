
import Foundation
import GoogleMaps
import GooglePlaces
import RxCocoa
import RxSwift
import UserNotifications
class OriginDestinationViewModel:  OriginDestination{
    var destinationAddress = BehaviorRelay<String>(value: "At")
    var originAddress = BehaviorRelay<String>(value: "From")
    var originLocation: Location!
    var destinationLocation: Location!
    
    func getAddress(position: CLLocationCoordinate2D, type: LocationType) {
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(position) {[weak self] response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
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
    
    
    func setNotification(place: Place, date: Date) {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = place.name
        content.body = "go to \(place.name!) ad \(date)"
        content.sound = UNNotificationSound.default
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
            }
        })
        
    }
    
}



protocol OriginDestination: class {
    func getAddress(position: CLLocationCoordinate2D, type: LocationType)
}
