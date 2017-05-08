//
//  ShowEventController.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 13/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import GoogleMaps

class ShowEventController: UIViewController {
    // MARK : - Properties
    var event : Event!
    var googleMapsView : GMSMapView!
    
    // MARK : - Outlets
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventMonthLabel: UILabel!
    @IBOutlet weak var eventDayLabel: UILabel!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var eventCreatorImageView: UIImageView!
    @IBOutlet weak var eventCreatorName: UILabel!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var eventVacanciesLabel: UILabel!
    
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.event.title
        self.setupViewComponents()
        self.setupViewBorder()
        self.setupProfileImageView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.googleMapsView = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height))
        let position = self.event.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: (position?.latitude)!, longitude: (position?.longitude)!, zoom: 18)
        self.googleMapsView.camera = camera
        let marker = GMSMarker(position: position!)
        marker.title = event.locationName
        marker.map = self.googleMapsView
        self.mapView.addSubview(self.googleMapsView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK : - View Methods
    
    func setupViewComponents() {
        self.eventCreatorName.text = self.event.user.name?.capitalized
        self.eventCreatorImageView.image = self.event.user.profileImage
        self.eventDescriptionTextView.text = self.event.description
        self.eventVacanciesLabel.text = "\(self.event.vacancies!)"
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self.event.date!)
        let day = calendar.component(.day, from: self.event.date!)
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months![month-1]
        self.eventImageView.image = self.event.image
        self.eventLocationLabel.text = self.event.locationName
        self.eventMonthLabel.text = monthSymbol
        self.eventDayLabel.text = "\(day)"
    }
    
    func setupViewBorder() {
        let views = [self.firstView, self.secondView]
        for view in views {
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        }
    }
    
    func setupProfileImageView(){
        self.eventCreatorImageView.layer.cornerRadius = 30
        self.eventCreatorImageView.translatesAutoresizingMaskIntoConstraints = false
        self.eventCreatorImageView.clipsToBounds = true
        self.eventCreatorImageView.contentMode = .scaleToFill
    }
    
    
    // MARK : - View Actions
    
    @IBAction func showUserButton(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "userProfileController") as! UserProfileController
        viewController.user = self.event.user
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func buyTicketsAction(_ sender: UIButton) {
        print("Comprar")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
