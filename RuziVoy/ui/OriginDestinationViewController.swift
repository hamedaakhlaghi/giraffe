

import UIKit

class OriginDestinationViewController: BaseViewController {

    @IBOutlet weak var buttonDinner: UIButton!
    @IBOutlet weak var labelAt: UILabel!
    @IBOutlet weak var labelFrom: UILabel!
    @IBOutlet weak var viewDestination: UIView!
    @IBOutlet weak var viewOrigin: UIView!
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
    
    @objc func onOriginView() {
        
    }
    
    @objc func onDestinationView() {
        
    }
    @IBAction func onDinner(_ sender: Any) {
   
    }
}
