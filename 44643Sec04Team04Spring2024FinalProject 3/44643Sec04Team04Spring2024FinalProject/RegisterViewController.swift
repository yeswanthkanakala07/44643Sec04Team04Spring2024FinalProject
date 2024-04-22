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
    }
    
    
    @IBAction func signup(_ sender: UIButton) {
//        guard let email = emailTF.text else {return}
//        guard let password = passwordTF.text else {return}
//        Auth.auth().signIn(withEmail: email, password: password){ firebaseResult, error in
//            if let e = error{
//                print("error")
//            }
//            else{
//                self.performSegue(withIdentifier: "Home", sender: self)
//            }
//        }
        guard let email = emailTF.text, !email.isEmpty else {
            showAlert(message: "Please enter your email.")
            return
        }
        
        guard let password = passwordTF.text, !password.isEmpty else {
            showAlert(message: "Please enter your password.")
            return
        }
        
        guard let reenteredPassword = reenterTF.text, !reenteredPassword.isEmpty else {
            showAlert(message: "Please re-enter your password.")
            return
        }
        
        guard password == reenteredPassword else {
            showAlert(message: "Passwords do not match.")
            return
        }
        
        // Perform password criteria check
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$&*]).{8,}$"
        guard NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password) else {
            showAlert(message: "Password must be at least 8 characters long and contain at least one uppercase letter, one number, and one special character.")
            return
        }
        
        // Register user with Firebase
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                self.showAlert(message: "Error: \(error.localizedDescription)")
            } else {
                // Registration successful
                self.showAlert(message: "Registration successful!")
                
                
                // Optionally, you can navigate to another screen upon successful registration
                // Example: self.performSegue(withIdentifier: "YourSegueIdentifier", sender: nil)
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
