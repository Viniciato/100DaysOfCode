//
//  UserProfileController.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 17/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK : - Properties
    var user : UserProfile!
    var events : [Event]!
    
    // MARK : - Outlets
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var eventsButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEventsTableView: UITableView!
    
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.events = [Event]()
        self.userEventsTableView.delegate = self
        self.userEventsTableView.dataSource = self
        self.setupOutlets()
        self.userNameLabel.text = self.user.name?.capitalized
        self.navigationItem.title = self.user.name?.capitalized
        self.eventsOfUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK : - View Methods
    func setupOutlets() {
        self.followButton.layer.borderWidth = 1
        self.followButton.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        self.followButton.layer.cornerRadius = 5
        
        self.userProfileImageView.layer.cornerRadius = 30
        self.userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.userProfileImageView.clipsToBounds = true
        self.userProfileImageView.contentMode = .scaleAspectFit
    }
    
    func eventsOfUser() {
        self.user.events { (events) in
            self.events = events
            self.userEventsTableView.reloadData()
        }

    }
    
    // MARK : - View Actions
    @IBAction func followUser(_ sender: UIButton) {
        print("Seguindo")
    }
    
    // MARK : - Methods override by TableView DataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.events[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stor = UIStoryboard(name: "Main", bundle: nil)
        let vc = stor.instantiateViewController(withIdentifier: "ShowEventController") as! ShowEventController
        vc.event = self.events[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

