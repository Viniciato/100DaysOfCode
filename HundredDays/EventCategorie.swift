//
//  EventCategorie.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 16/05/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Firebase

class EventCategorie {
    var id : String?
    var name : String!
    
    init(name : String) {
        self.name = name
    }
    
    static func findById(id : String, completion: @escaping (EventCategorie) -> ()){
        let databaseReference = DatabaseReference.getDatabaseRef().child("categories")
        var categorie : EventCategorie!
        let eventCategorieDispatch = DispatchGroup()
        databaseReference.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            eventCategorieDispatch.enter()
            if let value = snapshot.value as? [String : String] {
                let name = (value["name"])
                categorie = EventCategorie(name: name!)
                categorie.id = id
                eventCategorieDispatch.leave()
            } else {
                completion(categorie)
            }
            eventCategorieDispatch.notify(queue: .main, execute: {
                completion(categorie)
            })
        })
    }
    
    static func findAll(completion: @escaping ([EventCategorie]) -> ()){
        let databaseReference = DatabaseReference.getDatabaseRef()
        var categories = [EventCategorie]()
        let eventCategorieDispatch = DispatchGroup()
        databaseReference.child("categories").observeSingleEvent(of: .value, with: { (snapShot) in
            if let dictionary = snapShot.value as? [String : [String : String]]{
                for dic in dictionary {
                    eventCategorieDispatch.enter()
                    let name = (dic.value["name"])
                    let id = dic.key
                    let categorie = EventCategorie(name: name!)
                    categorie.id = id
                    categories.append(categorie)
                    eventCategorieDispatch.leave()
                }
                eventCategorieDispatch.notify(queue: .main, execute: {
                    completion(categories)
                })
            }
            else{completion(categories)}
        })
    }
    
    
    // MARK : - Methods to administrate db...
    func save(){
    }
    
    static func createAll(){
        let categoriesReference = DatabaseReference.getDatabaseRef().child("categories")
        var values : [String : String]!
        let categories : [EventCategorie]!
        categories = [EventCategorie(name: "Sertanejo"), EventCategorie(name: "Eletro"), EventCategorie(name: "Palestra")]
        for categorie in categories {
            values = ["name" : categorie.name] as [String : String]
            categoriesReference.childByAutoId().updateChildValues(values) { (error, reference) in
                if error != nil {
                    print(error!)
                }
            }
        }
    }
    
    
}
