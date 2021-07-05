//
//  MainTabBarController.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 03.05.2020.
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectedTabBarItem()
 
    }
    
    // MARK: func
    func sectedTabBarItem(){
        let filter = UserDefaults.standard.object(forKey: "idList") as? String ?? ""
        let arrayObjectsLists = ListTasksData.dataLoad(strPredicate: "id = %@", filter: filter)
        if arrayObjectsLists.count == 1 {
            self.selectedIndex = 1
        }
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
