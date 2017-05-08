//
//  Event.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 13/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class Event {
    var creatorID : String?
    var title : String?
    var coordinate : CLLocationCoordinate2D?
    var locationName : String?
    var date : Date?
    var image : UIImage?
    var description : String?
    var vacancies : Int?
    var categorie : String?
    var user : UserProfile!
    
    init(creatorID : String, title : String, coordinate : CLLocationCoordinate2D, date : Date, description : String, locationName : String) {
        self.creatorID = creatorID
        self.title = title
        self.coordinate = coordinate
        self.locationName = locationName
        self.date = date
        self.description = description
    }
    
    static func create(event : Event, eventLocation : CLLocationCoordinate2D, completion: @escaping (Error?) -> ()){
        let eventGroup = DispatchGroup()
        var errorReturn : Error?
        let databaseReference = DatabaseReference.getDatabaseRef()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let eventsReference = databaseReference.child("events").childByAutoId()
        let values = ["userID" : event.creatorID!, "title" : event.title!, "date" : Int((event.date?.timeIntervalSince1970)!), "description" : event.description!, "image" : "party.jpg", "locationName" : event.locationName!, "vacancies" : event.vacancies!, "categorie" : event.categorie!] as [String : Any]
        eventsReference.updateChildValues(values) { (error, reference) in
            eventGroup.enter()
            if error != nil {
                print(error!)
                errorReturn = error
                eventGroup.leave()
                return
            }
            let eventLocationReference = eventsReference.child("location")
            let locationValue = ["latitude" : eventLocation.latitude, "longitude" : eventLocation.longitude] as [String : CLLocationDegrees]
            eventLocationReference.updateChildValues(locationValue, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    errorReturn = err
                    eventGroup.leave()
                    return
                }
                eventGroup.leave()
            })
            eventGroup.notify(queue: .main, execute: {
                completion(errorReturn)
            })
        }
    }
    
    static func findAll(completion: @escaping ([Event]) -> ()){
        let databaseReference = DatabaseReference.getDatabaseRef()
        var events = [Event]()
        databaseReference.child("events").observeSingleEvent(of: .value, with: { (snapShot) in
            let eventGroup = DispatchGroup()
            if let dictionary = snapShot.value as? [String : [String : Any]]{
                events.removeAll()
                for dic in dictionary {
                    eventGroup.enter()
                    let userID = (dic.value["userID"] as! String)
                    let title = (dic.value["title"] as! String)
                    let date = (dic.value["date"] as! Int)
                    let description = (dic.value["description"] as! String)
                    let image = (dic.value["image"] as! String)
                    let categorie = (dic.value["categorie"] as! String)
                    let vacancies = (dic.value["vacancies"] as! Int)
                    var eventCoordinate = CLLocationCoordinate2D()
                    if let location = (dic.value["location"] as? [String : CLLocationDegrees]){
                        var locationValues = [CLLocationDegrees]()
                        for value in location {
                            locationValues.append(value.value)
                        }
                        eventCoordinate = CLLocationCoordinate2D(latitude: locationValues[1], longitude: locationValues[0])
                    }
                    let locationName = (dic.value["locationName"] as! String)
                    let event = Event(creatorID: userID, title: title, coordinate: eventCoordinate, date: Date(timeIntervalSince1970: TimeInterval(date)), description: description, locationName: locationName)
                    event.vacancies = vacancies
                    event.categorie = categorie
                    event.image = UIImage(named: "\(image)")
                    UserProfile.findById(id: userID, completion: { (user) in
                        event.user = user
                        events.append(event)
                        eventGroup.leave()
                    })
                }
                eventGroup.notify(queue: .main, execute: {
                    completion(events)
                })
            }
            else {
                completion(events)
            }
        })
    }
}
