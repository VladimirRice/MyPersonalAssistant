//
//  Tasks+CoreDataProperties.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 20.04.2020.
//  Copyright © 2020 Test. All rights reserved.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

//    @NSManaged public var dateNotification: Date?
    @NSManaged public var dateTermination: Date?
    @NSManaged public var heading: String?
    @NSManaged public var image0: Data?
    @NSManaged public var image1: Data?
    @NSManaged public var image2: Data?
    @NSManaged public var isClose: Bool
    @NSManaged public var listName: String?
    @NSManaged public var name: String?
    @NSManaged public var priority: NSNumber?
    @NSManaged public var id: String?
    @NSManaged public var idList: String?
    @NSManaged public var turn: NSNumber?
    @NSManaged public var imageTask: Data?
    @NSManaged public var updatedDate: Date?
    @NSManaged public var compare: Bool
    @NSManaged public var isEnabled: Bool
    @NSManaged public var color: NSNumber?
    @NSManaged public var status: String?
    @NSManaged public var category: String?
    @NSManaged public var go: Bool
    
    

}
