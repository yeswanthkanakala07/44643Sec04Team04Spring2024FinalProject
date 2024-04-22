import UIKit

import SDWebImage

class PlayerListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var players: [PlayerList] = []
    
    var team : TeamList?
    var tournament : Tournament?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.registerCells([TeamListCell.self])
        self.tableView.tableFooterView = UIView()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        self.title = "Players"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchTournamentsTeams()
    }
    
 
    
    @objc func addButtonTapped() {
      
    
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure want to Join yourself in the team?", preferredStyle: .alert)
           
           let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
              
        
               let uid = DataSaver.shared.getUID()
               let email = DataSaver.shared.getEmail()
               
               self.sendData()
               
           }
           
           let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
           
           alert.addAction(yesAction)
           alert.addAction(noAction)
           
           present(alert, animated: true, completion: nil)
        
    }
    
    func sendData(){
        
        let uid = DataSaver.shared.getUID()
        let email = DataSaver.shared.getEmail()
        
        FireStoreManager.shared.joinTeam(tournamentId: team?.tournamentId ?? "", teamName: team?.teamName ?? "", logoImage: team?.logoImage ?? "",teamId: self.team?.documentId ?? "", playerName: email, playerId: uid) { success, data in
           
            var msg = "Already Added"
            if (success) {
                msg = "Added"
            }
            
            showOkAlertAnyWhereWithCallBack(message: msg) {
                self.navigationController?.popViewController(animated: true)
            }
          
        }
        
    }
    
    func fetchTournamentsTeams() {
        
        FireStoreManager.shared.getTournamentTeamsPlayer(tournamentId: self.tournament!.doucmentId!, teamId: self.team!.documentId!) { items in
             
            self.players = items
            self.tableView.reloadData()
            
        }
    }
}

extension PlayerListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamListCell", for: indexPath) as! TeamListCell
      
        cell.itemImage.image = UIImage(named: "player")
        
        cell.itemTilte.text = (self.players[indexPath.row].name)
        return cell
    }
}
