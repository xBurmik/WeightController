//
//  ViewController.swift
//  WeightController
//
//  Created by Aleksey on 12.07.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var person : Person!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem .setHidesBackButton(true, animated: true)
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            person = try context.fetch(fetchRequest).last
            if person != nil {
//                print("person is not empty!")
//                print(person.name)
//                print("person age:\(person.age)")
//                print("person height:\(person.height)")
//                print("weight count: \(String(describing: person.weight?.count))")
//                print("person last weight:\(person.weight?.last)")
            } else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let enterVC = storyboard.instantiateViewController(identifier: "EnterViewController")
                show(enterVC, sender: self)
            }
        }catch{print(error.localizedDescription)}
        
    }
}
