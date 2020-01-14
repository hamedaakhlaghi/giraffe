
import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt
import GoogleMaps
import UserNotifications

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
        let calendar = Calendar.current
        let time=calendar.dateComponents([.hour,.minute,.second], from: Date())
        let hour = String(format: "%0.2d:%0.2d", time.hour!, time.minute!)
        content.body = "go to \(place.name!) at \(hour)"
        content.sound = UNNotificationSound.default
        let newDate = Calendar.current.date(byAdding: .minute, value: -30, to: date) // "Jun 13, 2016, 1:18 PM"

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate ?? date)
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
