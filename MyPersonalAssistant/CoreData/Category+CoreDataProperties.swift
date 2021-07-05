//
//  Category+CoreDataProperties.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 13.01.2021.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var color: NSNumber?
}

//extension Category : Identifiable {
//
//}
