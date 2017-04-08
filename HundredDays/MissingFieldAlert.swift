//
//  MissingFieldAlert.swift
//  iDrunk
//
//  Created by Vinicius Nadin on 28/02/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class MissingFieldAlert {
    
    // Display an alert on received UIViewController
    static func showAlert(vc : UIViewController, title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(actionOk)
        vc.present(alert, animated: true, completion: nil)
    }
}
