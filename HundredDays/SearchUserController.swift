//
//  SearchUserController.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 17/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class SearchUserController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    // MARK : - Properties
    var users : [UserProfile]!
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK : - Outlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var searchUserTextField: UITextField!
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.users = [UserProfile]()
        self.usersTableView.delegate = self
        self.usersTableView.dataSource = self
        self.searchUserTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
    
    @IBAction func clearSearchs(_ sender: UIBarButtonItem) {
        self.users = [UserProfile]()
        self.usersTableView.reloadData()
    }
    
    // MARK : - View Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SearchUserCell", owner: self, options: nil)?.first as! SearchUserCell
        let user = self.users[indexPath.row]
        cell.user = user
        cell.setupCellLabels()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.becomeFirstResponder()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "userProfileController") as! UserProfileController
        let cell = tableView.cellForRow(at: indexPath) as! SearchUserCell!
        viewController.user = cell?.user
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.searchUser(UIButton())
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.usersTableView.reloadData()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

