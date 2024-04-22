//
//  CricketAPIService.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by vani battu on 4/12/24.
//

import UIKit
import Foundation


class CricketAPIService: UIViewController {

    let apiUrl = "https://example.com/api/cricket/scores"

    // Example API key
    let apiKey = "ab6b756daamsh3feb221e4e1b3eep1550b2jsn404dffecd8e3"

    // Define a typealias for the completion handler
    typealias CricketScoresCompletion = (Result<[String: String], Error>) -> Void

    func fetchCricketScores(completion: @escaping CricketScoresCompletion) {
        guard let url = URL(string: apiUrl) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: nil)))
                return
            }
            
            if let data = data {
                do {
                    // Parse the JSON response
                    let decoder = JSONDecoder()
                    let scores = try decoder.decode([String: String].self, from: data)
                    completion(.success(scores))
                    
                    // Handle the scores data (update UI, etc.)
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
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
