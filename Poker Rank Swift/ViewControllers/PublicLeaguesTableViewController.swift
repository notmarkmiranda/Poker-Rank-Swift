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
//  var leagues = Leagues.sharedInstance.publicLeagues
  var db = Firestore.firestore()
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
    self.navigationItem.title = "Public Leagues"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tabBarController = navigationController?.tabBarController as! RootTabBarViewController
    tabBarController.rootTabBarDelegate = self
    NotificationCenter.default.addObserver(self, selector: #selector(publicLeaguesLoaded), name: .didLoadPublicLeagues, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(addSingleLeague), name: .addSinglePublicLeague, object: nil)
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Leagues.sharedInstance.publicLeagues.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "leagueCell", for: indexPath)

    cell.textLabel?.text = Leagues.sharedInstance.publicLeagues[indexPath.row].name
    if let location = Leagues.sharedInstance.publicLeagues[indexPath.row].location {
      cell.detailTextLabel?.text = location
    }
    print("HERE: \(Leagues.sharedInstance.publicLeagues.count)")
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let league = Leagues.sharedInstance.publicLeagues[indexPath.row]
    if let viewController = storyboard?.instantiateViewController(identifier: "LeagueDetailViewController") as? LeagueDetailViewController {
      viewController.league = league
      navigationController?.pushViewController(viewController, animated: true)
    }
  }
  
  @objc
  func publicLeaguesLoaded() {
    print("LEAGUES LOADED!")
  }
  
  @objc
  func addSingleLeague(_ notification: Notification) {
    if let indexPath = notification.userInfo?["indexPath"] as? IndexPath, let newLeagues = notification.userInfo?["leagues"] as? [League] {
      print(Leagues.sharedInstance.publicLeagues)
      tableView.insertRows(at: [indexPath], with: .fade)
    }
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

extension PublicLeaguesTableViewController: RootTabBarDelegate {
  func reloadTableData(leagues: [League] = []) {
//    self.leagues = leagues
    tableView.reloadData()
  }
}
