//
//  EMail.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 08.02.2021.
//


/*
 
 import MessageUI
 
 class .....

 ,MFMailComposeViewControllerDelegate

 
 //MARK:- MailcomposerDelegate
 
 func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//            switch result {
//            case .cancelled:
//                print("User cancelled")
//                break
//
//            case .saved:
//                print("Mail is saved by user")
//                break
//
//            case .sent:
//                print("Mail is sent successfully")
//                break
//
//            case .failed:
//                print("Sending mail is failed")
//                break
//            default:
//                break
//            }
//
     controller.dismiss(animated: true)
     
 }
 
 */
import Foundation

import MessageUI

class EMail {
    
    var selfVC: UIViewController?
    var setSubject = ""
    var setMessageBody = "Отправлено из программы MyPersonalAssistant"
    var aFileNames = [""]
    
    func sendEmail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            selfVC!.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = selfVC as? MFMailComposeViewControllerDelegate // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        let eMail = UserDefaults.standard.object(forKey: "eMail") as? String
        //let eMail = "rvoipm@gmail.com"
        
        mailComposerVC.setToRecipients([eMail!])
        mailComposerVC.setSubject(setSubject)
        mailComposerVC.setMessageBody(setMessageBody, isHTML: false)
        
        let url = Files.mFolderURL()
        let urlTmp = url?.appendingPathComponent("tmp")
        for fileName in aFileNames {
            let currFileURL = url?.appendingPathComponent("\(fileName)")
            let filePath = currFileURL!.path
            if let data = NSData(contentsOfFile: filePath) {
                mailComposerVC.addAttachmentData(data as Data, mimeType: "application/zip" , fileName: fileName)
            }
            //}
        }
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        Functions.alertShort(selfVC: selfVC!, title: "Ошибка отправки письма!", message: "")
        //        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert, delegate: self, cancelButtonTitle: "OK")
        //        sendMailErrorAlert.show()
    }
    
    //MARK:- MailcomposerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("User cancelled")
            break
            
        case .saved:
            print("Mail is saved by user")
            break
            
        case .sent:
            print("Mail is sent successfully")
            break
            
        case .failed:
            print("Sending mail is failed")
            break
        default:
            break
        }
        
        controller.dismiss(animated: true)
        
    }
    
} //class
