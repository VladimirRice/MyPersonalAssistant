//
//  InterfaceController.swift
//  TasksWatch Extension
//
//  Created by Vladimir Rice on 28.02.2021.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
  
    //var currentListObject: String!
    
    
    
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    
    override func awake(withContext context: Any?) {
        loadData()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

    
    // MARK: -  delegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //currentListObject = session.curr
    }
    
    
    // MARK: - func
    func loadData() {
////        //if currentListObject == nil{
//            let filter = UserDefaults.standard.object(forKey: "idList") as? String ?? ""
//            let arrayObjectsLists = ListTasksData.dataLoad(strPredicate: "id = %@", filter: filter)
//            if arrayObjectsLists.count == 1 {
//                currentListObject = arrayObjectsLists[0]
//            }
//        //}

    }
}


class W_TableViewCell   : NSObject {
    
    @IBOutlet weak var textLabel: WKInterfaceLabel!
    
    
    
}

