//
//  ScreenChanger.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 12/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class ScreenChange {
    
    // Go to screen passed by parameter
    static func toScreen(bundle : String, controllerIndetifier : String){
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        guard let rootViewController = window.rootViewController else {
            return
        }
        let storyboard = UIStoryboard(name: bundle, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: controllerIndetifier)
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        }, completion: nil)

    }
    
}
