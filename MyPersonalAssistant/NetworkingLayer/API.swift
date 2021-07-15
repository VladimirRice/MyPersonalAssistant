
import Foundation

class API {
    
    class func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.baseURL
        components.path = endpoint.path
        
        //url parameters
        components.queryItems = endpoint.urlParameters
        
        guard let url = components.url else { return }
        
//        //
//        let urlString = "https://tasks.googleapis.com/tasks/v1/users/@me/lists"
//        let url = URL(string: urlString)!
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
            
            DispatchQueue.main.async {
                
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                print(json as Any)
                
                if let objects = try? JSONDecoder().decode(T.self, from: data) {
                    completion(.success(objects))
                } else {
                    let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to decode this object"])
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
}
