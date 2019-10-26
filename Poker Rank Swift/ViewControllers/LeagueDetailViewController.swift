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
  @IBOutlet weak var seasonsCount: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let league = league {
      leagueName.text? = league.name
      if let seasons = league.seasons {
        seasonsCount.text? = "Seasons Count: \(seasons.count)"
      } else {
        seasonsCount.text? = "Seasons Count: 0"
      }
      
    }
    
  }
}
