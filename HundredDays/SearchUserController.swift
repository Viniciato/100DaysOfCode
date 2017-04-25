//
//  SearchUserController.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 17/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class SearchUserController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK : - Properties
    var users : [UserProfile]!
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK : - Outlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var usersTableView: UITableView!
    
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.users = [UserProfile]()
        self.usersTableView.delegate = self
        self.usersTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK : - View Methods
    
    // MARK : - View Actions
    @IBAction func searchUser(_ sender: UIButton) {
        self.resignFirstResponder()
        if !(self.userNameTextField.text?.isEmpty)! {
            UserProfile.searchUser(name: self.userNameTextField.text!) { (users) in
                self.users = users
                self.usersTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchUserCell")
        let user = self.users[indexPath.row]
        let nameField = cell?.viewWithTag(1) as! UILabel
        let profileImage = cell?.viewWithTag(2) as! UIImageView
        profileImage.layer.cornerRadius = 15
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleToFill
        nameField.text = user.name
        if user.profileImage == nil {
            DispatchQueue.global().async {
                let url = URL(string: user.profileImageUrl!)
                URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    let image = UIImage(data: data!)
                    self.users[indexPath.row].profileImage = image
                    DispatchQueue.main.async {
                        profileImage.image = image
                    }
                }.resume()
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.becomeFirstResponder()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "userProfileController") as! UserProfileController
        viewController.user = self.users[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

