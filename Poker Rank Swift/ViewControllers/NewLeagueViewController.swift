//
//  NewLeagueViewController.swift
//  Poker Rank Swift
//
//  Created by Mark Miranda on 10/2/19.
//  Copyright © 2019 Mark Miranda. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class NewLeagueViewController: UIViewController {
  let db = Firestore.firestore()
  var newLeagueViewControllerDelegate: NewLeagueViewControllerDelegate?
  
  @IBOutlet weak var createLeagueButton: UIButton!
  @IBOutlet weak var publicLeagueSwitch: UISwitch!
  @IBOutlet weak var leagueNameTextField: UITextField!
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var errorMessage: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    createLeagueButton.layer.cornerRadius = 5
//    self.navigationItem.title = "Create New League"
//    navigationController?.navigationBar.prefersLargeTitles = true
    errorMessage.isHidden = true
    publicLeagueSwitch.isOn = false
    
  }
    
  @IBAction func createLeagueTapped(_ sender: UIButton) {
    if let leagueName = leagueNameTextField.text, let userId = Auth.auth().currentUser?.uid {
      var newLeague = League(name: leagueName, location: locationTextField.text , public_league: publicLeagueSwitch.isOn, user_id: userId)
      let leagueRef = db.collection("leagues")
      var ref: DocumentReference? = nil
      ref = leagueRef.addDocument(data: newLeague.createDictionary()) { error in
        if let error = error {
          print("Error adding document: \(error)")
        } else {
          if let documentId = ref?.documentID {
            newLeague.id = documentId
            self.createInitialSeason(leagueId: documentId)
          }
          self.newLeagueViewControllerDelegate?.appendNewLeague(newLeague)
          
          self.dismiss(animated: true, completion: nil)
        }
      }
    } else {
      print("error: something went wrong")
    }
  }
  
  func createInitialSeason(leagueId: String) {
    let seasonRef = db.collection("seasons")
    var ref: DocumentReference? = nil
    ref = seasonRef.addDocument(data: [ "league_id": leagueId, "isActive": true, "completed": false ]) { error in
      if let error = error {
        print("Error creating initial season: \(error)")
      } else {
        if let documentId = ref?.documentID {
          print("Created Initial Season: \(documentId)")
        }
      }
    }
  }
  
  @IBAction func editingDidEnd(_ sender: UITextField) {
    
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

protocol NewLeagueViewControllerDelegate: AnyObject {
  func appendNewLeague(_ league: League)
}
