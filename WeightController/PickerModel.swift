 //
//  BirthdayPicker.swift
//  WeightController
//
//  Created by Aleksey on 04.08.2021.
//

import UIKit

class PickerModel {
    
    var birthdayPicker = UIDatePicker()
    var birthday = Date()
    let dataModel = DataModel()
    
    init() {
        birthdayPicker.setDate(dataModel.fetchData()?.birthday ?? Date(), animated: false)
    }
    
    func CreateDatepicker(birthday: Date?)-> UIDatePicker {
        birthdayPicker.locale = .current
        birthdayPicker.preferredDatePickerStyle = .wheels
        birthdayPicker.datePickerMode = .date
        birthdayPicker.maximumDate = Date()
        return (birthdayPicker)
    }
    
    func getDate() -> String{
        birthday = birthdayPicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let selectedDate = dateFormatter.string(from: birthday)
        
        return selectedDate
    }
    func createButton()-> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let spaceBTN = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBTN = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(EnterViewController.pickerDonePressed))
        toolbar.setItems([spaceBTN, doneBTN, spaceBTN], animated: true)
        return toolbar
    }
    
}
