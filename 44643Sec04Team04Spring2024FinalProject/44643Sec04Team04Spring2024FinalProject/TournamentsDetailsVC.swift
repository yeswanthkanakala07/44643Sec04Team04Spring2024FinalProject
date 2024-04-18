//
//  TournamentsDetailsVC.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Puppala,Dharani on 4/11/24.
//

import UIKit
import SwiftUI
import Firebase

class TournamentsDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    var tournmanetSec = [String]()
//    var tournament = [String : [Tournament]]()
//    
    
    var data = Tournament(name: "",city: "",ground: "",organizerName: "organizerName",organizerPhone: "OrganizerPhone", startDate:  Timestamp(), endDate: Timestamp() ,ballType: "ballType", pitchType: "pitchType", matchType: "matchType", otherDetails: "otherDetails",logo: "", teams: [])
//

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.teams?.count ?? 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TournamentDetailsTableViewCell", for: indexPath) as! TournamentDetailsTableViewCell
        var config = cell.defaultContentConfiguration()
       
            config.text = data.name
            cell.contentConfiguration = config
            

        
        return cell
    }
    
    
    
    
    @IBOutlet weak var tournamentLogoIV: UIImageView!
    
    
    @IBOutlet weak var tournySC: UISegmentedControl!
    
    @IBOutlet weak var tournamnetsDetailsTV: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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




//#Preview("44643Sec04Team04Spring2024FinalProject"){
//    UIStoryboard(name:"Main",bundle: nil).instantiateInitialViewController()!
//}
