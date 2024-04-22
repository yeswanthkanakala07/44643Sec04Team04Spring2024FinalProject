import UIKit
import SDWebImage

class PlayerListTournament: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var matche: Match?
    var tournament: Tournament?
    var tournamentPlayers: [TournamentPlayers] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerCells([TeamListCell.self])
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = "Players of the Match"
        
        guard let matche = matche, let tournament = tournament else {
            return
        }
        
//        FireStoreManager.shared.getAllTournamentPlayers { players in
//            self.tournamentPlayers = players
//            self.tableView.reloadData()
//        }
//        
        
        FireStoreManager.shared.getAllTournamentPlayers { players in
            // Filter out duplicate players based on player ID
            var uniquePlayers: [TournamentPlayers] = []
            var playerIDs: Set<String> = Set()
            for player in players {
                if !playerIDs.contains(player.playerId!) {
                    uniquePlayers.append(player)
                    playerIDs.insert(player.playerId!)
                }
            }
            
            // Filter players belonging to the current tournament
            self.tournamentPlayers = uniquePlayers.filter { $0.tournamentId == tournament.doucmentId }
            self.tableView.reloadData()
        }

        
    }
}

extension PlayerListTournament: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tournamentPlayers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        let vc = PostScoreVC()
        vc.player = self.tournamentPlayers[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamListCell", for: indexPath) as! TeamListCell
      
        cell.itemImage.image = UIImage(named: "player")
        
        cell.itemTilte.text = (self.tournamentPlayers[indexPath.row].name)
        return cell
    }
}
