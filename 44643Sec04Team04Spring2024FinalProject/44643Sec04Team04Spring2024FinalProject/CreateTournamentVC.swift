//
//  CreateTournamentVC.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Yaswanth Kanakala on 3/27/24.
//

import UIKit
import Eureka

class CreateTournamentVC: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set_form()
        // Do any additional setup after loading the view.
    }
    public final class ImageCell: Cell<UIImage>, CellType {
        
        @IBOutlet weak var imgView: UIImageView!
        
        public override func setup() {
            super.setup()
            // Cell setup, add UIImageView if not using XIB
        }
        
        public override func update() {
            super.update()
            // Update cell state, set image to UIImageView
            imgView.image = row.value
        }
    }
    
    // Define the custom ImageRow
    public final class ImageRow: Row<ImageCell>, RowType {
        required public init(tag: String?) {
            super.init(tag: tag)
            // Specify the cellProvider if you are using a XIB
            cellProvider = CellProvider<ImageCell>(nibName: "ImageCell")
        }
    }
    private func set_form(){
        form +++ Section()
        <<< ImageRow() { row in
            row.tag = "profilePictureRow" // Assign a tag
            row.title = "Profile Picture"
            row.value = UIImage(named: "defaultImage")
        }

        <<< TextRow(){ row in
            row.title = "Tournament Name"
            row.placeholder = "Enter text here"
        }
        <<< TextRow(){ row in
            row.title = "city"
            row.placeholder = "Enter text here"
        }
        <<< TextRow(){ row in
            row.title = "Ground"
            row.placeholder = "Enter text here"
        }
        <<< TextRow(){ row in
            row.title = "Oraganizer Name"
            row.placeholder = "Enter text here"
        }
        <<< PhoneRow(){ row in
            row.title = "Oraganizer Name"
            row.placeholder = "Enter text here"
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage, let row = form.rowBy(tag: "profilePictureRow") as? ImageRow {
            row.value = image
            row.updateCell() // Refreshes the cell to display the new image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
