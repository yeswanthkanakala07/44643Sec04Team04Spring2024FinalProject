//
//  DashboardVC.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Macbook-Pro on 16/04/24.
//

import UIKit
import WebKit

class DashboardVC: UIViewController {
    @IBOutlet weak var web_View: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "https://news.google.com/search?cf=all&hl=en-IN&q=cricket&gl=IN&ceid=IN:en") {
            let request = URLRequest(url: url)
            web_View.load(request)
        } else {
            print("Invalid URL")
        }
    }
    
    
}
