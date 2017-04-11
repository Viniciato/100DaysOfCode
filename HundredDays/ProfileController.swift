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
            let profileImageUrl = (value?["profileImage"] as! String)
            self.downloadProfileImage(url: profileImageUrl)
            self.user = User(id: id!, email: email, name: name)
        })
    }
    
    func downloadProfileImage(url : String){
        let profileImageGroup = DispatchGroup()
        let profileUrl = URL(string: url)
        var image : UIImage!
        URLSession.shared.dataTask(with: profileUrl!) { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            profileImageGroup.enter()
            DispatchQueue.main.async {
                image = UIImage(data: data!)
                profileImageGroup.leave()
            }
            profileImageGroup.notify(queue: .main, execute: {
                self.user.profileImage = image
                print(image.size)
                self.setupLabels()
            })
        }.resume()
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
    
    @IBAction func teste(_ sender: UIBarButtonItem) {
        let stor = UIStoryboard(name: "Main", bundle: nil)
        let vc = stor.instantiateViewController(withIdentifier: "EditProfileController") as! EditProfileController
        vc.user = self.user
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
