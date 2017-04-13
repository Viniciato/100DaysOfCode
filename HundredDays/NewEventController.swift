//
//  NewEventController.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 13/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Firebase

class NewEventController: UIViewController {
    // MARK : - Properties
    var databaseReference : FIRDatabaseReference!
    var event : Event!
    
    // MARK : - Outlets
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var eventLocationTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseReference = DatabaseReference.getDatabaseRef()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK : - View Methods
    func verifyFields() -> Bool{
        if !(self.eventTitleTextField.text?.isEmpty)! {
            if !(self.eventLocationTextField.text?.isEmpty)! {
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
        let location = self.eventLocationTextField.text
        let date = self.eventDatePicker.date
        let description = self.eventDescriptionTextView.text
        self.event = Event(creatorID: userID!, title: title!, location: location!, date: date, description: description!)
        self.event.image = UIImage(named: "party.jpg")
        self.saveEventOnDatabase()
    }
    
    func saveEventOnDatabase() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let eventsReference = self.databaseReference.child("events").childByAutoId()
        let values = ["userID" : self.event.creatorID!, "title" : self.event.title!, "location" : self.event.location!, "date" : Int((self.event.date?.timeIntervalSince1970)!), "description" : self.event.description!, "image" : "party.jpg"] as [String : Any]
        eventsReference.updateChildValues(values) { (error, reference) in
            if error != nil {
                print(error!)
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

