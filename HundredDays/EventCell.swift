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
    
    // MARK : - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK : - Cell Methods
    func setupCell() {
        self.eventImageView.image = self.event.image
        self.eventDescriptionLabel.text = self.event.description
        self.eventLocationLabel.text = self.event.location
        self.eventTitleLabel.text = self.event.title
    }
    
    // MARK : - Cell Actions
    
}
