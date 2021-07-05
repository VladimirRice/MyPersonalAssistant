//
//  UserNotificationManager.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 06.05.2020.
//  Copyright © 2020 Test. All rights reserved.
//

import Foundation
import UserNotifications
import CoreLocation
import UIKit


class UserNotificationManager: NSObject, UNUserNotificationCenterDelegate {

static let shared = UserNotificationManager()

override init() {
    super.init()
    UNUserNotificationCenter.current().delegate = self
}

func registerNotification() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        //handle error
    }
}

//MARK: - Add Default Notification
//func addNotificationWithTimeIntervalTrigger() {
//    let content = UNMutableNotificationContent()
//    content.title = "Title"
//    content.subtitle = "Subtitle"
//    content.body = "Body"
//    //content.badge = 1
//    content.sound = UNNotificationSound.default
//
//    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
//    let request = UNNotificationRequest(identifier: "timeInterval", content: content, trigger: trigger)
//
//    UNUserNotificationCenter.current().add(request) { (error) in
//        //handle error
//    }
//}

//    func addNotificationWithCalendarTrigger(identifier: String, title: String, subtitle: String, body: String, badge: Int?, nextDate: Date?) {
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.subtitle = subtitle
//        content.body = body
//        content.badge = badge as NSNumber?
//        
//        content.sound = UNNotificationSound.default
//        
////        var delayTimeTrigger: UNTimeIntervalNotificationTrigger?
//
////        if let nextDate = nextDate {
////            delayTimeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(nextDate), repeats: false)
////        }
//
//        if let badge = badge {
//            var currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
//            currentBadgeCount += badge
//            content.badge = NSNumber(integerLiteral: currentBadgeCount)
//        }
//        
//        
//        let components = NSDateComponents()
//        
//        let calendar = Calendar(identifier: .gregorian)
//        components.year = (calendar.component(.year, from: nextDate! as Date))
//        components.month = (calendar.component(.month, from: nextDate! as Date))
//        components.day = (calendar.component(.day, from: nextDate! as Date))
//        components.hour = (calendar.component(.hour, from: nextDate! as Date))
//        components.minute = (calendar.component(.minute, from: nextDate! as Date))
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: components as DateComponents, repeats: true)
//        
//        //print("trigger.nextTriggerDate()::::\(trigger.nextTriggerDate())")
//
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        
//        UNUserNotificationCenter.current().add(request) { (error) in
//            //handle error
//        }
//        
//        let action1 = UNNotificationAction(identifier: identifier+"##"+"deleteAction", title: "Удалить уведомление", options: [.destructive])
//        let action2 = UNNotificationAction(identifier: identifier+"##"+"openAppAction", title: "Action Second", options: [.foreground])
//        
//        let category = UNNotificationCategory(identifier: "actionCategory", actions: [action1,action2], intentIdentifiers: [], options: [])
//        
//        UNUserNotificationCenter.current().setNotificationCategories([category])
//        
//        
//    }
    

    func deleteOverduePendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests {
            (requests) in
            //var overdueNotifications: [UNNotificationRequest] = []
            var overdueNotifications: [String]=[]

            //let endOfDay = Date().endOfDay
            let startOfDay = Date().startOfDay
            let calendar = Calendar.current
            
            for request in requests {
                let trigger = request.trigger as? UNCalendarNotificationTrigger
                
                let triggerDate = calendar.date(from: trigger!.dateComponents)

                if triggerDate == nil {
                    overdueNotifications.append(request.identifier)
                } else {
                    if triggerDate! < startOfDay {
                        overdueNotifications.append(request.identifier)
                    }
                }
            }
        
            self.deleteNotifications(identifiers: overdueNotifications)
        }
    }
    
    func deleteNotifications(identifiers: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
        
    }
    
    func setNotificationTask(object: Tasks) {
        
        // notifications
        var strDeleteNotifications: [String] = []
        //let endOfDay = Date().endOfDay
        let startOfDay = Date().startOfDay
        
//        if !dateTermination!.isEmpty && object!.dateTermination! >= startOfDay {
//
//            let subtitle = object!.heading
//            let body =  "Дата окончания: " + dateTermination!
//            + "\n" + "Дата оповещения: " + dateNotification!
//            + "\n" + object!.heading!
//
//            let badge = 1
//            let nextDate = object!.dateTermination
//            UserNotificationManager.shared.addNotificationWithCalendarTrigger(identifier: object!.id!+"##"+"dateTermination", title: "Предупреждение!", subtitle: subtitle!, body: body, badge: badge, nextDate: nextDate!)
//        }
//
        if object.dateTermination == nil {
            strDeleteNotifications.append(object.id!+"##"+"dateTermination")
        } else {
            if object.dateTermination! < startOfDay {
                strDeleteNotifications.append(object.id!+"##"+"dateTermination")
            }
        }
        
//        if !object!.dateNotification! == Date.init() && object!.dateNotification! >= startOfDay {
//
//            let subtitle = object.heading
//            let body =  "Дата окончания: " + dateTermination!
//            + "\n" + "Дата оповещения: " + dateNotification!
//            + "\n" + object!.heading!
//
//            let badge = 0
//            let nextDate = object!.dateNotification
//            addNotificationWithCalendarTrigger(identifier: object!.id!+"##"+dateNotification!, title: "Предупреждение!", subtitle: subtitle!, body: body, badge: badge, nextDate: nextDate!)
//
//          //  probaSendNotification()
//        }
        
//        if object.dateNotification!.isEmpty || object!.dateNotification! < startOfDay {
//            strDeleteNotifications.append(object.id!+"##"+"dateNotification")
//        }

        UserNotificationManager.shared.deleteNotifications(identifiers: strDeleteNotifications)
        
        UserNotificationManager.shared.deleteOverduePendingNotifications()
        
        UIApplication.shared.applicationIconBadgeNumber = TasksData.quantyTasksForBadgeNotifications(date: Date())
    }
    
} // class


