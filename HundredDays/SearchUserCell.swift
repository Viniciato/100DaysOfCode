//
//  SearchUserCell.swift
//
//
//  Created by Vinicius Nadin on 26/04/17.
//
//

import UIKit
import Firebase

class SearchUserCell: UITableViewCell {
    // MARK : - Properties
    var user : UserProfile!
    var databaseReference : FIRDatabaseReference!
    
    // MARK : - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.databaseReference = DatabaseReference.getDatabaseRef()
        self.setupFollowingButton()
        self.setupProfileImageView()
    }
    
    // MARK : - Methods
    func setupCellLabels(){
        self.followButton.setTitle("seguir", for: .normal)
        self.setFollowButton()
        self.userNameLabel.text = self.user.name?.capitalized
        if self.user.profileImage == nil {
            NotificationCenter.default.addObserver(self, selector: #selector(SearchUserCell.refreshProfileImage), name: NSNotification.Name(rawValue: "imageLoaded\(self.user.userID)"), object: nil)
        }else {
            self.refreshProfileImage()
        }
    }
    
    func refreshProfileImage() {
        NotificationCenter.default.removeObserver(self)
        print("Refresssh")
        self.profileImageView.image = self.user.profileImage
    }
    
    func setFollowButton(){
        if self.user.isFollowingUser(){
            self.followButton.setTitle("seguindo", for: .normal)
        }else{
            self.followButton.setTitle("seguir", for: .normal)
        }
    }
    
    func setupFollowingButton(){
        self.followButton.layer.borderWidth = 1
        self.followButton.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        self.followButton.layer.cornerRadius = 5
    }
    
    func setupProfileImageView(){
        self.profileImageView.layer.cornerRadius = 15
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.profileImageView.clipsToBounds = true
        self.profileImageView.contentMode = .scaleToFill
    }
    
    // MARK : - Actions
    @IBAction func followUserAction(_ sender: UIButton) {
        self.user.followAction()
        self.setFollowButton()
    }
    
    
    
}
