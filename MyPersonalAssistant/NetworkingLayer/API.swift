
import Foundation

class API {
    
    class func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.baseURL
        components.path = endpoint.path
        
        //url parameters
        components.queryItems = endpoint.urlParameters
        
        guard var url = components.url else { return }
        
//        //
//        if endpoint.method.rawValue == "POST" {
//            let urlString = "https://tasks.googleapis.com/tasks/v1/users/@me/lists"
//            url = URL(string: urlString)!
//        }
        
//        var IsGetTask = false
//        if endpoint.method.rawValue == "GET" && url != URL(string: "https://tasks.googleapis.com/tasks/v1/users/@me/lists?") {
//                           //https://tasks.googleapis.com/tasks/v1/lists/{tasklist}/tasks
//            let urlString = "https://tasks.googleapis.com/tasks/v1/lists/MTc1MjI3NjM3MDg4MzU1NjExMDg6NjUzNzUxMzg0OjA/tasks"
//            url = URL(string: urlString)!
//            IsGetTask = true
//        }
        
//        //
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        //body parameters
        if endpoint.bodyParameters.count > 0 {
            let jsonData = try? JSONSerialization.data(withJSONObject: endpoint.bodyParameters)
            request.httpBody = jsonData
        }
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completion(.failure(error!))
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            guard response != nil, let data = data else { return }
            
            //DispatchQueue.main.async {
            //print("any value", terminator: Array(repeating: "\n", count: 100).joined())
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                print(json as Any)
                
//                if let objects = try? JSONDecoder().decode(T.self, from: data) {
//                    completion(.success(objects))
//                } else {
//                    let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to decode this object"])
//                    completion(.failure(error))
//                }
                
                do {
                    //try decode
                    let objects = try? JSONDecoder().decode(T.self, from: data)
                    if objects != nil {
                        completion(.success(objects!))
                    }
                } catch DecodingError.keyNotFound(let key, let context) {
                    Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
                } catch DecodingError.valueNotFound(let type, let context) {
                    Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
                } catch DecodingError.typeMismatch(let type, let context) {
                    Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                } catch DecodingError.dataCorrupted(let context) {
                    Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
                } catch let error as NSError {
                    NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                } catch {
                    //let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to decode this object"])
                    print("\\\\\\\\\\\\\\\\\\__\(error)")
                    completion(.failure(error))
                }
                
            //}
        }
        dataTask.resume()
    }
}
