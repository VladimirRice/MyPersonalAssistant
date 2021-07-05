//
//  Nomenklature+CoreDataProperties.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 29.04.2020.
//  Copyright © 2020 Test. All rights reserved.
//
//

import Foundation
import CoreData


extension Nomenklature {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Nomenklature> {
        return NSFetchRequest<Nomenklature>(entityName: "Nomenklature")
    }

//    @NSManaged public var id: String?
//    @NSManaged public var name: String?
//    @NSManaged public var checkmark: NSNumber?
//    @NSManaged public var priority: NSNumber?
//    @NSManaged public var quantity: NSNumber?
    @NSManaged public var article: String?
    @NSManaged public var checkmark: Bool
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var priority: NSNumber?
    @NSManaged public var quantity: Float
    @NSManaged public var image: Data?


}
