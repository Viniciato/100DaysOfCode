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
    var editProfileBarButtonItem : UIBarButtonItem!

    // MARK : - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseReference = DatabaseReference.getDatabaseRef()
        self.setupProfileImageView()
        self.loadUserInfos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK : - View Methods
    func setActivityIndicator() {
        self.editProfileBarButtonItem = self.navigationItem.rightBarButtonItem
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.color = UIColor.darkGray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
    }
    
    func setEditButtonItem() {
        self.navigationItem.setRightBarButton(self.editProfileBarButtonItem, animated: true)
    }
    
    func loadUserInfos() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.setActivityIndicator()
        let id = FIRAuth.auth()?.currentUser?.uid
        self.databaseReference.child("users").child(id!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let email = (value?["email"] as! String)
            let name = (value?["name"] as! String)
            User.sharedInstance.setAttributes(id: id!, email: email, name: name)
            let profileImageUrl = (value?["profileImage"] as! String)
            self.downloadProfileImage(url: profileImageUrl)
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
                User.sharedInstance.profileImage = image
                self.setupLabels()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.setEditButtonItem()
            })
        }.resume()
    }
    
    func setupLabels(){
        self.profileImageView.image = User.sharedInstance.profileImage
        self.nameLabel.text = User.sharedInstance.name
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        do {
            try FIRAuth.auth()?.signOut()
            User.sharedInstance.setAttributes(id: "", email: "", name: "")
            User.sharedInstance.profileImage = nil
            ScreenChange.toScreen(bundle: "Main", controllerIndetifier: "LoginPageController")
        } catch {
            SimpleAlert.showAlert(vc: self, title: "Error", message: "Error on logout!")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupLabels()
    }
    
}










