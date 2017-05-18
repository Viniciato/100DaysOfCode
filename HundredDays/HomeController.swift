//
//  HomeController.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 17/05/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

private let categorieCellIdentifier = "eventCategorieCell"

class HomeController: UICollectionViewController {

    // MARK : - Properties
    var categories = [EventCategorie]()
    
    
    // MARK : - Outlets
    
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK : - Methods
    func loadCategories(){
        EventCategorie.findAll { (categories) in
            self.categories = categories
            self.collectionView?.reloadData()
        }
    }
    
    // MARK : - Actions
    
    // MARK : - Overrided Methods
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categorieCellIdentifier, for: indexPath) as! CategorieCell
        cell.categorieNameLabel.text = self.categories[indexPath.row].name
        let rand = Float(arc4random_uniform(255))/255
        let index = Float(indexPath.row)/255
        cell.backgroundColor = UIColor(red: CGFloat(rand+index), green: CGFloat(rand-index), blue: CGFloat(rand/index), alpha: 1)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stor = UIStoryboard(name: "Main", bundle: nil)
        let vc = stor.instantiateViewController(withIdentifier: "EventsViewController") as! EventsViewController
        vc.categorie = self.categories[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

    


















}
