//
//  ListTasks+CoreDataProperties.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 20.04.2020.
//  Copyright © 2020 Test. All rights reserved.
//
//

import Foundation
import CoreData


extension ListTasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListTasks> {
        return NSFetchRequest<ListTasks>(entityName: "ListTasks")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: String?
    @NSManaged public var updatedDate: Date?
    @NSManaged public var compare: Bool
    @NSManaged public var turn: NSNumber?
}
