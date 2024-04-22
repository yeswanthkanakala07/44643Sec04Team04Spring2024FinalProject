//
//  ProfileVC.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Yaswanth Kanakala on 3/26/24.
//

import UIKit
import Firebase
import Social
import QRCode

class ProfileVC: UIViewController {

    @IBOutlet weak var qrCode: UIImageView!
    
    @IBOutlet weak var profilepic: UIImageView!
    
    @IBOutlet weak var usernamelbl: UILabel!
    
    @IBOutlet weak var descriptioblbl: UITextView!
    
    @IBOutlet weak var descripitioolbl: UILabel!
    
    @IBOutlet weak var lastnamelbl: UILabel!
    
    @IBOutlet weak var fristnamelbl: UILabel!
    
    @IBOutlet weak var emaillbl: UILabel!
    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        self.usernamelbl.text = DataSaver.shared.getEmail()
        let qrCodeB = QRCode(string: DataSaver.shared.getEmail())
      //  let myImage: UIImage? = try! qrCode.image

        self.qrCode.image = try! qrCodeB!.image()
    }
    

   
    
    
    @IBAction func share(_ sender: Any) {
        
        let textToShare = "Hi Welcome to Fantasy Cricket League App, Join Me \(DataSaver.shared.getEmail())"
        
        let serviceTypes = [SLServiceTypeTwitter, SLServiceTypeFacebook, SLServiceTypeSinaWeibo]
        
        for serviceType in serviceTypes {
            if SLComposeViewController.isAvailable(forServiceType: serviceType) {
                if let shareViewController = SLComposeViewController(forServiceType: serviceType) {
                    shareViewController.setInitialText(textToShare)
                    
                    present(shareViewController, animated: true, completion: nil)
                }
            } else {
                let serviceName: String
                switch serviceType {
                    case SLServiceTypeTwitter:
                        serviceName = "Twitter"
                    case SLServiceTypeFacebook:
                        serviceName = "Facebook"
                    case SLServiceTypeSinaWeibo:
                        serviceName = "Sina Weibo"
                    default:
                        serviceName = "Unknown"
                }
                let alertController = UIAlertController(title: "Facebook Account", message: "You are not signed in to Twitter. Would you like to sign in?", preferredStyle: .alert)
                let signInAction = UIAlertAction(title: "Sign In", style: .default) { _ in
                   
                    if let twitterURL = URL(string: "https://www.facebook.com") {
                        UIApplication.shared.open(twitterURL, options: [:], completionHandler: nil)
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(signInAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion: nil)
            
            }
        }
        
        
    }
    
    
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

extension UIImageView {
    convenience init(qrCode: QRCode) {
        self.init(image: qrCode.unsafeImage)
    }
}
