//
//  EventCell.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 13/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    // MAKR : - Properties
    var event : Event!
    
    // MARK : - Outlets
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionView: UIView!
    @IBOutlet weak var eventDateView: UIView!
    @IBOutlet weak var monthSymbolLabel: UILabel!
    @IBOutlet weak var eventDayLabel: UILabel!
    @IBOutlet weak var eventScheduleLabel: UILabel!
    @IBOutlet weak var eventCreatorLabel: UILabel!
    @IBOutlet weak var eventCreatorImage: UIImageView!
    
    // MARK : - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupBorderOnViews()
        self.setupProfileImageView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK : - Cell Methods
    func setupBorderOnViews() {
        let views = [self.eventDescriptionView, self.eventDateView]
        for view in views {
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
            view?.layer.cornerRadius = 2.5
        }
        self.eventImageView.layer.cornerRadius = 2.5
        self.eventImageView.translatesAutoresizingMaskIntoConstraints = false
        self.eventImageView.clipsToBounds = true
    }
    
    func setupCell() {
        self.eventImageView.image = self.event.image
        self.eventDescriptionLabel.text = self.event.description
        self.eventLocationLabel.text = self.event.locationName
        self.eventTitleLabel.text = self.event.title
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self.event.date!)
        let day = calendar.component(.day, from: self.event.date!)
        let hour = calendar.component(.hour, from: self.event.date!)
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months![month-1] // month - from your date components
        self.monthSymbolLabel.text = monthSymbol
        self.eventDayLabel.text = "\(day)"
        self.eventScheduleLabel.text = "\(hour)h00"
        self.eventCreatorLabel.text = self.event.user.name?.capitalized
        if self.event.user.profileImage == nil {
            self.event.user.downloadProfileImage(completion: { (bool) in
                if bool {
                    self.refreshProfileImage()
                }
            })
        } else {
            self.refreshProfileImage()
        }
    }
    
    func refreshProfileImage() {
        DispatchQueue.main.async {
            self.eventCreatorImage.image = self.event.user.profileImage
        }
    }
    
    func setupProfileImageView(){
        self.eventCreatorImage.layer.cornerRadius = 15
        self.eventCreatorImage.translatesAutoresizingMaskIntoConstraints = false
        self.eventCreatorImage.clipsToBounds = true
        self.eventCreatorImage.contentMode = .scaleToFill
    }
    
    // MARK : - Cell Actions
    
}
