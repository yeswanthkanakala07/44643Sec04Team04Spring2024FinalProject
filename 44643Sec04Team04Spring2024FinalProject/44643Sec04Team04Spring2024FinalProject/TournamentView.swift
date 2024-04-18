//
//  TournamentView.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Yaswanth Kanakala on 4/14/24.
//

import UIKit
import Firebase

class TournamentView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var TournamentIV: UIImageView!
    
    @IBOutlet weak var decriptionLBL: UILabel!
    
    var tournament = Tournament(name: "",city: "",ground: "",organizerName: "organizerName",organizerPhone: "OrganizerPhone", startDate: Timestamp(), endDate: Timestamp(), ballType: "ballType", pitchType: "pitchType", matchType: "matchType", otherDetails: "otherDetails",logo: "", teams: [])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    func loadView() {
        let nib = UINib(nibName: "TournamentView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
}
