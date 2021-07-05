//
//  TasksNavigationController.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 02.05.2020.
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

class TasksNavigationController: UINavigationController {

    var currentListObject: ListTasks?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let initialController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TasksVC") as? TasksViewController
//        
//        
//        //initialController!.delegateViewController = self
//        //initialController!.statusController = "Enter"
//        initialController!.modalPresentationStyle = .custom
//        initialController!.currentListObject = currentListObject
//        self.present(initialController!, animated: true)
//        //navigationController?.pushViewController(initialController!, animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
