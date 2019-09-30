//
//  LeaguesTableViewController.swift
//  Poker Rank Swift
//
//  Created by Mark Miranda on 9/25/19.
//  Copyright © 2019 Mark Miranda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase

class LeaguesTableViewController: UITableViewController {
    var leagues = [League]()
    var db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
        if leagues.isEmpty {
            loadLeagues()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Public Leagues"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if Auth.auth().currentUser != nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        }
        self.navigationItem.rightBarButtonItem = rightBarButtonItem()
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


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = leagues[indexPath.row].name
        if let location = leagues[indexPath.row].location {
            cell.detailTextLabel?.text = location
        }
        return cell
    }
    
    func loadLeagues() {
        let leaguesRef = db.collection("leagues")
        let query = leaguesRef.whereField("public_league", isEqualTo: true).order(by: "name")
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let league = try! FirebaseDecoder().decode(League.self, from: document.data())
                    self.leagues.append(league)
                    let indexPath = IndexPath(row: self.leagues.count - 1, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    func rightBarButtonItem() -> UIBarButtonItem {
        if Auth.auth().currentUser != nil {
            return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        } else {
            return UIBarButtonItem(title: "Log In", style: .plain, target: self, action: #selector(loginButtonTapped))
        }
        
    }
    
    @objc
    func loginButtonTapped() {
        print("Button tapped!")
        performSegue(withIdentifier: "leaguesToLogin", sender: self)
    }
    
    @objc
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
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
