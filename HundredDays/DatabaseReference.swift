//
//  FireBase.swift
//  iDrunk
//
//  Created by Vinicius Nadin on 02/03/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Firebase

class DatabaseReference {
    
    static func getDatabaseRef() -> FIRDatabaseReference{
        let database = FIRDatabase.database().reference(fromURL: "https://hundreddays-2796e.firebaseio.com/")
        return database
    }
    
    static func getStorageRef() -> FIRStorageReference{
        let storage = FIRStorage.storage().reference()
        return storage
    }
    
}
