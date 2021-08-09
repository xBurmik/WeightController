//
//  DataModel.swift
//  WeightController
//
//  Created by Aleksey on 04.08.2021.
//

import UIKit
import CoreData

class DataModel {
    
    var person: Person?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchData() -> Person? {
        // Get data from base
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        do{
            person = try context.fetch(fetchRequest).last ?? nil
        }catch{print(error.localizedDescription)}
        guard person != nil else {return nil}
        return person
    }
    
    func editData (name: String, gender: Bool, birthday: Date, height: Int16, weight: [Double]) {
        // Clean entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        let butchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do{
            try context.execute(butchRequest)
        }catch{print(error.localizedDescription)}
        
        // Rewrote entity
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        let personObject = NSManagedObject(entity: entity!, insertInto: context) as! Person
        
        personObject.name = name
        personObject.gender = gender
        personObject.birthday = birthday
        personObject.height = height
        personObject.weight = weight
        personObject.date?.append(Date())
        if context.hasChanges{
            do{
                try context.save()
            }catch{print(error.localizedDescription)}
        }
    }
    
    func saveWeight(weight: [Double]){
        // Contains old data
        let fetchResult = fetchData()
        // clean entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        let butchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do{
            try context.execute(butchRequest)
        }catch{print(error.localizedDescription)}
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        let personObject = NSManagedObject(entity: entity!, insertInto: context) as! Person
        
            // Wrote  old data
        personObject.name = fetchResult!.name
        personObject.birthday = fetchResult!.birthday
        personObject.height = Int16(fetchResult!.height)
        personObject.gender = fetchResult!.gender
            // Wrote new data
        personObject.weight = weight
        personObject.date?.append(Date())
        
        if context.hasChanges{
            do{
                try context.save()
            } catch{
                print(error.localizedDescription)
            }
        }
    }
}
