

import UIKit
import GoogleMaps
import RxSwift
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
