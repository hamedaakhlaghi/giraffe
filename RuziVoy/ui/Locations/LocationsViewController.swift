

import UIKit
import GoogleMaps
import RxSwiftExt
import RxSwift
import RxCocoa

class LocationsViewController: BaseViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var labelPlaceName: UILabel!
    @IBOutlet weak var imagePlace: UIImageView!
    
    var disposeBag = DisposeBag()
    var viewModel: LocationsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setData(place: Place, origin: Location, destination: Location) {
        viewModel = LocationsViewModel(place: place, origin: origin, destination: destination)
    }
    
    override func initUIComponent() {
        
    }
    
    override func bindViewModel() {
        viewModel.place.asObserver().subscribe(onNext: { [weak self] place in
            self?.labelPlaceName.text = place?.name
        }).disposed(by: disposeBag)
        
        viewModel.placeMarker.asObserver().subscribe(onNext: { [weak self] marker in
//            marker?.icon =
            
            marker?.map = self?.mapView
        }).disposed(by: disposeBag)
        
        viewModel.originMarker.asObserver().subscribe(onNext: { [weak self] marker in
            marker?.map = self?.mapView
        }).disposed(by: disposeBag)
        
        viewModel.destinationMarker.asObserver().subscribe(onNext: { [weak self] marker in
            marker?.map = self?.mapView
        }).disposed(by: disposeBag)
    }
}
