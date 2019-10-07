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
  let leaguesRef = Firestore.firestore().collection("leagues")
  
  var myLeagues = [League]()
  var publicLeagues = [League]()
  
  func loadAllLeagues(_ user: User?) {
    loadLeagues(leagueQuery(), isPublic: true)
    
    if let user = user {
      loadLeagues(leagueQuery(user), isPublic: false)
    }
  }
  
  private func loadLeagues(_ query: Query, isPublic: Bool) {
    query.getDocuments() { querySnapshot, error in
      guard error == nil else {
        print("error retriving leagues: \(error!)")
        return
      }
      
      if self.arrayCount(isPublic) != querySnapshot!.documents.count {
        if isPublic {
          self.publicLeagues.removeAll()
        } else {
          self.myLeagues.removeAll()
        }
      } else {
        print("same number of leagues from response")
        return
      }
      
      for document in querySnapshot!.documents {
        do {
          let league = try FirebaseDecoder().decode(League.self, from: document.data())
          if isPublic {
            self.publicLeagues.append(league)
          } else {
            self.myLeagues.append(league)
          }
        } catch {
          print("could not convert documents to league model")
        }
      }
    }
  }
  
  private func leagueQuery(_ user: User? = nil  ) -> Query {
    if let user = user {
      return leaguesRef.whereField("user_id", isEqualTo: user.uid).order(by: "name")
    } else {
      return leaguesRef.whereField("public_league", isEqualTo: true).order(by: "name")
    }
  }
  
  private func arrayCount(_ isPublic: Bool) -> Int {
    if isPublic {
      return self.publicLeagues.count
    } else {
      return self.myLeagues.count
    }
  }
}
