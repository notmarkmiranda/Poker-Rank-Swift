//
//  LeagueDetailViewController.swift
//  Poker Rank Swift
//
//  Created by Mark Miranda on 10/7/19.
//  Copyright © 2019 Mark Miranda. All rights reserved.
//

import UIKit

class LeagueDetailViewController: UIViewController {
    var league: League?
    @IBOutlet weak var leagueName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let league = league {
            leagueName.text? = league.name
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
