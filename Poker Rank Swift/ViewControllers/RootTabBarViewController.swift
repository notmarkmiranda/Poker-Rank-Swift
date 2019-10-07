//
//  RootTabBarViewController.swift
//  Poker Rank Swift
//
//  Created by Mark Miranda on 9/28/19.
//  Copyright © 2019 Mark Miranda. All rights reserved.
//

import UIKit
import FirebaseAuth

class RootTabBarViewController: UITabBarController {
  var user = false
  var viewControllersBackup = [UIViewController]()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    Leagues.sharedInstance.loadAllLeagues(Auth.auth().currentUser)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
    Auth.auth().addStateDidChangeListener { (auth, user) in
      Leagues.sharedInstance.loadAllLeagues(user)
      self.buildTabBarMenu()
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

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
  }
  */

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
