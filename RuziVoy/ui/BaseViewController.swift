import UIKit

class BaseViewController: UIViewController {
    var tapGesture : UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIComponent()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture!)
    }
    
    func initUIComponent() {
        
    }
    
    
    func bindViewModel() {
        
    }
    
    
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func removeGesture(view: UIView) {
        view.removeGestureRecognizer(tapGesture!)
    }
}
