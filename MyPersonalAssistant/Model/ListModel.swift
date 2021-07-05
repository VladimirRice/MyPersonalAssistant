//
//  ListModel.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 15.04.2020.
//  Copyright © 2020 Vladimir Rice. All rights reserved.
//

import Foundation
import  CoreData
import  UIKit
import SwiftyJSON

struct ListModel {
    var id = ""
    var name = ""
    var updatedDate = Date()
    var compare = false
    var turn = 0

//    var coordinates : Array<Any>?
//
//    subscript(index: Int) -> Any {
//
//        return(coordinates)!
//    }
}

//@objcMembers
//class ListModel0: NSObject {
//    dynamic var name = ""
//}


//class ListModel: NSObject {
//
//    var id = ""
//    var name = ""
//    var updatedDate = Date()
//    var compare = false
//    var turn = 0
//
//
////    convenience required init(data: JSON) {
////        self.init()
//
////        self.id = data.id.string!
////        self.name = data.title.string!
//
////        self.firstName = data.first_name.string
////        self.photo100 = data.photo_100.string
////        self.photo50 = data.photo_50.string
////    }
//}

class ListTasksData {
    //var arrayObjects: [ListTasks]
    init() {
        //var arrayObjects = Tasks()
    }
    
    class func dataLoad(strPredicate: String, filter: String) -> [ListTasks] {
        //"name = %@"
        //let filter = currentListObject?.name
        var arrayObjects: [ListTasks] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ListTasks")
        let sort = NSSortDescriptor(key: "turn", ascending: true)
        request.sortDescriptors = [sort]

        if strPredicate != "" {
            let predicate = NSPredicate(format: strPredicate, filter)
            request.predicate = predicate
        }
        do {
            let objects = try context.fetch(request)
            for object in objects as! [NSManagedObject] {
                arrayObjects.append(object as! ListTasks)
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
    
    class func deleteListsAll() {
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        var listTasks = ListTasksData.dataLoad(strPredicate: "", filter: "")
        if listTasks.count == 0 {
            return
        }
        
        for indexPath in 0...listTasks.count-1 {
            //var indexPath = arrayObject.indexPath
            //self.ListtasksViewController.deleteRows(at: [indexPath], with: .fade)
            //self.arrayObjects.remove(at: indexPath)
            deleteTasks(appDelegate: appDelegate, id: listTasks[indexPath].id!)
            
            context.delete(listTasks[indexPath])
        }
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        listTasks.removeAll()
    }
    
    class func deleteTasks(appDelegate: AppDelegate, id: String) {
        let idTask = id
        var tasks = TasksData.dataLoad(strPredicate: "idList = %@", filter: idTask)
        
        if tasks.count > 0 {
            let context = appDelegate.persistentContainer.viewContext
            for indexPath in 0...tasks.count-1 {
                context.delete(tasks[indexPath])
            }
            tasks.removeAll()
        }
        
        saveObjects()
        
    }

    class func saveObjects(){
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //if context.hasChanges {
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        //appDelegate.saveContext()
    }
} // class

