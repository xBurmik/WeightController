//
//  Person+CoreDataProperties.swift
//  WeightController
//
//  Created by Aleksey on 28.07.2021.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Date?
    @NSManaged public var height: Int16
    @NSManaged public var name: String?
    @NSManaged public var weight: [Double]?

}

extension Person : Identifiable {

}
