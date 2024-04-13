//
//  ProfileVC.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Yaswanth Kanakala on 3/26/24.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet weak var profilepic: UIImageView!
    
    @IBOutlet weak var usernamelbl: UILabel!
    
    @IBOutlet weak var descriptioblbl: UITextView!
    
    @IBOutlet weak var descripitioolbl: UILabel!
    
    @IBOutlet weak var lastnamelbl: UILabel!
    
    @IBOutlet weak var fristnamelbl: UILabel!
    
    @IBOutlet weak var emaillbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            goToLoginScreen()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    private func goToLoginScreen() {
        
        let homeController = self.storyboard?.instantiateViewController(identifier: "LoginScreen") as? UIViewController
        self.view.window?.rootViewController = homeController
        self.view.window?.makeKeyAndVisible()
        }
    
}
