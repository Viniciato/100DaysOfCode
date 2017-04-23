//
//  User.swift
//  NexMe
//
//  Created by Vinicius Nadin on 02/03/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Firebase

class User{
    var userID : String?
    var email : String?
    var name : String?
    var profileImageUrl : String?
    var profileImage : UIImage?
    static let sharedInstance = User()
    
    private init() {}
    
    func setAttributes (id : String, email : String, name : String, url : String){
        self.userID = id
        self.email = email
        self.name = name
        self.profileImageUrl = url
    }
    
    func loadUserInfos(completion: @escaping () -> ()) {
        let id = FIRAuth.auth()?.currentUser?.uid
        let databaseReference = DatabaseReference.getDatabaseRef()
        databaseReference.child("users").child(id!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let email = (value?["email"] as! String)
            let name = (value?["name"] as! String)
            let profileImageUrl = (value?["profileImage"] as! String)
            User.sharedInstance.setAttributes(id: id!, email: email, name: name, url : profileImageUrl)
            completion()
        })
    }
    
}
