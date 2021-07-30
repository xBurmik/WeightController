//
//  EnterViewController.swift
//  WeightController
//
//  Created by Aleksey on 12.07.2021.
//

import UIKit
import CoreData

class EnterViewController: UIViewController, UITextFieldDelegate {
    
    var person : Person!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let birthdayPicker = UIDatePicker()
    var birthday = Date()
    var weight: [Double] = []
    private lazy var regex = "^([0-9]){1,3}\\.([0-9]){1,2}$"
    
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
        
        nameTF.delegate = self
        nameTF.tag = 0
        heightTF.delegate = self
        heightTF.tag = 1
        weightTF.delegate = self
        weightTF.tag = 2
        birthdayButton.tag = 3
        
        
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
                weightTF.text = String(Double((person.weight?.last)!))
                
                birthdayButton.setTitle(selectedDate, for: .normal)
                birthdayPicker.setDate(person.age!, animated: false)
                birthday = birthdayPicker.date
                birthdayButton.tintColor = .black
                sendButton.tintColor = .black
            }
        }catch{print(error.localizedDescription)}
    }
    
    
    @IBAction func BirthdayInput(_ sender: AnyObject? = nil) {
                
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
    
    
    
    func saveData (name: String, birthday: Date, height: Int, weight: [Double]){
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
//        let pattern = "\\D"
        let weightSTRReplace = weightTF.text?.replacingOccurrences(of: #"\D"#, with: ".", options: .regularExpression)
        let heightSTRReplace = heightTF.text?.replacingOccurrences(of: #"\D"#, with: ".", options: .regularExpression)
        
        weight.append(Double(weightSTRReplace!)!)
        
        saveData(name: nameTF.text!, birthday: birthday, height: Int(heightSTRReplace!)!, weight: weight)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTF:
            heightTF.becomeFirstResponder()
        case heightTF:
            weightTF.becomeFirstResponder()
        default:
//            self.view.endEditing(true)
            textField.resignFirstResponder()
            BirthdayInput()
        }
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
}

