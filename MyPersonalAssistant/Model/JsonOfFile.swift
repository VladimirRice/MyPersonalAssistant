//
//  JsonOfFile.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 30.06.2021.
//

import UIKit
import SwiftyJSON
import SSZipArchive
import CoreData

func jsonInDataFromDefaultFile(selfVC: UIViewController) {
    let fileNameZip = UserDefaults.standard.object(forKey: "fileBackup") as? String ?? ""
//    let documentsUrl = Files.mFolderURL()
//    let fullFileName = documentsUrl!.appendingPathComponent(fileName)
////    let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl!, includingPropertiesForKeys: nil)
////
////    let fullfileName = directoryContents.filter{ $0.name == fileName }
//    //let fullfileName = url+fileName
    if !existingFile(miniFileName: fileNameZip) {
        Functions.alertShort(selfVC: selfVC, title: "Внимание", message: "Не найден файл \(String(describing: fileNameZip))", second: 0.02)
        return
    }
        
    jsonInData(fileName: fileNameZip)
    Functions.alertShort(selfVC: selfVC, title: "Внимание", message: "Синхронизация закончена", second: 0.02)
    //Functions.openComment(selfVC: selfVC, commentText: "Синхронизация закончена", second: 1.00)
}

func jsonInData(fileName: String) {
//    let urlString = "https://drive.google.com/file/d/1jazU2hlaTYd_cbXYca9oGOVnNBCLQauH/view?usp=sharing"

//    //let json = MyControllerFile.downloadFileURL(id: 1, urlString: urlString)

//        let jsonFile = Tasks_.json
//        let json = try JSON(data: jsonFile)

    //let fileName = "Tasks_"
    
    var currFileName = ""
    var currFileNameFull = ""
    var currFileURL: URL?
//    var urlFile: URL?
//    var urlFileZip: URL?
//    var fileNameZipFull = ""
//    var fileUrlForJson: URL?
    
    var json: JSON!
    var mError = ""
    
    
    var fileNameZip = ""
    
    
    let url = Files.mFolderURL()
    let urlTmp = url?.appendingPathComponent("tmp")
    
    currFileName = fileName
    currFileURL = url?.appendingPathComponent("\(currFileName)")
    currFileNameFull = currFileURL!.path

    var currFileNameFullJson = ""
    

    
    //if currFileName.count < 100 {
     
        
        if currFileName.contains(".zip") {
            fileNameZip = "!"
            
            do {
                
//                urlFileZip = urlFile
//                fileNameZipFull = urlFileZip!.path
//                fileNameZipFull.replaceOccurrences(of: ".zip", with: ".json")
            
                //currFileName = fileName
//                currFileName.replaceOccurrences(of: ".zip", with: ".json")
                
                currFileNameFullJson = currFileNameFull
                currFileNameFullJson.replaceOccurrences(of: ".zip", with: ".json")
                
                
//                let fileManager = FileManager()
////                let currentWorkingPath = fileManager.currentDirectoryPath
////                var sourceURL = URL(fileURLWithPath: currentWorkingPath)
////                sourceURL.appendPathComponent("archive.zip")
////                var destinationURL = URL(fileURLWithPath: currentWorkingPath)
////                destinationURL.appendPathComponent("directory")
//                url?.appendingPathComponent("directory")
//                do {
//                    try fileManager.createDirectory(at: url!, withIntermediateDirectories: true, attributes: nil)
//                    try fileManager.unzipItem(at: currFileURL!, to: url!)
//
//                    //currFileURL = url?.appendingPathComponent("\(currFileName)")
//                    currFileNameFull = currFileURL!.path
//
//                 } catch {
//                    print("Extraction of ZIP archive failed with error:\(error)")
//                    mError = mError + error.localizedDescription + "/n"
//                }
                
                
//                if !FileManager().fileExists(atPath: fileNameZipFull) {
//                    currFileURL = url?.appendingPathComponent("\(fileNameZip)")
//                } else {
//                    currFileURL = URL(string: fileNameZipFull)
//                }
//                currFileNameFull = currFileURL!.path
//                currFileName = fileNameZip

    
                SSZipArchive.unzipFile(atPath: currFileNameFull, toDestination: urlTmp!.path)
                let filePaths = try FileManager.default.contentsOfDirectory(atPath: urlTmp!.path)
                for filePath in filePaths {
                    currFileName = filePath
                    currFileURL = urlTmp!.appendingPathComponent(currFileName)
                    break
                }
                
                
            } catch {
                print(" : \(error)")
                mError = mError + error.localizedDescription + "/n"
            }

        } else {
//            currFileURL = urlFile
//            currFileName = currFileURL!.path
        }
//    } else {
//
//    }

    //    if currFileNameFullJson != "" {
//    if !FileManager().fileExists(atPath: currFileNameFullJson) {
//        currFileURL = url?.appendingPathComponent("\(currFileName)")
//        //currFileName = currFileURL!.path
//    } else {
//        currFileURL = URL(string: currFileNameFull)
//        //currFileName = currFileURL!.path//fileNameZipAll
//    }
    
    //fileUrlForJson = currFileURL!
    
    do {
        var data = try Data(contentsOf: currFileURL!, options: .alwaysMapped)
        json = try JSON(data: data)
        
        
        
//        guard (try? JSONDecoder().decode([itemsListD].self, from: data)) != nil else {
//            print("Error: Couldn't decode data into itemsListD array")
//            return
//          }
        
    } catch let error {
        print("parse error: \(error.localizedDescription)")
        mError = mError + error.localizedDescription + "/n"
    }
    
    if fileNameZip == "!" {
        do {
            try FileManager().removeItem(atPath: currFileURL!.path)
        } catch {
            print(" : \(error)")
            mError = mError + error.localizedDescription + "/n"
        }
    }
    if mError != "" {
        print(" : \(mError)")
        return
    }
    do {
        try parseJson(json: json)
    } catch {
        print(error)
    }
}


func parseJson(json: JSON, listID: String = "") {
    let appDelegate =
        UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext

    var jsonListsTasks = ListTasksData.dataLoad(strPredicate: "", filter: "")
    var jsonTasks = TasksData.dataLoad(strPredicate: "", filter: "")
    var listsTasks = jsonListsTasks
    var tasks = jsonTasks
    jsonListsTasks.removeAll()
    jsonTasks.removeAll()
    //var emptyListTasks = sListTasks()

    let attrObjects = AttrObjects()
    var attrListsTasks = attrObjects.attrLists
    var attrTasks = attrObjects.attrTasks
    var attrTasksApp = attrObjects.attrTasksApp



            for item in json["items"].arrayValue { // listTasks
                var nZl = 0

                //let id = item["id"].string
                // find
//                let filter = id
//                let objects = ListTasksData.dataLoad(strPredicate: "id = %@", filter: filter!)
//                if objects.count == 0 {
                    let newTask = NSEntityDescription.insertNewObject(forEntityName: "ListTasks", into: context)
                    jsonListsTasks.append(newTask as! ListTasks)
                    nZl = jsonListsTasks.count-1
                    jsonListsTasks[nZl].id = item["id"].string
//                } else {
//                    let newTask = objects[0]
//                    nZl = listsTasks.firstIndex(of: newTask)!
//                }
                //
                var titleItem = item["title"].string
                var title = titleItem
                var searchStrs: [String] = []
                searchStrs.append("\n")
                let s = titleItem!.findSubString(inputStr: titleItem!, subStrings: searchStrs)
                if s.count > 0 {
                    let s1 = s[0].1
                    title = titleItem!.strRange(string: titleItem!, intStart: 0, IntFinish: s1)
                }

                jsonListsTasks[nZl].name = title
                let updateString = item["updated"].string!
                let strDate = dateInFormat1(strDate: updateString)
                jsonListsTasks[nZl].updatedDate = strDate

                jsonListsTasks[nZl].compare = false

                //if in item["items"].arrayValue
                for itemTask in item["items"].arrayValue { // Tasks
                    let status = itemTask["status"].string
                    if status != "needsAction" {
                        continue
                    }
                    var nZTasks = 0
//                    let id = item["id"].string
//                    // find
//                    let filter = id
//                    let objects = TasksData.dataLoad(strPredicate: "id = %@", filter: filter!)
//                    if objects.count == 0 {
                        let newTask = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context)
                        jsonTasks.append(newTask as! Tasks)
                        nZTasks = jsonTasks.count-1
                        jsonTasks[nZTasks].id = itemTask["id"].string
//                    } else {
//                        let newTask = objects[0]
//                        nZTasks = tasks.firstIndex(of: newTask)!
//                    }

//                    let newTask = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context)
//                    jsonTasks.append(newTask as! Tasks)
//                    let nZTasks = jsonTasks.count-1
//                    jsonTasks[nZTasks].id = itemTask["id"].string
                    jsonTasks[nZTasks].idList = jsonListsTasks[nZl].id
                    jsonTasks[nZTasks].listName = jsonListsTasks[nZl].name
                    let updateString = itemTask["updated"].string!
                    let strDate1 = dateInFormat1(strDate: updateString)
                    jsonTasks[nZTasks].updatedDate = strDate1
                    jsonTasks[nZTasks].compare = false
                    let titleTask = itemTask["title"].string
                    jsonTasks[nZTasks].heading = titleTask

                    //
                    var isDateTermination = false
                    if let dateTermination = itemTask["due"].string, itemTask["due"].string != "" {
                        let strDate2 = dateInFormat1(strDate: dateTermination)
                        jsonTasks[nZTasks].dateTermination = strDate2
                        isDateTermination = true
                    }

//                    if !isDateTermination, let dateTermination3 = itemTask["dataTermination"].string {
//                        let strDate3 = dateInFormat1(strDate: dateTermination3)
//                        jsonTasks[nZTasks].dateTermination = strDate3
//                        isDateTermination = true
//                    }

                    if var notes = itemTask["notes"].string {
                        var alarmPeriod = ""
                        var searchStrs: [String] = []
                        searchStrs.append("@")
                        let s = titleTask!.findSubString(inputStr: titleTask!, subStrings: searchStrs)
                        if s.count > 0 { // alarmPeriod
                            searchStrs.removeAll()
                            searchStrs.append("\n")
                            let s = titleTask!.findSubString(inputStr: titleTask!, subStrings: searchStrs)
                            if s.count > 0 {
                                let s1 = s[0].1
                                alarmPeriod = titleTask!.strRange(string: titleTask!, intStart: 0, IntFinish: s1)
                                if s1 > titleTask!.count {
                                    notes = titleTask!.strRange(string: titleTask!, intStart: s1+1, IntFinish: 1000)
                                }

                            }
                        }
                        jsonTasks[nZTasks].name = notes

                    }

                    for attrTask in attrTasksApp {
//                        if attrTask == "status" {
//                            continue
//                        }
                        if let strObject = itemTask[attrTask].string {
                            jsonTasks[nZTasks].setValue(strObject, forKey: attrTask)
                        }
                        if let strObject = itemTask[attrTask].number {
                            jsonTasks[nZTasks].setValue(strObject, forKey: attrTask)
                        }

                    }
                    //                            jsonTasks[nZTasks].
                    //                            jsonTasks[nZTasks].
                    //                            jsonTasks[nZTasks].


                }
            }
//        }


    //

//        clearCoreData(objects: listsTasks)
//        listsTasks.removeAll()
//
//        clearCoreData(objects: tasks)
//        tasks.removeAll()

    uploadObjects(dataObjects: listsTasks, jsonObjects: jsonListsTasks, attributs: attrListsTasks)
    uploadObjects(dataObjects: tasks, jsonObjects: jsonTasks, attributs: attrTasks, attributsAPP: attrTasksApp)

    saveObjectsAfterJson()

    clearCoreData(objects: jsonListsTasks)
    clearCoreData(objects: jsonTasks)
    jsonListsTasks.removeAll()
    jsonTasks.removeAll()

}


func uploadObjects(dataObjects: [AnyObject], jsonObjects: [AnyObject], attributs: [String], attributsAPP: [String]? = nil) -> [(String, Any)] {
    
    let nattributsAPP = attributsAPP
    //        if dataObjects == jsonObjects {
    //            return
    //        }
    let appDelegate =
        UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext

    //var aDeleted: [AnyObject] = []
    var objectsModificationGoogle: [(String, Any)] = []
    
    var updateObject = false
    
    // objects compare with jsonObjects
    for object in dataObjects {
        // object.compare = true
        object.setValue(true, forKey: "compare") // просмотрен!
        let jsonObjectsFilter = jsonObjects.filter({$0.id == object.id})
        if jsonObjectsFilter.count == 0 {
            objectsModificationGoogle.append(("insert", object)) // нет в json
            continue
        }
        let jsonObject = jsonObjectsFilter[0]
        //jsonObject.compare = true
        jsonObject.setValue(true, forKey: "compare")
        //            if (object as! ListTasks) === (jsonObject as! ListTasks) {
        //                continue
        //            }
        var isModifi = false
        for i in 0..<attributs.count {
            let attribut = attributs[i]
//            if attribut == "status" {
//                continue
//            }

            if nattributsAPP != nil {
                if nattributsAPP!.contains(attribut) {
                    continue
                }
            }
            var currAttrObject = object.value(forKey: attribut)
            let currAttrJsonObject = jsonObject.value(forKey: attribut)
            if compareV2(v0: currAttrObject as AnyObject, v1: currAttrJsonObject as AnyObject) {
                continue
            }
            if currAttrObject == nil && currAttrJsonObject == nil {
                continue
            }
            updateObject = true
            object.setValue(currAttrJsonObject, forKey: attribut)
            
        }
        if isModifi {
            objectsModificationGoogle.append(("update", object))
        }
    }

    // исключаем уже просмотренные
    let jsonObjectsFilter = jsonObjects.filter({$0.compare != true})
    
    for jsonObject in jsonObjectsFilter {
        jsonObject.setValue(true, forKey: "compare")
        var objectsFilter = dataObjects.filter({$0.id == jsonObject.id})
        if objectsFilter.count == 0 {
            var newTask: AnyObject
            
            switch jsonObject {

            case let jsonObject as ListTasks:
                newTask = NSEntityDescription.insertNewObject(forEntityName: "ListTasks", into: context)
            case let jsonObject as Tasks:
                newTask = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context)

            default:
                newTask = Tasks()
            }
            objectsFilter.append(newTask)
        }

        let object = objectsFilter[0]

        for i in 0..<attributs.count {
            let attribut = attributs[i]
//            if nattributsAPP != nil {
//                if nattributsAPP!.contains(attribut) {
//                    continue
//                }
//            }

            //var currAttrObject = object.value(forKey: attribut)
            let currAttrJsonObject = jsonObject.value(forKey: attribut)
//                if compareV(v0: currAttrObject, v1: currAttrJsonObject) {
//                    continue
//                }
            updateObject = true
            object.setValue(currAttrJsonObject, forKey: attribut)
            
        }
    }
    
    
//    // update
//    if updateObject == true {
//        saveObjects()
//    }
    
    return objectsModificationGoogle
}


func compareV2(v0: AnyObject, v1: AnyObject) -> Bool {
    if let va = v0 as? Int, let vb = v1 as? Int            {if va != vb {return false} else {return true}}
    else if let va = v0 as? String, let vb = v1 as? String {if va != vb {return false} else {return true}}
    else if let va = v0 as? Bool, let vb = v1 as? Bool     {if va != vb {return false} else {return true}}
    else if let va = v0 as? Date, let vb = v1 as? Date     {if va != vb {return false} else {return true}}
    else if v0 == nil, v1 == nil  {return true}
    else {
        // not a type we expected
        return false;
    }
    return false;
}

func compareV(v0: AnyObject, v1: AnyObject) -> Bool {
    switch v0 {
      //case .None: return true
    case let v0 as String: return compare(obj1: v0, v1 as! String)
    case let v0 as Int: return compare(obj1: v0, v1 as! Int)
    case let v0 as Date: return compare(obj1: v0, v1 as! Date)
        
    case let v1 as String: return compare(obj1: v1, v0 as! String)
    case let v1 as Int: return compare(obj1: v1, v0 as! Int)
    case let v1 as Date: return compare(obj1: v1, v0 as! Date)
          /* ...
           expand with the known possible types of your array elements
           ... */
      case _ : return true
          /*  */
      }
}

func compare<T: Equatable>(obj1: T, _ obj2: Any) -> Bool {
        return obj1 == obj2 as? T
    }

func saveObjectsAfterJson(){
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

func clearCoreData(objects: [AnyObject]) {
    
    let appDelegate =
        UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    if objects.count == 0 {
        return
    }
    //arrayObjects.removeAll()
    //for arrayObject in arrayObjects {
    for indexPath in 0...objects.count-1 {
        //var indexPath = arrayObject.indexPath
        //self.ListtasksViewController.deleteRows(at: [indexPath], with: .fade)
        //self.arrayObjects.remove(at: indexPath)
        context.delete(objects[indexPath] as! NSManagedObject)
    }
    
    //objects.removeAll()
    //self.ListtasksViewController.beginUpdates()
    saveObjectsAfterJson()
}

func dataInJson(selfVC: UIViewController? = nil, dopName: String? = nil) -> String {
    
    var dopName = dopName
    
    let pathURL = Files.mFolderURL()
    
    let dateFormat = "yyMMdd_HHmmss"
    let currDateStr = Functions.dateToStringFormat(date: Date(), minDateFormat: dateFormat)
    let listTasks = ListTasksData.dataLoad(strPredicate: "", filter: "")
    if dopName == nil {
        dopName = ""
    }
    var fileName = "mT_"+dopName!+""+currDateStr+".json"
    
    var sJsonList = itemsList()
    var sJsonLists = [sJsonList]
    var sJsonTask = itemsTask()
    var sJsonTasks = [sJsonTask]
    var sItemsALL = itemsALL()
    //var sItemsALLs = [sItemsALL]
    var sItemsALLs = sItemsALL
    
    
    sJsonLists.removeAll()
    sJsonTasks.removeAll()
    //sItemsALLs.removeAll()
    
    
    for listTask in listTasks { // listTasks
        
        let idList = String(listTask.id!)
        let tasks = TasksData.dataLoad(strPredicate: "idList = %@", filter: idList)
        
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        var strDate = ""
        sJsonTasks.removeAll()
        
        for task in tasks { // tasks
            if task.updatedDate == nil {
                task.updatedDate = Date()
            }
            
            strDate = Functions.dateToStringFormat(date: task.updatedDate!, minDateFormat: dateFormat)
            var dateTermination = ""
            if task.dateTermination != nil {
                dateTermination = Functions.dateToStringFormat(date: task.dateTermination!, minDateFormat: dateFormat)
            }
            
            sJsonTask = itemsTask(
                id: task.id!,
                title:     task.heading!,
                notes:     task.name!,
                updated:   strDate,
                isEnabled: task.isEnabled,
                color:     Int(task.color!),
                priority:  Int(task.priority!),
                status:     "needsAction",
                due: dateTermination,
                idList: idList,
                go:  task.go,
                turn: Int(task.turn!)

            )
                
            sJsonTasks.append(sJsonTask)
        }
        
        strDate = Functions.dateToStringFormat(date: listTask.updatedDate!, minDateFormat: dateFormat)
        sJsonList = itemsList(
            id: idList,
            title:  listTask.name!,
            updated:  strDate,
            items: sJsonTasks
        )
        sJsonLists.append(sJsonList)
    }
    
    sItemsALL = itemsALL(
//        id: listTask.id!,
//        title:  listTask.name!,
//        updated:  listTask.updatedDate!,
        items: sJsonLists
    )

    fileName = saveJSON(path: pathURL as! URL, named: fileName, object: sItemsALL)
    
    return fileName
}

func saveJSON<T: Encodable>(path: URL, named: String, object: T) -> String {
  
    var namedZip = named
    
    do {
//        let fileURL = try FileManager.default
//            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            .appendingPathComponent(named)
        let fileURL = path.appendingPathComponent(named)
        
        let encoder = try JSONEncoder().encode(object)

        try encoder.write(to: fileURL)
        
        // zip
        
        namedZip.replaceOccurrences(of: ".json", with: ".zip")
 //       let zipFilePath = try Zip.quickZipFiles([fileURL], fileName: fileURL) // Zip
        
        let fileURLZip = path.appendingPathComponent(namedZip)
        SSZipArchive.createZipFile(atPath: fileURLZip.path, withFilesAtPaths: [fileURL.path])
        //try FileManager().zipItem(at: fileURL, to: fileURLZip)
        
        // delete json
        do {
            try FileManager.default.removeItem(atPath: fileURL.path)
        } catch {
            print("Ошибка удаления файла : \(error)")
        }

    } catch {
        print("JSONSave error of \(error)")
    }
    
    return namedZip
}

// MARK: - struct

// MARK: - Codable
struct itemsALL: Codable {
    var items = [itemsList()]
    //var items = itemsList()
}
struct itemsList: Codable {
    var id = ""
    var title = ""
    var updated = ""//Date()
    var items = [itemsTask()]
}
struct itemsTask: Codable {
    var id = ""
    var title = ""
    //var heading : String
    var notes = ""
    var updated = ""
    var isEnabled = false
    var color = 0
    var priority = 0
    var status = ""
    var due = ""
    var idList = ""
    var go = false
    var turn = 0
}

//// MARK: -  Decodable
//struct itemsListD: Decodable {
//    var id = ""
//    var title = ""
//    var updated = Date()
//    var items = [itemsTaskD()]
//}
//struct itemsTaskD: Decodable {
//    var id = ""
//    var title = ""
//    //var heading : String
//    var notes = ""
//    var updated = Date()
//    var isEnabled = false
//    var color = 0
//    var priority = 0
//}

// MARK: - /////////
struct AttrObjects {
    var attrLists: [String] = ["id", "name", "updatedDate"]
    var attrTasks: [String] = ["id", "idList", "listName", "updatedDate", "name", "heading", "dateTermination", "isEnabled", "color", "priority", "status", "go", "turn"]
    var attrTasksApp: [String] = ["isEnabled", "color", "priority", "go", "turn"]
}

//class AttrObject {
//    var attrListsTasks: [String]// = []
//    var attrTasks: [String]// = []
//    var attrTasksApp: [String]// = []
//
//    init(attrListsTasks: attrListsTasks, attrTasks: attrTasks, attrTasksApp: attrTasksApp) {
//        attrListsTasks.append("id")
//        attrListsTasks.append("name")
//        attrListsTasks.append("updatedDate")
//
//        attrTasks.append("id")
//        attrTasks.append("idList")
//        attrTasks.append("listName")
//        attrTasks.append("updatedDate")
//        attrTasks.append("name")
//        attrTasks.append("heading")
//        attrTasks.append("dateTermination")
//
//        attrTasks.append("isEnabled")
//        attrTasks.append("color")
//        attrTasks.append("priority")
//
//        attrTasksApp.append("isEnabled")
//        attrTasksApp.append("color")
//        attrTasksApp.append("priority")
//    }
//
//}
