

import Foundation

enum PostEndpoint: Endpoint {
    
    case getDataList(accTok: String)
    case postDataList(accTok: String, paramsBody: [String : String])
    case putDataList(accTok: String)
    case patchDataList(accTok: String, paramsBody: [String : String], idList: String?)
    case deleteDataList(accTok: String)
    case getDataTask(accTok: String, idList: String)
    case postDataTask(accTok: String, paramsBody: [String : String])
    case putDataTask(accTok: String)
    case patchDataTask(accTok: String, paramsBody: [String : String], idList: String?, idTask: String)
    case deleteDataTask(accTok: String)

    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    var baseURL: String {
        switch self {
        default:
            return "tasks.googleapis.com"
        }
    }
    
//    var idList: String {
//        switch self {
//        default:
//            return ""
//        }
//
//    }
    
    var path: String {
        switch self {
        case .getDataList:
            return "/tasks/v1/users/@me/lists"
        case .postDataList:
            return "/tasks/v1/users/@me/lists"
        case .putDataList:
            return "/tasks/v1/users/@me/lists"
        case .patchDataList(let accTok, let paramsBody, let idList):
            return "/tasks/v1/users/@me/lists/\(String(describing: idList))/"
        case .deleteDataList:
            return "/posts/1"
        
        case .getDataTask(let accTok, let idList):
            return "/tasks/v1/lists/\(idList)/tasks"
        case .postDataTask:
            return "/tasks/v1/users/@me/lists"
        case .putDataTask:
            return "/tasks/v1/users/@me/lists"
        case .patchDataTask(let accTok, let paramsBody, let idList, let idTask):
            return "/tasks/v1/lists/\(idList)/tasks\(idTask))/"
        case .deleteDataTask:
            return "/posts/1"
        }

    }
    
    var method: HTTPMethods {
        switch self {
        case .getDataList:
            return .get
        case .postDataList:
            return .post
        case .putDataList:
            return .put
        case .patchDataList:
            return .patch
        case .deleteDataList:
            return .delete
  
        case .getDataTask:
            return .get
        case .postDataTask:
            return .post
        case .putDataTask:
            return .put
        case .patchDataTask:
            return .patch
        case .deleteDataTask:
            return .delete
        }
    }
    
    var urlParameters: [URLQueryItem] {
        
        switch self {
        case .getDataList(let accTok):
            return []
//            return
//                [
//                    URLQueryItem(name: "Authorization", value: "Bearer \(accTok)")
//                    ,URLQueryItem(name: "Accept", value: "application/json")
//                ]
        case .postDataList(let accTok):
            return []

        case .putDataList(let accTok):
            return []
            
        case .patchDataList(let accTok, let paramsBody, let idList):
            return []
            
        case .deleteDataList:
            return []
            
        case .getDataTask(let accTok, let idList):
            return []
        case .postDataTask(let accTok):
            return []
        case .putDataTask(let accTok):
            return []
        case .patchDataTask(let accTok, let paramsBody, let idList, let idTask):
            return []
        case .deleteDataTask:
            return []
        }
    }
    
    var bodyParameters: [String: String] {
        switch self {
        case .getDataList:
            return [:]
        case .postDataList(let accTok, let paramsBody):
            return paramsBody
        case .putDataList:
            return ["title": "Foo",
                    "body": "Bar"]
        case .patchDataList(let accTok, let paramsBody, let idList):
            return paramsBody
        case .deleteDataList:
            return [:]
        
        case .getDataTask(let accTok, let idList):
            return [:]
        case .postDataTask(let accTok, let paramsBody):
            return paramsBody
        case .putDataTask:
            return ["title": "Foo",
                    "body": "Bar"]
        case .patchDataTask(let accTok, let paramsBody, let idList, let idTask):
            return paramsBody
        case .deleteDataTask:
            return [:]
        }

    }
    
    var headers: [String:String] {
        switch self {
        case .getDataList(let accTok):
            return [
                "Authorization":"Bearer \(accTok)"
                ,"Accept":"application/json"
            ]
        case .postDataList(let accTok, let paramsBody):
            return [
                "Authorization":"Bearer \(accTok)"
                ,"Accept":"application/json"
            ]

        case .putDataList:
            return ["application/json":"Content-type"]
        case .patchDataList(let accTok, let paramsBody, let idList):
            return [
                "Authorization":"Bearer \(accTok)"
                ,"Accept":"application/json"
            ]
        case .deleteDataList:
            return [:]
        
        case .getDataTask(let accTok, let idList):
            return [
                "Authorization":"Bearer \(accTok)"
                ,"Accept":"application/json"
            ]
        case .postDataTask(let accTok, let paramsBody):
            return [
                "Authorization":"Bearer \(accTok)"
                ,"Accept":"application/json"
            ]

        case .putDataTask:
            return ["application/json":"Content-type"]
        case .patchDataList(let accTok, let paramsBody, let idList):
            return [
                "Authorization":"Bearer \(accTok)"
                ,"Accept":"application/json"
            ]
        case .deleteDataTask:
            return [:]
        case .patchDataTask(let accTok, let paramsBody, let idList, let idTask):
            return [
                "Authorization":"Bearer \(accTok)"
                ,"Accept":"application/json"
            ]
        }
    }
}
