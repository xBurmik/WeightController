//
//  EnterViewController.swift
//  WeightController
//
//  Created by Aleksey on 12.07.2021.
//

import UIKit
import CoreData

class EnterViewController: UIViewController, UITextFieldDelegate {
    
    var person: Person?
    var weight = [Double]()
    var gender = Bool()
    var birthday = Date()
    
    let dataModel = DataModel()
    let pickerModel = PickerModel()
    
    @IBOutlet weak var greetingsLabel: UILabel!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var BirthdayTF: UITextField!
    
    @IBOutlet weak var genderSelector: UISwitch!
    @IBOutlet weak var boyButton: UIButton!
    @IBOutlet weak var girlButton: UIButton!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem .setHidesBackButton(true, animated: true)
        
        person = dataModel.fetchData()
        
        if let person = person {
            self.weight = person.weight!
            
            greetingsLabel.text = "Update your data"
            nameTF.text = person.name
            heightTF.text = String(person.height)
            weightTF.text = String(person.weight!.last!)
            BirthdayTF.text = pickerModel.getDate()
            
            
            gender = person.gender
            cancelButton.isEnabled = true
            sendButton.isEnabled = true
        }
        
        nameTF.delegate = self
        nameTF.tag = 0
        heightTF.delegate = self
        heightTF.tag = 1
        weightTF.delegate = self
        weightTF.tag = 2
        BirthdayTF.delegate = self
        BirthdayTF.tag = 3
        BirthdayTF.inputView = pickerModel.CreateDatepicker(birthday: birthday)
        BirthdayTF.inputAccessoryView = pickerModel.createButton()
        
        genderSelector.isOn = gender
        SetGender(gender: genderSelector.isOn)
    }
    @objc func doneBTNPressed() {
        BirthdayTF.text = pickerModel.getDate()
        birthday = pickerModel.birthdayPicker.date
        self.view.endEditing(true)
    }
    
    @IBAction func SendButtonPress(_ sender: Any) {
        let weightSTRReplace = weightTF.text?.replacingOccurrences(of: #"\D"#, with: ".", options: .regularExpression)
        weight.append(Double(weightSTRReplace!)!)
        let height = Int16(heightTF.text!)!
        
        dataModel.editData(name: nameTF.text!, gender: genderSelector.isOn, birthday: birthday, height: height, weight: weight)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTF:
            heightTF.becomeFirstResponder()
        case heightTF:
            weightTF.becomeFirstResponder()
        case weightTF:
            BirthdayTF.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            sendButton.isEnabled = true
        }
        return true
    }
    
    @IBAction func GenderSwitch(_ sender: Any) {
        SetGender(gender: genderSelector.isOn)
    }
    
    @IBAction func BoyButtonPress(_ sender: Any) {
        genderSelector.setOn(false, animated: true)
        SetGender(gender: genderSelector.isOn)
    }
    @IBAction func GirlButtonPress(_ sender: Any) {
        genderSelector.setOn(true, animated: true)
        SetGender(gender: genderSelector.isOn)
    }
    
    func SetGender(gender: Bool) {
        self.gender = genderSelector.isOn
        switch genderSelector.isOn{
        case true:
            boyButton.setImage(UIImage(named: "Boy_black"), for: .normal)
            girlButton.setImage(UIImage(named: "Girl"), for: .normal)
        default:
            boyButton.setImage(UIImage(named: "Boy"), for: .normal)
            girlButton.setImage(UIImage(named: "Girl_black"), for: .normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


