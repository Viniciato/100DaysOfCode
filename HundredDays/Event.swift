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
    var categorie : EventCategorie?
    var user : UserProfile!
    var guests = [String]()
    var isPrivateEvent : Bool?
    
    init(creatorID : String, title : String, coordinate : CLLocationCoordinate2D, date : Date, description : String, locationName : String) {
        self.creatorID = creatorID
        self.title = title
        self.coordinate = coordinate
        self.locationName = locationName
        self.date = date
        self.description = description
    }
    
    init() {}
    
    static func create(event : Event, eventLocation : CLLocationCoordinate2D, completion: @escaping (Error?) -> ()){
        let eventGroup = DispatchGroup()
        var errorReturn : Error?
        let databaseReference = DatabaseReference.getDatabaseRef()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let eventsReference = databaseReference.child("events").childByAutoId()
        let values : [String : Any]!
        values = ["userID" : event.creatorID!, "title" : event.title!, "date" : Int((event.date?.timeIntervalSince1970)!), "description" : event.description!, "image" : "party.jpg", "locationName" : event.locationName!, "vacancies" : event.vacancies!, "categorie" : event.categorie?.id! as Any, "privateEvent" : event.isPrivateEvent!] as [String : Any]
        eventsReference.updateChildValues(values) { (error, reference) in
            eventGroup.enter()
            if error != nil {
                print(error!)
                errorReturn = error
                eventGroup.leave()
                return
            }
            eventGroup.leave()
            let eventLocationReference = eventsReference.child("location")
            let locationValue = ["latitude" : eventLocation.latitude, "longitude" : eventLocation.longitude] as [String : CLLocationDegrees]
            eventLocationReference.updateChildValues(locationValue, withCompletionBlock: { (err, ref) in
                eventGroup.enter()
                if err != nil {
                    print(err!)
                    errorReturn = err
                    eventGroup.leave()
                    return
                }
                eventGroup.leave()
            })
            if event.isPrivateEvent! {
                let eventGuestsReference = eventsReference.child("guests")
                for guest in event.guests {
                    let key = eventGuestsReference.childByAutoId().key
                    let guestValue = ["\(key)" : guest]
                    eventGuestsReference.updateChildValues(guestValue, withCompletionBlock: { (e, d) in
                        eventGroup.enter()
                        if e != nil {
                            print(e!)
                            errorReturn = e
                            eventGroup.leave()
                            return
                        }
                        eventGroup.leave()
                    })
                }
            }
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
                    let privacy = (dic.value["privateEvent"] as! Bool)
                    let userID = (dic.value["userID"] as! String)
                    var eventGuests = [String]()
                    if privacy, let guests = (dic.value["guests"] as? [String : String]){
                        for value in guests {
                            eventGuests.append(value.value)
                        }
                    }
                    if !privacy || eventGuests.contains((FIRAuth.auth()?.currentUser?.uid)!) || userID == FIRAuth.auth()?.currentUser?.uid{
                        eventGroup.enter()
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
                        eventGroup.enter()
                        EventCategorie.findById(id: categorie, completion: { (categorie) in
                            event.categorie = categorie
                            eventGroup.leave()
                        })
                        event.image = UIImage(named: "\(image)")
                        event.isPrivateEvent = privacy
                        if event.isPrivateEvent! {
                            event.guests = eventGuests
                        }
                        UserProfile.findById(id: userID, completion: { (user) in
                            event.user = user
                            events.append(event)
                            eventGroup.leave()
                        })
                    }
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
