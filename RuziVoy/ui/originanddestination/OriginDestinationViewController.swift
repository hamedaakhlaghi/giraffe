

import UIKit
import GoogleMaps
import RxSwift
import UserNotifications

class OriginDestinationViewController: BaseViewController {

    @IBOutlet weak var buttonDinner: UIButton!
    @IBOutlet weak var labelAt: UILabel!
    @IBOutlet weak var labelFrom: UILabel!
    @IBOutlet weak var viewDestination: UIView!
    @IBOutlet weak var viewOrigin: UIView!
    var viewModel = OriginDestinationViewModel()
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        notification()
    }
    
    override func initUIComponent() {
        viewOrigin.layer.cornerRadius = 5
        viewDestination.layer.cornerRadius = 5
        buttonDinner.layer.cornerRadius = 5
        let originGesture = UITapGestureRecognizer(target: self, action: #selector(onOriginView))
        viewOrigin.addGestureRecognizer(originGesture)
        
        let destinationGesture = UITapGestureRecognizer(target: self, action: #selector(onDestinationView))
        viewDestination.addGestureRecognizer(destinationGesture)
    }
    
    override func bindViewModel() {
        viewModel.originAddress.subscribe(onNext: { [weak self] address in
            self?.labelFrom.text = address
        }).disposed(by: disposeBag)
        
        viewModel.destinationAddress.subscribe(onNext:{[weak self] address in
            self?.labelAt.text = address
        }).disposed(by: disposeBag)
    }
    @objc func onOriginView() {
        performSegue(withIdentifier: R.segue.originDestinationViewController.originDestinationToSelectLocation, sender: LocationType.origin)
    }
    
    @objc func onDestinationView() {
        performSegue(withIdentifier: R.segue.originDestinationViewController.originDestinationToSelectLocation, sender: LocationType.destination)
    }
    @IBAction func onDinner(_ sender: Any) {
        if viewModel.originLocation != nil {
            performSegue(withIdentifier: R.segue.originDestinationViewController.planToPlaces, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = R.segue.originDestinationViewController.originDestinationToSelectLocation(segue: segue)?.destination {
            destination.set(delegate: self)
            destination.setLocation(type: sender as! LocationType)
        }
        if let destination = R.segue.originDestinationViewController.planToPlaces(segue: segue)?.destination {
            destination.setLocation(location: viewModel.originLocation)
        }
    }
    
    func notification() {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        
       
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = "Buy some milk"
        content.sound = UNNotificationSound.default
        let date1 = Date(timeIntervalSinceNow: 10)
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
            }
        })
        // Objective-C
        
        
        
//        let content = UNMutableNotificationContent()
//        content.title = "Notification Demo"
//        content.subtitle = "Demo"
//        content.body = "Notification on specific date!!"
//
//        let request = UNNotificationRequest(
//            identifier: "identifier",
//            content: content,
//            trigger: trigger
//        )
//
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
//            if error != nil {
//                //handle error
//            } else {
//                //notification set up successfully
//            }
//        })
    }
    
    
}


extension OriginDestinationViewController: SelectLocationDelegate{
    func selectedLocation(position: CLLocationCoordinate2D, type: LocationType) {
        
        viewModel.getAddress(position: position, type: type)
    }
}
enum LocationType {
    case origin
    case destination
}
