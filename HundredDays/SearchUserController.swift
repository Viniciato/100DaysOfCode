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
        if !(self.userNameTextField.text?.isEmpty)! {
            UserProfile.searchUser(name: self.userNameTextField.text!) { (users) in
                self.users = users
                self.usersTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchUserCell")
        let nameField = cell?.viewWithTag(1) as! UILabel
        nameField.text = users[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "userProfileController") as! UserProfileController
        viewController.user = self.users[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

