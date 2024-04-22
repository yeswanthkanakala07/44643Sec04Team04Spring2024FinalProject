import UIKit

import SDWebImage

class MatchListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var matches: [Match] = []

    var tournament : Tournament?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.registerCells([TeamListCell.self])
        self.tableView.tableFooterView = UIView()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        self.title = "Matches"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchTournamentsMatches()
    }
    
 
    
    @objc func addButtonTapped() {
      
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateMatchVC") as! CreateMatchVC
        vc.tournament = tournament
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    
    
    func fetchTournamentsMatches() {
        
        FireStoreManager.shared.getTournamentMatches(tournamentId: self.tournament!.doucmentId! ) { matchs in
             
            self.matches = matchs
            self.tableView.reloadData()
            
        }
        
    }
}

extension MatchListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerListTournament") as! PlayerListTournament
        vc.matche = self.matches[indexPath.row]
        vc.tournament = self.tournament
        
        vc.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamListCell", for: indexPath) as! TeamListCell
      
        cell.itemImage.image = UIImage(named: "match")
        
        cell.itemTilte.text = self.matches[indexPath.row].matchName
        
        return cell
    }
}



extension MatchListVC {
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            let deletedTeam = matches.remove(at: indexPath.row)
           
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
            FireStoreManager.shared.deleteMatch(doucumentId: deletedTeam.documentId!) { success in
                
                if success {
                    showAlerOnTop(message: "Matche deleted successfully")
                } else {
                    
                    // You might want to re-add the deleted booking if deletion fails
                    self.matches.insert(deletedTeam, at: indexPath.row)
                    tableView.insertRows(at: [indexPath], with: .fade)
                }
            }
            
        }
    }
}
