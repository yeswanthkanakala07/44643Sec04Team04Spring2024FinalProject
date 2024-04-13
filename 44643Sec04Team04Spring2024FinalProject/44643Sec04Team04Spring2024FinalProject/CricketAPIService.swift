//
//  CricketAPIService.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by vani battu on 4/12/24.
//

import UIKit
import Foundation


class CricketAPIService: UIViewController {

    func fetchCricketScores(completion: @escaping ([CricketScore]?) -> Void) {
           
            let Url = URL(string: "https://api.example.com/cricket/scores")!
            
            
            let ses = URLSession.shared
            
            
            let thread = ses.dataTask(with: Url) { data, response, error in
                
                if let err = error {
                    print("Error fetching cricket scores: \(err)")
                    completion(nil)
                    return
                }
                
               
                guard let reply = data else {
                    print("No data received")
                    completion(nil)
                    return
                }
                
                
                do {
                  
                    let decode = JSONDecoder()
                    let Scores = try decode.decode([CricketScore].self, from: reply)
                    
                    
                    completion(Scores)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
            
            
            thread.resume()
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
