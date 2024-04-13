//
//  CreateTournamentVC.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Yaswanth Kanakala on 3/27/24.
//

import UIKit
import Eureka
import FirebaseFirestore



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
            row.onCellSelection{cell,row in 
                Task {
                    await self.createTournament()
                }
            }
                
        }
        
    }
    
    private func createTournament() async  {
        var tournament_details = form.values()
        guard let name = tournament_details["name"] as? String,
              let city = tournament_details["city"] as? String,
              let ground = tournament_details["ground"] as? String,
              let organizerName = tournament_details["organizerName"] as? String,
              let OrganizerPhone = tournament_details["OrganizerPhone"] as? String,
              let startDate = tournament_details["startDate"] as? Date,
              let endDate = tournament_details["endDate"] as? Date,
              let ballType = tournament_details["ballType"] as? String,
              let pitchType = tournament_details["pitchType"] as? String,
              let matchType = tournament_details["matchType"] as? String,
              let otherDetails = tournament_details["otherDetails"] as? String
              //let logo = tournament_details["logo"] as? String
                
        else{
            return
        }
        let tournament = Tournament(name: name,city: city,ground: ground,organizerName: organizerName,OrganizerPhone: OrganizerPhone, startDate: startDate, endDate: endDate, ballType: ballType, pitchType: pitchType, matchType: matchType, otherDetails: otherDetails,logo: "")
       
        await createDoc(name: name,city: city,ground: ground,organizerName: organizerName,OrganizerPhone: OrganizerPhone, startDate: startDate, endDate: endDate, ballType: ballType, pitchType: pitchType, matchType: matchType, otherDetails: otherDetails)
        
    }
    
    private func createDoc(name: String,city: String,ground: String,organizerName: String,OrganizerPhone: String, startDate: Date, endDate: Date, ballType: String, pitchType: String, matchType: String, otherDetails: String) async {
        do{
            try await db.collection("tournaments").addDocument(data: [
                "OrganizerPhone" : OrganizerPhone,
                "ballType" : ballType,
                "city":city,
                "endDate":endDate,
                "ground":ground,
//                "logo": logo,
                "name":name,
                "organizerName":organizerName,
                "otherDetails":otherDetails,
                "pitchType" : pitchType,
                "startDate": startDate
            ])
        }
        catch{
            print("")
        }    }
    
    
    
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
