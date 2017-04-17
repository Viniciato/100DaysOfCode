//
//  NewEventController.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 13/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Firebase

class NewEventController: UIViewController {
    // MARK : - Properties
    var event : Event!
    var eventLocation : CLLocationCoordinate2D!
    var eventLocationName : String!
    var googleMapsView : GMSMapView!
    
    // MARK : - Outlets
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var eventLocationButton: UIButton!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var mapView: UIView!
    
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.googleMapsView == nil {
            self.googleMapsView = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height))
            self.mapView.addSubview(self.googleMapsView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK : - View Methods
    func verifyFields() -> Bool{
        if !(self.eventTitleTextField.text?.isEmpty)! {
            if !(self.eventLocation == nil) {
                if !(self.eventDescriptionTextView.text.isEmpty){
                    return true
                }
            }
        }
        return false
    }
    
    func createEvent() {
        let userID = FIRAuth.auth()?.currentUser?.uid
        let title = self.eventTitleTextField.text
        let coordinate = self.eventLocation
        let date = self.eventDatePicker.date
        let description = self.eventDescriptionTextView.text
        let locationName = self.eventLocationName
        self.event = Event(creatorID: userID!, title: title!, coordinate: coordinate!, date: date, description: description!, locationName: locationName!)
        self.event.image = UIImage(named: "party.jpg")
        self.saveEventOnDatabase()
    }
    
    func saveEventOnDatabase() {
        Event.create(event: self.event, eventLocation: self.eventLocation) { (error) in
            if error != nil {
                SimpleAlert.showAlert(vc: self, title: "Error", message: "\(error)")
                return
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.backToParent()
        }
    }
    
    func backToParent() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK : - View Actions
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.backToParent()
    }
    
    @IBAction func createAction(_ sender: UIBarButtonItem) {
        if self.verifyFields() {
            self.createEvent()
        }
    }
    
    @IBAction func searchAddress(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}

extension NewEventController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.eventLocationLabel.text = place.name
        let position = place.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 18)
        self.googleMapsView.camera = camera
        let marker = GMSMarker(position: position)
        marker.title = place.name
        marker.map = self.googleMapsView
        self.eventLocation = position
        self.eventLocationName = place.formattedAddress
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
