//
//  RegisterViewController.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Puppala,Dharani on 3/6/24.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var reenterTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signup(_ sender: UIButton) {
        guard let email = emailTF.text else {return}
        guard let password = passwordTF.text else {return}
        Auth.auth().signIn(withEmail: email, password: password){ firebaseResult, error in
            if let e = error{
                print("error")
            }
            else{
                self.performSegue(withIdentifier: "Home", sender: self)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
