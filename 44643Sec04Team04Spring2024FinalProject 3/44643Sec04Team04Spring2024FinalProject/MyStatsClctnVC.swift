import UIKit

class MyStatsClctnVC: UIViewController {
    
    @IBOutlet weak var matchValue: UILabel!
    @IBOutlet weak var runs: UILabel!
    @IBOutlet weak var avg: UILabel!
    @IBOutlet weak var thirtty: UILabel!
    @IBOutlet weak var fifty: UILabel!
    @IBOutlet weak var hundred: UILabel!
    @IBOutlet weak var duck: UILabel!
    @IBOutlet weak var toalSixes: UILabel!
    @IBOutlet weak var totalFours: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var stack: UIStackView!
    
    var playerData: [PlayerData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Call the function to set random values when the view loads
       
        
     
        self.name.text = DataSaver.shared.getEmail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let id = DataSaver.shared.getUID()
        
        FireStoreManager.shared.getRecords(playerId: id) { playerData in
            self.playerData = playerData
            // Calculate stats and update UI
            self.updateUIWithPlayerStats()
        }
    }
  
    
    func updateUIWithPlayerStats() {
        var totalBalls = 0
        var totalFoursHit = 0
        var totalSixesHit = 0
        var total30s = 0
        var total50s = 0
        var total100s = 0
        var totalDucks = 0
        
        for data in playerData {
            totalBalls += data.runs
            totalFoursHit += data.fours
            totalSixesHit += data.sixes
            if data.runs >= 30 && data.runs < 50 {
                total30s += 1
            } else if data.runs >= 50 && data.runs < 100 {
                total50s += 1
            } else if data.runs >= 100 {
                total100s += 1
            } else if data.runs == 0 {
                totalDucks += 1
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.matchValue.text = "\(self?.playerData.count ?? 0)"
            self?.runs.text = "\(totalBalls)"
            self?.thirtty.text = "\(total30s)"
            self?.fifty.text = "\(total50s)"
            self?.hundred.text = "\(total100s)"
            self?.duck.text = "\(totalDucks)"
            self?.toalSixes.text = "\(totalSixesHit)"
            self?.totalFours.text = "\(totalFoursHit)"
            
            // Calculate and update average
            if let totalRuns = self?.playerData.reduce(0, { $0 + $1.runs }) {
                let average = Double(totalRuns) / Double(self?.playerData.count ?? 1)
                self?.avg.text = String(format: "%.2f", average)
            }
        }
    }
}
