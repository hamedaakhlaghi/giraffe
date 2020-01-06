import UIKit
import RxCocoa
import RxSwift
class PlacesViewController: BaseViewController {
    var viewModel = PlacesViewModel()
    var originLocation: Location!
    var destinationLocation: Location!
    var disposeBag: DisposeBag?
    var places = [Place]()
    weak var placesDelegate: PlacesDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func set(origin: Location, destination: Location) {
        self.originLocation = origin
        self.destinationLocation = destination
    }
    
    override func initUIComponent() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func bindViewModel() {
        disposeBag = DisposeBag()
        viewModel.places.asObservable().subscribe(onNext: {[weak self] places in
            self?.places = places
            self?.tableView.reloadData()
        }).disposed(by: disposeBag!)
        viewModel.getPlaces(location: originLocation)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = R.segue.placesViewController.placesToShowAll(segue: segue)?.destination {
            destination.setData(place: sender as! Place, origin: originLocation, destination: destinationLocation)
        }
    }
}

extension PlacesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.placeTableViewCell, for: indexPath)!
        let place = places[indexPath.row]
        cell.set(place: place)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: R.segue.placesViewController.placesToShowAll, sender: self.places[indexPath.row])
        let cell = tableView.cellForRow(at: indexPath) as! PlaceTableViewCell
        cell.isHighlighted = false
    }
}

protocol PlacesDelegate: class {
    func selected(place: Place, origin: Location, destination: Location)
}
