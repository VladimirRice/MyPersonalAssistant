

import Foundation

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol Endpoint {
    
    var scheme: String { get }
    
    var baseURL: String { get }
    
    //var idInPath: String { get }
    
    var path: String { get }
    
    var method: HTTPMethods { get }
    
    var urlParameters: [URLQueryItem] { get }
    
    var bodyParameters: [String: String] { get }
    
    var headers: [String:String] { get }
}
