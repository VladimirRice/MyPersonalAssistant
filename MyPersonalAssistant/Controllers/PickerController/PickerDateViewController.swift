//
//  PickerDateViewController.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 27.04.2020.
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

protocol CurrencySelectedDateDelegate {
    func currencySelectedDate(currentLabelDate: UILabel, currentDate: Date?)
}

class PickerDateViewController: UIViewController { //}, HalfModalPresentable {

    var modelController: ModelController?
    var delegateViewController:  CurrencySelectedDateDelegate?
    var currentValueDateText: String?
    var currentLabelDate: Any?
    let minDateFormat = "EEEE.dd.MM.yyyy HH:mm"
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        cancelTapped()
    }
    @IBAction func modePicker(_ sender: UIBarButtonItem) {
        modePicker()
    }
    @IBAction func donePicker(_ sender: UIBarButtonItem) {
      donePicker()
    }
    
    @IBAction func clearPickerBarButtonItem(_ sender: UIBarButtonItem) {
        clearPicker()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentValue = modelController?.dataExport.arrayValue[0] {
            currentValueDateText = (currentValue as! String)
        }
        currentLabelDate = modelController?.dataExport.arrayValue[1] as Any
        updatePicker()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func cancelTapped(){
//        if let delegate = navigationController?.transitioningDelegate as? HalfModalTransitioningDelegate {
//            delegate.interactiveDismiss = false
//        }
        self.dismiss(animated: true, completion: nil)
    }
   
    func clearPicker(){
        let  currentDate: Date? = nil
        delegateViewController!.currencySelectedDate(currentLabelDate: currentLabelDate! as! UILabel, currentDate: currentDate)
            cancelTapped()
        }
    func donePicker(){
//        let formatter = DateFormatter()
//        formatter.dateFormat = minDateFormat //maxDateFormat
//        formatter.locale = Locale(identifier: "ru_RU")
//        //formatter.dateStyle = DateFormattersender.Style.medium
//        let currentDate = formatter.string(from: datePicker.date)
        let  currentDate = datePicker.date
        delegateViewController!.currencySelectedDate(currentLabelDate: currentLabelDate! as! UILabel, currentDate: currentDate)
        cancelTapped()
    }
    
    func modePicker(){
         if datePicker.datePickerMode == .date{
            datePicker.datePickerMode = .dateAndTime
        }else {
            datePicker.datePickerMode = .date
        }
    }
    
//    func currentDateString(currentDateString: String) -> Date {
//        var currentDate = Functions.dateFromString(dateStr: currentDateString) as Date?
//        var isHour = true
//        if currentDate == nil{
//            currentDate = NSDate() as Date
//            isHour = false
//        }
//        let calendar = Calendar(identifier: .gregorian)//NSCalendar.current
//        let components = NSDateComponents()
//        components.year = (calendar.component(.year, from: currentDate! as Date))
//        components.month = (calendar.component(.month, from: currentDate! as Date))
//        components.day = (calendar.component(.day, from: currentDate! as Date))
//        if !isHour {//currentDate == nil {
//            components.hour = 9
//            components.minute = 0
//        } else {
//            components.hour = (calendar.component(.hour, from: currentDate! as Date))
//            components.minute = (calendar.component(.minute, from: currentDate! as Date))
//        }
//        let newDate = calendar.date(from: components as DateComponents)
//        return newDate! as Date
//    }
    
    func updatePicker(){
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.minuteInterval = 5
        let currentDate = currentValueDateText
        let newDate = Functions.currentDateString(currentDateString: currentDate!)
        //datePicker.datePickerStyle
        datePicker.setDate(newDate, animated: true)
        //datePicker.date = newDate! as Date
    }
//    func showDatePickerTextField(){
//        updatePicker()
//}

} // class
