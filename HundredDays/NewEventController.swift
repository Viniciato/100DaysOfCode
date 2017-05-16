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

class NewEventController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK : - Properties
    var event = Event()
    var eventLocation : CLLocationCoordinate2D!
    var eventLocationName : String!
    var googleMapsView : GMSMapView!
    var categorie : String!
    var categories = ["Festa","Show Beneficiente","Tecnologia","Palestra"]
    var guests = [String]()
    
    // MARK : - Outlets
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var eventLocationButton: UIButton!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventVacanciesTextView: UITextField!
    @IBOutlet weak var eventCategoryPicker: UIPickerView!
    @IBOutlet weak var eventPrivacySwitch: UISwitch!
    @IBOutlet weak var selectGuestsButton: UIButton!
    @IBOutlet weak var mapView: UIView!
    
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupEventCategoryPicker()
        self.setupDescriptionTextView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupGoogleMapsView()
        print(self.event.guests)
        self.guests = self.event.guests
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK : - View Methods
    func setupGoogleMapsView(){
        if self.googleMapsView == nil {
            self.googleMapsView = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height))
            self.mapView.addSubview(self.googleMapsView)
        }
    }
    
    func setupEventCategoryPicker(){
        self.eventCategoryPicker.dataSource = self
        self.eventCategoryPicker.delegate = self
    }
    
    func setupDescriptionTextView() {
        self.eventDescriptionTextView.layer.borderWidth = 0.5
        self.eventDescriptionTextView.layer.borderColor = UIColor.black.cgColor
    }
    
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
        if self.categorie != nil {
            let userID = FIRAuth.auth()?.currentUser?.uid
            let title = self.eventTitleTextField.text
            let coordinate = self.eventLocation
            let date = self.eventDatePicker.date
            let description = self.eventDescriptionTextView.text
            let locationName = self.eventLocationName
            self.event = Event(creatorID: userID!, title: title!, coordinate: coordinate!, date: date, description: description!, locationName: locationName!)
            self.event.vacancies = 0
            self.event.isPrivateEvent = true
            if !self.eventPrivacySwitch.isOn {
                let vacancies = self.eventVacanciesTextView.text
                self.event.vacancies = Int(vacancies!)
                self.event.isPrivateEvent = false
            }
            self.event.guests = self.guests
            self.event.categorie = self.categorie
            self.event.image = UIImage(named: "party.jpg")
            self.saveEventOnDatabase()
        }
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
    
    @IBAction func selectGuestsAction(_ sender: UIButton) {
        // Abrir view para selecionar os usuarios
    }
    
    @IBAction func isPublicEventSwitch(_ sender: UISwitch) {
        // Implementar funcionalidade de esconder os campos desnecessarios
    }
    
    // MARK : - Methods override of UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categorie = self.categories[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "selectGuestsSegue") {
            let destinationVc = segue.destination as! SelectGuestsController
            destinationVc.user = User.sharedInstance.user
            destinationVc.event = self.event
        }
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
