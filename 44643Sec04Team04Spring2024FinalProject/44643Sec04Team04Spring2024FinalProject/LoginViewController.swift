//
//  LoginViewController.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Yaswanth Kanakala on 3/5/24.
//

import UIKit
import Firebase
import Lottie


class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func LoginClicked(_ sender: UIButton) {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password){ firebaseResult, error in
            if let e = error{
                print("error")
            }
            else{
                AppDelegate.username = self.emailTextField.text!
                let tabBarController = self.storyboard?.instantiateViewController(identifier: "HomeScreenTBC") as? UITabBarController
                self.view.window?.rootViewController = tabBarController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    
    @IBOutlet weak var LaunchLAV: LottieAnimationView!{
        didSet{
            LaunchLAV.loopMode = .playOnce
            LaunchLAV.animationSpeed = 1.0
            LaunchLAV.play { [weak self] _ in
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 1.0,
                    delay: 0.0,
                    options:[.curveEaseInOut]){
                        self?.LaunchLAV.alpha = 0.0
                    }
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
