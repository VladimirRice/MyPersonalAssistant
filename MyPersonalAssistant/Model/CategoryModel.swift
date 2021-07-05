//
//  CategoryModel.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 13.01.2021.
//

import Foundation

import  CoreData
import  UIKit


class CategoryData {
    //var arrayObjects: [ListTasks]
    init() {
        //var arrayObjects = Tasks()
    }
    
    class func dataLoad(strPredicate: String, filter: String) -> [Category] {
        //"name = %@"
        //let filter = currentListObject?.name
        var arrayObjects: [Category] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]

        if strPredicate != "" {
            let predicate = NSPredicate(format: strPredicate, filter)
            request.predicate = predicate
        }
        do {
            let objects = try context.fetch(request)
            for object in objects as! [NSManagedObject] {
                arrayObjects.append(object as! Category)
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
    
    class func categoryDefault() {
        var categorys = CategoryData.dataLoad(strPredicate: "", filter: "")
        if categorys.count < 4 {
            
            let categorysDefault = CategoryDefault().names
            for i in 0...categorysDefault.count-1 {
                if CategoryData.dataLoad(strPredicate: "name = %@", filter: categorysDefault[i]).count > 0 {
                    continue
                }
                
                let appDelegate =
                    UIApplication.shared.delegate as! AppDelegate
                
                let context = appDelegate.persistentContainer.viewContext
                
                let newObject = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context)
                
                let currCategory = newObject as? Category
                currCategory!.id = UUID().uuidString
                currCategory!.name = categorysDefault[i]
                currCategory!.color = NSNumber(value: CategoryDefault().color[i])
                
                categorys.append(currCategory!)
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    
} //class

struct CategoryDefault {
    var names = ["<не выбрана>", "Коммунальные", "Личные", "Рабочие", "Прочие"]
    var color = [0,6,8,5,2]
}
