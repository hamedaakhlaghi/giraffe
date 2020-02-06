

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
    private var searchController: UISearchController!
    private var resultsTableController: PlacesResultsTableController!
    
    @IBOutlet weak var viewMap: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        viewMap.delegate = self
        navigationItem.rightBarButtonItem?.isEnabled = false
        // Do any additional setup after loading the view.
        initSearchBar()
    }
    
    func initSearchBar() {
        resultsTableController = PlacesResultsTableController()
        searchController = UISearchController(searchResultsController: resultsTableController)
        resultsTableController.tableView.delegate = resultsTableController
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.white
        let textFieldInsideSearchBar = self.searchController.searchBar.value(forKey: "searchField") as? UITextField
        searchController.searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 8.0, vertical: 0.0)
        searchController.searchBar.tintColor = .red
        textFieldInsideSearchBar?.layer.cornerRadius = 10
        textFieldInsideSearchBar?.layer.borderColor = UIColor.white.cgColor
        textFieldInsideSearchBar?.layer.borderWidth = 1
        textFieldInsideSearchBar?.borderStyle = .none
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .white
        textFieldInsideSearchBar?.tintColor = UIColor.white
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = .white
        textFieldInsideSearchBar?.textColor = .white
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
//        searchController.delegate = self
//        searchController.searchBar.delegate = self
        definesPresentationContext = true
        self.viewMap.addSubview(searchController.searchBar)
        
        
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
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func removeMarkers(mapView: GMSMapView){
        for (index, _) in markers.enumerated() {
            self.markers[index].map = nil
        }
    }
}


extension SelectLocationViewController: UISearchControllerDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
}

extension SelectLocationViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
//        
//        viewModel.filterContact(text: searchController.searchBar.text ?? "")
        
    }
    
}
