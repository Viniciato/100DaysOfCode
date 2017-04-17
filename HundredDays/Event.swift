//
//  Event.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 13/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import GoogleMaps

class Event {
    var creatorID : String?
    var title : String?
    var coordinate : CLLocationCoordinate2D?
    var locationName : String?
    var date : Date?
    var image : UIImage?
    var description : String?
    
    init(creatorID : String, title : String, coordinate : CLLocationCoordinate2D, date : Date, description : String, locationName : String) {
        self.creatorID = creatorID
        self.title = title
        self.coordinate = coordinate
        self.locationName = locationName
        self.date = date
        self.description = description
    }
}
