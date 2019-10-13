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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadLeagues()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Auth.auth().addStateDidChangeListener { (auth, user) in
      self.buildTabBarMenu()
    }
  }
  
  func loadLeagues() {
    let query = leaguesRef.whereField("public_league", isEqualTo: true).order(by: "name")
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
            self.publicLeagues.append(league)
            
            let indexPath = IndexPath(row: (self.publicLeagues.count - 1), section: 0)
            let userInfoDictionary = ["indexPath": indexPath, "leagues": self.publicLeagues] as [String : Any]
            NotificationCenter.default.post(name: .addSingleLeague, object: nil, userInfo: userInfoDictionary)
          } catch {
            print("Error: RootTabBarVC#loadLeagues: converting snapshot to League model")
          }
        }
      }
      
//      self.rootTabBarDelegate?.reloadTableData(leagues: self.publicLeagues)
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
