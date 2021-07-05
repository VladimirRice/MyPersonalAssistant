//
//  TasksModel.swift
//  Tasks App
//
//  Created by Алексей Пархоменко on 30/01/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation

import UIKit

struct TasksModelMenu {
    var mainImage: UIImage
    var taskNameMnu: String
    var smallDescription: String
    var cost: String
    var idTask: String?

    static func fetchTasks() -> [TasksModelMenu] {
        let nameImageFull = "Lists"


        var priorityObjects: [TasksModelMenu] = []//[TasksModelMenu].self
        let priorityOn1 = UserDefaults.standard.object(forKey: "isPriority1") as? Bool ?? false
        let priorityOn2 = UserDefaults.standard.object(forKey: "isPriority2") as? Bool ?? false
        let priorityOn3 = UserDefaults.standard.object(forKey: "isPriority3") as? Bool ?? false
        
        //var isPriority = false
        var arrayPriority: [Int] = []
//        if priorityOn1 != nil {
//            isPriority = true
//        }
        if priorityOn1 == true {
            arrayPriority.append(1)
        }
//        if priorityOn2 != nil {
//            isPriority = true
//        }
        if priorityOn2 == true {
            arrayPriority.append(2)
        }
//        if priorityOn3 != nil {
//            isPriority = true
//        }
        if priorityOn3 == true {
            arrayPriority.append(3)
        }
        
        let filter = arrayPriority//[1,2,3]
        //let tasksArray = TasksData.dataLoad(strPredicate: "priority > ", filter: filter)
        let tasksArray = TasksData.dataLoad(strPredicate: "priority IN %@", filter: filter)
        //"item_id IN %@", wantedItemIDs
        for task in tasksArray {
            var dateTerminationStr: String?
            if task.dateTermination == nil {
                dateTerminationStr = ""
            } else {
                dateTerminationStr = Functions.dateToString(date: task.dateTermination!)
            }
            var imageNameImage = UIImage(named: nameImageFull)
            
            if task.imageTask != nil {
                imageNameImage = UIImage(data: task.imageTask!)
            }
            let firstItem = TasksModelMenu(mainImage: imageNameImage!,
                                           taskNameMnu: task.heading!,
                                           smallDescription: task.name!,
                                           cost: dateTerminationStr!, idTask: task.id)
            priorityObjects.append(firstItem)
        }
        if priorityObjects.count == 0 {
            let firstItem = TasksModelMenu(mainImage: UIImage(named: nameImageFull)!,
                                           taskNameMnu: "",
                                           smallDescription: "Важных задач нет!",
                                       cost: "", idTask: "")
            priorityObjects.append(firstItem)
        }
        return priorityObjects
        }
    }

struct Constants {
    static let leftDistanceToView: CGFloat = 40
    static let rightDistanceToView: CGFloat = 40
    static let galleryMinimumLineSpacing: CGFloat = 10
    static let galleryItemWidth = (UIScreen.main.bounds.width - Constants.leftDistanceToView - Constants.rightDistanceToView - (Constants.galleryMinimumLineSpacing / 2)) / 2
}
