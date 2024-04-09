//
//  CreateTournamentVC.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Yaswanth Kanakala on 3/27/24.
//

import UIKit
import Eureka
import FirebaseFirestore

struct Tournamnet {
    var name : String?
    var city : String?
    var ground : String?
    var organizerName : String?
    var OrganizerPhone : String?
    var startDate : Date
    var endDate : Date
    var ballType : String
    var pitchType : String
    var matchType : String
    var otherDetails : String?
    var logo : UIImage?
}


class CreateTournamentVC: FormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var image = UIImage()
    let db = Firestore.firestore()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set_form()
        // Do any additional setup after loading the view.
    }
   
 
    private func set_form(){
        form +++ Section()
        <<< ButtonRow(){ row in
            row.title = "Upload tournament Logo "
            row.tag = "logo"
            row.onCellSelection{ cell , row in
                self.uploadImage()
                        
            }
            
        }
        <<< TextRow(){ row in
            row.title = "Tournament Name"
            row.placeholder = "Enter text here"
            row.tag = "name"
        }
        <<< TextRow(){ row in
            row.title = "City/Place"
            row.placeholder = "Enter text here"
            row.tag = "city"
        }
        <<< TextRow(){ row in
            row.title = "Ground"
            row.placeholder = "Enter text here"
            row.tag = "ground"
        }
        <<< TextRow(){ row in
            row.title = "Oraganizer Name"
            row.placeholder = "Enter text here"
            row.tag = "organizerName"
        }
        <<< PhoneRow(){ row in
            row.title = "Phone No:"
            row.placeholder = "Enter text here"
            row.tag = "OrganizerPhone"
        }
        <<< DateRow() { row in
            row.title = "Tournament Start Date"
            row.tag = "startDate"
            
        }
        <<< DateRow() { row in
            row.title = "Tournament End Date"
            row.tag = "endDate"
            
        }
        <<< AlertRow<String>() {
            $0.title = "Ball Type"
            $0.selectorTitle = "Ball Type"
            $0.options = ["Hard Tennis 🥎","Leather 🏏","Other"]
            $0.value = "Leather 🏏"    // initially selected
            $0.tag = "ballType"
        }
        <<< AlertRow<String>() {
            $0.title = "Pitch Type"
            $0.selectorTitle = "Pitch Type"
            $0.options = ["Rough","Cement","Turf"]
            $0.value = "Turf"    // initially selected
            $0.tag = "pitchType"
        }
        <<< AlertRow<String>() {
            $0.title = "Match Type"
            $0.selectorTitle = "Match Type"
            $0.options = ["Limited Overs","The Hundred","T20", "Test Match"]
            $0.value = "Limited Overs"    // initially selected
            $0.tag = "matchType"
        }
        
        <<< TextAreaRow(){
            $0.title = "Other Details"
            $0.placeholder = "Add any other details like Prizes, Rules, Entry Fee,etc."
            $0.tag = "otherDetails"
        }
        
        
        +++ Section()
                <<< ButtonRow(){ row in
                    row.title = "Create"
                    row.tag = "createBtn"
                    row.onCellSelection{ cell , row in
                        self.createTournament()
                    }
                }
        
    }
    
    private func createTournament(){
        var tournament_details = form.values()
        
    }
   
    

    private func uploadImage(){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            picker.dismiss(animated: true)
            guard let userSelectedImage = info[.originalImage] as? UIImage else{return}
            image = userSelectedImage
            let alert = UIAlertController(title: "Image selected✅", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default))
                    self.present(alert, animated: true, completion: nil)
            
        }
}
