//
//  HomeViewController.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 07/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK : - Properties
    var events : [Event]!
    var databaseReference : FIRDatabaseReference!
    
    // MARK : - Outlets
    @IBOutlet weak var eventsTableView: UITableView!
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventsTableView.dataSource = self
        self.eventsTableView.delegate = self
        self.databaseReference = DatabaseReference.getDatabaseRef()
        self.events = [Event]()
        self.loadEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK : - View Methods
    func loadEvents() {
        self.databaseReference.child("events").observeSingleEvent(of: .value, with: { (snapShot) in
            let eventGroup = DispatchGroup()
            if let dictionary = snapShot.value as? [String : [String : Any]]{
                for dic in dictionary {
                    eventGroup.enter()
                    let userID = (dic.value["userID"] as! String)
                    let title = (dic.value["title"] as! String)
                    let location = (dic.value["location"] as! String)
                    let date = (dic.value["date"] as! Int)
                    let description = (dic.value["description"] as! String)
                    let image = (dic.value["image"] as! String)
                    let event = Event(creatorID: userID, title: title, location: location, date: Date(timeIntervalSince1970: TimeInterval(date)), description: description)
                    event.image = UIImage(named: "\(image)")
                    self.events.append(event)
                    eventGroup.leave()
                }
                eventGroup.notify(queue: .main, execute: {
                    self.eventsTableView.reloadData()
                })
            }
        })
    }
    
    // MARK : - View Actions

    
    
    // MARK : - Methods override of TVDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("EventCell", owner: self, options: nil)?.first as! EventCell
        let event = self.events[indexPath.row]
        cell.event = event
        cell.setupCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 237
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 8))
        footerView.backgroundColor = UIColor(red: 232/255, green: 235/255, blue: 237/255, alpha: 1)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showEvent", sender: self)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

