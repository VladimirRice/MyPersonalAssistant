//
//  GoogleSign.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 14.04.2021.
//

import Foundation
import GoogleSignIn
import SwiftyJSON


enum DirectionSynchronization {
    case googleInData
    case dataInGoogle
    case none
}

enum Actions {
    case add
    case patch
    case delete
    case none
}

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

func googleSynchron(selfVC: UIViewController?, listID: String) -> Bool {
    initialSign(selfVC: selfVC!)
    let user = GIDSignIn.sharedInstance()!.currentUser
    if user == nil {
//        GIDSignIn.sharedInstance().delegate = selfVC as? GIDSignInDelegate
//        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/tasks")
//        GIDSignIn.sharedInstance().signIn()
//        GIDSignIn.sharedInstance()?.currentUser
        return false
    }
    
    if (GIDSignIn.sharedInstance()?.currentUser) != nil {
        
        //var status = true
        if listID != "" {
            let message = ""
            let title = "Синхронизация с Google"
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alertController.addAction(UIAlertAction(title: "Текущий список", style: UIAlertAction.Style.default, handler: { [weak alertController] (action) -> Void in
    
                //googleSynchronNext(selfVC: selfVC!, listID: listID)
                googleSynchronNextAPI(selfVC: selfVC!, listID: listID)
                //selfVC.tasksViewController.refreshControl?.endRefreshing()
                //googleSynchronNextAPIService(selfVC: selfVC, listID: listID)
                //status = true
            }
            ))
 
            alertController.addAction(UIAlertAction(title: "ВСЕ", style: UIAlertAction.Style.default, handler: { [weak alertController] (action) -> Void in

                //googleSynchronNext(selfVC: selfVC!, listID: "")
                googleSynchronNextAPI(selfVC: selfVC!, listID: "")
                //googleSynchronNextAPIService(selfVC: selfVC, listID: listID)
                //status = true
            }
            ))

            // cancel
            alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { [weak alertController] (action) -> Void in
                //status = false
            }
            ))
            
            // show the alert
            selfVC!.present(alertController, animated: true, completion: nil)
        }
    
        return true
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

//func googleSynchronNextAPI(selfVC: UIViewController, listID: String) {
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
//        //        var listID = listID
//        //        listID = ""
//
//        //        var jsonList: [Any] = []
//        //        var jsonTasks: [Any] = []
//        do {
//
////            let urlString = "https://tasks.googleapis.com/tasks/v1/users/@me/lists"
////            //let urlString = "https://tasks.googleapis.com/tasks/v1/users/@me/lists/\(listID)"
////
////            var googleObjectsList: [ListModel] = []
////
////            let urlStringList = "https://tasks.googleapis.com/tasks/v1/users/@me/lists"
////            let id = "MTc1MjI3NjM3MDg4MzU1NjExMDg6MTc2ODk2MzM0OjA"
////            let formatter = DateFormatter()
////            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
////            let vupdatedDate = formatter.date(from: "2021-07-01T00:01")
////
////            let updatedDate = Functions.dateToStringFormat(date: vupdatedDate!, minDateFormat: "yyyy-MM-dd'T'HH:mm")
////            let paramsBody: [String : String] = ["id":  id, "title": "Proch", "updated": updatedDate]
////            //let paramsBody: [String : String] = ["title": dataObjectList.name!, "updated": updatedDate]
////            //DispatchQueue.main.async {
////
////            //PostEndpoint
////            API.request(endpoint: PostEndpoint.postDataList(accTok: accTok, paramsBody: paramsBody)) { (result: Result<ListAble, Error>) in
////            //API.request(endpoint: PostEndpoint.getDataList(accTok: accTok)) { (result: Result<ListAble, Error>) in
////                        switch result {
////                        case .failure(let error):
////                            print(error.localizedDescription)
////                        case .success(let comments):
////                            print(comments)
////                        }
////                    }
//
//        } catch {
//
//        }
//    }
//}

func googleSynchronNextAPI(selfVC: UIViewController, listID: String) {
    
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
            
//            //let urlString = "https://tasks.googleapis.com/tasks/v1/users/@me/lists"
//
//            let id = "MTc1MjI3NjM3MDg4MzU1NjExMDg6MTc2ODk2MzM0OjA"
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
//            let vupdatedDate = formatter.date(from: "2021-07-01T00:01")
//
//            let updatedDate = Functions.dateToStringFormat(date: vupdatedDate!, minDateFormat: "yyyy-MM-dd'T'HH:mm")
//            let paramsBody: [String : String] = ["id":  id, "title": "Proch", "updated": updatedDate]
//            //let paramsBody: [String : String] = ["title": dataObjectList.name!, "updated": updatedDate]
//            //DispatchQueue.main.async {
////            APIService().doRequestPost(urlString: urlStringList, params: nil, accTok: accTok, paramsBody: paramsBody, completion: { (json, error) in
////                let json1 = json
////             })
//            API.request(endpoint: PostEndpoint.postDataList(accTok: accTok, paramsBody: paramsBody)) { (result: Result<ListsCodable, Error>) in
//            //API.request(endpoint: PostEndpoint.getDataList(accTok: accTok)) { (result: Result<ListsCodable, Error>) in
//                switch result {
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    return
//                case .success(let objects):
//                    print(objects)
//                    //objectsFromJson = objects.items
//                }
//            }

        
            //var googleObjectsList: [ListModel] = []
            //APIService().doRequest(urlString: urlString, params: nil, accTok: accTok, completion: { (json, error) in
            API.request(endpoint: PostEndpoint.getDataList(accTok: accTok)) { (result: Result<ListsCodable, Error>) in
               
                var objectsFromJson: [ListCodable] = []
                
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    return
                case .success(let objects):
                    print(objects)
                    objectsFromJson = objects.items
                }
            //}
                
//                let error = ""
//                guard let jsonOfRequest = json as? JSON else {print("\(String(describing: error))"); return}
//                let googleListFromJson = JsonGoogle.parseJsonInObjects(json: jsonOfRequest, vidObjects: "list", idObjects: listID)
//                googleObjectsList += (googleListFromJson as? [ListModel])!
//                //synchronNext(selfVC: selfVC, accTok: accTok, listID: listID, googleObjectsList: googleObjectsList)
//            //})
//
                let googleListFromJson = objectsFromJson//.items
                
                let dataObjectsListAll = ListTasksData.dataLoad(strPredicate: "", filter: "")
                var dataObjectsList = dataObjectsListAll
                if listID != "" {
                    dataObjectsList = dataObjectsListAll.filter { $0.id == listID }
                    //deleteObjectsNoModifi = false
                }

                let dataObjectsTaskAll = TasksData.dataLoad(strPredicate: "", filter: "")
                var dataObjectsTask = dataObjectsTaskAll
                if listID != "" {
                    dataObjectsTask = dataObjectsTaskAll.filter { $0.idList == listID }
                }

//                // compare date
//                let emptyDate = Functions.emptyDate(dateFormat: nil)
//
//                var maxUpdatedDateData: Date? = emptyDate
//                var maxUpdatedDateGoogle: Date? = emptyDate
//
//
//                for dataObjectList in dataObjectsList {
//                    let updateDate = dataObjectList.updatedDate!
//                    if updateDate > maxUpdatedDateData!  {
//                        maxUpdatedDateData = updateDate
//                    }
//                }
//                for googleObjectList in objectsFromJson { //in googleObjectsList {
//                    var strDate = googleObjectList.updated!
//                    strDate.replaceOccurrences(of: "-", with: ".")
//                    strDate.replaceOccurrences(of: "T", with: " ")
//                    let updateDate = Functions.dateFromString(dateStr: strDate, format: 1)
//                    if updateDate! > maxUpdatedDateGoogle!  {
//                        maxUpdatedDateGoogle = updateDate
//                    }
//                }
//                if maxUpdatedDateData == maxUpdatedDateGoogle {
//                    return
//                }

                var directionSynchronization = DirectionSynchronization.dataInGoogle
//                if maxUpdatedDateGoogle! > maxUpdatedDateData! {
//                    directionSynchronization = DirectionSynchronization.googleInData
//                }

                ///
                // data in google
                if directionSynchronization == DirectionSynchronization.dataInGoogle {
                    // data
                    for dataObjectList in dataObjectsList {
                        let currGoogleObjectsList = objectsFromJson.filter {($0 as? ListCodable)?.id == (dataObjectList as? ListTasks)!.id}
                        // add
                        var isNew = false
                        if currGoogleObjectsList.count == 0 {
                            continue
                            
//                            let urlStringList = "https://tasks.googleapis.com/tasks/v1/users/@me/lists"
//                            let updatedDate = Functions.dateToStringFormat(date: dataObjectList.updatedDate!, minDateFormat: "yyyy-MM-dd'T'HH:mm")
//                            let paramsBody: [String : String] = ["id":  String(dataObjectList.id!), "title": dataObjectList.name!, "updated": updatedDate]
//                            //let paramsBody: [String : String] = ["title": dataObjectList.name!, "updated": updatedDate]
//                            //DispatchQueue.main.async {
//                            APIService().doRequestPost(urlString: urlStringList, params: nil, accTok: accTok, paramsBody: paramsBody)
//                            //}
                            
//                            let updatedDate = Functions.dateToStringFormat(date: dataObjectList.updatedDate!, minDateFormat: "yyyy-MM-dd'T'HH:mm")
//                            let paramsBody: [String : String] = ["id":  String(dataObjectList.id!), "title": dataObjectList.name!, "updated": updatedDate]
//                            //let paramsBody: [String : String] = ["title": dataObjectList.name!, "updated": updatedDate]
//                            //DispatchQueue.main.async {
//        //                    APIService().doRequestPost(urlString: urlStringList, params: nil, accTok: accTok, paramsBody: paramsBody, completion: { (json, error) in
//        //
//        //                    })
//                            API.request(endpoint: PostEndpoint.postDataList(accTok: accTok, paramsBody: paramsBody)) { (result: Result<ListsCodable, Error>) in
//                               
//                                switch result {
//                                case .failure(let error):
//                                    print(error.localizedDescription)
//                                    return
//                                case .success(let objects):
//                                    print(objects)
//                                    //objectsFromJson = objects.items
//                                }
//                            }

                            isNew = true
                        }
                        JsonGoogle.dataObjectsInGoogleObjects(accTok: accTok, dataObjects: [dataObjectList], isNew: isNew)

                        let currDataObjectsTask = dataObjectsTaskAll.filter { $0.idList == dataObjectList.id }
                        JsonGoogle.dataObjectsInGoogleObjects(accTok: accTok, dataObjects: currDataObjectsTask)
                        
                    } //if directionSynchronization == DirectionSynchronization.dataInGoogle {

                    // google
                    for googleObjectList in objectsFromJson { //in googleObjectsList {
                        let currDataObjectsList = dataObjectsListAll.filter {$0.id == (googleObjectList as? ListCodable)?.id}
                        if currDataObjectsList.count > 0 {
                            continue
                        }

                        // delete
                        let currListID = (googleObjectList as? ListCodable)?.id
                        //let urlString = "https://tasks.googleapis.com/tasks/v1/users/@me/lists/\(String(describing: currListID))/"
                        //APIService().doRequestDelete(urlString: urlString, params: nil, accTok: accTok)
                    }
                } // if dataInGoogle


//                // google in data
//                if directionSynchronization == DirectionSynchronization.googleInData {
//
//
//                } //if googleInData
//
                
            }//) //APIService().doRequest( 1 list
            //
        } catch let error {
            print(error)
        }
        
        //        }
    }
} // func

                
//func synchronNext(selfVC: UIViewController, accTok: String, listID: String, googleObjectsList: [ListModel]) {
//    let dataObjectsListAll = ListTasksData.dataLoad(strPredicate: "", filter: "")
//    var dataObjectsList = dataObjectsListAll
//
//    if listID != "" {
//        dataObjectsList = dataObjectsListAll.filter { $0.id == listID }
//        //deleteObjectsNoModifi = false
//    }
//
//    let dataObjectsTaskAll = TasksData.dataLoad(strPredicate: "", filter: "")
//    var dataObjectsTask = dataObjectsTaskAll
//    if listID != "" {
//        dataObjectsTask = dataObjectsTaskAll.filter { $0.idList == listID }
//    }
//
//    // compare date
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy/MM/dd HH:mm"
//    let emptyDate = formatter.date(from: "1900/01/01 00:01")
//
//    var maxUpdatedDateData: Date? = emptyDate
//    var maxUpdatedDateGoogle: Date? = emptyDate
//
//
//    for dataObjectList in dataObjectsList {
//        let updateDate = dataObjectList.updatedDate!
//        if updateDate > maxUpdatedDateData!  {
//            maxUpdatedDateData = updateDate
//        }
//    }
//    for googleObjectList in googleObjectsList {
//        let updateDate = ((googleObjectList as? ListModel)?.updatedDate)!
//        if updateDate > maxUpdatedDateGoogle!  {
//            maxUpdatedDateGoogle = updateDate
//        }
//    }
//    if maxUpdatedDateData == maxUpdatedDateGoogle {
//        return
//    }
//
//    var directionSynchronization = DirectionSynchronization.dataInGoogle
//    //                if maxUpdatedDateGoogle! > maxUpdatedDateData! {
//    //                    directionSynchronization = DirectionSynchronization.googleInData
//    //                }
//
//    ///
//    // data in google
//    if directionSynchronization == DirectionSynchronization.dataInGoogle {
//        // data
//        for dataObjectList in dataObjectsList {
//            let currGoogleObjectsList = googleObjectsList.filter {($0 as? ListModel)?.id == (dataObjectList as? ListTasks)!.id}
//            // add
//            var isNew = false
//            if currGoogleObjectsList.count == 0 {
//                //                            let urlStringList = "https://tasks.googleapis.com/tasks/v1/users/@me/lists"
//                //                            let updatedDate = Functions.dateToStringFormat(date: dataObjectList.updatedDate!, minDateFormat: "yyyy-MM-dd'T'HH:mm")
//                //                            let paramsBody: [String : String] = ["id":  String(dataObjectList.id!), "title": dataObjectList.name!, "updated": updatedDate]
//                //                            //let paramsBody: [String : String] = ["title": dataObjectList.name!, "updated": updatedDate]
//                //                            //DispatchQueue.main.async {
//                //                            APIService().doRequestPost(urlString: urlStringList, params: nil, accTok: accTok, paramsBody: paramsBody)
//                //                            //}
//                isNew = true
//                //continue
//            }
//            JsonGoogle.dataObjectsInGoogleObjects(accTok: accTok, dataObjects: [dataObjectList], isNew: isNew)
//
//            let currDataObjectsTask = dataObjectsTaskAll.filter { $0.idList == dataObjectList.id }
//            JsonGoogle.dataObjectsInGoogleObjects(accTok: accTok, dataObjects: currDataObjectsTask)
//        }
//
//        // google
//        for googleObjectList in googleObjectsList {
//            let currDataObjectsList = dataObjectsListAll.filter {$0.id == (googleObjectList as? ListModel)?.id}
//            if currDataObjectsList.count > 0 {
//                continue
//            }
//
//            // delete
//            let currListID = (googleObjectList as? ListModel)?.id
//            let urlString = "https://tasks.googleapis.com/tasks/v1/users/@me/lists/\(String(describing: currListID))/"
//            APIService().doRequestDelete(urlString: urlString, params: nil, accTok: accTok)
//        }
//    } // if dataInGoogle
//
//
//    //                // google in data
//    //                if directionSynchronization == DirectionSynchronization.googleInData {
//    //
//    //
//    //                } //if googleInData
//    //
//} // func


//func googleSynchronNext1(selfVC: UIViewController, listID: String) {
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
////        var listID = listID
////        listID = ""
//
////        var jsonList: [Any] = []
////        var jsonTasks: [Any] = []
//        do {
//            // list
//            let urlString = "https://tasks.googleapis.com/tasks/v1/users/@me/lists"
//            //let urlString = "https://tasks.googleapis.com/tasks/v1/users/@me/lists/\(listID)"
//
//            APIService().doRequest(urlString: urlString, params: nil, accTok: accTok, completion: { (json, error) in
//                guard let jsonOfRequest = json as? JSON else {print("\(String(describing: error))"); return}
//                let googleListFromJson = JsonGoogle.parseJsonInObjects(json: jsonOfRequest, vidObjects: "list", idObjects: listID)
//                let googleObjectsList = googleListFromJson
//
//                //var deleteObjectsNoModifi = true
//
//                let dataObjectsListAll = ListTasksData.dataLoad(strPredicate: "", filter: "")
//                var dataObjectsList = dataObjectsListAll
//                if listID != "" {
//                    dataObjectsList = dataObjectsListAll.filter { $0.id == listID }
//                    //deleteObjectsNoModifi = false
//                }
//
//                let dataObjectsTaskAll = TasksData.dataLoad(strPredicate: "", filter: "")
//                var dataObjectsTask = dataObjectsTaskAll
//                if listID != "" {
//                    dataObjectsTask = dataObjectsTaskAll.filter { $0.idList == listID }
//                }
//
//                var directionSynchronization = DirectionSynchronization.dataInGoogle
//
////                // no google
////                if googleObjectsList.count == 0 {
////                    JsonGoogle.dataObjectsInGoogleObjects(accTok: accTok, dataObjects: dataObjectsList)
////                    JsonGoogle.dataObjectsInGoogleObjects(accTok: accTok, dataObjects: dataObjectsTask)
////                    // сравнить
////
////                    return
////                }
//
////                var dataObjectsListModifi = dataObjectsList
////                dataObjectsListModifi.removeAll()
//
////                var dataObjectsListForModifi: [ListTasks: DirectionSynchronization]
////                var googleObjectsListForModifi: [ListModel?: DirectionSynchronization]
//
//                //var listsModifi: [[DirectionSynchronization: AnyObject?: Actions]]  = [[:]]
//
//                var listsModifi: [(directionSynchronization: DirectionSynchronization, object: AnyObject, action: Actions)] = []
//                var googleListsModifi: [ListModel] = []
//
//                // data on google
//                for dataObjectList in dataObjectsList {
//
//                    var directionSynchronization:DirectionSynchronization!
//                    var actions: Actions
//                    var object: AnyObject? = dataObjectList
//
//                    let currGoogleObjectsList = googleObjectsList.filter {($0 as? ListModel)?.id == (dataObjectList as? ListTasks)!.id}
//                    if currGoogleObjectsList.count > 0 {
//
//                        if (dataObjectList.updatedDate)! == ((currGoogleObjectsList[0] as! ListModel).updatedDate) {
//                            actions = Actions.none
//                            directionSynchronization = DirectionSynchronization.none
//                            object = currGoogleObjectsList[0] as? ListModel as AnyObject?
//                            googleListsModifi.append((currGoogleObjectsList[0] as? ListModel)!)
//
//                            //continue
//                        } else {
//                            actions = Actions.patch
//                            if (dataObjectList.updatedDate)! > ((currGoogleObjectsList[0] as! ListModel).updatedDate) {
//                                directionSynchronization = DirectionSynchronization.dataInGoogle
//                                object = dataObjectList as? ListTasks
//                            }
//                            if  ((currGoogleObjectsList[0] as! ListModel).updatedDate) > (dataObjectList.updatedDate)! {
//                                directionSynchronization = DirectionSynchronization.googleInData
//                                object = currGoogleObjectsList[0] as? ListModel as AnyObject?
//                                googleListsModifi.append((currGoogleObjectsList[0] as? ListModel)!)
//                            }
//                        }
//
//                    } else {
//                        directionSynchronization = DirectionSynchronization.dataInGoogle
//                        actions = Actions.add
//                        object = dataObjectList as? ListTasks
//                    }
//
//                    listsModifi.append((directionSynchronization: directionSynchronization, object: object!, action: actions))
//
//                }
//
//                // google on data and listsModifi
//                for googleObjectList in googleObjectsList {
//
//                    //var id = googleObjectList as? ListModel
//                    let currGoogleObjectsList = googleListsModifi.filter {($0 as? ListModel)?.id == (googleObjectList as? ListModel)?.id}
//                    if currGoogleObjectsList.count > 0 {
//                        continue
//                    }
//                    let currDataObjectsList = dataObjectsListAll.filter {$0.id == (googleObjectList as? ListModel)?.id}
//                    if currDataObjectsList.count > 0 {
//                        continue
//                    }
//                    //listsModifi.append(<#T##newElement: (directionSynchronization: DirectionSynchronization, object: AnyObject, action: Actions)##(directionSynchronization: DirectionSynchronization, object: AnyObject, action: Actions)#>)
//                    //listsModifi.append((directionSynchronization: DirectionSynchronization.googleInData, object: googleObjectList!, action: Actions.delete))
//                }
//
//                for listModifi in listsModifi {
//                    if listModifi.directionSynchronization == DirectionSynchronization.none {
//                        continue
//                    }
//                    if listModifi.directionSynchronization == DirectionSynchronization.dataInGoogle {
//                        JsonGoogle.dataObjectsInGoogleObjects(accTok: accTok, dataObjects: [listModifi.object])
//
//                    }
//
//                }
////                // list
////                for googleObjectList in googleObjectsList {
////
//////                    var directionModifiListDataGoogle = false
//////                    var directionModifiTaskDataGoogle = false
////
////                    let currDataObjectsList = dataObjectsList.filter {$0.id == (googleObjectList as! ListModel).id}
////                    var currDataObjectList: ListTasks!// = ListTasks()
////
////                    // dataObjectsList is true
////                    if currDataObjectsList.count > 0 {
////                        currDataObjectList = currDataObjectsList[0]
////                        //
////                        //dataObjectsListModifi.append(currDataObjectList)
////                        //
////                        if (currDataObjectList.updatedDate)! == ((googleObjectList as! ListModel).updatedDate) {
////                            continue
////                        }
////                        if (currDataObjectList.updatedDate)! > ((googleObjectList as! ListModel).updatedDate) {
////                            directionSynchronization = DirectionSynchronization.dataInGoogle
//////                            directionModifiListDataGoogle = true
//////                            directionModifiTaskDataGoogle = true
////                        }
////                        if  ((googleObjectList as! ListModel).updatedDate) > (currDataObjectList.updatedDate)! {
////                            directionSynchronization = DirectionSynchronization.googleInData
//////                            directionModifiListDataGoogle = true
//////                            directionModifiTaskDataGoogle = true
////                        }
////
////                    } else { // new data
////                        directionSynchronization = DirectionSynchronization.googleInData
////                    }
////
////                    // data in google
////                    if directionSynchronization == DirectionSynchronization.dataInGoogle, currDataObjectList != nil { // data in google
////                        JsonGoogle.dataObjectsInGoogleObjects(accTok: accTok, dataObjects: [currDataObjectList!])
////                        let currDataObjectsTask = dataObjectsTask.filter {$0.idList == (googleObjectList as! ListModel).id}
////                        JsonGoogle.dataObjectsInGoogleObjects(accTok: accTok, dataObjects: [currDataObjectsTask])
////                        continue
////                    }
////
////                    // google in data
////                    JsonGoogle.googleObjectsInDataObjects(accTok: accTok, googleObjects: [googleObjectList!], completion: { (dataObjectsListModifi) in
////
////                        }
////                    )
////
////                    // tasks else google in data
////                    let currListID = (googleObjectList! as! ListModel).id
////                    let urlStringTasks = "https://tasks.googleapis.com/tasks/v1/lists/\(currListID)/tasks"
////                    APIService().doRequest(urlString: urlStringTasks, params: nil, accTok: accTok, completion: { (json, error) in
////                        guard let jsonOfRequest = json as? JSON else {print("\(String(describing: error))"); return}
////                        let jsonTasksOfList = JsonGoogle.parseJsonInObjects(json: jsonOfRequest, vidObjects: "task", idObjects: "")
////                        JsonGoogle.googleObjectsInDataObjects(accTok: accTok, googleObjects: jsonTasksOfList, completion: { (dataObjectsListModifi) in
////
////                        }
////                    )
////                    })
////                } // for list
////
//////                // надо сделать стереть лишние списки !!
//////                // deleteNoModifi
//////                if dataObjectsListModifi != dataObjectsList {
//////                    let appDelegate =
//////                        UIApplication.shared.delegate as! AppDelegate
//////                    let context = appDelegate.persistentContainer.viewContext
//////                    for dataObjectList in dataObjectsList {
//////                        if !dataObjectsListModifi.contains(dataObjectList) {
//////                            context.delete(dataObjectList)
//////                        }
//////                    }
//////
//////                    ListTasksData.saveObjects()
//////                }
////
//        }) //APIService().doRequest( 1 list
////
//        } catch let error {
//         print(error)
//        }
//
////        }
//    }
//}

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

