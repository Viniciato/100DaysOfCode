//
//  LoginPageControllerViewController.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 08/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class LoginPageController: UIPageViewController, UIPageViewControllerDataSource {
    
    var views : [UIViewController] = {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let registerView = sb.instantiateViewController(withIdentifier: "RegisterView")
        let loginView = sb.instantiateViewController(withIdentifier: "LoginView")
        return [loginView, registerView]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.setFirstView()
        self.view.backgroundColor = UIColor(red: 244.0, green: 247.0, blue: 250.0, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setFirstView(){
        if let firstView = views.first{
            setViewControllers([firstView], direction: .reverse, animated: true, completion: nil)}
    }
    
    func setSecondView(){
        setViewControllers([views[1]], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = views.index(of: viewController) else{
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard views.count > previousIndex else {
            return nil
        }
        
        return views[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = views.index(of: viewController) else{
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let viewsCount = views.count
        
        guard viewsCount != nextIndex else {
            return nil
        }
        guard viewsCount > nextIndex else {
            return nil
        }
        return views[nextIndex]
    }
}
