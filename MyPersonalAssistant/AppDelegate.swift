//
//  AppDelegate.swift
//  MyPersonalAssistant
//
//  Created by Test on 23.03.17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import CoreData
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var window: UIWindow?
    //var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0);

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
   
//        // 1
//        GIDSignIn.sharedInstance().clientID = "AIzaSyDzIHRlMCv8RA97536YO_PhhjAsrm27HCs"
//        // 2
//        GIDSignIn.sharedInstance().delegate = self
//        // 3
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        Functions.initArh()
        
        Files.filesCountArh()
        
        //TimerApp().timerOn()
        
        UserNotificationManager.shared.registerNotification()
        
        // badge
        UserNotificationManager.shared.deleteOverduePendingNotifications()
        _ = TasksData.quantyTasksForBadgeNotifications(date: Date())
        
        //
        let isLogin  = UserDefaults.standard.object(forKey: "isLogin") as? Bool ?? false
        if isLogin {
            initialViewController()
            
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//
//            let initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "naviTabBar")
//            //let initialViewController = ContainerViewController() //storyboard.instantiateViewController(withIdentifier: "mainViewController")
//
//            self.window?.rootViewController = initialViewController
//            self.window?.makeKeyAndVisible()
            
        }
        
//        let pathURL = Files.mFolderURL(folderName: "MyPersonalAssistent")
//        UserDefaults.standard.set(pathURL, forKey: "pathDefault") as? URL
        let clientID = "556209321860-fq3nq9hpvklg2848pp67rvdt7e9b30vb.apps.googleusercontent.com"
        UserDefaults.standard.set(clientID, forKey: "clientID")
        
        // documentDirectory
        let fileManager = FileManager.default
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        let docsURL = dirPaths[0]
        
        let newDir = docsURL.appendingPathComponent("\("tmp")").path
        if !fileManager.fileExists(atPath: newDir) {
            //let newDir = docsURL.path
            do{
                try fileManager.createDirectory(atPath: newDir,withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        // watch
//        let directory: NSURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.MyPersonalAssistant")! as NSURL
//        let realmPath = directory.path!.appendingPathComponent("db.realm")
//        RLMRealm.setDefaultRealmPath(realmPath)
        
        //
        
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        filesInArhivAppleDelegate()
    }

    // MARK: - Core Data stack

    @available(iOS 13.0, *)
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "MyPersonalAssistant")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    @available(iOS 13.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - UNUserNotification
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.init(arrayLiteral: [.alert, .sound, .badge]))
    }
    
    func initialViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "naviTabBar")
        //let initialViewController = ContainerViewController() //storyboard.instantiateViewController(withIdentifier: "mainViewController")
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    

    // MARK: - GIDSignIn
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {

        return GIDSignIn.sharedInstance().handle(url)
    }
    
//    // MARK: - timer
//    func timerArh() {
//        //let context = ["user": "@twostraws"]
//        // 86400 сутки
//        // 43200 12 часов
//        let timeInterval = userDefaults.object(forKey: "timerSave") as? Double ?? 10.0
//        Timer.scheduledTimer(timeInterval: 43200.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
//    }
//    @objc func fireTimer(){
//        dataInJson()
//      Files.filesCountArh()
//    }

    
    func filesInArhivAppleDelegate() {
        let isArhInitApp = UserDefaults.standard.object(forKey: "isArhInitApp") as? Bool ?? false
        if !isArhInitApp {
                return
        }


        dataInJson(selfVC: nil, dopName: "A")
        Files.filesCountArh()

//        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .actionSheet)
//        let okAction = UIAlertAction(title: "OK", style: .default) {
//            UIAlertAction in
//            dataInJson()
//        }
//        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel) {
//            UIAlertAction in
//            //NSLog("Cancel Pressed")
//        }
//        alertController.addAction(okAction)
//        alertController.addAction(cancelAction)
//        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    
} // class



////
//
//extension AppDelegate: GIDSignInDelegate {
//
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//
//        // Check for sign in error
//        if let error = error {
//            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
//                print("The user has not signed in before or they have since signed out.")
//            } else {
//                print("\(error.localizedDescription)")
//            }
//            return
//        }
//
//        // Post notification after user successfully sign in
//        NotificationCenter.default.post(name: .signInGoogleCompleted, object: nil)
//    }
//}
//
//extension Notification.Name {
//
//    /// Notification when user successfully sign in using Google
//    static var signInGoogleCompleted: Notification.Name {
//        return .init(rawValue: #function)
//    }
//
//
//}
