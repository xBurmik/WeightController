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
    let birthdayPicker = UIDatePicker()
    var birthday = Date()
    var weight: [Int16] = []
    
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var birthdayButton: UIButton!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem .setHidesBackButton(true, animated: true)
        
        greetingsLabel.numberOfLines = 0
        birthdayButton.setTitle("Enter Your Birthday", for: .normal)
        birthdayButton.layer.cornerRadius = 5
        birthdayButton.tintColor = .gray
        sendButton.layer.cornerRadius = 5
        sendButton.backgroundColor = .lightText
        sendButton.tintColor = .gray
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        do {
            person = try context.fetch(fetchRequest).last
            if let person = person {
                
                self.weight = person.weight!
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMMM yyyy"
                let selectedDate = dateFormatter.string(from: person.age!)
                
                greetingsLabel.text = "Update your data"
                nameTF.text = person.name
                heightTF.text = String(person.height)
                weightTF.text = String(Int((person.weight?.last)!))
                birthdayButton.setTitle(selectedDate, for: .normal)
                self.birthdayPicker.setDate(person.age!, animated: false)
                birthdayButton.tintColor = .black
                sendButton.tintColor = .black
            }
        }catch{print(error.localizedDescription)}
    }
    
    
    @IBAction func BirthdayInput(_ sender: Any) {
        birthdayPicker.locale = .current
        birthdayPicker.preferredDatePickerStyle = .wheels
        birthdayPicker.datePickerMode = .date
        birthdayPicker.maximumDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        var selectedDate = dateFormatter.string(from: birthdayPicker.date)
        
        let vc = UIViewController()
        vc.view.addSubview(birthdayPicker)
        vc.view.subviews.first?.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        vc.view.subviews.first?.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert =  UIAlertController(title: "Enter Your Birthday", message: nil, preferredStyle: .actionSheet)
        alert.setValue(vc, forKey: "contentViewController")
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default){action in
            self.birthday = self.birthdayPicker.date
            selectedDate = dateFormatter.string(from: self.birthdayPicker.date)
            self.birthdayButton.setTitle("\(selectedDate)", for: .normal)
            self.birthdayButton.tintColor = .black
            self.sendButton.tintColor = .black
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func saveData (name: String, birthday: Date, height: Int, weight: [Int16]){
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
        personObject.weight = weight
        
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
        let temp = weightTF.text
        weight.append(Int16(temp!)!)
        saveData(name: nameTF.text!, birthday: birthday, height: Int(heightTF.text!)!, weight: weight)
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
