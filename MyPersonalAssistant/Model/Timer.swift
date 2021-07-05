//
//  Timer.swift
//  ShortcutsM
//
//  Created by Vladimir Rice on 19.12.2020.
//

import Foundation
import UIKit


struct SVars {
    //var nameShortcut = ""
    var countRepeatsTimer = ""
    var countMinuteTimer = ""
}


//class TimerApp {
//
//    var timer: Timer?
//    var runCount = 1
//    //let selfVC: UIViewController? = nil
//
//
//
//    func timerOn() -> String {
//        let sVars = loadSettingsVars()
//        let error = fireTimer()
//        if error != "" {
//            return error
//        }
//        let strTimer = sVars.countMinuteTimer//countMinuteTimerTextField.text!
//        let intStrTimer = NumberFormatter().number(from: strTimer)
//        let timerSecond: Double = Double(intStrTimer as! Double * 60)
//        //let strTimerSecond = String(timerSecond)
//
//        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timerSecond), target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
//
//        RunLoop.current.add(timer!, forMode: .common)
//        return error
//    }
//
////    @objc func fireTimer0() {
////        let sVars = loadSettingsVars()
////    }
//
//    @objc func fireTimer() -> String {
//        let sVars = loadSettingsVars()
//        let error = runShortcut(nameShortcut: sVars.nameShortcut)
//        if error != "" {
//            return error
//        }
//
//        runCount += 1
//        let countRepeatsTimer = Int(sVars.countRepeatsTimer)
//        if runCount == countRepeatsTimer {
//            timer?.invalidate()
//        }
//        return error
//    }
//
//    func cancelTimer() {
//        timer?.invalidate()
//    }
//
//    func runShortcut(nameShortcut: String) -> String {
//        //let kCustomURLScheme = "prefs:root=ControlCenter&path=CUSTOMIZE_CONTROLS"
//        //let kCustomURLScheme = "shortcuts://run-shortcut?name=S1"
//        //let nameShortcut = nameShortcutTextField.text
//        if nameShortcut == "" {
//            return "Не заполнено наименование команды."
//        }
//
//        let kCustomURLScheme = "shortcuts://run-shortcut?name="+nameShortcut
//
//        //
//        //func openCustomApp() {
//
//        let Url : NSURL? = NSURL(string: kCustomURLScheme)
//
//        if Url == nil {
//            return "Не найдена быстрая команда " + nameShortcut
//        }
//
//
//        //}
//        if UIApplication.shared.canOpenURL(Url! as URL)
//        {
//            UIApplication.shared.openURL(Url! as URL)
//
//        } else {
//            //redirect to safari because the user doesn't have Instagram
//            UIApplication.shared.openURL(NSURL(string: kCustomURLScheme)! as URL)
//        }
//        return ""
//    }
//
//    func loadSettingsVars() -> SVars {
//        var svars = SVars()
//        svars.nameShortcut = (UserDefaults.standard.object(forKey: "nameShortcut") as? String)!
//        svars.countRepeatsTimer = UserDefaults.standard.object(forKey: "countRepeatsTimer") as? String ?? "10"
//        svars.countMinuteTimer = UserDefaults.standard.object(forKey: "countMinuteTimer") as? String ?? "20"
//        return svars
//    }
//
//
//} //class



// import Dispatch

//class RepeatingTimer {
//
//    var timer: DispatchSourceTimer?
//    let queue: DispatchQueue
//
//    var eventHandler: (() -> Void)?
//
//    private enum State {
//        case none
//        case suspended
//        case resumed
//    }
//
//    private var state: State = .none
//
//    init() {
//        queue = DispatchQueue(label: "serial.queue.1")
//
//        timer = DispatchSource.makeTimerSource(queue: queue)
//        //timer?.cancel()
//
//        timer?.schedule(deadline: .now() + .seconds(10), repeating: .seconds(10), leeway: .milliseconds(100))
//
//        //suspend()
//
//        if #available(iOS 10.0, *) {
//            timer?.activate()
//        } else {
//            timer?.resume()
//        }
//
//        timer?.setEventHandler { [weak self] in
//            print(Date())
//        }
//
//        resume()
//    }
//
//    deinit {
//        timer?.setEventHandler {}
//        timer?.cancel()
//
//        //timer?.resume()
//        //eventHandler = nil
//    }
//
//    func resume() {
//        if state == .resumed {
//            return
//        }
//        state = .resumed
//        //timer?.resume()
//    }
//
//    func suspend() {
//        if state == .suspended {
//            return
//        }
//        state = .suspended
//        timer?.suspend()
//    }



/////
//// https://medium.com/over-engineering/a-background-repeating-timer-in-swift-412cecfd2ef9
//class RepeatingTimer {
//
//    let timeInterval: TimeInterval
//
//    init(timeInterval: TimeInterval) {
//        self.timeInterval = timeInterval
//    }
//
//    private lazy var timer: DispatchSourceTimer = {
//        let t = DispatchSource.makeTimerSource()
//        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
//        t.setEventHandler(handler: { [weak self] in
//            self?.eventHandler?()
//        })
//        return t
//    }()
//
//    var eventHandler: (() -> Void)?
//
//    private enum State {
//        case suspended
//        case resumed
//    }
//
//    private var state: State = .suspended
//
//    deinit {
//        timer.setEventHandler {}
//        timer.cancel()
//        /*
//         If the timer is suspended, calling cancel without resuming
//         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
//         */
//        resume()
//        eventHandler = nil
//    }
//
//    func resume() {
//        if state == .resumed {
//            return
//        }
//        state = .resumed
//        timer.resume()
//    }
//
//    func suspend() {
//        if state == .suspended {
//            return
//        }
//        state = .suspended
//        timer.suspend()
//    }
//
//
//} //class


//// https://forum.swiftbook.ru/t/rabota-tajmera-v-fonovom-rezhime/2586
//class Timer2 {
//
//    func on() {
//    let N = 10
////    let timer = Timer.scheduledTimerWithTimeInterval(TimeInterval(N), target: self, selector: //#selector(timerFunc(_:)), userInfo: nil, repeats: true)
////        #selector(timerFunc), userInfo: nil, repeats: true)
//
//    let timer = Timer.scheduledTimer(timeInterval: TimeInterval(N), target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
//
//    }
//    //@objc func fireTimer(timer: Timer) {
//    @objc func fireTimer() {
//        //starts background task
//        var backgroundTask = UIApplication.shared.beginBackgroundTask {}
//        print("-----------------fire")
//        //stops background task
//        if backgroundTask != UIBackgroundTaskIdentifier.invalid {
//            if UIApplication.shared.applicationState == .active {
//                UIApplication.shared.endBackgroundTask(backgroundTask)
//                backgroundTask = UIBackgroundTaskIdentifier.invalid
//            }
//        }
//    }
//
//
//} //class

//class TimerCycle {
//
//    func on() -> String {
//        let sVars = loadSettingsVars()
//        let error = fireTimer()
//        if error != "" {
//            return error
//        }
//
////    let timer = Timer.scheduledTimerWithTimeInterval(TimeInterval(N), target: self, selector: //#selector(timerFunc(_:)), userInfo: nil, repeats: true)
////        #selector(timerFunc), userInfo: nil, repeats: true)
//
//        let strTimer = sVars.countMinuteTimer//countMinuteTimerTextField.text!
//        let intStrTimer = NumberFormatter().number(from: strTimer)
//        let timerSecond: Double = Double(intStrTimer as! Double * 60)
//
//        let timer = Timer.scheduledTimer(timeInterval: TimeInterval(timerSecond)!, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
//
//        return error
//
//    }
//    //@objc func fireTimer(timer: Timer) {
//    @objc func fireTimer() -> String {
//        //starts background task
//        var backgroundTask = UIApplication.shared.beginBackgroundTask {}
//        print("-----------------fire")
//        //stops background task
//        if backgroundTask != UIBackgroundTaskIdentifier.invalid {
//            if UIApplication.shared.applicationState == .active {
//                UIApplication.shared.endBackgroundTask(backgroundTask)
//                backgroundTask = UIBackgroundTaskIdentifier.invalid
//            }
//        }
//        return ""
//    }
//
//
//    func loadSettingsVars() -> SVars {
//        var svars = SVars()
//        svars.nameShortcut = (UserDefaults.standard.object(forKey: "nameShortcut") as? String)!
//        svars.countRepeatsTimer = UserDefaults.standard.object(forKey: "countRepeatsTimer") as? String ?? "10"
//        svars.countMinuteTimer = UserDefaults.standard.object(forKey: "countMinuteTimer") as? String ?? "20"
//        return svars
//    }
//
// }
    

class TimerApp {

    var timer: Timer?
    var runCount = 1
    //let selfVC: UIViewController? = nil
    
    
    
    func timerOn() -> String {
        let sVars = loadSettingsVars()
        let error = fireTimer()
        if error != "" {
            return error
        }
        let strTimer = sVars.countMinuteTimer//countMinuteTimerTextField.text!
        let intStrTimer = NumberFormatter().number(from: strTimer)
        let timerSecond: Double = Double(intStrTimer as! Double * 60)
        //let strTimerSecond = String(timerSecond)
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timerSecond), target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)

        //RunLoop.current.add(timer!, forMode: .common)
        return error
    }
    
//    @objc func fireTimer0() {
//        let sVars = loadSettingsVars()
//    }
    
    @objc func fireTimer() -> String {
        var error = ""
        
        //starts background task
        var backgroundTask = UIApplication.shared.beginBackgroundTask {}
        print("-----------------fireTimer\(runCount)")
        //stops background task
        if backgroundTask != UIBackgroundTaskIdentifier.invalid {
            if UIApplication.shared.applicationState == .active {
                UIApplication.shared.endBackgroundTask(backgroundTask)
                backgroundTask = UIBackgroundTaskIdentifier.invalid
            }
        }
    
        dataInJson()
        
        let sVars = loadSettingsVars()

        //        let error = runShortcut(nameShortcut: sVars.nameShortcut)
//        if error != "" {
//            return error
//        }

        runCount += 1
        let countRepeatsTimer = Int(sVars.countRepeatsTimer)
        if runCount == countRepeatsTimer {
            timer?.invalidate()
        }
        return error
    }
    
    func cancelTimer() {
        timer?.invalidate()
    }
    
//    func runShortcut(nameShortcut: String) -> String {
//        //let kCustomURLScheme = "prefs:root=ControlCenter&path=CUSTOMIZE_CONTROLS"
//        //let kCustomURLScheme = "shortcuts://run-shortcut?name=S1"
//        //let nameShortcut = nameShortcutTextField.text
//        if nameShortcut == "" {
//            return "Не заполнено наименование команды."
//        }
//        
//        let kCustomURLScheme = "shortcuts://run-shortcut?name="+nameShortcut
//        
//        //
//        //func openCustomApp() {
//        
//        let Url : NSURL? = NSURL(string: kCustomURLScheme)
//        
//        if Url == nil {
//            return "Не найдена быстрая команда " + nameShortcut
//        }
//
//        
//        //}
//        if UIApplication.shared.canOpenURL(Url! as URL)
//        {
//            UIApplication.shared.openURL(Url! as URL)
//            
//        } else {
//            //redirect to safari because the user doesn't have Instagram
//            UIApplication.shared.openURL(NSURL(string: kCustomURLScheme)! as URL)
//        }
//        return ""
//    }
    
    func loadSettingsVars() -> SVars {
        var svars = SVars()
//        //svars.nameShortcut = (UserDefaults.standard.object(forKey: "nameShortcut") as? String)!
//        svars.countRepeatsTimer = UserDefaults.standard.object(forKey: "countRepeatsTimer") as? String ?? "10"
//        svars.countMinuteTimer = UserDefaults.standard.object(forKey: "countMinuteTimer") as? String ?? "20"
        svars.countRepeatsTimer = "3"
        svars.countMinuteTimer = "1"
        return svars
    }

    
} //class
