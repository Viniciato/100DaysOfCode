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
    var user = UserProfile()
    static let sharedInstance = User()
    
    private init() {}
    
    func loadUserInfos(completion: @escaping () -> ()) {
        let id = FIRAuth.auth()?.currentUser?.uid
        UserProfile.findById(id: id!) { (user) in
            User.sharedInstance.user = user
            User.sharedInstance.user.downloadProfileImage(completion: { (bool) in})
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userLoaded"), object: nil)
        }
    }
}
