//
//  TasksModel.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 30.03.2020.
//  Copyright © 2020 Vladimir Rice. All rights reserved.
//

import Foundation
import  CoreData
import  UIKit

class TaskModel {
    var dateTermination: Date?
    var heading = ""
    var image0: Data?
    var image1: Data?
    var image2: Data?
    var isClose = false
    var listName = ""
    var name = ""
    var priority: NSNumber?
    var id = ""
    var idList = ""
    var turn = 0
    var imageTask: Data?
    var updatedDate = Date()
    var compare = false
    var isEnabled = false
    var color: NSNumber?
    var status = ""
    var category = ""
    var go = false
    
    //var propertys: [String] = ["heading", "idList", "status"]
    
    var propertys = AttrObjects().attrTasks
    
//    var coordinates : Array<Any>?
//    subscript(index: Int) -> Any {
//        return(coordinates)!
//    }
    
//    subscript(index: Int) -> String {
//        get {
//            return propertys[index]
//        }
//        set(newValue) {
//            self.propertys[index] = newValue
//        }
//    }
}


class TasksData {
    //var arrayObjects: [Tasks]
    init() {
        //var arrayObjects = Tasks()
    }
    
    class func dataLoad(strPredicate: String, filter: Any) -> [Tasks] { //filter: String
        //"name = %@"
        //let filter = currentListObject?.name
        var arrayObjects: [Tasks] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        let sort = NSSortDescriptor(key: "turn", ascending: true)
        request.sortDescriptors = [sort]
        if strPredicate != "" {
            let predicate = NSPredicate(format: strPredicate, filter as! CVarArg)
            request.predicate = predicate
        }
        do {
            let objects = try context.fetch(request)
            for object in objects as! [NSManagedObject] {
                arrayObjects.append(object as! Tasks)
            }
        } catch {
            print("Failed")
        }
        return arrayObjects
    }

//    class func dataLoadFilters(strPredicate: String, filter: [Any]) -> [Tasks] {         var arrayObjects: [Tasks] = []
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
//        let sort = NSSortDescriptor(key: "turn", ascending: true)
//        request.sortDescriptors = [sort]
//        if strPredicate != "" {
//            let predicate = NSPredicate(format: strPredicate, argumentArray: [filter]) // as! CVarArg)
//            request.predicate = predicate
//        }
//        do {
//            let objects = try context.fetch(request)
//            for object in objects as! [NSManagedObject] {
//                arrayObjects.append(object as! Tasks)
//            }
//        } catch {
//            print("Failed")
//        }
//        return arrayObjects
//    }

    
    class func quantyTasksForBadgeNotifications(date: Date, listId: String? = nil) -> Int{
        //var filters: [Any] = []
        let strPredicate = "dateTermination <= %@"
        let filters = date as NSDate
//        strPredicate = strPredicate + " && !isClose == %@"
//        filters.append(NSNumber(value: true))
        
//        if listId != nil {
//            strPredicate = strPredicate + " && listID = %@"
//            filters.append(listId as Any)
//       }
        var objects = dataLoad(strPredicate: strPredicate, filter: filters)// as [Tasks]
        objects = objects.filter({$0.isClose == false})
        
        if listId != nil {
            objects = objects.filter({$0.idList == listId})
        }
        return objects.count
    }

} // class

