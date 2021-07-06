//
//  APIService.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 19.06.2021.
//

//import Foundation
import Alamofire
import SwiftyJSON

class APIService {
    
    func doRequest(urlString: String, params: [String: String]?, accTok: String, completion: @escaping (Any?, Error?) -> ()) {
        var params = params
        if params == nil && accTok != nil {
            params = [
                "Bearer \(accTok)": "Authorization",
                "application/json": "Accept"
            ]
        }
        let url = URL(string: urlString)
        var request = URLRequest(url: url! as URL)
        //request.httpMethod = httpMethod //set http method
        request.httpMethod = "GET" //set http method
        for param in params! {
            request.addValue(param.key, forHTTPHeaderField: param.value)
        }
//        request.addValue("Bearer \(accTok)", forHTTPHeaderField: "Authorization")
//        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")

        
        AF.request(request).responseJSON { response in
            switch response.result {
            case .success(let result):
                let json = JSON(response.data)
                completion(json, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
 
    //func doRequestPatch(urlString: String, params: [String: String]?, accTok: String, paramsBody: String) {
    func doRequestPatch(urlString: String, params: [String: String]?, accTok: String, paramsBody: [String: String]) {
        var params = params
        if params == nil && accTok != nil {
            params = [
                "Bearer \(accTok)": "Authorization",
                "application/json": "Accept"
            ]
        }
        let url = URL(string: urlString)
        var request = URLRequest(url: url! as URL)
        //request.httpMethod = "PATCH" //set http method
        request.httpMethod = "POST" //set http method
        for param in params! {
            request.addValue(param.key, forHTTPHeaderField: param.value)
        }
        
//        let bodystring = "{ \"status\": \"needsAction\" }"
//        let body = (bodystring as NSString).data(using: String.Encoding.utf8.rawValue)
//        request.httpBody = body
        
        // Serialize HTTP Body data as JSON
        //let body = ["status": "needsAction"]
        //let paramsBody = ["name": "__M"]
        //let body: NSMutableDictionary? = paramsBody as? NSMutableDictionary
        //let body = paramsBody
        
        //let body = (paramsBody as NSString).data(using: String.Encoding.utf8.rawValue)
        
        //let jsonData = try? JSONSerialization.data(withJSONObject: paramsBody)
        
//        let bodyData = try? JSONSerialization.data(
//            withJSONObject: body,
//            options: []
//        )
//        request.httpBody = bodyData
        
//        let body: NSMutableDictionary? = [
//            "name": "11111",
//            "phone": "22222"]
        
//        let data = try! JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
//
//        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
//        if let json = json {
//            print(json)
//        }
//        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
        
        let data = try! JSONSerialization.data(withJSONObject: paramsBody, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsons = NSString(data: data, encoding: String.Encoding.utf8.rawValue)

        
        request.httpBody = jsonData
        
        AF.request(request).responseJSON { response in
            switch response.result {
            case .success(let result): break
                //let json = JSON(response.data)
                //completion(json, nil)
            case .failure(let error): break
                //completion(nil, error)
            }
        }
    }
    
    
//    let urlString = "https://example.org/some/api"
//    let json = "{\"What\":\"Ever\"}"
//
//    let url = URL(string: urlString)!
//    let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
//
//    var request = URLRequest(url: url)
//    request.httpMethod = HTTPMethod.post.rawValue
//    request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//    request.httpBody = jsonData
//
//    Alamofire.request(request).responseJSON {
//        (response) in
//
//        print(response)
//    }
    
    
    
//    func doRequestParseJson(httpMethod: String? = "GET", urlString: String, params: [String: String]?, accTok: String, vid: String, completion: @escaping (Any?, Error?) -> ()) {
//        var params = params
//        if params == nil && accTok != nil {
//            params = [
//                "Bearer \(accTok)": "Authorization",
//                "application/json": "Accept"
//            ]
//        }
//        let url = URL(string: urlString)
//        var request = URLRequest(url: url! as URL)
//        request.httpMethod = httpMethod //set http method
//        for param in params! {
//            request.addValue(param.key, forHTTPHeaderField: param.value)
//        }
////        request.addValue("Bearer \(accTok)", forHTTPHeaderField: "Authorization")
////        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
////        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//
//        AF.request(request).responseJSON { response in
//            switch response.result {
//            case .success(let result):
//                let data = response.data
//                let json = JSON(response.data)
//                //guard let items = json.response.items.array else { return}
////                if let items = json.response.items {
////
////                }
//                //let friends: [UserModel] = items.map { UserModel(data: $0) }
//
//                //            let friends: [UserModel] = items.map { json in
//                //                UserModel(data: json)
//                //            }
//
//
////                if json["items"] != nil {
////                    let items = json["items"]
////                    let jsonObjects: [ListModel] = items.map { json in
////                        ListModel(data: json)
////                    }
////                }
//
//   //             let arrayResponse = try? JSONDecoder().decode(ListModel.self, from: data!)
//                //guard let friends = arrayResponse?.response.items else { return }
//
//
//                            DispatchQueue.main.async {
//                            //    completion(friends)
//                            }
//                completion(json, nil)
//            case .failure(let error):
//                completion(nil, error)
//            }
//        }
//    }
    
    
//    func afRequest(request: URLRequest, completion: @escaping (Any?, Error?) -> ()) {
//        AF.request(request).responseJSON { response in
//            switch response.result {
//            case .success(let result):
//                let json = JSON(response.data)
////                guard let jsonObject = try JSONSerialization.jsonObject(with: response.data!) as? [String: Any] else {
////                    print("Error: Cannot convert data to JSON object")
////                    return
////                }
//                //completion(result, nil)
//                completion(json, nil)
//            case .failure(let error):
//                completion(nil, error)
//            }
//        }
//    }
    
//    //func currentSession(selfVC: UIViewController, accTok: String, urlString: String, params: [String: Any], completion: @escaping(Any?) throws -> ()) {
//    func currentSession(selfVC: UIViewController, accTok: String, urlString: String, params: [String: Any]) throws -> () {
//        AF.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { AFdata in
//                do {
//                    guard let jsonObject = try JSONSerialization.jsonObject(with: AFdata.data!) as? [String: Any] else {
//                        print("Error: Cannot convert data to JSON object")
//                        return
//                    }
////                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
////                        print("Error: Cannot convert JSON object to Pretty JSON data")
////                        return
////                    }
////                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
////                        print("Error: Could print JSON in String")
////                        return
////                    }
////
////                    print(prettyPrintedJson)
//                } catch {
//                    print("Error: Trying to convert JSON data to string")
//                    return
//                }
//            }
//    }
    
//    func getRequest(url:String, parameters:[String : Any]? = nil,success:@escaping (_ response : String)->(), failure : @escaping (_ error : Error)->()){
//        AF.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseString { (response) in
//                switch response.result {
//                case .success: break
////                    if let value = response.result.value {
////                        success(value)
////                    }
//                case .failure(let error):
//                    failure(error)
//                }
//            }
//        }
    
    
}
