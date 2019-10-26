//
//  MyLeaguesTableViewController.swift
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

class MyLeaguesTableViewController: UITableViewController, NewLeagueViewControllerDelegate {
//  var myLeagues = Leagues.sharedInstance.myLeagues
  var db = Firestore.firestore()
  var user = Auth.auth().currentUser
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
//    loadLeagues()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "My Leagues"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(segueToCreate))
    
    NotificationCenter.default.addObserver(self, selector: #selector(addSingleLeague), name: .addSingleOwnedLeague, object: nil)
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return Leagues.sharedInstance.myLeagues.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "myLeagueCell", for: indexPath)

    let league = Leagues.sharedInstance.myLeagues[indexPath.row]
    cell.textLabel?.text = league.name
    if let location = league.location {
      cell.detailTextLabel?.text = location
    }

    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? NewLeagueViewController {
      destination.newLeagueViewControllerDelegate = self
    }
  }
  
  @objc func addSingleLeague(_ notification: Notification) {
    if let indexPath = notification.userInfo?["indexPath"] as? IndexPath{
      tableView.insertRows(at: [indexPath], with: .fade)
    }
  }

  @objc func segueToCreate() {
    performSegue(withIdentifier: "myLeaguesToCreate", sender: self)
  }
  
  func appendNewLeague(_ league: League) {
    Leagues.sharedInstance.myLeagues.append(league)
    if league.public_league {
      Leagues.sharedInstance.publicLeagues.append(league)
    }
    let indexPath = IndexPath(row: (Leagues.sharedInstance.myLeagues.count - 1), section: 0)
    tableView.insertRows(at: [indexPath], with: .fade)
  }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        
        let league = Leagues.sharedInstance.myLeagues[indexPath.row]
        
        if let leagueID = league.id {
          db.collection("leagues").document(leagueID).delete { error in
            guard error == nil else {
              print("Error: MyLeaguesTableVC#tableview(editingStyle): deleting league")
              return
            }
            
            if league.public_league, let index = Leagues.sharedInstance.publicLeagues.firstIndex(where: { $0.id == leagueID }) {
              Leagues.sharedInstance.publicLeagues.remove(at: index)
            }
            
            Leagues.sharedInstance.myLeagues.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
          }
        }
      }
    }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let league = Leagues.sharedInstance.myLeagues[indexPath.row]
    if let viewController = storyboard?.instantiateViewController(identifier: "LeagueDetailViewController") as? LeagueDetailViewController {
      // collect all the seasons based on league_id
      let seasonRef = db.collection("seasons")
      
      seasonRef.whereField("league_id", isEqualTo: league.id).getDocuments() { querySnapshot, error in
        guard error == nil else {
          print("Error: MyLeaguesTVC#tableView(didSelectRowAt): loading seasons")
          return
        }
        
        // emppty seasons
        
        // convert and load!
      }
      
      viewController.league = league
      navigationController?.pushViewController(viewController, animated: true)
    }
  }

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
