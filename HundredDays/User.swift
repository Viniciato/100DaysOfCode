//
//  User.swift
//  NexMe
//
//  Created by Vinicius Nadin on 02/03/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class User{
    var userID : String?
    var email : String?
    var name : String?
    var profileImage : UIImage?
    static let sharedInstance = User()
    
    private init() {}
    
    func setAttributes (id : String, email : String, name : String){
        self.userID = id
        self.email = email
        self.name = name
    }
    
    
    
    
}
