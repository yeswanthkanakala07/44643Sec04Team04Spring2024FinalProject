
import UIKit
import Eureka
import Firebase
 

class AddTeamVC: FormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var tournamentId = ""
    var selectedImage:UIImage?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set_form()
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
           row.title = "Team Name"
           row.placeholder = "Enter team name here"
           row.tag = "teamName"
       }
       
       <<< ButtonRow(){ row in
           row.title = "Submit "
           row.tag = ""
           row.onCellSelection{ cell , row in
               self.createTeam()
               
          }
           
       }
       
       +++ Section()
       
   }
   
    private func createTeam()  {
        var tournament_details = form.values()
        
         
        guard let teamName = tournament_details["teamName"] as? String, !teamName.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Team name cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if let selectedImage = selectedImage {
            
            
            FireStoreManager.shared.createTeam(tournamentId:tournamentId, teamName: teamName, logoImage: selectedImage) { v, v in
                  
                
                self.navigationController?.popViewController(animated: true)
                
            }
            
            
        }else {
            showAlerOnTop(message: "Please add image")
        }
       
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
       self.selectedImage = userSelectedImage
       let alert = UIAlertController(title: "Image selected✅", message: "", preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "Okay", style: .default))
       self.present(alert, animated: true, completion: nil)
       
   }
}


