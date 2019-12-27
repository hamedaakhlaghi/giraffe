

import UIKit
import GoogleMaps

protocol SelectLocationDelegate: class {
    func selectedLocation(position: CLLocationCoordinate2D, type: LocationType)
}

class SelectLocationViewController: UIViewController {
    private let locationManager = CLLocationManager()
    var markers = [GMSMarker]()
    var locationType: LocationType!
    weak var delegate: SelectLocationDelegate!
    var position: CLLocationCoordinate2D!
    
    @IBOutlet weak var viewMap: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        viewMap.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func set(delegate: SelectLocationDelegate)  {
        self.delegate = delegate
    }
    
    func setLocation(type: LocationType) {
        locationType = type
    }
    
    @IBAction func onDone(_ sender: UIBarButtonItem) {
        delegate.selectedLocation(position: position, type: locationType)
        navigationController?.popViewController(animated: true)
    }
    
}

extension SelectLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        viewMap.isMyLocationEnabled = true
        viewMap.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        viewMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
    }
    
}

extension SelectLocationViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        plotMarker(AtCoordinate: coordinate, onMapView: mapView)
    }
    
    private func plotMarker(AtCoordinate coordinate : CLLocationCoordinate2D, onMapView vwMap : GMSMapView) {
        let marker = GMSMarker(position: coordinate)
        
        removeMarkers(mapView: vwMap)
        markers.append(marker)
        marker.map = vwMap
        position = coordinate
    }
    
    func removeMarkers(mapView: GMSMapView){
        for (index, _) in markers.enumerated() {
            self.markers[index].map = nil
        }
    }
}

