import UIKit
import SDWebImage
import FirebaseFirestore

 
enum SegmentType {
    case myMatches
    case myTournaments
    case myTeams
}

class MyTournamentsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    var selectedTab: SegmentType = .myTournaments
    var tournaments: [Tournament] = []
    var myTournamentPlayers: [TournamentPlayers] = []
    var myMatchs: [Match] = []
 
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TournamentCell")
        tableView.registerCells([TeamListCell.self])
            
        self.tableView.tableFooterView = UIView()
        // Add action for segmented control value changed event
        segment.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        
        self.getData()
    }
    
    @IBAction func CreateTournamentBTN(_ sender: UIButton) {
        self.performSegue(withIdentifier: "CreateTournament", sender: sender)
    }
    
    @objc func segmentValueChanged(_ sender: UISegmentedControl) {
        // Get the selected segment index
        let selectedIndex = sender.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            print("My Matches")
            selectedTab = .myMatches
         
        case 1:
            print("My Tournaments")
            selectedTab = .myTournaments
          
        case 2:
            print("My Teams")
            selectedTab = .myTeams
            
        default:
            break
        }
        
        self.getData()
    }
    
    func getData() {
        switch selectedTab {
            
        case .myMatches :
            geyMyMatches()
            break
            
            
        case .myTeams :
            geyMyTeams()
            break
        case .myTournaments:
            fetchMyTournaments()
            break
        default:
            break
        }
    }
    
    func geyMyTeams() {
        
        FireStoreManager.shared.getTournamentPlayers { players in
            self.myTournamentPlayers = players
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func geyMyMatches() {
        
        FireStoreManager.shared.getTournamentPlayers { myTournamentPlayers in
             
            var data = [Match]()
            
            FireStoreManager.shared.getAllTournamentMatches { matches in
                
              
                for player in myTournamentPlayers {
                     
                    
                    for match in matches {
                        
                        if((match.team1Id == player.teamId) || (match.team2Id == player.teamId)) {
                            data.append(match)
                        }
                    }
                    
                    
                }
                self.myMatchs = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
            
        }
    }
    
    func fetchMyTournaments() {
        // Clear previous tournaments
        tournaments.removeAll()
        
        // Fetch tournaments from Firestore
        db.collection("tournaments").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching tournaments: \(error.localizedDescription)")
                return
            }
            
            for document in querySnapshot!.documents {
                let tournamentData = document.data()
                // Parse tournament data and create a Tournament object
                let tournament = Tournament(
                    name: tournamentData["name"] as? String ?? "",
                    city: tournamentData["city"] as? String ?? "",
                    ground: tournamentData["ground"] as? String ?? "",
                    organizerName: tournamentData["organizerName"] as? String ?? "",
                    OrganizerPhone: tournamentData["OrganizerPhone"] as? String ?? "",
                    startDate: tournamentData["startDate"] as? Date ?? Date(),
                    endDate: tournamentData["endDate"] as? Date ?? Date(),
                    ballType: tournamentData["ballType"] as? String ?? "",
                    pitchType: tournamentData["pitchType"] as? String ?? "",
                    matchType: tournamentData["matchType"] as? String ?? "",
                    otherDetails: tournamentData["otherDetails"] as? String ?? "",
                    logo: tournamentData["logo"] as? String ?? "",
                    doucmentId: document.documentID
                )
                self.tournaments.append(tournament)
            }
            
            // Reload table view data on the main thread
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}




extension MyTournamentsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        switch self.selectedTab {
        case .myMatches:
            return 90
        case .myTournaments:
            return  UITableView.automaticDimension
        case .myTeams:
            return  90
        default:
            break
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        switch self.selectedTab {
        case .myMatches:
            return myMatchs.count
        case .myTournaments:
            return tournaments.count
        case .myTeams:
            return myTournamentPlayers.count
        default:
            break
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.selectedTab {
            
            
        case .myMatches:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TeamListCell", for: indexPath) as! TeamListCell
                   let url = self.myMatchs[indexPath.row]
                   
            cell.itemImage.image = UIImage(named: "match")
                   
            cell.itemTilte.text = (self.myMatchs[indexPath.row].matchName)
            
            return cell
            
         

            
        case .myTournaments:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TournamentCell", for: indexPath)
            
            let tournament = tournaments[indexPath.row]
            
            // Configure the cell with tournament data
        
         
            
            // Additional details
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            let startDateString = dateFormatter.string(from: tournament.startDate)
            let endDateString = dateFormatter.string(from: tournament.endDate)
           
            // Concatenate additional details
            var detailsText = "Name: \( tournament.name ?? "" )\n"
            detailsText += "Start Date: \(startDateString)\n"
            detailsText += "End Date: \(endDateString)\n"
            
            cell.textLabel?.text = detailsText
         
            cell.textLabel?.numberOfLines = 0
            return cell
            
            
            
        case .myTeams:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TeamListCell", for: indexPath) as! TeamListCell
                   let url = self.myTournamentPlayers[indexPath.row]
                   
                   cell.itemImage.sd_setImage(with: URL(string: url.logoImage ?? ""), placeholderImage:nil,options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
                   })
                   
                   cell.itemTilte.text = (self.myTournamentPlayers[indexPath.row].teamName)
              return cell
        
            
        default:
            break
        }
        
        return UITableViewCell()
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if selectedTab == .myTournaments {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            // Add Match Action
            let addMatchAction = UIAlertAction(title: "Matchs", style: .default) { _ in
                
                 
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MatchListVC") as! MatchListVC
                vc.tournament = self.tournaments[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }
            
            alertController.addAction(addMatchAction)
            
           
            let addTeamsAction = UIAlertAction(title: "Add Teams", style: .default) { _ in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TeamListVC") as! TeamListVC
                vc.tournament = self.tournaments[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            alertController.addAction(addTeamsAction)
            
          
            
            let viewInfo = UIAlertAction(title: "View Details", style: .default) { _ in
                
                let  tournament = self.tournaments[indexPath.row]
                
                // Additional details
                           let dateFormatter = DateFormatter()
                           dateFormatter.dateFormat = "MMM d, yyyy"
                           let startDateString = dateFormatter.string(from: tournament.startDate)
                           let endDateString = dateFormatter.string(from: tournament.endDate)
                          
                           // Concatenate additional details
                           var detailsText = "Name: \( tournament.name ?? "" )\n"
                           detailsText += "Start Date: \(startDateString)\n"
                           detailsText += "End Date: \(endDateString)\n"
                           detailsText += "Organizer: \(tournament.organizerName  ?? "")\n"
                           detailsText += "Phone: \(tournament.OrganizerPhone ?? "")\n"
                           detailsText += "Ball Type: \(tournament.ballType)\n"
                           detailsText += "Pitch Type: \(tournament.pitchType)\n"
                           detailsText += "Match Type: \(tournament.matchType)\n"
                           detailsText += "Other Details: \(tournament.otherDetails ?? "")"
                
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "InfoVC") as! InfoVC
                
                vc.data = detailsText
                
                self.navigationController?.pushViewController(vc, animated: true)
               
                
            }
            
            
            alertController.addAction(viewInfo)
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            // Present the action sheet
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = tableView.rectForRow(at: indexPath)
            }
            present(alertController, animated: true, completion: nil)
        }
    }

    
    
    
}
