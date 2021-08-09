//
//  ViewController.swift
//  WeightController
//
//  Created by Aleksey on 12.07.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    var person : Person!
    var BMI = Double()
    var weight = [Double]()
    var weightDates = [Date]()
    
    let dataModel = DataModel()
    
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        person = dataModel.fetchData()
        
            if person == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let enterVC = storyboard.instantiateViewController(identifier: "EnterViewController")
                show(enterVC, sender: self)
            } else{
                weight = person.weight!
                weightDates = person.date!
                
                let height = (Double(person.height))/100
                let birthday = person.birthday
                let lastWeight = person.weight!.last!
                let now = Date()
                let calendar = Calendar.current
                let ageComponents = calendar.dateComponents([.year], from: birthday!, to: now)
                let age = ageComponents.year!
                
                self.BMI = lastWeight/pow(height, 2)
                
                GetBMINormal(gender: person.gender, age: age)
            }
        
        weightTF.delegate = self
        weightTF.tag = 1
        resendButton.backgroundColor = .white
        resendButton.layer.cornerRadius = 5
        resendButton.tintColor = .black
        resendButton.setTitle("Edit weight", for: .normal)
        
        self.navigationItem .setHidesBackButton(true, animated: true)
    }
    
    @IBAction func ResendButtonPressed(_ sender: Any) {
        self.weightTF.text = ""
        self.weightTF.isHidden = false
        self.resendButton.isHidden = true
        weightTF.becomeFirstResponder()
    }
    
    func GetBMINormal (gender: Bool, age: Int) {
        if(gender) {
            calculateForMen(forAge: age);
        } else {
            calculateForWomen(forAge: age);
        }
        
        func bmiForMen(index: Double) {
            switch BMI {
            case (0 + index)...(20 + index):
                print("to low")
            case (21 + index)...(25 + index):
                print("normal")
            default:
                print("to much")
            }
        }
        
        func bmiForWomen(index: Double) {
            switch BMI {
            case (0 + index)...(19 + index):
                print("to low")
            case (19 + index)...(24 + index):
                print("normal")
            default:
                print("to much")
            }
        }
        
                
        func calculateForMen(forAge: Int) {
            switch forAge {
              case 0...24:
                 bmiForMen(index: 0)
              case 25...34:
                bmiForMen(index: 0.2)
              case 35...44:
                bmiForMen(index: 1.5)
              case 45...54:
                bmiForMen(index: 4.4)
              default:
                bmiForMen(index: 5.2)
              }
        }
        
        func calculateForWomen(forAge: Int) {
            switch forAge {
              case 0...24:
                bmiForWomen(index: 0)
              case 25...34:
                bmiForWomen(index: 3.7)
              case 35...44:
                bmiForWomen(index: 3.9)
              case 45...54:
                bmiForWomen(index: 5.7)
              default:
                bmiForWomen(index: 7.8)
              }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let weightSTRReplace = Double((weightTF.text?.replacingOccurrences(of: #"\D"#, with: ".", options: .regularExpression))!)
        weight.append(weightSTRReplace!)
        weightDates.append(Date())
        
        dataModel.saveWeight(weight: weight, dates: weightDates)

        textField.resignFirstResponder()
        textField.isHidden = true
        resendButton.isHidden = false
        
        print(weight)
        print(weightDates)
        return true
    }
    

    @IBAction func unwindSegue(unwindSegue:UIStoryboardSegue)
    {
        //returning here
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
