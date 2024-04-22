import UIKit

import SDWebImage

class TeamListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var teams: [TeamList] = []
    
    var tournament : Tournament?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.registerCells([TeamListCell.self])
        self.tableView.tableFooterView = UIView()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        self.title = "Teams"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchTournamentsTeams()
    }
    
 
    
    @objc func addButtonTapped() {
      
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTeamVC") as! AddTeamVC
        
        vc.tournamentId = self.tournament!.doucmentId!
        vc.modalPresentationStyle  = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        
        
     
    }
    
    func fetchTournamentsTeams() {
        
        
        FireStoreManager.shared.getTournamentTeams(tournamentId: self.tournament!.doucmentId!) { teams in
             
            self.teams = teams
            self.tableView.reloadData()
            
            
        }
       
    }
}

extension TeamListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerListVC") as! PlayerListVC
        vc.team = self.teams[indexPath.row]
        vc.tournament = self.tournament
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamListCell", for: indexPath) as! TeamListCell
        let url = self.teams[indexPath.row]
        
        cell.itemImage.sd_setImage(with: URL(string: url.logoImage), placeholderImage:nil,options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
        })
        
        cell.itemTilte.text = (self.teams[indexPath.row].teamName)
        return cell
    }
}



extension TeamListVC {
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            let deletedTeam = teams.remove(at: indexPath.row)
           
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
            FireStoreManager.shared.deleteTeam(doucumentId: deletedTeam.documentId!) { success in
                
                if success {
                    showAlerOnTop(message: "Team deleted successfully")
                } else {
                    
                    // You might want to re-add the deleted booking if deletion fails
                    self.teams.insert(deletedTeam, at: indexPath.row)
                    tableView.insertRows(at: [indexPath], with: .fade)
                }
            }
            
        }
    }
}
