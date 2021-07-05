//
//  NomenklatureModel.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 29.04.2020.
//  Copyright © 2020 Test. All rights reserved.
//

import Foundation
import  CoreData
import  UIKit


class NomenklatureData {
    //var arrayObjects: [ListTasks]
    init() {
        //var arrayObjects = Tasks()
    }
    
    class func dataLoad(strPredicate: String, filter: String) -> [Nomenklature] {
        //"name = %@"
        //let filter = currentListObject?.name
        var arrayObjects: [Nomenklature] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Nomenklature")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]

        if strPredicate != "" {
            let predicate = NSPredicate(format: strPredicate, filter)
            request.predicate = predicate
        }
        do {
            let objects = try context.fetch(request)
            for object in objects as! [NSManagedObject] {
                arrayObjects.append(object as! Nomenklature)
//              context.perform {
//                      let entity = ListTasks.entity()
//                      let listTask = ListTasks(entity: entity, insertInto: context)
//                      //task.image = imageData
//                      //task.image = imageData
//              }
            }
        } catch {
            print("Failed")
        }
        return arrayObjects
    }


} // class


