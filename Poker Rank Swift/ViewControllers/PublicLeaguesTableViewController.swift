//
//  PublicLeaguesTableViewController.swift
//  Poker Rank Swift
//
//  Created by Mark Miranda on 9/28/19.
//  Copyright © 2019 Mark Miranda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import CodableFirebase

class PublicLeaguesTableViewController: UITableViewController {
  var leagues = Leagues.sharedInstance.publicLeagues
  var db = Firestore.firestore()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
    
    loadLeagues()
    tableView.reloadData()
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "Public Leagues"
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return leagues.count
  }

  func loadLeagues() {
    let leaguesRef = db.collection("leagues")
    let query = leaguesRef.whereField("public_league", isEqualTo: true).order(by: "name")
    query.getDocuments() { querySnapshot, error in
      
      if !self.leagues.isEmpty {
        self.leagues.removeAll()
        self.tableView.reloadData()
      }

      if let error = error {
        print("Error getting documents: \(error)")
      } else {
        for document in querySnapshot!.documents {
          do {
            let league = try FirebaseDecoder().decode(League.self, from: document.data())
            self.leagues.append(league)
            let indexPath = IndexPath(row: (self.leagues.count - 1), section: 0)
            self.tableView.insertRows(at: [indexPath], with: .fade)
          } catch {
            print("Error: Could not convert to League Model")
          }
        }
      }
      
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "leagueCell", for: indexPath)

    cell.textLabel?.text = leagues[indexPath.row].name
    if let location = leagues[indexPath.row].location {
      cell.detailTextLabel?.text = location
    }

    return cell
  }

  /*
  // Override to support conditional editing of the table view.
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }
  */

  /*
  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // Delete the row from the data source
      tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
  }
  */

  /*
  // Override to support rearranging the table view.
  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

  }
  */

  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
      // Return false if you do not want the item to be re-orderable.
      return true
  }
  */

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destination.
      // Pass the selected object to the new view controller.
  }
  */

}
