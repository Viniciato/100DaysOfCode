//
//  UserProfile.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 17/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

class UserProfile : CustomStringConvertible{
    var userID : String?
    var email : String?
    var name : String?
    var profileImageUrl : String?
    var profileImage : UIImage!
    var following = [UserKeys]()
    var followers = [UserKeys]()
    fileprivate var databaseReference = DatabaseReference.getDatabaseRef()
    fileprivate var keyUserFollowing : String!
    fileprivate var keySelfFollower : String!
    public var description: String { return "id: \(self.userID!), name: \(self.name!), email: \(self.email!)" }
    
    init(userID : String, email : String, name : String, profileImageUrl : String) {
        self.userID = userID
        self.email = email
        self.name = name
        self.profileImageUrl = profileImageUrl
    }
    
    init() {}
    
    static func findById(id : String, completion: @escaping (UserProfile) -> ()) {
        let databaseReference = DatabaseReference.getDatabaseRef().child("users")
        var user : UserProfile!
        let userDispatch = DispatchGroup()
        databaseReference.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            userDispatch.enter()
            let value = snapshot.value as? [String : Any]
            let email = (value?["email"] as! String)
            let name = (value?["name"] as! String)
            let profileImageUrl = (value?["profileImage"] as! String)
            user = UserProfile(userID: id, email: email, name: name, profileImageUrl: profileImageUrl)
            
            if let following = (value?["following"] as? [String : AnyObject]){
                for val in following {
                    let userKeys = UserKeys(key: val.key, id: val.value as! String)
                    user.following.append(userKeys)
                }
            }
            if let followers = (value?["followers"] as? [String : AnyObject]){
                for val in followers {
                    let userKeys = UserKeys(key: val.key, id: val.value as! String)
                    user.followers.append(userKeys)
                }
            }
            userDispatch.leave()
            userDispatch.notify(queue: .main, execute: {
                completion(user)
            })
        })
    }
    
    func setAttributes(userID : String, email : String, name : String, profileImageUrl : String) {
        self.userID = userID
        self.email = email
        self.name = name
        self.profileImageUrl = profileImageUrl
    }
    
    func downloadProfileImage(completion: @escaping (Bool) -> ()){
        DispatchQueue.global().async {
            let url = URL(string: self.profileImageUrl!)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                let image = UIImage(data: data!)
                self.profileImage = image
                completion(true)
            }.resume()
        }
    }
    
    static func searchUser(name : String, completion: @escaping ([UserProfile]) -> ()){
        let searchUserDispatch = DispatchGroup()
        var databaseReference = DatabaseReference.getDatabaseRef()
        var arrayUsers = [UserProfile]()
        databaseReference = databaseReference.child("users")
        databaseReference.queryOrdered(byChild: "name").queryStarting(atValue: name.lowercased()).queryEnding(atValue: name.lowercased()+"\u{f8ff}").observeSingleEvent(of: .value, with: { (snapShot) in
            if let values = snapShot.value as? [String : [String : Any]]{
                for value in values {
                    searchUserDispatch.enter()
                    let userID = (value.key )
                    let name = (value.value["name"] as! String)
                    let email = (value.value["email"] as! String)
                    let imageUrl = (value.value["profileImage"] as! String)
                    let user = UserProfile(userID: userID, email: email, name: name, profileImageUrl: imageUrl)
                    if let following = (value.value["following"] as? [String : AnyObject]){
                        for val in following {
                            let userKeys = UserKeys(key: val.key, id: val.value as! String)
                            user.following.append(userKeys)
                        }
                    }
                    if let followers = (value.value["followers"] as? [String : AnyObject]){
                        for val in followers {
                            let userKeys = UserKeys(key: val.key, id: val.value as! String)
                            user.followers.append(userKeys)
                        }
                    }
                    if user.userID != User.sharedInstance.user.userID {
                        arrayUsers.append(user)
                    }
                    searchUserDispatch.leave()
                }
                searchUserDispatch.notify(queue: .main, execute: {
                    completion(arrayUsers)
                })
            } else {
                completion(arrayUsers)
            }
        })
    }
    
    func followAction() {
        let key = self.databaseReference.child("users").childByAutoId().key
        let following = ["following/\(key)" : self.userID]
        let followers = ["followers/\(key)" : User.sharedInstance.user.userID]
        if self.isFollowing() {
            self.databaseReference.child("users").child(User.sharedInstance.user.userID!).child("following").child(keyUserFollowing).removeValue()
            self.databaseReference.child("users").child(self.userID!).child("followers").child(keySelfFollower).removeValue()
        } else {
            self.databaseReference.child("users").child(User.sharedInstance.user.userID!).updateChildValues(following)
            self.databaseReference.child("users").child(self.userID!).updateChildValues(followers)
            self.followers.append(UserKeys(key: key, id: User.sharedInstance.user.userID!))
            User.sharedInstance.user.following.append(UserKeys(key: key, id: self.userID!))
        }
    }
    
    fileprivate func isFollowing() -> Bool {
        let fwing = User.sharedInstance.user.following
        let fllwers = self.followers
        var following = false
        for i in 0..<fwing.count{
            if fwing[i].id == self.userID{
                self.keyUserFollowing = fwing[i].key
                User.sharedInstance.user.following.remove(at: i)
                following = true
            }
        }
        if following {
            for i in 0..<fllwers.count{
                if fllwers[i].id == User.sharedInstance.user.userID{
                    self.keySelfFollower = fllwers[i].key
                    self.followers.remove(at: i)
                }
            }
        }
        return following
    }
    
    func isFollowingUser() -> Bool {
        for user in User.sharedInstance.user.following{
            if user.id == self.userID{
                return true
            }
        }
        return false
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
