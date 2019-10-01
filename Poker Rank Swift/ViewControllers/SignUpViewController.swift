//
//  SignUpViewController.swift
//  Poker Rank Swift
//
//  Created by Mark Miranda on 9/27/19.
//  Copyright © 2019 Mark Miranda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
  var db = Firestore.firestore()
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var errorMessage: UILabel!
  @IBOutlet weak var emailAddressTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var passwordConfirmationTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
    signUpButton.layer.cornerRadius = 5

    errorMessage.layer.cornerRadius = 10
    errorMessage.layer.masksToBounds = true
    errorMessage.isHidden = true

    self.navigationItem.title = "Sign Up"
    self.navigationItem.backBarButtonItem?.title = ""
  }
  
  @IBAction func editingDidEnd(_ sender: UITextField) {
    if sender == emailAddressTextField {
      if sender.text == "" {
        errorMessage.text = "email address cannot be blank"
        errorMessage.isHidden = false
      }
    }
  }
  
  @IBAction func editingDidBegin(_ sender: UITextField) {
    errorMessage.isHidden = true
  }
  
  @IBAction func signUpButtonTapped(_ sender: UIButton) {
    errorMessage.isHidden = true
    if let password = passwordTextField.text, let passwordConfirmation = passwordConfirmationTextField.text, let emailAddress = emailAddressTextField.text {
      if password != passwordConfirmation {
        errorMessage.text = "passwords must match"
        errorMessage.isHidden = false
      } else {
        Auth.auth().createUser(withEmail: emailAddress, password: password) { authResult, error in
          guard let user = authResult?.user, error == nil else {
            self.errorMessage.text = error!.localizedDescription
            self.errorMessage.isHidden = false
            print("something went wrong: \(error!.localizedDescription)")
            return
          }
          print("\(user.email!) created")
          self.emailAddressTextField.text = ""
          self.passwordTextField.text = ""
          self.passwordConfirmationTextField.text = ""
          self.tabBarController?.selectedIndex = 0
        }
      }
    }
  }
}
