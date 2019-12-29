import UIKit

class PlacesViewController: BaseViewController {
    var viewModel = PlacesViewModel()
    var location: Location!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setLocation(location: Location) {
        self.location = location
    }
    
    override func initUIComponent() {
        
    }
    
    override func bindViewModel() {
        viewModel.getPlaces(location: location)
    }
}

extension PlacesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
