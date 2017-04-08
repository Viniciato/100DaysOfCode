//
//  HomeViewController.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 07/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goOne(_ sender: UIButton) {
        UIApplication.shared.keyWindow?.rootViewController = storyboard!.instantiateViewController(withIdentifier: "Login")
    }
    

}
