//
//  HomeViewController.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 07/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import GoogleMaps

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK : - Properties
    var events : [Event]!
    var refresher : UIRefreshControl!
    
    // MARK : - Outlets
    @IBOutlet weak var eventsTableView: UITableView!
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.events = [Event]()
        self.eventsTableView.dataSource = self
        self.eventsTableView.delegate = self
        self.setPullToRefresh()
        self.loadEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK : - View Methods
    func setPullToRefresh(){
        self.refresher = UIRefreshControl()
        self.refresher.addTarget(self, action: #selector(HomeViewController.pullRefreshSelector), for: UIControlEvents.valueChanged)
        self.eventsTableView.addSubview(self.refresher)
    }
    
    func pullRefreshSelector() {
        self.loadEvents()
    }
    
    func loadEvents() {
        self.refresher.beginRefreshing()
        Event.findAll { (events) in
            self.events = events
            self.eventsTableView.reloadData()
            self.refresher.endRefreshing()
        }
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
        let event = self.events[indexPath.section]
        cell.event = event
        cell.setupCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 246
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
        let stor = UIStoryboard(name: "Main", bundle: nil)
        let vc = stor.instantiateViewController(withIdentifier: "ShowEventController") as! ShowEventController
        vc.event = self.events[indexPath.section]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

