//
//  HomeVC.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Yaswanth Kanakala on 3/26/24.
//

import UIKit
import Social
import WebKit
struct CricketScore: Decodable {
       let CSK: String
       let SRH: String
       let RCB: String
   }

class HomeVC: UIViewController {
    @IBOutlet weak var web_View: WKWebView!
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
        return button
    }()
    
    let cricketAPIService = CricketAPIService()
    var cricketScores: [CricketScore] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(sharedTextView)
        view.addSubview(postButton)
        
        NSLayoutConstraint.activate([
            sharedTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            sharedTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sharedTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sharedTextView.heightAnchor.constraint(equalToConstant: 50),
            
            postButton.topAnchor.constraint(equalTo: sharedTextView.bottomAnchor, constant: 20),
            postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
       
        postButton.addTarget(self, action: #selector(postOnMedia), for: .touchUpInside)
        
        
        fectchCricketFeed()
    }
    func fectchCricketFeed(){
        if let url = URL(string: "https://news.google.com/search?cf=all&hl=en-IN&q=cricket&gl=IN&ceid=IN:en") {
                   let request = URLRequest(url: url)
                   web_View.load(request)
               } else {
                   print("Invalid URL")
               }
    }
    
    func fetchCricketScores() {
        cricketAPIService.fetchCricketScores { [weak self] cricketScores in
            guard let self = self, let cricketScores = cricketScores else {
               
                return
            }
           
            self.cricketScores = cricketScores
            
           
            DispatchQueue.main.async {
               
                self.updateWithCricketScores()
            }
        }
    }
    
    func updateWithCricketScores() {
      
        for (index, score) in cricketScores.enumerated() {
            let scoreLabel = UILabel()
            scoreLabel.text = "\(score.CSK) vs \(score.SRH) vs \(score.RCB)"
            
            scoreLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(scoreLabel)
            
           
            NSLayoutConstraint.activate([
                scoreLabel.topAnchor.constraint(equalTo: postButton.bottomAnchor, constant: CGFloat(index * 30 + 20)),
                scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
        }
    }
    
    @objc func postOnMedia() {
        guard let sharedText = sharedTextView.text, !sharedText.isEmpty else {
                
                let alert = UIAlertController(title: "Empty Post", message: "Please enter some text to post.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
            
            // Check if the user is allowed to post on Twitter
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                let composeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                composeViewController?.setInitialText(sharedText)
                
                // Present the compose view controller
                if let viewController = composeViewController {
                    present(viewController, animated: true, completion: nil)
                }
            } else {
               
                let alertController = UIAlertController(title: "Twitter Account", message: "You are not signed in to Twitter. Would you like to sign in?", preferredStyle: .alert)
                let signInAction = UIAlertAction(title: "Sign In", style: .default) { _ in
                   
                    if let twitterURL = URL(string: "https://twitter.com") {
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
