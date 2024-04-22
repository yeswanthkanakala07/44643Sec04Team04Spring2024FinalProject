 
import UIKit


class InfoVC: UIViewController {

   
    var data = ""
     
    
    @IBOutlet weak var label: UILabel!
    

    
    override func viewDidLoad() {
        self.label.text = data
    }
}
