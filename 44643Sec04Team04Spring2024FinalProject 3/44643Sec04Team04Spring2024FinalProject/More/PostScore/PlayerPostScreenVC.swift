import UIKit
import Eureka

class PostScoreVC: FormViewController {
    
    var player: TournamentPlayers?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if player is not nil
        guard let player = self.player else {
            // Handle error, player is nil
            return
        }
        
        form +++ Section(player.name ?? "")
            <<< IntRow() {
                $0.title = "Runs"
                $0.tag = "runs\(player.playerId ?? "")" // Tag for identification
            }
            <<< IntRow() {
                $0.title = "Balls"
                $0.tag = "balls\(player.playerId ?? "")"
            }
            <<< IntRow() {
                $0.title = "4s"
                $0.tag = "fours\(player.playerId ?? "")"
            }
            <<< IntRow() {
                $0.title = "6s"
                $0.tag = "sixes\(player.playerId ?? "")"
            }

        
        // Add submit button
        form +++ Section()
            <<< ButtonRow() {
                $0.title = "Submit"
                $0.onCellSelection { _, _ in
                    self.submitForm(player: player)
                }
            }
    }
    
    func submitForm(player: TournamentPlayers) {
        // Extract specific values from the form
        guard let runs = form.rowBy(tag: "runs\(player.playerId ?? "")")?.baseValue as? Int,
              let balls = form.rowBy(tag: "balls\(player.playerId ?? "")")?.baseValue as? Int,
              let fours = form.rowBy(tag: "fours\(player.playerId ?? "")")?.baseValue as? Int,
              let sixes = form.rowBy(tag: "sixes\(player.playerId ?? "")")?.baseValue as? Int
       else {
            showAlert(message: "Please fill in all the required fields.")
            return
        }
        
        // Check if any of the required fields are empty
        if runs == 0 || balls == 0 || fours == 0 || sixes == 0  {
            showAlert(message: "Please fill in all the required fields.")
            return
        }
        
        // Use the extracted values
        print("Runs: \(runs)")
        print("Balls: \(balls)")
        print("4s: \(fours)")
        print("6s: \(sixes)")

        // Check if the player scored fifty or hundred
        var haveFiftyInThisMatch = false
        if runs >= 50  {
            haveFiftyInThisMatch = true
        }
        
        var haveHundredInThisMatch = false
        if runs >= 100  {
            haveHundredInThisMatch = true
        }

        // Call saveORUpdatePlayerRecord function from FireStoreManager
        let fireStoreManager = FireStoreManager.shared
        fireStoreManager.saveORUpdatePlayerRecord(playerId: player.playerId ?? "",
                                                  tournamentId: player.tournamentId ?? "",
                                                  teamId: player.teamId ?? "",
                                                  playerName: player.name ?? "",
                                                  runs: runs,
                                                  balls: balls,
                                                  fours: fours,
                                                  sixes: sixes,
                                                  haveFifty: haveFiftyInThisMatch,
                                                  haveHundred: haveHundredInThisMatch) { success, message in
            if success {
                // Show success message or perform any other action
                print("Player record saved successfully")
                
                showOkAlertAnyWhereWithCallBack(message: "Player record saved successfully" ) {
                    self.navigationController?.popViewController(animated: true)
                }
              
            } else {
                // Show error message or handle error
                print("Error: \(message ?? "Unknown error")")
            }
        }
    }

    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
