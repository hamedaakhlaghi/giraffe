import UIKit
import RxCocoa
import RxSwift
class PlacesViewController: BaseViewController {
    var viewModel = PlacesViewModel()
    var location: Location!
    var disposeBag: DisposeBag?
    var places = [Place]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setLocation(location: Location) {
        self.location = location
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
        viewModel.getPlaces(location: location)
        
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
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
