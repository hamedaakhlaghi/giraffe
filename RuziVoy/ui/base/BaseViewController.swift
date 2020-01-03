import UIKit
class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIComponent()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    func initUIComponent() {
        
    }
    
    
    func bindViewModel() {
        
    }
    
    
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
   
}

