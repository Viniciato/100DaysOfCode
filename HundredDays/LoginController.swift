//
//  ViewController.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 06/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goTwo(_ sender: UIButton) {
                UIApplication.shared.keyWindow?.rootViewController = storyboard!.instantiateViewController(withIdentifier: "HomeViewController")
    }
    


}

