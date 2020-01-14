

import UIKit
import GoogleMaps
import RxSwift
import UserNotifications

class OriginDestinationViewController: BaseViewController {
    
    @IBOutlet weak var textFieldTime: UITextField!
    @IBOutlet weak var buttonDinner: UIButton!
    @IBOutlet weak var labelAt: UILabel!
    @IBOutlet weak var labelFrom: UILabel!
    @IBOutlet weak var viewDestination: UIView!
    @IBOutlet weak var viewOrigin: UIView!
    var date: Date!
    var viewModel = OriginDestinationViewModel()
    var disposeBag = DisposeBag()
    let datePicker = UIDatePicker()
    var selectedPlace: Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initUIComponent() {
        showDatePicker()
        textFieldTime.layer.cornerRadius = 5
        viewOrigin.layer.cornerRadius = 5
        viewDestination.layer.cornerRadius = 5
        buttonDinner.layer.cornerRadius = 5
        buttonDinner.isEnabled = false
        buttonDinner.backgroundColor = .gray
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
        
        viewModel.isDinnerActive.subscribe(onNext: {[weak self] isEnabled in
            self?.buttonDinner.isEnabled = isEnabled
            self?.buttonDinner.backgroundColor = isEnabled ? .orange : .gray
        }).disposed(by: disposeBag)
    }
    @objc func onOriginView() {
        performSegue(withIdentifier: R.segue.originDestinationViewController.originDestinationToSelectLocation, sender: LocationType.origin)
    }
    
    @objc func onDestinationView() {
        performSegue(withIdentifier: R.segue.originDestinationViewController.originDestinationToSelectLocation, sender: LocationType.destination)
    }
    @IBAction func onDinner(_ sender: Any) {
        if viewModel.originLocation != nil, viewModel.destinationLocation != nil {
            performSegue(withIdentifier: R.segue.originDestinationViewController.planToPlaces, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = R.segue.originDestinationViewController.originDestinationToSelectLocation(segue: segue)?.destination {
            destination.set(delegate: self)
            destination.setLocation(type: sender as! LocationType)
        }
        if let destination = R.segue.originDestinationViewController.planToPlaces(segue: segue)?.destination {
            
            destination.set(origin: viewModel.originLocation, destination: viewModel.destinationLocation, date: date)
        }
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        textFieldTime.inputAccessoryView = toolbar
        textFieldTime.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM hh:mm a"
        textFieldTime.text = formatter.string(from: datePicker.date)
        date = datePicker.date
        viewModel.date.accept(date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}


extension OriginDestinationViewController: SelectLocationDelegate{
    func selectedLocation(position: CLLocationCoordinate2D, type: LocationType) {
        
        viewModel.getAddress(position: position, type: type)
    }
}

//extension OriginDestinationViewController: PlacesDelegate {
//    func selected(place: Place) {
//        self.selectedPlace = place
//        textFieldTime.isHidden = false
//    }
//}
enum LocationType {
    case origin
    case destination
}
