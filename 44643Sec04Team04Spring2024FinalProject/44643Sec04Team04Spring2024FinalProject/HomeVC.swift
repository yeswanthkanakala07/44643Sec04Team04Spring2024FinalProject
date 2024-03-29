//
//  HomeVC.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Yaswanth Kanakala on 3/26/24.
//

import UIKit
import Social

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let shareButton = UIButton(type: .system)
        shareButton.setTitle("Share", for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        shareButton.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        view.addSubview(shareButton)
    }
    

    @objc func shareButtonTapped() {
        // Create an instance of the SLComposeViewController
        let shareController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        // Check if social service is available
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            // Set default text for sharing
            shareController?.setInitialText("Check out this cool app!")
    
            // Present share controller
            present(shareController!, animated: true, completion: nil)
        } else {
            // Show an alert if the social service is not available
            let alert = UIAlertController(title: "Accounts", message: "Please log in to a Twitter account to share.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
