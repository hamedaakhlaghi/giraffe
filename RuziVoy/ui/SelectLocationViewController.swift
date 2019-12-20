//
//  SelectLocationViewController.swift
//  RuziVoy
//
//  Created by Hamed on 12/20/19.
//  Copyright © 2019 Hamed. All rights reserved.
//

import UIKit
import GoogleMaps

class SelectLocationViewController: UIViewController, GMSMapViewDelegate{
    private let locationManager = CLLocationManager()

    @IBOutlet weak var viewMap: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        viewMap.delegate = self
        // Do any additional setup after loading the view.
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
//        fetchNearbyPlaces(coordinate: location.coordinate)
    }
}

