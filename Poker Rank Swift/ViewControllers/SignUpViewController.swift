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
import CodableFirebase

class SignUpViewController: UIViewController {
  var db = Firestore.firestore()
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var errorMessage: UILabel!
  @IBOutlet weak var displayNameTextField: UITextField!
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
        // TODO => can this be extract to a service class?
        Auth.auth().createUser(withEmail: emailAddress, password: password) { authResult, error in
          guard let user = authResult?.user, error == nil else {
            self.errorMessage.text = error!.localizedDescription
            self.errorMessage.isHidden = false
            print("Error: creating user \(error!.localizedDescription)")
            return
          }
          do {
            if let userId = authResult?.user.uid {
              let userData = ["email": user.email, "displayName": self.displayNameTextField.text ?? "", "uid": authResult?.user.uid ?? ""]
              let newUser = try FirebaseDecoder().decode(User.self, from: userData)
              let usersRef = self.db.collection("users")
//              var ref: DocumentReference? = nil
              usersRef.document(userId).setData(newUser.createDictionary()) { error in
                
              }
              print(newUser)
            }
            
            
          } catch {
            print(error)
            print("Error: could not decode user")
          }
          // decode user as User.self
          // create user in databaseRef for "users"
                    
          
          self.emailAddressTextField.text = ""
          self.passwordTextField.text = ""
          self.passwordConfirmationTextField.text = ""
          self.tabBarController?.selectedIndex = 0
        }
      }
    }
  }
}
