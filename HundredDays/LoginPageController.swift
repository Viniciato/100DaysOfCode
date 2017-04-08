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
        if let firstView = views.first{
            setViewControllers([firstView], direction: .forward, animated: true, completion: nil)}
        
//        self.setViewControllers(self.views, direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
