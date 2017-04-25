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
    var databaseReference : FIRDatabaseReference!
    var isSelfProfile = false
    
    // MARK : - Outlets
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEventsTableView: UITableView!
    @IBOutlet weak var numberOfEventsLabel: UILabel!
    
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseReference = DatabaseReference.getDatabaseRef()
        if self.user == nil {
            self.user = UserProfile(userID: User.sharedInstance.userID!, email: User.sharedInstance.email!, name: User.sharedInstance.name!, profileImageUrl: User.sharedInstance.profileImageUrl!)
            if self.user.profileImage == nil {
                DispatchQueue.global().async {
                    URLSession.shared.dataTask(with: URL(string: self.user.profileImageUrl!)!, completionHandler: { (data, response, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        DispatchQueue.main.async {
                            let image = UIImage(data: data!)
                            self.user.profileImage = image
                            self.userProfileImageView.image = image
                        }
                    }).resume()
                }
            }
        }
        self.setupUserInfos()
        self.events = [Event]()
        self.userEventsTableView.delegate = self
        self.userEventsTableView.dataSource = self
        self.setupOutlets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK : - View Methods
    
    func setupUserInfos() {
        if self.user.userID == User.sharedInstance.userID{
            self.isSelfProfile = true
            self.followButton.setTitle("Editar perfil", for: .normal)
        }
        self.userNameLabel.text = self.user.name?.capitalized
        self.navigationItem.title = self.user.name?.capitalized
        self.eventsOfUser()
    }
    
    func setupOutlets() {
        self.followButton.layer.borderWidth = 1
        self.followButton.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        self.followButton.layer.cornerRadius = 5
        
        self.userProfileImageView.layer.cornerRadius = 30
        self.userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.userProfileImageView.clipsToBounds = true
        self.userProfileImageView.contentMode = .scaleToFill
        if self.isSelfProfile {
            self.userProfileImageView.image = self.user.profileImage
        }
        self.userProfileImageView.image = self.user.profileImage
    }
    
    func eventsOfUser() {
        self.user.events { (events) in
            self.events = events
            self.userEventsTableView.reloadData()
            self.numberOfEventsLabel.text = "\(self.events.count)"
        }
    }
    
    // MARK : - View Actions
    @IBAction func followUser(_ sender: UIButton) {
        if isSelfProfile {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let editProfileViewController = storyBoard.instantiateViewController(withIdentifier: "EditProfileController") as! EditProfileController
            self.navigationController?.pushViewController(editProfileViewController, animated: true)
        }
    }
    
    // MARK : - Methods override by TableView DataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = self.events[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "userEventsCell")
        let monthLabel = cell?.viewWithTag(1) as! UILabel
        let dayLabel = cell?.viewWithTag(2) as! UILabel
        let titleLabel = cell?.viewWithTag(3) as! UILabel
        let addressLabel = cell?.viewWithTag(4) as! UILabel
        addressLabel.text = event.locationName
        titleLabel.text = event.title
        let calendar = Calendar.current
        let month = calendar.component(.month, from: event.date!)
        let day = calendar.component(.day, from: event.date!)
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months![month-1] // month - from your date components
        monthLabel.text = monthSymbol
        dayLabel.text = "\(day)"
        return cell!
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

