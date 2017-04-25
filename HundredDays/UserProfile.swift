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
    var profileImage : UIImage?
    public var description: String { return "id: \(self.userID!), name: \(self.name!), email: \(self.email!)" }
    
    init(userID : String, email : String, name : String, profileImageUrl : String) {
        self.userID = userID
        self.email = email
        self.name = name
        self.profileImageUrl = profileImageUrl
    }
    
    func events(completion: @escaping ([Event]) -> ()) {
        var events = [Event]()
        let eventsDispatchGroup = DispatchGroup()
        let databaseReference = DatabaseReference.getDatabaseRef().child("events")
        databaseReference.queryOrdered(byChild: "userID").queryEqual(toValue: self.userID).observeSingleEvent(of: .value, with: { (snapShot) in
            if let values = snapShot.value as? [String : [String : Any]]{
                for value in values {
                    eventsDispatchGroup.enter()
                    let date = (value.value["date"] as! Int)
                    let description = (value.value["description"] as! String)
                    let image = (value.value["image"] as! String)
                    var eventCoordinate = CLLocationCoordinate2D()
                    if let location = (value.value["location"] as? [String : CLLocationDegrees]){
                        var locationValues = [CLLocationDegrees]()
                        for value in location {
                            locationValues.append(value.value)
                        }
                        eventCoordinate = CLLocationCoordinate2D(latitude: locationValues[1], longitude: locationValues[0])
                    }
                    let locationName = (value.value["locationName"] as! String)
                    let title = (value.value["title"] as! String)
                    let userID = (value.value["userID"] as! String)
                    let event = Event(creatorID: userID, title: title, coordinate: eventCoordinate, date: Date(timeIntervalSince1970: TimeInterval(date)), description: description, locationName: locationName)
                    event.image = UIImage(named: "\(image)")
                    events.append(event)
                    eventsDispatchGroup.leave()
                }
                eventsDispatchGroup.notify(queue: .main, execute: {
                    completion(events)
                })
            } else{
                completion(events)
            }
        })
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
//                    if user.userID != User.sharedInstance.userID {
                        arrayUsers.append(user)
//                    }
                    searchUserDispatch.leave()
                }
                searchUserDispatch.notify(queue: .main, execute: {
                    print("Returnou")
                    completion(arrayUsers)
                })
            } else {
                completion(arrayUsers)
            }
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
