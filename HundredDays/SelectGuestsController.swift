//
//  SelectGuestsController.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 07/05/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class SelectGuestsController: UITableViewController {
    
    // MARK : - Properties
    var user : UserProfile!
    var event : Event!
    var followingUsers = [UserProfile]()
    var guests = [String]()
    var refresher : UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refresher = UIRefreshControl()
        self.refresher.addTarget(self, action: #selector(SelectGuestsController.pullRefreshSelector), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refresher)
        self.pullRefreshSelector()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followingUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestUsersCell", for: indexPath)
        cell.textLabel?.text = self.followingUsers[indexPath.row].name?.capitalized
        return cell
    }
    
    // MARK : - View Methods
    
    func pullRefreshSelector(){
        let userDispatch = DispatchGroup()
        for user in user.following {
            userDispatch.enter()
            UserProfile.findById(id: user.id) { (user) in
                self.followingUsers.append(user)
                userDispatch.leave()
            }
        }
        userDispatch.notify(queue: .main, execute: {
            self.refresher.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    // MARK : - View Actions
    @IBAction func finishGuestSelection(_ sender: UIBarButtonItem) {
        self.event.guests = self.guests
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.guests.contains(self.user.following[indexPath.row].id){
            self.guests.append(self.user.following[indexPath.row].id)
        }
    }
    
    
    
    
}
