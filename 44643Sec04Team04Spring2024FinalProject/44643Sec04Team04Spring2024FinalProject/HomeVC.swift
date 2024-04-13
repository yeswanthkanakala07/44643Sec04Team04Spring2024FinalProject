//
//  HomeVC.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Yaswanth Kanakala on 3/26/24.
//

import UIKit
import Social

class HomeVC: UIViewController {

  
    let sharedTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5
        return textView
    }()
        
    let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(postOnMedia), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        
        view.addSubview(sharedTextView)
        view.addSubview(postButton)

        
        NSLayoutConstraint.activate([
            sharedTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            sharedTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sharedTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sharedTextView.heightAnchor.constraint(equalToConstant: 150),
                
            postButton.topAnchor.constraint(equalTo: sharedTextView.bottomAnchor, constant: 20),
            postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
        
    @objc func postOnMedia() {
        guard let sharedText = sharedTextView.text, !sharedText.isEmpty else {
            
            let alert = UIAlertController(title: "Empty Post", message: "Please enter some text to post.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let composeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            composeViewController?.setInitialText(sharedText)
            
            
            if let viewController = composeViewController {
                present(viewController, animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(title: "Twitter Account", message: "You are not signed in to Twitter. Would you like to sign in?", preferredStyle: .alert)
            let signInAction = UIAlertAction(title: "Sign In", style: .default) { _ in
               
                if let twitterURL = URL(string: "App-Prefs:root=TWITTER") {
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
