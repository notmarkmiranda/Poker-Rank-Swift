//
//  RootTabBarViewController.swift
//  Poker Rank Swift
//
//  Created by Mark Miranda on 9/28/19.
//  Copyright © 2019 Mark Miranda. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CodableFirebase

protocol RootTabBarDelegate {
  func reloadTableData(leagues: [League])
}

class RootTabBarViewController: UITabBarController {
  var user = false
  var viewControllersBackup = [UIViewController]()
  let leaguesRef = Firestore.firestore().collection("leagues")
  var rootTabBarDelegate: RootTabBarDelegate?
  var publicLeagues = Leagues.sharedInstance.publicLeagues
  var myLeagues = Leagues.sharedInstance.myLeagues
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadAllLeagues()
    
//    loadLeagues()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Auth.auth().addStateDidChangeListener { (auth, user) in
      self.buildTabBarMenu()
    }
  }
  
  func loadAllLeagues() {
    emptyLeagues(isPublic: true)
    loadLeagues(isPublic: true)
    
    if Auth.auth().currentUser != nil {
      emptyLeagues(isPublic: false)
      loadLeagues(isPublic: false)
    }
  }
  
  func loadLeagues(isPublic: Bool) {
    let query = leagueQuery(isPublic)
    
    var publicDirty = false
    var privateDirty = false
    
    query.getDocuments() { querySnapshot, error in
      if !self.publicLeagues.isEmpty {
        self.publicLeagues.removeAll()
        self.rootTabBarDelegate?.reloadTableData(leagues: [])
      }
      
      if let error = error {
        print("Error: RootTabBarVC#loadLeagues: \(error)")
      } else {
        
        for document in querySnapshot!.documents {
          do {
            let league = try FirebaseDecoder().decode(League.self, from: document.data())
            
            if isPublic {
              Leagues.sharedInstance.publicLeagues.append(league)
              publicDirty = true
            } else {
              Leagues.sharedInstance.myLeagues.append(league)
              privateDirty = true
            }
            
            if publicDirty {
              let indexPath = IndexPath(row: (self.publicLeagues.count - 1), section: 0)
              let userInfoDictionary = ["indexPath": indexPath, "leagues": Leagues.sharedInstance.publicLeagues] as [String : Any]
              NotificationCenter.default.post(name: .addSinglePublicLeague, object: nil, userInfo: userInfoDictionary)
            }

            if privateDirty {
              let indexPath = IndexPath(row: (self.publicLeagues.count - 1), section: 0)
              let userInfoDictionary = ["indexPath": indexPath, "leagues": Leagues.sharedInstance.myLeagues] as [String : Any]

              NotificationCenter.default.post(name: .addSingleOwnedLeague, object: nil, userInfo: userInfoDictionary)
            }
            
          } catch {
            print("Error: RootTabBarVC#loadLeagues: converting snapshot to League model")
          }
        }
        print("IM DONE")
      }
    }
  }
  
  func buildTabBarMenu() {
    guard var allViewControllers = self.viewControllers else { return }
    
    if self.viewControllersBackup.isEmpty {
      self.viewControllersBackup = self.viewControllers!
    }
    
    if self.viewControllersBackup.count != self.viewControllers!.count {
      allViewControllers = self.viewControllersBackup
    }
    
    self.viewControllers = viewControllersBackup
    if Auth.auth().currentUser != nil {
      allViewControllers.remove(at: 3)
    } else {
      allViewControllers.remove(at: 2)
      allViewControllers.remove(at: 1)
    }
    
    self.viewControllers = allViewControllers
  }
  
  func leagueQuery(_ isPublic: Bool) -> Query {
    switch isPublic {
    case true:
      return leaguesRef.whereField("public_league", isEqualTo: true).order(by: "name")
    case false:
      let user = Auth.auth().currentUser!
      return leaguesRef.whereField("user_id", isEqualTo: user.uid).order(by: "name")
    }
  }
  
  func leaguesArray(_ isPublic: Bool) -> [League] {
    return isPublic ? self.publicLeagues : self.myLeagues
  }
  
  func emptyLeagues(isPublic: Bool) {
    isPublic ? Leagues.sharedInstance.publicLeagues.removeAll() : Leagues.sharedInstance.myLeagues.removeAll()
  }
}

extension RootTabBarViewController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
          return false // Make sure you want this as false
        }

        if fromView != toView {
          UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }

        return true
    }
}
