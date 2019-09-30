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

class SignUpViewController: UIViewController {
    var db = Firestore.firestore()

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = 5
        errorMessage.layer.cornerRadius = 10
        errorMessage.layer.masksToBounds = true
        errorMessage.isHidden = true
        self.navigationItem.title = "Sign Up"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        // check for uniqueness of email address - MAYBE NOT
        // confirm passwords match
        if let password = passwordTextField.text, let passwordConfirmation = passwordConfirmationTextField.text {
            if password.isEmpty == false && password != passwordConfirmation {
                errorMessage.text = "passwords do not match"
                errorMessage.isHidden = false
            } else {
                if let emailAddress = emailTextField.text {
                    Auth.auth().createUser(withEmail: emailAddress, password: password) { (result, error) in
                        if error == nil {
                            print("um, create a new flow?")
//                            self.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
                        }
                    }
                }
                
            }
        }
        // sign up the user?
    }

    @IBAction func editingDidEnd(_ sender: UITextField) {
        errorMessage.isHidden = true
        // check if it is blank
        if sender == emailTextField {
            if let emailAddress = sender.text {
                if emailAddress.isEmpty {
                    errorMessage.text = "email address cannot be blank"
                    errorMessage.isHidden = false
                }
            }
        }
        
        // check if it is unique
    }
    @IBAction func editingDidBegin(_ sender: UITextField) {
        errorMessage.isHidden = true
    }
}
