//
//  Event.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 13/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class Event {
    var creatorID : String?
    var title : String?
    var location : String?
    var date : Date?
    var image : UIImage?
    var description : String?
    
    init(creatorID : String, title : String, location : String, date : Date, description : String) {
        self.creatorID = creatorID
        self.title = title
        self.location = location
        self.date = date
        self.description = description
    }
}
