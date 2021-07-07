//
//  Json.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 11.11.2020.
//  Copyright © 2020 Test. All rights reserved.
//

import Foundation
import UIKit
//import Alamofire
import SwiftyJSON
import CoreData
import GoogleSignIn
import SSZipArchive
//import ZIPFoundation


//import PackageDescription

//func synchGoogle(){
//
//    // API_key = "AIzaSyDzIHRlMCv8RA97536YO_PhhjAsrm27HCs"
//    // id = "mypersonalassistant-275113"
//    // client_id = "556209321860-fq3nq9hpvklg2848pp67rvdt7e9b30vb.apps.googleusercontent.com"
//
//    /*   "https://accounts.google.com/o/oauth2/v2/auth?scope=https://www.google.com/m8/feeds&access_type=offline&include_granted_scopes=true&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&client_id=921647******-l5jcha3bt7r6q******bhtsgk*****um6.apps.googleusercontent.com"
//
//
//    let urlString =  "https://accounts.google.com/o/oauth2/v2/auth?scope=https://www.googleapis.com/auth/tasks&access_type=offline&include_granted_scopes=true&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&client_id=556209321860-fq3nq9hpvklg2848pp67rvdt7e9b30vb.apps.googleusercontent.com"
//
//     */
//    let urlString =  "https://accounts.google.com/o/oauth2/v2/auth"
//
//    let url = URL(string: urlString)
//
//    var request = URLRequest(url: url!)
//
//    request.setValue("scope", forHTTPHeaderField: "https://www.googleapis.com/auth/tasks")
//    request.setValue("access_type", forHTTPHeaderField: "offline")
//    request.setValue("include_granted_scopes", forHTTPHeaderField: "true")
//    request.setValue("redirect_uri", forHTTPHeaderField: "urn:ietf:wg:oauth:2.0:oob")
//    request.setValue("response_type", forHTTPHeaderField: "code")
//    request.setValue("client_id", forHTTPHeaderField: "556209321860-fq3nq9hpvklg2848pp67rvdt7e9b30vb.apps.googleusercontent.com")
//
//
//
//    let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
//        guard let data = data else { return }
//        print(String(data: data, encoding: .utf8)!)
//    }
//
//}

class JsonGoogle {
    
    class func parseJsonInObjects(json: JSON, vidObjects: String, idObjects: String) -> [Any?] {
        
        var GoogleObjects: [Any?] = []
        let attrObjects = AttrObjects()
        var attributs: [String] = []
        if vidObjects == "list" {
            //        GoogleObjects = ListTasksData.dataLoad(strPredicate: "", filter: "")
            //        GoogleObjects.removeAll()
            //guard let object = ListModel() else { return }
            
            //        let object: ListModel!
            //        //GoogleObjects = ListTasks
            //        GoogleObjects.append(object as? ListTasks)
            //        GoogleObjects.removeAll()
            attributs = attrObjects.attrLists
        }
        if vidObjects == "task" {
            attributs = attrObjects.attrTasks
        }
        
        for item in json["items"].arrayValue {
            let currListID = item["id"].string!
            if idObjects != "", currListID != idObjects {
                continue
            }
            
            //var object: Any?
            if vidObjects == "list" {
                var object = ListModel()
                //        for attribut in attributs {
                //            guard let value = item[attribut].string else { continue }
                //            object[attribut] = value
                //        }
                object.id = item["id"].string!
                var titleItem = item["title"].string
                var title = titleItem
                var searchStrs: [String] = []
                searchStrs.append("\n")
                let s = titleItem!.findSubString(inputStr: titleItem!, subStrings: searchStrs)
                if s.count > 0 {
                    let s1 = s[0].1
                    title = titleItem!.strRange(string: titleItem!, intStart: 0, IntFinish: s1)
                }
                object.name = title!
                let updateString = item["updated"].string!
                let strDate = dateInFormat1(strDate: updateString)
                object.updatedDate = strDate
                object.compare = false
                
                GoogleObjects.append(object)
                return GoogleObjects
            }
            
            if vidObjects == "task" {
                
                //for itemTask in json["items"].arrayValue { // Tasks
                let status = item["status"].string
                if status != "needsAction" {
                    continue
                }
                var nZTasks = 0
                
                //let newTask = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context)
                var object = TaskModel()
                //GoogleObjects.append(newTask as! Tasks)
                //nZTasks = GoogleObjects.count-1
                object.id = item["id"].string!
                //                    } else {
                //                        let newTask = objects[0]
                //                        nZTasks = tasks.firstIndex(of: newTask)!
                //                    }
                
                //                    let newTask = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context)
                //                    jsonTasks.append(newTask as! Tasks)
                //                    let nZTasks = jsonTasks.count-1
                //                    jsonTasks[nZTasks].id = itemTask["id"].string
                //                jsonTasks[nZTasks].idList = jsonListsTasks[nZl].id
                //                jsonTasks[nZTasks].listName = jsonListsTasks[nZl].name
                let updateString = item["updated"].string!
                let strDate1 = dateInFormat1(strDate: updateString)
                object.updatedDate = strDate1
                object.compare = false
                let titleTask = item["title"].string
                object.heading = titleTask!
                
                //
                var isDateTermination = false
                if let dateTermination = item["due"].string, item["due"].string != "" {
                    let strDate2 = dateInFormat1(strDate: dateTermination)
                    object.dateTermination = strDate2
                    isDateTermination = true
                }
                
                //                    if !isDateTermination, let dateTermination3 = itemTask["dataTermination"].string {
                //                        let strDate3 = dateInFormat1(strDate: dateTermination3)
                //                        jsonTasks[nZTasks].dateTermination = strDate3
                //                        isDateTermination = true
                //                    }
                
                if var notes = item["notes"].string {
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
                    object.name = notes
                    
                }
                
                //            for attrTask in attributs {
                //                if let strObject = item[attrTask].string {
                //                    object.setValue(strObject, forKey: attrTask)
                //                }
                //                if let strObject = item[attrTask].number {
                //                    object.setValue(strObject, forKey: attrTask)
                //                }
                //            }
                
                //            for (index, element) in object.enumerated() {
                //              print("Item \(index): \(element)")
                //            }
                
                //            //let mirror = Mirror(reflecting: object)
                //            for property in Mirror(reflecting: object).children {
                //                //print("name: \(property.label) type: \(type(of: property.value))")
                //                if let strObject = item[property.label!].string {
                //            //        property.value = strObject
                //                }
                //            }
                //
                //            for attrTask in attributs {
                //                if let strObject = item[attrTask].string {
                //                //    object.setValue(strObject, forKey: attrTask)
                //                }
                ////                if let strObject = item[attrTask].number {
                ////                    object.setValue(strObject, forKey: attrTask)
                ////                }
                //            }
                
                //            for number in 0..<attributs.count {
                //                if let strObject = item[attributs[number]].string {
                //                    object[number] = strObject
                //                }
                //                //                if let strObject = item[attributs[number]].number {
                //                //                    object[number] = strObject
                //                //                }
                //            }
                
                GoogleObjects.append(object)
            }
            // }
            
            //}
            
        }
        return GoogleObjects
    }
    
    
    class func googleObjectsInDataObjects(accTok: String, googleObjects: [Any], dataObjects: [Any]) {
        var vid = ""
        guard let googleObjectsList = googleObjects as? [ListModel], let googleObjectsTask = googleObjects as? [TaskModel] else {
            return
        }
        
        if googleObjectsList != nil {
            vid = "list"
        }
        if googleObjectsTask != nil {
            vid = "task"
        }
        
        if vid == "list" {
            let googleObjects = googleObjectsList
            
            for googleObject in googleObjects {
                
                let id = googleObject.id
                let currDataObjects = dataObjects.filter{ ($0 as AnyObject).id! == id }
            }
        }
        
    }
    
    class func dataObjectsInGoogleObjects(accTok: String, dataObjects: [Any]) {
            
            var vid = ""
    //        guard let dataObjectsList = dataObjects as? [ListModel], let dataObjectsTask = dataObjects as? [TaskModel] else {
//    //            return
//    //        }
//
//    //        switch dataObjects {
//    //        case dataObjects as? [ListModel]
//    //            <#code#>
//    //        case dataObjects as? [TaskModel]
//    //            <#code#>
//    //
//    //        default:
//    //            <#code#>
//            //        }
//
            if let dataObjectsList = dataObjects as? [ListTasks] {

                let currDataObjects = dataObjectsList

                for dataObject in currDataObjects {

                    let id = dataObject.id
                    let currListID = dataObject.id!

                    //https://tasks.googleapis.com/tasks/v1/users/@me/lists/{tasklist}
                    let urlString = "https://tasks.googleapis.com/tasks/v1/lists/\(currListID)/"
                    let updatedDate = Functions.dateToStringFormat(date: dataObject.updatedDate!, minDateFormat: "yyyy-MM-dd HH:mm")
                    
                    //let paramsBody = ["name": dataObject.name, "updatedDate": updatedDate] as [String : String]
                    //let paramsBody: [String : String] = ["name": dataObject.name!, "updatedDate": updatedDate]
                    let paramsBody: [String : String] = ["name": dataObject.name!]
                    //let bodystring = "{ \"title\": \"\(temptask.title)\",\"notes\": \"\(temptask.notes)\" }"
                    //let paramsBody = "{ \"status\": \"needsAction\", \"updatedDate\": \"\(updatedDate)\"}"

                    //let paramsBody = ["":""]
                    APIService().doRequestPatch(urlString: urlString, params: nil, accTok: accTok, paramsBody: paramsBody)

                    //let currDataObjects = dataObjects.filter{ ($0 as AnyObject).id! == id }
                }
                
            }
//
//    //        if let dataObjectsList as? [ListModel] == nil, let dataObjectsTask as? [TaskModel] == nil {
//    //            return
//    //        }
//
//    //        guard let dataObjectsList = dataObjects as? [ListModel] else {
//    //            vid = ""
//    //        }
//    //        guard let dataObjectsTask = dataObjects as? [ListModel] else {
//    //            vid = ""
//    //        }
//
//    //        if dataObjectsList != nil {
//    //            vid = "list"
//    //        }
//    //        if dataObjectsTask != nil {
//    //            vid = "task"
//    //        }
//    //
//    //        if vid == "list" {
//    //            let dataObjects = dataObjectsList
//    //
//    //            for dataObject in dataObjects {
//    //
//    //                let id = dataObject.id
//    //                let currListID = dataObject.id
//    //
//    //                //https://tasks.googleapis.com/tasks/v1/users/@me/lists/{tasklist}
//    //                let urlString = "https://tasks.googleapis.com/tasks/v1/lists/\(currListID)/"
//    //                let paramsBody = ["title": dataObject.name, "updatedDate": dataObject.updatedDate] as [String : Any]
//    //                APIService().doRequestPatch(urlString: urlString, params: nil, accTok: currListID, paramsBody: paramsBody)
//    //
//    //
//    //
//    //                //let currDataObjects = dataObjects.filter{ ($0 as AnyObject).id! == id }
//    //            }
//    //        }
//
        
        }
        
    } //class

    




//struct ObjectsModificationGoogle {
//    var lists: [(String, ListTasks)]? = []
//    var tasks: [(String,Tasks)]? = []
////    init(lists: [(String, ListTasks)], tasks: [(String,Tasks)]) {
////        init() {
////        self.lists = lists
////        self.tasks = tasks
////    }
//}


//func parseJsonsGoogle(jsonList: JSON, jsonTasks: JSON, listID: String = "")  throws {
////    var filter = listID
////    var predicate = "id == %@"//NSPredicate(format: "id = %@", filter!)
////    if listID == "" {
////        predicate = ""
////        filter = ""
////    }
////    var listsData = ListTasksData.dataLoad(strPredicate: predicate, filter: filter)
//
//    let tasksData = TasksData.dataLoad(strPredicate: "", filter: "")
//
//    let attrObjects = AttrObjects()
//    var attrLists = attrObjects.attrLists
//    var attrTasks = attrObjects.attrTasks
//    var attrTasksApp = attrObjects.attrTasksApp
//
//    let appDelegate =
//        UIApplication.shared.delegate as! AppDelegate
//    let context = appDelegate.persistentContainer.viewContext
//
//    //var listObject: ListTasks?
//
//    var nZl = 0
//    var item = jsonList
//
////    var newObject = NSEntityDescription.insertNewObject(forEntityName: "ListTasks", into: context)
////    var listObject = newObject as? ListTasks
//    var listObject = ListModel()
//    //newObject = nil
//    listObject.id = jsonList["id"].string!
//    var titleItem = jsonList["title"].string
//    var title = titleItem
//    var searchStrs: [String] = []
//    searchStrs.append("\n")
//    let s = titleItem!.findSubString(inputStr: titleItem!, subStrings: searchStrs)
//    if s.count > 0 {
//        let s1 = s[0].1
//        title = titleItem!.strRange(string: titleItem!, intStart: 0, IntFinish: s1)
//    }
//    listObject.name = title!
//    let updateString = jsonList["updated"].string!
//    let strDate = dateInFormat1(strDate: updateString)
//    listObject.updatedDate = strDate
//    listObject.compare = false
//
//    // tasks
//    var tasksJson: [Tasks] = []
//
//    for itemTask in jsonTasks["items"].arrayValue { // Tasks
//        let status = itemTask["status"].string
//        if status != "needsAction" {
//            continue
//        }
//        var nZTasks = 0
//        //var newTask: Tasks? = Tasks()
//
//        let id = itemTask["id"].string
//        let objectsData = tasksData.filter{( $0.id == id)}
//
//        if objectsData.count == 0 {
//            let newTaskData = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context)
//            tasksJson.append(newTaskData as! Tasks)
//            nZTasks = tasksJson.count-1
//            tasksJson[nZTasks].id = itemTask["id"].string
//        } else {
//            //newTask = objectsData[0]
//            tasksJson.append(objectsData[0])
//            nZTasks = tasksJson.count-1
//        }
//
////        tasksJson[nZTasks].idList = listsJson[0].id
////        tasksJson[nZTasks].listName = listsJson[0].name
//        tasksJson[nZTasks].idList = listObject.id
//        tasksJson[nZTasks].listName = listObject.name
//
//        let updateString = itemTask["updated"].string!
//        let strDate1 = dateInFormat1(strDate: updateString)
//        tasksJson[nZTasks].updatedDate = strDate1
//        tasksJson[nZTasks].compare = false
//        let titleTask = itemTask["title"].string
//        tasksJson[nZTasks].heading = titleTask
//
//        //
//        var isDateTermination = false
//        if let dateTermination = itemTask["due"].string, itemTask["due"].string != "" {
//            let strDate2 = dateInFormat1(strDate: dateTermination)
//            tasksJson[nZTasks].dateTermination = strDate2
//            isDateTermination = true
//        }
//
//        if var notes = itemTask["notes"].string {
//            var alarmPeriod = ""
//            var searchStrs: [String] = []
//            searchStrs.append("@")
//            let s = titleTask!.findSubString(inputStr: titleTask!, subStrings: searchStrs)
//            if s.count > 0 { // alarmPeriod
//                searchStrs.removeAll()
//                searchStrs.append("\n")
//                let s = titleTask!.findSubString(inputStr: titleTask!, subStrings: searchStrs)
//                if s.count > 0 {
//                    let s1 = s[0].1
//                    alarmPeriod = titleTask!.strRange(string: titleTask!, intStart: 0, IntFinish: s1)
//                    if s1 > titleTask!.count {
//                        notes = titleTask!.strRange(string: titleTask!, intStart: s1+1, IntFinish: 1000)
//                    }
//                }
//            }
//            tasksJson[nZTasks].name = notes
//        }
//
//        for attrTask in attrTasksApp {
////                        if attrTask == "status" {
////                            continue
////                        }
//            if let strObject = itemTask[attrTask].string {
//                tasksJson[nZTasks].setValue(strObject, forKey: attrTask)
//            }
//            if let strObject = itemTask[attrTask].number {
//                tasksJson[nZTasks].setValue(strObject, forKey: attrTask)
//            }
//        }
//    }
//
//    // update ///////////////
//
//    // источник
//    var objectsSource = tasksData
//    // приемник
//    var objectsReceiver = tasksJson
//
//    let filter = listObject.id
//    let predicate = "id == %@"
//
//    let listsData = ListTasksData.dataLoad(strPredicate: predicate, filter: filter)
//
//    if listsData.count > 0 {
//        if listObject.updatedDate > listsData[0].updatedDate! {
//            objectsSource = tasksJson
//            objectsReceiver = tasksData
//        }
//    }
//
//    //uploadObjects(dataObjects: objectsSource, GoogleObjects: objectsReceiver, attributs: <#T##[String]#>)
//
////    for objectSource in objectsSource {
////        for attribut in attrLists {
//////            if let strObject = objectSource[attribut] {
//////                objectsReceiver[attribut] = strObject
//////            }
////        }
////    }
////
//
//}

//func parseJsonGoogleOLD(json: JSON, listID: String = "")  throws -> [(String, Any)]{
////    let appDelegate =
////        UIApplication.shared.delegate as! AppDelegate
////    let context = appDelegate.persistentContainer.viewContext
//    var filter = listID
//    var predicate = "id == %@"//NSPredicate(format: "id = %@", filter!)
//    if listID == "" {
//        predicate = ""
//        filter = ""
//    }
//
//    let lists = ListTasksData.dataLoad(strPredicate: predicate, filter: filter)
//    let tasksAll = TasksData.dataLoad(strPredicate: "", filter: "")
//
////    var jsonLists: [ListTasks] = []
////    var jsonTasks: [Tasks] = []
//
//    let attrObjects = AttrObjects()
//    let attrListsTasks = attrObjects.attrLists
//    let attrTasks = attrObjects.attrTasks
//    let attrTasksApp = attrObjects.attrTasksApp
//    var jsonLists: [ListTasks] = []
//
//
//    var isList = false
//    if listID != "" && lists.count > 0 { // there is list
//        jsonLists.append(lists[0])
//        isList = true
//    }
//
//    // List
//    var objectsModificationGoogle: [(String, Any)] = []
//    var objectsModificationData: [(String, Any)] = []
//    if !isList { // по всем
//        jsonLists = parseJsonLists(json: json, attrObjects: attrObjects, listID: listID)
//        let resume = uploadObjectsByUpdateDate(dataObjects: lists, GoogleObjects: jsonLists, attributs: attrListsTasks)
////        if resume.1 {
////            objectsModificationGoogle += resume.0
////        }
//        clearCoreData(objects: jsonLists)
//        updateAfterJson(typeObjects: "List", type: "Data", objectsModification: objectsModificationData)
//        updateAfterJson(typeObjects: "List", type: "Google", objectsModification: objectsModificationGoogle)
//
//    }
//
//    // Tasks
//    objectsModificationData.removeAll()
//    objectsModificationGoogle.removeAll()
//
//    for jsonList in jsonLists {
//        var jsonTasks = parseJsonTasks(json: json, attrObjects: attrObjects, jsonList: jsonList, attrTasksApp: attrTasksApp, tasksAll: tasksAll)
//        var tasks = tasksAll.filter{ ($0.idList == jsonList.id) }
//        let resume = uploadObjectsByUpdateDate(dataObjects: tasks, GoogleObjects: jsonTasks, attributs: attrTasks, attributsAPP: attrTasksApp)
//        if resume.1 {
//            objectsModificationGoogle += resume.0
//        } else {
//            objectsModificationData  += resume.0
//        }
//        //clearCoreData(objects: jsonTasks)
//    }
//
//    updateAfterJson(typeObjects: "Tasks", type: "Data", objectsModification: objectsModificationData)
//    updateAfterJson(typeObjects: "Tasks", type: "Google", objectsModification: objectsModificationGoogle)
//
//    saveObjectsAfterJson()
//
////    clearCoreData(objects: jsonLists)
////    clearCoreData(objects: jsonTasks)
////    jsonListsTasks.removeAll()
////    jsonTasks.removeAll()
//
//    return objectsModificationGoogle
//}

//func updateAfterJson(typeObjects: String, type: String, objectsModification: [(String, Any)]) {
//    if type == "Data" {
//
////        let appDelegate =
////            UIApplication.shared.delegate as! AppDelegate
////        let context = appDelegate.persistentContainer.viewContext
//
//        let attrObjects = AttrObjects()
//        let attrListsTasks = attrObjects.attrLists
//        let attrTasks = attrObjects.attrTasks
//        let attrTasksApp = attrObjects.attrTasksApp
//
//
//        var objectsDataAll: [AnyObject]?
//        if typeObjects == "List" {
//            objectsDataAll = ListTasksData.dataLoad(strPredicate: "", filter: "")
//        }
//        if typeObjects == "Tasks" {
//            objectsDataAll = TasksData.dataLoad(strPredicate: "", filter: "")
//        }
//
//        for objectCorteg in objectsModification {
//            let status = objectCorteg.0
//            let object = objectCorteg.1
//            if let objectModification = object as? Tasks {//}, object as? ListTasks {
//                let objectsData = objectsDataAll!.filter{( $0.id == objectModification.id)}
//                if objectsData.count == 0 {
//                    //let newTask = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context)
//                    let newTask = objectModification
//                    objectsDataAll!.append(newTask as! Tasks)
////                    let nZ = objectsDataAll!.count-1
////                    objectsDataAll![nZ].id = objectModification.id
//
//                }
//                if status == "delete" {
//                    objectsDataAll!.removeAll{( $0.id == objectModification.id)}
//                }
//
//                if status == "update" {
//                    var objectData = objectsData[0]
//                    let attributs = attrTasks
//                    for i in 0..<attributs.count {
//                        var attribut = attributs[i]
//                        var currAttrObjectModification = objectModification.value(forKey: attribut)
//                        var currAttrObject = objectData.value(forKey: attribut)
//
////                        if compareV(v0: currAttrObjectModification, v1: currAttrObject) {
////                            continue
////                        }
//                        //updateObject = true
//                        objectModification.setValue(currAttrObject, forKey: attribut)
//
//                    }
//                }
////                // update
////                if updateObject == true {
////                    saveObjectsAfterJson()
////                }
//                //}
//
//            }
//        }
//    }
//
//    if type == "Google" {
//
//    }
//}

//func parseJsonLists(json: JSON, attrObjects: AttrObjects, listID: String) -> [ListTasks] {
//    let appDelegate =
//        UIApplication.shared.delegate as! AppDelegate
//    let context = appDelegate.persistentContainer.viewContext
//
//    var GoogleObjects: [ListTasks] = []
//
////    let adress = json["items"].arrayValue[0]["selfLink"].string
////
////    if ((adress?.contains("\(listID)/tasks/")) == nil) { // lists
////
////    }
//
//
//    for item in json["items"].arrayValue { // listTasks
//        var nZl = 0
//
//        let newTask = NSEntityDescription.insertNewObject(forEntityName: "ListTasks", into: context)
//        //let newTask = ListTasks()
//        GoogleObjects.append(newTask as! ListTasks)
//        nZl = GoogleObjects.count-1
//        GoogleObjects[nZl].id = item["id"].string
//
//        var titleItem = item["title"].string
//        var title = titleItem
//        var searchStrs: [String] = []
//        searchStrs.append("\n")
//        let s = titleItem!.findSubString(inputStr: titleItem!, subStrings: searchStrs)
//        if s.count > 0 {
//            let s1 = s[0].1
//            title = titleItem!.strRange(string: titleItem!, intStart: 0, IntFinish: s1)
//        }
//
//        GoogleObjects[nZl].name = title
//        let updateString = item["updated"].string!
//        let strDate = dateInFormat1(strDate: updateString)
//        GoogleObjects[nZl].updatedDate = strDate
//
//        GoogleObjects[nZl].compare = false
//    }
//
//    return GoogleObjects
//}

//func parseJsonTasks(json: JSON, attrObjects: AttrObjects, jsonList: ListTasks, attrTasksApp: [String], tasksAll: [Tasks]) -> [Tasks] {
//
//    let appDelegate =
//        UIApplication.shared.delegate as! AppDelegate
//    let context = appDelegate.persistentContainer.viewContext
//
//    var GoogleObjects: [Tasks] = []
//
//    //    let adress = json["items"].arrayValue[0]["selfLink"].string
//    //
//    //    if ((adress?.contains("\(listID)/tasks/")) == nil) { // lists
//    //
//    //    }
//
//
//    for itemTask in json["items"].arrayValue { // Tasks
//        let status = itemTask["status"].string
//        if status != "needsAction" {
//            continue
//        }
//        var nZTasks = 0
//        //var newTask: Tasks? = Tasks()
//
//        let id = itemTask["id"].string
//        let objectsData = tasksAll.filter{( $0.id == id)}
//
//        if objectsData.count == 0 {
//            let newTaskData = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context)
//            GoogleObjects.append(newTaskData as! Tasks)
//            nZTasks = GoogleObjects.count-1
//            GoogleObjects[nZTasks].id = itemTask["id"].string
//        } else {
//            //newTask = objectsData[0]
//            GoogleObjects.append(objectsData[0])
//            nZTasks = GoogleObjects.count-1
//        }
//
//        GoogleObjects[nZTasks].idList = jsonList.id
//        GoogleObjects[nZTasks].listName = jsonList.name
//        let updateString = itemTask["updated"].string!
//        let strDate1 = dateInFormat1(strDate: updateString)
//        GoogleObjects[nZTasks].updatedDate = strDate1
//        GoogleObjects[nZTasks].compare = false
//        let titleTask = itemTask["title"].string
//        GoogleObjects[nZTasks].heading = titleTask
//
//        //
//        var isDateTermination = false
//        if let dateTermination = itemTask["due"].string, itemTask["due"].string != "" {
//            let strDate2 = dateInFormat1(strDate: dateTermination)
//            GoogleObjects[nZTasks].dateTermination = strDate2
//            isDateTermination = true
//        }
//
////                    if !isDateTermination, let dateTermination3 = itemTask["dataTermination"].string {
////                        let strDate3 = dateInFormat1(strDate: dateTermination3)
////                        jsonTasks[nZTasks].dateTermination = strDate3
////                        isDateTermination = true
////                    }
//
//        if var notes = itemTask["notes"].string {
//            var alarmPeriod = ""
//            var searchStrs: [String] = []
//            searchStrs.append("@")
//            let s = titleTask!.findSubString(inputStr: titleTask!, subStrings: searchStrs)
//            if s.count > 0 { // alarmPeriod
//                searchStrs.removeAll()
//                searchStrs.append("\n")
//                let s = titleTask!.findSubString(inputStr: titleTask!, subStrings: searchStrs)
//                if s.count > 0 {
//                    let s1 = s[0].1
//                    alarmPeriod = titleTask!.strRange(string: titleTask!, intStart: 0, IntFinish: s1)
//                    if s1 > titleTask!.count {
//                        notes = titleTask!.strRange(string: titleTask!, intStart: s1+1, IntFinish: 1000)
//                    }
//
//                }
//            }
//            GoogleObjects[nZTasks].name = notes
//
//        }
//
//        for attrTask in attrTasksApp {
////                        if attrTask == "status" {
////                            continue
////                        }
//            if let strObject = itemTask[attrTask].string {
//                GoogleObjects[nZTasks].setValue(strObject, forKey: attrTask)
//            }
//            if let strObject = itemTask[attrTask].number {
//                GoogleObjects[nZTasks].setValue(strObject, forKey: attrTask)
//            }
//
//        }
//
//    }
//    return GoogleObjects
//
//
//}


func dateInFormat1(strDate: String) -> Date {
    var str = strDate
    str.replaceOccurrences(of: "-", with: ".")
    str.replaceOccurrences(of: "T", with: " ")
    str = str.strRange(string: str, intStart: 0, IntFinish: 19)
    let dateDate = Functions.dateFromString(dateStr: str, format: 1)
    //let strDate = Functions.dateFromStringFormat(dateStr: updateString, dateFormat: "E, d MMM yyyy HH:mm:ss Z")
    return dateDate!
}



//func uploadObjectsByUpdateDate(dataObjects: [AnyObject], GoogleObjects: [AnyObject], attributs: [String], attributsAPP: [String]? = nil) -> ([(String, Any)], Bool) {
//
//    let nattributsAPP = attributsAPP
//    //        if dataObjects == GoogleObjects {
//    //            return
//    //        }
//
//    let appDelegate =
//        UIApplication.shared.delegate as! AppDelegate
//    let context = appDelegate.persistentContainer.viewContext
//
//    //var aDeleted: [AnyObject] = []
//    var objectsModification: [(String, Any)] = []
//
//    //var updateObject = false
//    var dataObjects = dataObjects
//    var GoogleObjects = GoogleObjects
//    //
//    var determineDirection = false
////    var dataObjectsSortUpdateDate = dataObjects
////    var GoogleObjectsSortUpdateDate = GoogleObjects
//    var updateGoogle = true
//
////    if var objects = dataObjectsSortUpdateDate as? [Tasks] {
////        objects.sort(by: { (s1: Tasks, s2: Tasks) -> Bool in return s1.updatedDate! > s2.updatedDate! } )
////        dataObjectsSortUpdateDate = objects
////    }
////    if var objects = GoogleObjectsSortUpdateDate as? [Tasks] {
////        objects.sort(by: { (s1: Tasks, s2: Tasks) -> Bool in return s1.updatedDate! > s2.updatedDate! } )
////        GoogleObjectsSortUpdateDate = objects
////    }
//
//    if var objects = dataObjects as? [Tasks] {
//        objects.sort(by: { (s1: Tasks, s2: Tasks) -> Bool in return s1.updatedDate! > s2.updatedDate! } )
//        dataObjects = objects
//        //dataObjectsSortUpdateDate = objects
//    }
//    if var objects = GoogleObjects as? [Tasks] {
//        objects.sort(by: { (s1: Tasks, s2: Tasks) -> Bool in return s1.updatedDate! > s2.updatedDate! } )
//        GoogleObjects = objects
//        //GoogleObjectsSortUpdateDate = objects
//    }
//    // источник
//    var objectsSource = dataObjects
//    // приемник
//    var objectsReceiver = GoogleObjects
//
//    var maxDateDataObjects = Date()
//    var maxDateGoogleObjects = Date()
//
//    if dataObjects.count == 0 {
//        objectsSource = GoogleObjects
//        objectsReceiver = dataObjects
//        determineDirection = true
//    } else {
//        if let currObjects = dataObjects as? [Tasks] {
//            maxDateDataObjects = currObjects[0].updatedDate!
//        }
//    }
//    if !determineDirection && GoogleObjects.count == 0 {
//        determineDirection = true
//    } else {
//        if let currObjects = GoogleObjects as? [Tasks] {
//            maxDateGoogleObjects = currObjects[0].updatedDate!
//        }
//    }
//    if !determineDirection && maxDateGoogleObjects > maxDateDataObjects {
//        objectsSource = GoogleObjects
//        objectsReceiver = dataObjects
//        determineDirection = true
//        updateGoogle = false
//    }
//
//    // objects compare with GoogleObjects
//    for object in objectsSource {
//        // object.compare = true
//        object.setValue(true, forKey: "compare") // просмотрен!
//        let objectsReceiverFilter = objectsReceiver.filter({$0.id == object.id})
//
//        if objectsReceiverFilter.count == 0 {
//            objectsModification.append(("insert", object))
//            continue
//        }
//        //var objectReceiver = object
//        //var objectReceiver = objectsReceiverFilter[0]
//        objectsReceiverFilter[0].setValue(true, forKey: "compare")
//        objectsModification.append(("update", object))
//
//
////        var isModifi = false
////        for i in 0..<attributs.count {
////            let attribut = attributs[i]
//////            if attribut == "status" {
//////                continue
//////            }
////
////            if nattributsAPP != nil {
////                if nattributsAPP!.contains(attribut) {
////                    continue
////                }
////            }
////            var currAttrObjectSourse = object.value(forKey: attribut)
////            let currAttrObjectReceiver = objectReceiver.value(forKey: attribut)
////            if compareV2(v0: currAttrObjectSourse as AnyObject, v1: currAttrObjectReceiver as AnyObject) {
////                continue
////            }
////            if currAttrObjectSourse == nil && currAttrObjectReceiver == nil {
////                continue
////            }
////            //updateObject = true
////            object.setValue(currAttrObjectReceiver, forKey: attribut)
////
////        }
////        if isModifi {
////            objectsModificationGoogle.append(("update", object))
////        }
//
//    }
//
////    if !updateGoogle {
////        return (objectsModification, updateGoogle)
////    }
//
////    // исключаем уже просмотренные
//    let objectsReceiverFilter = objectsReceiver.filter({$0.compare != true})
//
//    for objectReceiver in objectsReceiverFilter {
//
//        objectsModification.append(("delete", objectReceiver))
////        objectReceiver.setValue(true, forKey: "compare")
////        var objectsFilter = objectsSource.filter({$0.id == objectReceiver.id})
////        if objectsFilter.count == 0 {
////
////            objectsModification.append("insert", object)
////
////            var newTask = objectReceiver
////
//////            var newTask: AnyObject
//////
//////            switch objectReceiver {
//////
//////            case let objectReceiver as ListTasks:
//////                newTask = NSEntityDescription.insertNewObject(forEntityName: "ListTasks", into: context)
//////                //newTask = TasksEmpty()
//////            case let objectReceiver as Tasks:
//////                newTask = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context)
//////                //newTask = ListModel()
//////
//////            default:
//////                newTask = Tasks()
//////            }
////            objectsFilter.append(newTask)
////        }
////
////        let object = objectsFilter[0]
////
////        for i in 0..<attributs.count {
////            let attribut = attributs[i]
//////            if nattributsAPP != nil {
//////                if nattributsAPP!.contains(attribut) {
//////                    continue
//////                }
//////            }
////
////            //var currAttrObject = object.value(forKey: attribut)
////            let currAttrObjectReceiver = objectReceiver.value(forKey: attribut)
//////                if compareV(v0: currAttrObject, v1: currAttrJsonObject) {
//////                    continue
//////                }
////            //updateObject = true
////            object.setValue(currAttrObjectReceiver, forKey: attribut)
////
////        }
//    }
////
////
//////    // update
//////    if updateObject == true {
//////        saveObjectsAfterJson()
//////    }
//
//    //return (objectsModification, updateGoogle)
//    return (objectsModification, updateGoogle)
//}
//    class func uploadObjectsListTask(dataObjects: [ListTasks], GoogleObjects: [ListTasks], attributs: [String]) {
//        //        if dataObjects == GoogleObjects {
//        //            return
//        //        }
//        var aDeleted: [ListTasks] = []
//        var updateObject = false
//
//        for object in dataObjects {
//            object.compare = true
//            let GoogleObjectsFilter = GoogleObjects.filter({$0.id == object.id})
//            if GoogleObjectsFilter.count == 0 {
//                aDeleted.append(object)
//                continue
//            }
//            let jsonObject = GoogleObjectsFilter[0]
//            jsonObject.compare = true
//            //            if (object as! ListTasks) === (jsonObject as! ListTasks) {
//            //                continue
//            //            }
//
//            for i in 0..<attributs.count {
//                var attribut = attributs[i]
//                var currAttrObject = object.value(forKey: attribut)
//                var currAttrJsonObject = jsonObject.value(forKey: attribut)
//                //                if currAttrObject == currAttrJsonObject {
//                //                    continue
//                //                }
//                //                if currAttrObject === currAttrJsonObject {
//                //                    continue
//                //                }
//                //                if (currAttrObject as! NSObject) === (currAttrJsonObject as! NSObject) {
//                //                    continue
//                //                }
//                if compareV(v0: currAttrObject, v1: currAttrJsonObject) {
//                    continue
//                }
//                updateObject = true
//                object.setValue(currAttrJsonObject, forKey: attribut)
//
//            }
//        }
//        // update
//        if updateObject == true {
//            saveObjectsAfterJson()
//        }
//
//    }

//    class func compareV(v0: Any, v1: Any) -> Bool {
//        switch v0 {
//        //case .None: return true
//        case let v0 as String:
//            //let v1 = v1 as! String
//            if let v1 = v1 as? String { return !(v0 == v1) }; return true
//            //return v0 == v1
//        case let v0 as Int:
//            if let v1 = v1 as? Int { return !(v0 == v1) }; return true
//        case let v0 as Date:
//            if let v1 = v1 as? Date { return !(v0 == v1) }; return true
//        /* ...
//         expand with the known possible types of your array elements
//         ... */
//        case _ : return true
//        /*  */
//        }
//
//    }

