import UIKit

class CreateMatchVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tournament: Tournament?
    var allTeams: [TeamList] = []
    var selectedTeams: Set<TeamList> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchTournamentTeams()
    }
    
    func fetchTournamentTeams() {
        guard let tournamentId = tournament?.doucmentId else { return }
        
        FireStoreManager.shared.getTournamentTeams(tournamentId: tournamentId) { teamList in
            self.allTeams = teamList
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onCreateMatch(_ sender: Any) {
        // Check if exactly two teams are selected
        guard selectedTeams.count == 2 else {
            showAlert(message: "Please select 2 teams")
            return
        }
        
        self.createMatch()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTeams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let team = allTeams[indexPath.row]
        cell.textLabel?.text = "\(team.teamName) \(selectedTeams.contains(team) ? "☑️" : "☐")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let team = allTeams[indexPath.row]
        
        // Toggle selection
        if selectedTeams.contains(team) {
            selectedTeams.remove(team)
        } else {
            // Ensure exactly two teams are selected
            if selectedTeams.count < 2 {
                selectedTeams.insert(team)
            } else {
                // Show an alert if trying to select more than two teams
                showAlert(message: "You can select only 2 teams")
            }
        }
        
        tableView.reloadData()
    }
}

extension CreateMatchVC {
    
    func createMatch() {
        guard selectedTeams.count == 2 else {
            showAlert(message: "Exactly 2 teams should be selected to create a match.")
            return
        }
        
        let teamNames = selectedTeams.map { $0.teamName }
        let teamIds = selectedTeams.map { $0.documentId! }
        let teamLogos = selectedTeams.map { $0.logoImage }
        
        let matchName = "\(teamNames[0]) vs \(teamNames[1])"
        
        FireStoreManager.shared.createMatch(tournamentId: tournament!.doucmentId!, team1Id: teamIds[0], team2Id: teamIds[1], matchName: matchName, logo1: teamLogos[0], logo2: teamLogos[1]) { success, message in
            if success {
                showOkAlertAnyWhereWithCallBack(message: "Match created successfully") {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.showAlert(message: "Error creating match: \(message ?? "Unknown error")")
            }
        }
    }
}
