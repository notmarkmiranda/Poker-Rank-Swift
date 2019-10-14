//
//  Leagues.swift
//  Poker Rank Swift
//
//  Created by Mark Miranda on 10/5/19.
//  Copyright © 2019 Mark Miranda. All rights reserved.
//

import CodableFirebase
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class Leagues {
  static let sharedInstance = Leagues()
  
  var myLeagues = [League]()
  var publicLeagues = [League]()
}
