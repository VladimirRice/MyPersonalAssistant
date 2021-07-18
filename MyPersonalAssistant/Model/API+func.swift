//
//  API+func.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 18.07.2021.
//

import Foundation

class FunctionsAPI {
    func getDataAPITasks(accTok: String, idList: String, completion: @escaping (TasksCodable?, Error?) -> Void) {
        
        API.request(endpoint: PostEndpoint.getDataTask(accTok: accTok, idList: idList)) { (result: Result<TasksCodable, Error>) in
            
            //var jsonTasks: [TaskCodable] = []
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                //return nil
                completion (nil, error)
            case .success(let objects):
                print(objects)
                completion (objects, nil)
            //return objects
            //jsonTasks = objects//.items
            }
        } // API
        
        //return [AnyObject]?
    }
    
}
