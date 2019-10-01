//
//  LoginViewController.swift
//  Poker Rank Swift
//
//  Created by Mark Miranda on 9/27/19.
//  Copyright © 2019 Mark Miranda. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
  @IBOutlet weak var signInButton: UIButton!
  @IBOutlet weak var emailAddressTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    signInButton.layer.cornerRadius = 5
    
    self.navigationItem.title = "Log In"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
  }
  
  @IBAction func loginButtonTapped(_ sender: UIButton) {
    if let emailAddress = emailAddressTextField.text, let password = passwordTextField.text {
      Auth.auth().signIn(withEmail: emailAddress, password: password) { (user, error) in
        if error == nil {
          self.emailAddressTextField.text = ""
          self.passwordTextField.text = ""
          self.tabBarController?.selectedIndex = 0
        }
      }
    }
  }
}
