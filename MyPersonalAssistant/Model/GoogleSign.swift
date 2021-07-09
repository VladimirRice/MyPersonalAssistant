//
//  GoogleSign.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 14.04.2021.
//

import Foundation
import GoogleSignIn
import SwiftyJSON



//func googleSign(selfVC: UIViewController, listID: String) {
//    let user = GIDSignIn.sharedInstance()!.currentUser
//    if user == nil {
//        GIDSignIn.sharedInstance().delegate = selfVC as! GIDSignInDelegate
//        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/tasks")
//        GIDSignIn.sharedInstance().signIn()
//        //return true
//    } else {
//        return false
//    }
//    //updateScreenSign()
//    return true
//}

func initialSign(selfVC: UIViewController) {
    //googleSignButton.clipsToBounds = true  //
    // 1
    let clientID = UserDefaults.standard.object(forKey: "clientID") as! String
    GIDSignIn.sharedInstance().clientID = clientID
    // 2
    //GIDSignIn.sharedInstance().delegate = selfVC
    // 3
    GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    GIDSignIn.sharedInstance()?.presentingViewController = selfVC
}

func googleSynchron(selfVC: UIViewController, listID: String) -> Bool {
    initialSign(selfVC: selfVC)
    let user = GIDSignIn.sharedInstance()!.currentUser
    if user == nil {
//        GIDSignIn.sharedInstance().delegate = selfVC as? GIDSignInDelegate
//        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/tasks")
//        GIDSignIn.sharedInstance().signIn()
//        GIDSignIn.sharedInstance()?.currentUser
        return false
    }
    
    if (GIDSignIn.sharedInstance()?.currentUser) != nil {
        
        var status = true
        if listID != "" {
            let message = ""
            let title = "Синхронизация с Google"
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alertController.addAction(UIAlertAction(title: "Текущий список", style: UIAlertAction.Style.default, handler: { [weak alertController] (action) -> Void in
                var listID = listID
                listID = ""
                googleSynchronNext(selfVC: selfVC, listID: listID)
                //googleSynchronNextAPIService(selfVC: selfVC, listID: listID)
                status = true
            }
            ))
 
            alertController.addAction(UIAlertAction(title: "ВСЕ", style: UIAlertAction.Style.default, handler: { [weak alertController] (action) -> Void in

                googleSynchronNext(selfVC: selfVC, listID: "")
                //googleSynchronNextAPIService(selfVC: selfVC, listID: listID)
                status = true
            }
            ))

            // cancel
            alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { [weak alertController] (action) -> Void in
                status = false
            }
            ))
            
            // show the alert
            selfVC.present(alertController, animated: true, completion: nil)
        }
    
        return status
    } else {
        return false
    }
    return true
}

//func googleSynchronNextAPIService(selfVC: UIViewController, listID: String) {
//    
//    var accessToken: String?
//    
//    GIDSignIn.sharedInstance().currentUser.authentication.getTokensWithHandler { (authentication, error) in
//        
//        if let err = error {
//            print(err)
//        } else {
//            if let auth = authentication {
//                accessToken = auth.accessToken
//                //accessToken = auth.refreshToken
//            }
//        }
//    }
//    
//    if let accTok = accessToken {
//        
////        var jsonList: [Any] = []
////        var jsonTasks: [Any] = []
//        do {
//            // list
//            let urlString = "https://tasks.googleapis.com/tasks/v1/users/@me/lists"
//            //let urlString = "https://tasks.googleapis.com/tasks/v1/users/@me/lists/\(listID)"
//            
// //           APIService().doRequestParseJson(httpMethod: "GET", urlString: urlString, params: nil, accTok: accTok, vid: "list", completion: { (json, error) in
//            
////                }
////            )
//            
//            APIService().doRequest(httpMethod: "GET", urlString: urlString, params: nil, accTok: accTok, completion: { (json, error) in
//                guard let jsonOfRequest = json as? JSON else {print("\(String(describing: error))"); return}
//                let jsonListFromJson = parseJsonInObjects(json: jsonOfRequest, vidObjects: "list", idObjects: listID)
//                //jsonList = jsonList + jsonListFromJson
//                let jsonList = jsonListFromJson
//                var filter = listID
//                var predicate = "id == %@"//NSPredicate(format: "id = %@", filter!)
//                if listID == "" {
//                    predicate = ""
//                    filter = ""
//                }
//                var dataList = ListTasksData.dataLoad(strPredicate: predicate, filter: filter)
//
//
//                if jsonList.count == 0 {
//
//                }
//
//                // tasks
//                for list in jsonList {
//                    let currList = list as? ListModel
//                    let currListID = currList!.id
//                    let urlStringTasks = "https://tasks.googleapis.com/tasks/v1/lists/\(currListID)/tasks"
//                    APIService().doRequest(httpMethod: "GET", urlString: urlStringTasks, params: nil, accTok: accTok, completion: { (json, error) in
//                        guard let jsonOfRequest = json as? JSON else {print("\(String(describing: error))"); return}
//                        let jsonTasksOfList = parseJsonInObjects(json: jsonOfRequest, vidObjects: "task", idObjects: "")
//                        //jsonTasks = jsonTasks + jsonTasksOfList
//                        let jsonTasks = jsonTasksOfList
//                    })
//                }
//
//            })
//            
//            
//            
//        } catch let error {
//         print(error)
//        }
//
////        }
//    }
//}


func googleSynchronNext(selfVC: UIViewController, listID: String) {
    
    var accessToken: String?
    
    GIDSignIn.sharedInstance().currentUser.authentication.getTokensWithHandler { (authentication, error) in
        
        if let err = error {
            print(err)
        } else {
            if let auth = authentication {
                accessToken = auth.accessToken
                //accessToken = auth.refreshToken
            }
        }
    }
    
    if let accTok = accessToken {
    
//        var listID = listID
//        listID = ""
        
//        var jsonList: [Any] = []
//        var jsonTasks: [Any] = []
        do {
            // list
            let urlString = "https://tasks.googleapis.com/tasks/v1/users/@me/lists"
            //let urlString = "https://tasks.googleapis.com/tasks/v1/users/@me/lists/\(listID)"
            
            APIService().doRequest(urlString: urlString, params: nil, accTok: accTok, completion: { (json, error) in
                guard let jsonOfRequest = json as? JSON else {print("\(String(describing: error))"); return}
                let googleListFromJson = JsonGoogle.parseJsonInObjects(json: jsonOfRequest, vidObjects: "list", idObjects: listID)
                let googleObjectsList = googleListFromJson
        
                let dataObjectsListAll = ListTasksData.dataLoad(strPredicate: "", filter: "")
                var dataObjectsList = dataObjectsListAll
                if listID != "" {
                    dataObjectsList = dataObjectsListAll.filter { $0.id == listID }
                }
                
                let dataObjectsTaskAll = TasksData.dataLoad(strPredicate: "", filter: "")
                var dataObjectsTask = dataObjectsTaskAll
                if listID != "" {
                    dataObjectsTask = dataObjectsTaskAll.filter { $0.idList == listID }
                }

                // no google
                if googleObjectsList.count == 0 {
                    JsonGoogle.dataObjectsInGoogleObjects(accTok: accTok, dataObjects: dataObjectsList)
                    JsonGoogle.dataObjectsInGoogleObjects(accTok: accTok, dataObjects: dataObjectsTask)
                    return
                }
            
                var dataObjectsListModifi = dataObjectsList
                dataObjectsListModifi.removeAll()

                // list
                for googleObjectList in googleObjectsList {
        
                    var directionModifiListDataGoogle = false
                    var directionModifiTaskDataGoogle = false
                    
                    let currDataObjectsList = dataObjectsList.filter {$0.id == (googleObjectList as! ListModel).id}
                    var currDataObjectList: ListTasks!// = ListTasks()
                    
                    // dataObjectsList is true
                    if currDataObjectsList.count > 0 {
                        currDataObjectList = currDataObjectsList[0]
                        if (currDataObjectList.updatedDate)! == ((googleObjectList as! ListModel).updatedDate) {
                            continue
                        }
                        if (currDataObjectList.updatedDate)! > ((googleObjectList as! ListModel).updatedDate) {
                            directionModifiListDataGoogle = true
                            directionModifiTaskDataGoogle = true
                            //JsonGoogle.dataObjectsInGoogleObjects(accTok: accTok, dataObjects: [currDataObjectList])
                        }
                    }
                    
                    // надо сделать стереть лишние списки !!
                    
                    // data in google
                    if directionModifiListDataGoogle, currDataObjectList != nil { // data in google
                        JsonGoogle.dataObjectsInGoogleObjects(accTok: accTok, dataObjects: [currDataObjectList!])
                        let currDataObjectsTask = dataObjectsTask.filter {$0.idList == (googleObjectList as! ListModel).id}
                        JsonGoogle.dataObjectsInGoogleObjects(accTok: accTok, dataObjects: [currDataObjectsTask])
                        continue
                    }
                    
                    // google in data
                    JsonGoogle.googleObjectsInDataObjects(accTok: accTok, googleObjects: [googleObjectList!])
                    // tasks else google in data
                    let currListID = (googleObjectList! as! ListModel).id
                    let urlStringTasks = "https://tasks.googleapis.com/tasks/v1/lists/\(currListID)/tasks"
                    APIService().doRequest(urlString: urlStringTasks, params: nil, accTok: accTok, completion: { (json, error) in
                        guard let jsonOfRequest = json as? JSON else {print("\(String(describing: error))"); return}
                        let jsonTasksOfList = JsonGoogle.parseJsonInObjects(json: jsonOfRequest, vidObjects: "task", idObjects: "")
                        JsonGoogle.googleObjectsInDataObjects(accTok: accTok, googleObjects: jsonTasksOfList)
                    })
                }
            })
            
        } catch let error {
         print(error)
        }

//        }
    }
}

//func requestSession(selfVC: UIViewController, accTok: String, listID: String) throws {
//
//    //let url = NSURL(string: "https://tasks.googleapis.com/tasks/v1/users/@me/lists?key=[YOUR_API_KEY]")
//
////    var tasklist = listID
////    var tasklist: {
////                  "description": "Task list identifier.",
////                  "location": "path",
////                  "required": true,
////                  "type": "string"
////                }
//
//    //var urlString = "https://tasks.googleapis.com/tasks/v1/lists/?tasklist=[tasklist]/tasks"
//    //var urlString = "https://tasks.googleapis.com/tasks/v1/lists/MTc1MjI3NjM3MDg4MzU1NjExMDg6NjUzNzUxMzg0OjA/tasks"
//
//
//    // 1 list
//    //var urlString = "https://tasks.googleapis.com/tasks/v1/users/@me/lists/\(tasklist)"
//    // all tasks
//    let urlStringLists = "https://tasks.googleapis.com/tasks/v1/users/@me/lists"
////    if listID != "" {
////        urlStringLists = "https://tasks.googleapis.com/tasks/v1/users/@me/lists/\(listID)"
////    }
//
//
////    if listID == "" {
////        // all lists all tasks
////        urlString = "https://tasks.googleapis.com/tasks/v1/users/@me/lists"
////    }
//    guard let urlLists = NSURL(string: urlStringLists) else {
//        throw SinchronGoogleErrors.errorSession
//    }
////    guard let urlTasks = NSURL(string: urlStringTasks) else {
////        throw SinchronGoogleErrors.errorSession
////    }
//
////    guard let jsonLists = jsonRequestSessionUrl(selfVC: selfVC, accTok: accTok, url: urlLists)  else {
////        throw SinchronGoogleErrors.errorSession
////    }
//
////    guard let jsonTasks = jsonRequestSessionUrl(selfVC: selfVC, accTok: accTok, url: urlTasks)  else {
////        throw SinchronGoogleErrors.errorSession
////    }
//
//
//    let session = URLSession.shared
//
//    // lists
//    let request = NSMutableURLRequest(url: urlLists as URL)
//    request.httpMethod = "GET" //set http method
//    request.addValue("Bearer \(accTok)", forHTTPHeaderField: "Authorization")
//    //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
//    /*
//     let scopes: [String] = [
//     "https://www.googleapis.com/auth/tasks",
//     "https://www.googleapis.com/auth/tasks.readonly"]
//     request.addValue(scopes, forHTTPHeaderField: "scopes")
//     */
//
//    let task = session.dataTask(with: request as URLRequest, completionHandler: { [selfVC] data, response, error in
//        do {
//            //if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: AnyObject] {
//            if (try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]) != nil {
//                //print(jsonSession)
//                let jsonLists = try JSON(data: data!)
////                do {
////                    try parseJsonGoogle(json: json, listID: listID)
////                } catch {
////                    print(error)
////                }
//                // Lists
//                for jsonList in jsonLists["items"].arrayValue {
//                    // Tasks
//                    let currListID = jsonList["id"].string!
//                    if listID != "", currListID != listID {
//                        continue
//                    }
//
//                    let urlStringTasks = "https://tasks.googleapis.com/tasks/v1/lists/\(currListID)/tasks"
//                    guard let urlTasks = NSURL(string: urlStringTasks) else {
//                        throw SinchronGoogleErrors.errorSession
//                    }
//                    let request = NSMutableURLRequest(url: urlTasks as URL)
//                    request.httpMethod = "GET" //set http method
//                    request.addValue("Bearer \(accTok)", forHTTPHeaderField: "Authorization")
//                    request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//                    let task = session.dataTask(with: request as URLRequest, completionHandler: { [selfVC] data, response, error in
//                        do {
//                            //if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: AnyObject] {
//                            if (try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]) != nil {
//                                //print(jsonSession)
//                                let jsonTasks = try JSON(data: data!)
//                                do {
//                                    try parseJsonsGoogle(jsonList: jsonList, jsonTasks: jsonTasks)
//                                } catch {
//                                    print(error)
//                                }
//                            }
//
//                        } catch let error {
//                            print(error.localizedDescription)
//                            //return ""
//                        }
//
//                    })
//
//                    task.resume()
//                }
//            }
//
//        } catch let error {
//            print(error.localizedDescription)
//            //return ""
//        }
//
//    })
//
//    task.resume()
////    //}
////    //return json
//}

