

import UIKit
import GoogleMaps
import RxSwiftExt
import RxSwift
import RxCocoa

class LocationsViewController: BaseViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var labelPlaceName: UILabel!
    @IBOutlet var images: [UIImageView]!
    private let locationManager = CLLocationManager()
    var disposeBag = DisposeBag()
    var viewModel: LocationsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setData(place: Place, origin: Location, destination: Location, date: Date) {
        viewModel = LocationsViewModel(place: place, origin: origin, destination: destination)
        viewModel.setNotification(place: place, date: date)
        
    }
    
    override func initUIComponent() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func bindViewModel() {
        viewModel.place.asObserver().subscribe(onNext: { [weak self] place in
            
            if let photos = place?.photos {
                for i in 0..<photos.count {
                    let reference = photos[i].photoReference
                    let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=\(reference!)&key=\(ApiKey.key)"
                    let url = URL(string: urlString)
                    if i < 3 {
                        self?.images[i].kf.setImage(with: url)
                    }
                    
                }
            }
            self?.labelPlaceName.text = place?.name
            
        }).disposed(by: disposeBag)
        
        viewModel.placeMarker.asObserver().subscribe(onNext: { [weak self] marker in
            
            marker?.icon = GMSMarker.markerImage(with: .green)
            marker?.map = self?.mapView
        }).disposed(by: disposeBag)
        
        viewModel.originMarker.asObserver().subscribe(onNext: { [weak self] marker in
            
            marker?.map = self?.mapView
        }).disposed(by: disposeBag)
        
        viewModel.destinationMarker.asObserver().subscribe(onNext: { [weak self] marker in
            
            marker?.icon = GMSMarker.markerImage(with: .blue)
            marker?.map = self?.mapView
        }).disposed(by: disposeBag)
        
        viewModel.coordinates.subscribe(onNext: {[weak self] coordinates in
            let region = GMSVisibleRegion(nearLeft: coordinates[0], nearRight: coordinates[0], farLeft: coordinates[1], farRight: coordinates[2])
            let bounds = GMSCoordinateBounds(region: region)
            let camera = self?.mapView.camera(for: bounds, insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))!
            self?.mapView.camera = camera!
            
        }).disposed(by: disposeBag)
    }
}


extension LocationsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
//        let r = GMSVisibleRegion(nearLeft: locations[0].coordinate, nearRight: locations[1].coordinate, farLeft: locations[2].coordinate, farRight: locations[0].coordinate)
//        GMSCoordinateBounds(region: r)
//        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
    }
    
}
