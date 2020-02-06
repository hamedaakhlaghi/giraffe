import UIKit
class PlacesResultsTableController: UITableViewController {
    
    
    var places: [Place] = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(R.nib.)
        tableView.tableFooterView = UIView()
    }
    
    func set(filteredData: [Place]) {
        places = filteredData
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.contactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
//        let placesData = places[indexPath.row]
//        cell.set(place: placesData)
//        return cell
        return UITableViewCell()
    }
    
    
}
