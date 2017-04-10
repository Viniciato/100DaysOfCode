//
//  ProfileController.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 09/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    // MARK : - Properties
    var databaseReference : FIRDatabaseReference!
    var user : User!

    // MARK : - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseReference = FireBase.getDatabaseRef()
        self.setupProfileImageView()
        self.loadUserInfos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK : - View Methods
    func loadUserInfos() {
        let id = FIRAuth.auth()?.currentUser?.uid
        self.databaseReference.child("users").child(id!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let email = (value?["email"] as! String)
            let name = (value?["name"] as! String)
            let profileImage = UIImage(named: "\(value?["profileImage"] as! String).png")
            self.user = User(id: id!, email: email, name: name, profileImage: profileImage!)
            self.setupLabels()
        })
        
    }
    
    func setupLabels(){
        self.profileImageView.image = self.user.profileImage
        self.nameLabel.text = self.user.name
    }
    
    func setupProfileImageView() {
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.profileImageView.clipsToBounds = true
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.layer.cornerRadius = 30
    }
    
    // MARK : - View Actions
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
