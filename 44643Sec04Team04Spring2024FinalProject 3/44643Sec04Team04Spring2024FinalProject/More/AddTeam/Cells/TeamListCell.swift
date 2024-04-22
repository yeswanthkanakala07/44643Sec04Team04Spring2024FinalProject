 
import UIKit

class TeamListCell: UITableViewCell {
   
    @IBOutlet weak var itemTilte: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    override  func awakeFromNib() {
        self.itemImage.layer.cornerRadius = 25
    }
    
}
