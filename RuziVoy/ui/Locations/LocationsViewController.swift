

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
    var coordinates = [CLLocationCoordinate2D]()
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
            self?.coordinates = coordinates
            self?.showCamera(locations: coordinates)
        }).disposed(by: disposeBag)
    }
    
    func showCamera(locations: [CLLocationCoordinate2D]) {
        let count = locations.count
        if count > 1 {
            let lastIndex = count-1
            let region = GMSVisibleRegion(nearLeft: coordinates[min(lastIndex,3)], nearRight: coordinates[0], farLeft: coordinates[min(lastIndex,1)], farRight: coordinates[min(lastIndex,2)])
            let bounds = GMSCoordinateBounds(region: region)
            let camera = mapView.camera(for: bounds, insets: UIEdgeInsets(top: 150, left: 50, bottom: 50, right: 50))!
            self.mapView.camera = camera
        }
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
        coordinates.append(location.coordinate)
        showCamera(locations: coordinates)
        locationManager.stopUpdatingLocation()
    }
    
}
