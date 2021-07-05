//
//  Functions.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 24.04.2020.
//  Copyright © 2020 Test. All rights reserved.
//

import Foundation

import UIKit
import CoreData

///
struct DataExport {
    var arrayObjects: [Any]
    var arrayValue: [Any]
}
class ModelController {
    var dataExport = DataExport(arrayObjects: [], arrayValue: [])
}

///
struct SColors {
    var aColorsRU: [String] = ["<не выбран>"
                               ,"Красный"
                               ,"КрасныйСистемный"
                               ,"Желтый"
                               ,"ЖелтыйСистемный"
                               ,"Зеленый"
                               ,"ЗеленыйСистемный"
                               ,"Розовый"
                               ,"Пурпурный"
                               ,"Бардовый"
                               ,"Серый"
                               ,"Морской волны"
                               ,"Голубой"
                               ,"ГолубойСистемный"
                               ,"Коричневый"
                               
    ]
  
    var aColors: [UIColor] = [UIColor.white
                              ,UIColor.red
                              ,UIColor.systemRed
                              ,UIColor.yellow
                              ,UIColor.systemYellow
                              ,UIColor.green
                              ,UIColor.systemGreen
                              ,UIColor.systemPink
                              ,UIColor.magenta
                              ,UIColor(red: 120/255.0, green: 150/255.0, blue: 200/255.0, alpha: 1)
                              ,UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
                              ,UIColor.cyan
                              ,UIColor.blue
                              ,UIColor.systemBlue
                              ,UIColor.brown
        
    
    ]
}

//class CColorsTasks {
//    init() {
//     
//        let sColors = SColors.self
//        
//        func nameColorRU(color: Int) -> String {
//            switch color {
//            case 0:
//                return "<не выбрано>"
//            case 1:
//                return sColors.aColorsRU[1]
//            case 0:
//                return "<не выбрано>"
//            case 0:
//                return "<не выбрано>"
//            case 0:
//                return "<не выбрано>"
//                
//            default:
//                return "<не выбрано>"
//            }
//        }
////    var sColors = SColors(aColorsRU: ["<не выбран>","Красный","Желтый","Зеленый"], aColors: ["","R","Y","G"])
////    //}
////
//}


/*
             label = cell.heading
             let attributes:[NSAttributedString.Key:Any] = [
 //                .font : UIFont.systemFont(ofSize: 100),
                 .backgroundColor: UIColor.lightGray.withAlphaComponent(0.5),
 //                .strokeWidth : -2,
 //                .strokeColor : UIColor.black,
 //                .foregroundColor : UIColor.red,
                 .strikethroughStyle: 1,
             ]
             var attributesAttributedString = NSAttributedString(string: label.text!, attributes: attributes)
             label.attributedText = attributesAttributedString

 
 */


class Functions {

    init() {
        
    }
    
    class func openNextViewController(selfViewController: UIViewController, strViewController: String, navigationController: UINavigationController? = nil, fullScren: Bool? = nil) {
        let initialController = selfViewController.storyboard?.instantiateViewController(withIdentifier: strViewController)
        if fullScren != nil {
            initialController!.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        } else {
//            initialController!.modalPresentationStyle = .custom
        }
//        initialController!.modalTransitionStyle = .crossDissolve
//        initialController!.modalPresentationStyle = .custom//.overCurrentContext

        if navigationController != nil {
            navigationController!.pushViewController(initialController!,
                                                 animated: true)
        } else {
            selfViewController.present(initialController!, animated: true, completion: nil)
        }
        //selfViewController.dismiss(animated: true, completion: nil)
    }
    
    
    class func openMainMenu(selfViewController: UIViewController) {
//        let clientMenuTableViewController =  selfViewController.storyboard!.instantiateViewController(withIdentifier: "clientMenuTableViewController") as! ClientMenuTableViewController
//        selfViewController.navigationController?.pushViewController(clientMenuTableViewController, animated: true)
        
        let clientMenuTableViewController =  selfViewController.storyboard!.instantiateViewController(withIdentifier: "naviMenu") as! UINavigationController
       selfViewController.present(clientMenuTableViewController, animated: true, completion: nil)
    }
    
    class func setAttributedString(label: UILabel, AttributesKey: NSAttributedString.Key, attribut: Any) {
    let text = label.text
    let attributes: [NSAttributedString.Key: Any] = [AttributesKey: attribut]
    label.attributedText = NSAttributedString(string: text!, attributes: attributes)
}

    // format 0: 27.11.2019 07:56:13
    // format 1: 2019.11.27 07:56:13
    class func dateFromString(dateStr: String, format: Int = 0) -> (Date?) {
            if dateStr == "" {
                return nil
            }

            let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let componentArray = dateStr.components(separatedBy: " ")
            let compDate = componentArray[0]

            let compTime = componentArray[1]
            var dateComponentArray = compDate.components(separatedBy: ".")
            let timeComponentArray = compTime.components(separatedBy: ":")
            dateComponentArray = dateComponentArray + timeComponentArray

            if dateComponentArray.count == 6 {
                var components = DateComponents()
                if format == 0 {
                components.year = Int(dateComponentArray[3])
                components.month = Int(dateComponentArray[2])
                components.day = Int(dateComponentArray[1])
                components.hour = Int(dateComponentArray[4])
                components.minute = Int(dateComponentArray[5])
                }
                if format == 1 {
                components.year = Int(dateComponentArray[0])
                components.month = Int(dateComponentArray[1])
                components.day = Int(dateComponentArray[2])
                components.hour = Int(dateComponentArray[3])
                components.minute = Int(dateComponentArray[4])
                components.second = Int(dateComponentArray[5])
                }

                guard let date = calendar.date(from: components)! as Date? else {
                    return nil
                }

                return (date)
            } else {
                return nil
            }

        }
    
    /*
     Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
     09/12/2018                        --> MM/dd/yyyy
     09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
     Sep 12, 2:11 PM                   --> MMM d, h:mm a
     September 2018                    --> MMMM yyyy
     Sep 12, 2018                      --> MMM d, yyyy
     Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
     2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
     12.09.18                          --> dd.MM.yy
     10:41:02.112                      --> HH:mm:ss.SSS
     */
    
    class func dateFromStringFormat(dateStr: String, dateFormat: String) -> String {
        let isoDate = dateStr//"2016-04-14T10:44:00+0000"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat//"E, d MMM yyyy HH:mm:ss Z"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from:isoDate)
        return dateToString(date:date!)
    }
    //
     class func dateToString(date:Date) -> String{
            let minDateFormat = "EEEE.dd.MM.yyyy HH:mm"
            let formatter = DateFormatter()
            formatter.dateFormat = minDateFormat
            formatter.locale = Locale(identifier: "ru_RU")
            let dateResult = formatter.string(from: date as Date)
            return dateResult
        }
    class func dateToStringFormat(date:Date, minDateFormat: String?) -> String{
           //let minDateFormat = "EEEE.dd.MM.yyyy HH:mm"
        if minDateFormat == "" {
            let minDateFormat = "EEEE.dd.MM.yyyy HH:mm"
        }
           let formatter = DateFormatter()
           formatter.dateFormat = minDateFormat
           formatter.locale = Locale(identifier: "ru_RU")
           let dateResult = formatter.string(from: date as Date)
           return dateResult
       }

    class func isUpperString() -> Bool {
        return (UserDefaults.standard.object(forKey: "isUpperString") != nil)
    }
    
    
    // temp!
    /*
             let quantity_double = Double(truncating: quantity! as NSDecimalNumber)
             quantityStepper.value = quantity_double
             quantityLabel.text = "\(quantity_double)"
             quantityLabel.text = String(format: "%.2f", quantity_double)
     */
    
    //
    /*
     var roundButton = UIButton()
     
     override func viewDidLoad() {
     ......
     self.roundButton = UIButton(type: .custom)
     self.roundButton.setTitleColor(UIColor.orange, for: .normal)
     self.roundButton.addTarget(self, action: #selector(ButtonClick(_:)), for: UIControl.Event.touchUpInside)
     self.view.addSubview(roundButton)
     
     override func viewWillLayoutSubviews() {
         Functions.floatButton(selfVC: self, roundButton: roundButton)
     }
     
     @objc func ButtonClick(_ sender: UIButton){

      addObjectTable()

     }
     
     
     */
    class func floatButton(selfVC: UIViewController, roundButton: UIButton, bottom: Int) {
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        roundButton.backgroundColor = UIColor.darkGray
        roundButton.clipsToBounds = true
        roundButton.setImage(UIImage(named:"plus48"), for: .normal)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        roundButton.trailingAnchor.constraint(equalTo: selfVC.view.trailingAnchor, constant: -10), //-3
            roundButton.bottomAnchor.constraint(equalTo: selfVC.view.bottomAnchor, constant: CGFloat(bottom)), // -153 //-53
        roundButton.widthAnchor.constraint(equalToConstant: 50),
        roundButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    class func floatToString(curVar: Float) -> String {
        return String(format: "%.1f", curVar)
    }
    
    class func intToString(curVar: Int) -> String {
        return String(describing: curVar)//String(format: "%f", curVar)
    }
    
    class func currentDateString(currentDateString: String) -> Date {
        var currentDate = Functions.dateFromString(dateStr: currentDateString) as Date?
        var isHour = true
        if currentDate == nil{
            currentDate = NSDate() as Date
            isHour = false
        }
        let calendar = Calendar(identifier: .gregorian)//NSCalendar.current
        let components = NSDateComponents()
        components.year = (calendar.component(.year, from: currentDate! as Date))
        components.month = (calendar.component(.month, from: currentDate! as Date))
        components.day = (calendar.component(.day, from: currentDate! as Date))
        if !isHour {//currentDate == nil {
            components.hour = 1
            components.minute = 0
        } else {
            components.hour = (calendar.component(.hour, from: currentDate! as Date))
            components.minute = (calendar.component(.minute, from: currentDate! as Date))
        }
        let newDate = calendar.date(from: components as DateComponents)
        return newDate! as Date
    }

    //
    class func openFileTxt(selfVC: UIViewController, filename: String, dir: URL? = nil) {
        if dir == nil {
           let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        }
        if (dir != nil) {
            
            let fileURL = dir!.appendingPathComponent(filename)
            
            do {
                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
                
                let fileTextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "fileTextViewController") as! FileTextViewController
                fileTextViewController.textTextViewtext = text2
                fileTextViewController.fileName = filename//"ScanHistory.txt"
                selfVC.present(fileTextViewController, animated: true, completion: nil)
            }
            catch {/* error handling here */}
            


        }
    }
    
    class func writeFileText(fileName: String, decodedURL: String, addInTheEnd: Bool) {
            //let file = "ScanHistory.txt"

            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

                let fileURL = dir.appendingPathComponent(fileName)

                //reading
                do {
                    var text = decodedURL
                    if addInTheEnd {
                        let text2 = try String(contentsOf: fileURL, encoding: .utf8)
                        let textDate = "\n" + "== " + Functions.dateToString(date: Date())
                        text = text2 + "\n" + textDate + "\n" + decodedURL
                    }
                    
                    //writing
                    do {
                        try text.write(to: fileURL, atomically: false, encoding: .utf8)
                    }
                    catch {/* error handling here */}
                    
                }
                catch {/* error handling here */}
                
    //            let text = decodedURL
    //
    //            //writing
    //            do {
    //                try text.write(to: fileURL, atomically: false, encoding: .utf8)
    //            }
    //            catch {/* error handling here */}

    //            //reading
    //            do {
    //                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
    //            }
    //            catch {/* error handling here */}
            }
        }
    
    
    class func alertShort (selfVC: UIViewController, title: String, message: String, second: Double? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        //selfVC.present(alert, animated: true, completion: nil)
        var second = second
        if second == nil {
            second = 2
        }
        selfVC.present(alert,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: TimeInterval(second!), repeats:false, block: {_ in
            selfVC.dismiss(animated: true, completion: nil)
        })})
    }
    
//    class func openComment(selfVC: UIViewController, commentText: String, second: Double? = nil) {
//        let isComment = UserDefaults.standard.object(forKey: "isComment") as? Bool
//        if isComment == false {
//            return
//        }
//        var second = second
//        if second == nil {
//            second = 3
//        }
//        let initialController = selfVC.storyboard?.instantiateViewController(withIdentifier: "commentViewController") as? CommentViewController
//
//        initialController?.commentText = commentText
//        initialController!.transitioningDelegate = (selfVC as! UIViewControllerTransitioningDelegate)
//
//        initialController!.modalPresentationStyle = .custom
//        //selfVC.present(initialController!, animated: true)
//        selfVC.present(initialController!,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: second!, repeats:false, block: {_ in
//            selfVC.dismiss(animated: true, completion: nil)
//        })})
//
//    }
//
//    class func openCommentError(selfVC: UIViewController, commentText: String, second: Double? = nil) {
////        let isComment = UserDefaults.standard.object(forKey: "isComment") as? Bool
////        if isComment == false {
////            return
////        }
//        var second = second
//        if second == nil {
//            second = 3
//        }
//        let initialController = selfVC.storyboard?.instantiateViewController(withIdentifier: "commentViewController") as? CommentViewController
//        initialController?.view.backgroundColor = UIColor.red
//        initialController?.commentText = commentText
//        initialController?.commentLabel.text = commentText
//        initialController!.transitioningDelegate = selfVC as? UIViewControllerTransitioningDelegate
//
//        initialController!.modalPresentationStyle = .custom
//        //selfVC.present(initialController!, animated: true)
//        selfVC.present(initialController!,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: second!, repeats:false, block: {_ in
//            selfVC.dismiss(animated: true, completion: nil)
//        })})
//
//    }
    
    class func updateColorTask(currentObject: Tasks, tableView: UITableView){
        let sColors1 = SColors()
        
        tableView.backgroundColor = sColors1.aColors[currentObject.color as! Int]
//        tableView.backgroundColor = UIColor.white
//        switch currentObject.color {
//        case 1:
//            tableView.backgroundColor = UIColor.red
//        case 2:
//            tableView.backgroundColor = UIColor.yellow
//        case 3:
//            tableView.backgroundColor = UIColor.green
//
//        default:
//            tableView.backgroundColor = UIColor.white
//        }
        
    }
    
    class func updateEnabledTask(currentObject: Tasks, button: UIButton? = nil){
        var nameImage = "unlocked"
        if currentObject.isEnabled == false {
            nameImage = "locked"
        }
        if button != nil {
            button!.setImage(UIImage(named: nameImage), for: .normal)
        }
    }
    
//    // MARK: - timer
//    class func timerArh() {
//        //let context = ["user": "@twostraws"]
//        // 86400 сутки
//        // 43200 12 часов
//        let timerArhSecond = 60
//        let timeInterval = UserDefaults.standard.object(forKey: "timerArhSecond") as? Double ?? 43200
//        let timeIntervalSecond = TimeInterval(timeInterval)
//        Timer.scheduledTimer(timeInterval: timeIntervalSecond, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
//    }
//    
//    @objc func fireTimer(){
//        dataInJson()
//    }
//
    
    class func initArh() {
        let isArhInitApp = UserDefaults.standard.object(forKey: "isArhInitApp") as? Bool ?? false
        if isArhInitApp {
            dataInJson(selfVC: nil, dopName: "A")
        }
    }


} // class

extension Date {
    func add(minutes: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .minute, value: minutes, to: self)!
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    func days(to secondDate: Date, calendar: Calendar = Calendar.current) -> Int {
        let secondDate = secondDate.startOfDay
        return calendar.dateComponents([.day], from: self, to: secondDate).day! // Здесь force unwrap, так как в компонентах указали .day и берем day
    }
    
    func nextDay(nextValue: Int) -> Date {
        let today = self//.startOfDay
        return Calendar.current.date(byAdding: .day, value: nextValue, to: today)!
    }
}

//func alertShort (selfVC: UIViewController, title: String, message: String) {
//    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//
//    // add an action (button)
//    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//
//    // show the alert
//    selfVC.present(alert, animated: true, completion: nil)
//}

extension String {
    mutating func replaceOccurrences<Target: StringProtocol, Replacement: StringProtocol>(of target: Target, with replacement: Replacement, options: String.CompareOptions = [], locale: Locale? = nil) {
        var range: Range<Index>?
        repeat {
            range = self.range(of: target, options: options, range: range.map { self.index($0.lowerBound, offsetBy: replacement.count)..<self.endIndex }, locale: locale)
            if let range = range {
                self.replaceSubrange(range, with: replacement)
            }
        } while range != nil
    }
    
    func indexes(of string: String, offset: Int = 0) -> [Int]? {
        if let range = self.range(of : string) {
            if !range.isEmpty {
                let index = distance(from : self.startIndex, to : range.lowerBound) + offset
                var result = [index]
                let substr = self.substring(from: range.upperBound)
                if let substrIndexes = substr.indexes(of: string, offset: index + distance(from: range.lowerBound, to: range.upperBound)) {
                    result.append(contentsOf: substrIndexes)
                }
                return result
            }
        }
        return nil
    }
    
    func strRange(string: String, intStart: Int, IntFinish: Int) -> String {
        let lowerBound = String.Index.init(encodedOffset: intStart)
        let upperBound = String.Index.init(encodedOffset: IntFinish)
        return String(string[lowerBound..<upperBound])
    }
    
    /*
    let searchStrs = ["","","",""]
    findSubString(inputStr: Bigstring, subStrings: searchStrs)
*/
    
    func findSubString(inputStr : String, subStrings: Array<String>?) ->    Array<(String, Int, Int)> {
        var resultArray : Array<(String, Int, Int)> = []
        for i: Int in 0...(subStrings?.count)!-1 {
            if inputStr.contains((subStrings?[i])!) {
                let range: Range<String.Index> = inputStr.range(of: subStrings![i])!
                let lPos = inputStr.distance(from: inputStr.startIndex, to: range.lowerBound)
                let uPos = inputStr.distance(from: inputStr.startIndex, to: range.upperBound)
                let element = ((subStrings?[i])! as String, lPos, uPos)
                resultArray.append(element)
            }
        }
//        for words in resultArray {
//            print(words)
//        }
        return resultArray
    }
    //extension String {
        func capitalizingFirstLetter() -> String {
            //return prefix(1).capitalized + dropFirst()
            return prefix(1).uppercased() + self.dropFirst()// + self.lowercased().dropFirst()
        }
    //}

}


extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

extension UITextView {
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
    
//    func addDoneButton(title: String, target: Any, selector: Selector) {
//        
//        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
//                                              y: 0.0,
//                                              width: UIScreen.main.bounds.size.width,
//                                              height: 44.0))//1
//        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
//        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
//        toolBar.setItems([flexible, barButton], animated: false)//4
//        self.inputAccessoryView = toolBar//5
//    }
    
    // lite
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}
