//
//  TextNameViewController.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 28.04.2020.
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

class TextNameViewController: UIViewController, UITextViewDelegate {

    var nameTextViewText: String?
    var taskTableViewController: TaskTableViewController?
    
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBAction func closeViewController(_ sender: Any) {
        taskTableViewController?.nameTextView.text = nameTextView.text
     self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if taskTableViewController != nil {
            nameTextView.text = taskTableViewController!.nameTextView.text
        }
        if nameTextViewText != nil {
            nameTextView.text = nameTextViewText
        }
        nameTextView.addDoneButtonOnKeyboard()
        
        registerForKeyboardNotifications()
        
        //setNotificationKeyboard()
        
    }
    

    deinit {
        removeKeyboardNotifications()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - func
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height+10)
    }

    @objc func kbWillHide(_ notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }

//    @objc func kbWillShow(_ notification: NSNotification) {
//
//        if let keyboardSize = ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue) as AnyObject).cgRectValue {
//                if self.view.frame.origin.y == 0{
//                    self.view.frame.origin.y -= keyboardSize.height
//                }
//            }
//        }
//
//     @objc func kbWillHide(_ notification: NSNotification) {
//
//        if let keyboardSize = ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue) as AnyObject).cgRectValue {
//                if self.view.frame.origin.y != 0{
//                    self.view.frame.origin.y += keyboardSize.height
//                }
//            }
//        }
    
//    func setNotificationKeyboard ()  {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//
//    @objc func keyboardWasShown(notification: NSNotification)
//        {
//            var info = notification.userInfo!
//        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height+10, right: 0.0)
//            self.scrollView.contentInset = contentInsets
//            self.scrollView.scrollIndicatorInsets = contentInsets
//            var aRect : CGRect = self.view.frame
//            aRect.size.height -= keyboardSize!.height
//            if let nameTextView = self.nameTextView
//            {
//                if (!aRect.contains(nameTextView.frame.origin))
//                {
//                    self.scrollView.scrollRectToVisible(nameTextView.frame, animated: true)
//                }
//            }
//        }
//    // when keyboard hide reduce height of scroll view
//
//
//    @objc func keyboardWillBeHidden(notification: NSNotification){
//        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0,bottom: 0.0, right: 0.0)
//            self.scrollView.contentInset = contentInsets
//            self.scrollView.scrollIndicatorInsets = contentInsets
//            self.view.endEditing(true)
//        }
    
    
}
