

import Foundation

enum PostEndpoint: Endpoint {
    
    case getDataList(accTok: String)
    case postDataList(accTok: String, paramsBody: [String : String])
    case putDataList(accTok: String)
    case patchDataList(accTok: String, paramsBody: [String : String], idInPath: String?)
    case deleteDataList(accTok: String)

    
//    case getDataTask
//    case postDataTask
//    case putDataTask
//    case patchDataTask
//    case deleteDataTask

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
    
//    var idInPath: String {
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
        case .patchDataList(let accTok, let paramsBody, let idInPath):
            return "/tasks/v1/users/@me/lists/\(String(describing: idInPath))/"
        case .deleteDataList:
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
        }
    }
    
    var urlParameters: [URLQueryItem] {
        
        //var parameters = [URLQueryItem(name: "Authorization", value: "Bearer \(accTok)")]
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
//                [
//                    URLQueryItem(name: "Authorization", value: "Bearer \(accTok)")
//                    ,URLQueryItem(name: "Accept", value: "application/json")
//                ]
            
        case .putDataList(let accTok):
            return []
//                [
//                    URLQueryItem(name: "Authorization", value: "Bearer \(accTok)")
//                    ,URLQueryItem(name: "Accept", value: "application/json")
//                ]
            
        case .patchDataList(let accTok, let paramsBody, let idInPath):
            return []
//                [
//                    URLQueryItem(name: "Authorization", value: "Bearer \(accTok)")
//                    ,URLQueryItem(name: "Accept", value: "application/json")
//                ]
            
        case .deleteDataList:
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
        case .patchDataList(let accTok, let paramsBody, let idInPath):
            return paramsBody
        case .deleteDataList:
            return [:]
        }
    }
    
    var headers: [String:String] {
        switch self {
        
        case .getDataList(let accTok):
        //    return [:]
//            return [
//                "Bearer \(accTok)":"Authorization"
//                ,"application/json": "Accept"
//            ]
            return [
                "Authorization":"Bearer \(accTok)"
                ,"Accept":"application/json"
            ]
        case .postDataList(let accTok, let paramsBody):
            //return ["application/json":"Content-Type"]
            return [
                "Authorization":"Bearer \(accTok)"
                //,"Accept":"application/json"
            ]

        case .putDataList:
            return ["application/json":"Content-type"]
        case .patchDataList(let accTok, let paramsBody, let idInPath):
            return [
                "Authorization":"Bearer \(accTok)"
                ,"Accept":"application/json"
            ]

        case .deleteDataList:
            return [:]
        }
    }
}
