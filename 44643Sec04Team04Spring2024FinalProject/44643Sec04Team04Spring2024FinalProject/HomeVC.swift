//
//  HomeVC.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Yaswanth Kanakala on 3/26/24.
//

import UIKit
import Social

class HomeVC: UIViewController {

    // Text view for user to input post content
    let postTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5
        return textView
    }()
        
        // Button to post content
    let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(postOnSocialMedia), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        // Add subviews
        view.addSubview(postTextView)
        view.addSubview(postButton)

        // Constraints
        NSLayoutConstraint.activate([
            postTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            postTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            postTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            postTextView.heightAnchor.constraint(equalToConstant: 150),
                
            postButton.topAnchor.constraint(equalTo: postTextView.bottomAnchor, constant: 20),
            postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
        
    @objc func postOnSocialMedia() {
        guard let postText = postTextView.text, !postText.isEmpty else {
            // Show an alert if post text is empty
            let alert = UIAlertController(title: "Empty Post", message: "Please enter some text to post.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
            
            // Check if the user is allowed to post on Twitter
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let composeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            composeViewController?.setInitialText(postText)
                
            // Present the compose view controller
            if let viewController = composeViewController {
                present(viewController, animated: true, completion: nil)
            }
        } else {
            // Twitter is not available, display an alert
            let alertController = UIAlertController(title: "Twitter Account", message: "Please sign in to your Twitter account in Settings.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
}
