//
//  CreateTournamentVC.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Yaswanth Kanakala on 3/27/24.
//

import UIKit
import Eureka

class CreateTournamentVC: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func set_form(){
        form +++ Section()
        <<< TextRow(){ row in
                        row.title = "Organizer"
                        row.placeholder = "Enter text here"
                    }
        <<< TextRow(){ row in
                        row.title = "Tournament Name"
                        row.placeholder = "Enter text here"
                    }
        
    }
    
}
