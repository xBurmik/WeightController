//
//  EnterViewController.swift
//  WeightController
//
//  Created by Aleksey on 12.07.2021.
//

import UIKit
import CoreData

class EnterViewController: UIViewController {

    var person : Person!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        do {
            person = try context.fetch(fetchRequest).last
            print(person.name)
            print(person.age)
            print(person.weight)
            print(person.height)
        }catch{print(error.localizedDescription)}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func saveData (name: String, birthday: Date, height: Int, weight: Int){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        let butchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do{
            try context.execute(butchRequest)
        }catch{print(error.localizedDescription)}
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        let personObject = NSManagedObject(entity: entity!, insertInto: context) as! Person
        
        personObject.name = name
        personObject.age = birthday
        personObject.height = Int16(height)
        personObject.weight = Int16(weight)
        if context.hasChanges{
            do{
                try context.save()
                print("Saved!")
            } catch{
                print(error.localizedDescription)
            }
        }
        
    }
    
    @IBAction func SendButtonPress(_ sender: Any) {
        saveData(name: nameTF.text!, birthday: birthdayPicker.date, height: Int(heightTF.text!)!, weight: Int(weightTF.text!)!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
