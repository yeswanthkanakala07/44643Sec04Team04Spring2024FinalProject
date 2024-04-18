//
//  MyTournamentsVC.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Yaswanth Kanakala on 3/27/24.
//

import UIKit
import Firebase

class MyTournamentsVC: UIViewController {
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Task{
           try await fetchTournaments()
            
        }
       
    }
    
    @IBAction func TournamentsNavBarSC(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1{
           
            DispatchQueue.main.async {
                self.showMenu()
            }
        }
    }
    
    @IBOutlet weak var TournamentScrollView: UIScrollView!
    
    @IBAction func CreateTournamentBTN(_ sender: UIButton) {
        self.performSegue(withIdentifier: "CreateTournament", sender: sender)
    }
    
    @IBOutlet weak var TournamentStackView: UIStackView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    var data : [Tournament] = []
    
    private func showMenu(){
        data.forEach { item in
            print(item)
            let view = TournamentView()
            view.decriptionLBL.text = item.name
            view.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            tapGesture.numberOfTapsRequired = 1
            view.addGestureRecognizer(tapGesture)
            self.TournamentStackView.addArrangedSubview(view)
        }
    }
    
    @objc private func handleTap(_ recognizer: UITapGestureRecognizer){
        switch (recognizer.state){
        case .ended:
            guard let itemView = recognizer.view as? TournamentView else {return}
            self.performSegue(withIdentifier: "TournamentDetailsSegue", sender: itemView)
        default:
            assert (false, "Invalid segue!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TournamentDetailsSegue",
           let destinationVC = segue.destination as? TournamentsDetailsVC,
           let tournament = sender as? TournamentView {
            destinationVC.data = tournament.tournament
        }
    }
    
    func fetchTournaments() async throws{
        var documents: [QueryDocumentSnapshot] = []
        do{
            documents = try await db.collection("tournaments").getDocuments().documents
            print(documents.first)
            for i in 0..<documents.count{
                if
                    let name = documents[i]["name"] as? String,
                    let city = documents[i]["city"] as? String,
                    let organizerName = documents[i]["organizerName"] as? String,
                    let OrganizerPhone = documents[i]["OrganizerPhone"] as? String,
                    let ground = documents[i]["ground"] as? String,
                    let startDate = documents[i]["startDate"] as? Timestamp,
                    let endDate = documents[i]["endDate"] as? Timestamp,
                    let ballType = documents[i]["ballType"] as? String,
                    let pitchType = documents[i]["pitchType"] as? String,
                    let matchType = documents[i]["matchType"] as? String,
                    let otherDetails = documents[i]["otherDetails"] as? String,
                    let logo = documents[i]["logo"] as? String,
                    let teams = documents[i]["teams"] as? [String]
                {
                    data.append(Tournament(name: name,city: city,ground: ground,organizerName: organizerName,organizerPhone: OrganizerPhone, startDate: startDate, endDate: endDate, ballType: ballType, pitchType: pitchType, matchType: matchType, otherDetails: otherDetails,logo: logo, teams: teams))
                }
            }
           print(data)
        }
        catch{
            print("--------")
        }
    }

}
