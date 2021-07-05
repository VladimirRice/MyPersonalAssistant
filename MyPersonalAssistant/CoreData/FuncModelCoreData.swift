//
//  File.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 12.05.2020.
//  Copyright © 2020 Test. All rights reserved.
//
import UIKit
import Foundation
import CoreData

 // MARK: - backup Core Data

//func backUpCoreDate() {
//    //    let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
//    //        let backupUrl = backUpFolderUrl.appendingPathComponent(backupName + ".sqlite")
//    //    _ = ""
//    //    backUpCoreDataFiles(path: backUpFolderUrl, completion:  { (error) in error})
//    
//    let backupName = "Tasks_backUp"//Functions.dateToString(date: Date())
//    
//    backupCoreDateFile(backupName: backupName)
//}

//func backUpCoreDataFiles(path : URL, completion : @escaping (_ error : String?) -> ())
//    {
//
//        // Every time new container is a must as migratePersistentStore method will loose the reference to the container on migration
//        //let container = NSPersistentContainer(name : "<YourDataModelName>")
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let container = appDelegate.persistentContainer
// //        container.loadPersistentStores
// //            { (storeDescription, error) in
// //                if let error = error
// //                {
// //                    fatalError("Failed to load store: \(error)")
// //                }
// //        }
//        let coordinator = container.persistentStoreCoordinator
//        let store = coordinator.persistentStores[0]
//        do
//        {
//            try coordinator.migratePersistentStore(store, to : path, options : nil, withType : NSSQLiteStoreType)
//            completion(nil)
//        }
//        catch
//        {
//            //completion("\(Errors.coredataBackupError)\(error.localizedDescription)")
//            completion("\(error.localizedDescription)")
//        }
//    }

//    class func backUp(){
//
//    let storeCoordinator: NSPersistentStoreCoordinator = {
// //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
// //
// //    var coordinator: NSPersistentStoreCoordinator? = nil //NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//    do {
//        let backupFile = try storeCoordinator.backupPersistentStore(atIndex: 0)
//        defer {
//            // Delete temporary directory when done
//            try! backupFile.deleteDirectory()
//        }
//        print("The backup is at \"\(backupFile.fileURL.path)\"")
//        // Do something with backupFile.fileURL
//        // Move it to a permanent location, send it to the cloud, etc.
//        // ...
//    } catch {
//        print("Error backing up Core Data store: \(error)")
//    }
//    }

func backupCoreDateFile(backupName: String) -> Bool {
    var result = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
    let backupUrl = backUpFolderUrl.appendingPathComponent(backupName + ".sqlite")
    let container = appDelegate.persistentContainer//.viewContext
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in })
    
    //let store: NSPersistentStore
    let store = container.persistentStoreCoordinator.persistentStores.last!
    do {
        try container.persistentStoreCoordinator.migratePersistentStore(store,to: backupUrl,options: nil,withType: NSSQLiteStoreType)
        //print("Greate backup file \(backupUrl)")
        result = true
    } catch {
        //print("Failed to migrate")
        result = false
    }

    return result
}
//
func restoreFromStore(backupName: String) -> Bool {
    
    if !existingFile(miniFileName: backupName) == false {
        return false
    }
    //eraseAll()
    
    var result = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //print(DatabaseHelper.shareInstance.getAllUsers())
    let storeFolderUrl = FileManager.default.urls(for: .applicationSupportDirectory, in:.userDomainMask).first!
    //let storeUrl = storeFolderUrl.appendingPathComponent("YourProjectName.sqlite")
    let storeUrl = storeFolderUrl.appendingPathComponent(backupName)
    let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
    let backupUrl = backUpFolderUrl.appendingPathComponent(backupName + ".sqlite")
    
    let container = appDelegate.persistentContainer
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        let stores = container.persistentStoreCoordinator.persistentStores
//        for store in stores {
//            print("-----store \(store)")
//            //print(container)
//        }
        do {
            try container.persistentStoreCoordinator.replacePersistentStore(at: storeUrl,destinationOptions: nil,withPersistentStoreFrom: backupUrl,sourceOptions: nil,ofType: NSSQLiteStoreType)
            result = true
        } catch {
            result = false
        }
    })
    return result
}

func eraseAll(){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let container = appDelegate.persistentContainer
    //guard let url = container.persistentStoreDescriptions.first?.url else { return }
    let url = container.persistentStoreDescriptions.first?.url
    let persistentStoreCoordinator = container.persistentStoreCoordinator
    do {
        try persistentStoreCoordinator.destroyPersistentStore(at:url!, ofType: NSSQLiteStoreType, options: nil)
        try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
    } catch _ {
        //print("Attempted to clear persistent store: " + error.localizedDescription)
    }
    //
}
func existingFile(miniFileName: String) -> Bool {
    if miniFileName == "" {
        return false
    }
//    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//    let url = NSURL(fileURLWithPath: path)
        
    let url = Files.mFolderURL()
    
//    let path = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
//    let url = path.appendingPathComponent(fileName + ".sqlite")

    if let pathComponent = url?.appendingPathComponent("\(miniFileName)") {
        let filePath = pathComponent.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
}
//func checkFileExist() -> Bool {
//    let path = self.path
//    if (FileManager.default.fileExists(atPath: path))   {
//        print("FILE AVAILABLE")
//        return true
//    }else        {
//        print("FILE NOT AVAILABLE")
//        return false;
//    }
//}

