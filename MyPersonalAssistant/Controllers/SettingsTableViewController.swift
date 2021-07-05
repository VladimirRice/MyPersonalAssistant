//
//  SettingsTableViewController.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 13.04.2020.
//  Copyright © 2020 Vladimir Rice. All rights reserved.
//

import UIKit
//import SwiftyJSON
import CoreData
import GoogleSignIn
import GoogleAPIClientForREST
//import GTMAppAuth

//import Alamofire
import SwiftyJSON

class SettingsTableViewController: UITableViewController, UITextFieldDelegate
                                   //    ,UIPickerViewDataSource
                                   ,CurrencySelectedDelegate
{
    
    //var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    var modelController: ModelController! = ModelController()
    var idList: String?
    
    var currentListAllert: ListTasks = ListTasks()
    
    var dayInt: Int!
    var hourInt: Int!
    var minuteInt: Int!
    
    var jsonFiles: [String] = []
    //
    var cellsAppPro = [6,7]
    //var appRelease = false
    //    var loginIFNS: String!
    //    var passwIFNS: String!
    
    @IBOutlet weak var isLoginSwitch: UISwitch!
    @IBOutlet weak var pinKodTextField: UITextField!
    @IBOutlet weak var eMailTextField: UITextField!
    @IBOutlet weak var heigthCellTextField: UITextField!
    @IBOutlet weak var fontHeadingTextField: UITextField!
    @IBOutlet weak var fontNameTextField: UITextField!
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var isUpperStringSwitch: UISwitch!
    
    @IBOutlet weak var isPriority1Switch: UISwitch!
    @IBOutlet weak var isPriority2Switch: UISwitch!
    @IBOutlet weak var isPriority3Switch: UISwitch!
    
    @IBOutlet weak var intervalSwitch: UISwitch!
    
    @IBOutlet weak var dateIntervalLabel: UILabel!
    
    @IBOutlet weak var arhFileButton: UIButton!
    @IBOutlet weak var restoreFileButton: UIButton!
    //@IBOutlet weak var pickerFiles: UIPickerView!
    @IBOutlet weak var fileJsonLabel: UILabel!
    
    @IBOutlet weak var googleSignStatus: UILabel!
    @IBOutlet weak var googleSignButton: UIButton!
    @IBOutlet weak var SinhchronButton: UIButton!
    @IBOutlet weak var isAutoSaveSwitch: UISwitch!
    
    @IBOutlet weak var saveButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var timerSaveTextField: UITextField!
    //@IBOutlet weak var timerArhTextField: UITextField!
    @IBOutlet weak var isArhInitAppSwitch: UISwitch!
    @IBOutlet weak var countFileBackupTextField: UITextField!
    
    var listArray: [ListTasks] = []
    
    var currArrayValue: String?
    
    // pickerInterval
    var arrayDay: [Int] = [0,1,2,3]
    var arrayHour: [Int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
    var arrayMinute: [Int] = [0,5,10,15,20,30,40,50]
    
    
    private let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        //        appPro = publicVars.appPro
        //        appForItunes = publicVars.appForItunes
        //
        
        LoadSettings()
        
        // sign
        googleSignButton.layer.cornerRadius = 5    /// радиус закругления закругление
        googleSignButton.layer.borderWidth = 2.0   // толщина обводки
        googleSignButton.layer.borderColor = (UIColor(red: 242.0/255.0, green: 116.0/255.0, blue: 119.0/255.0, alpha: 1.0)).cgColor // цвет обводки
        googleSignButton.clipsToBounds = true  //
        
        SinhchronButton.layer.cornerRadius = 5    /// радиус закругления закругление
        SinhchronButton.layer.borderWidth = 1.0   // толщина обводки
        SinhchronButton.layer.borderColor = UIColor.green.cgColor//(UIColor(red: 242.0/255.0, green: 116.0/255.0, blue: 119.0/255.0, alpha: 1.0)).cgColor // цвет обводки
        SinhchronButton.clipsToBounds = true  //
        
        GIDSignIn.sharedInstance().delegate = self
        initialSign(selfVC: self)
        updateScreenSign()
        //
        
        view.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickerInterval))
        dateIntervalLabel.addGestureRecognizer(tap)
        dateIntervalLabel.isUserInteractionEnabled = true
        
        //        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        
        //       if appPro {
        let tapfileJsonLabel = UITapGestureRecognizer(target: self, action: #selector(tappedJsonFiles))
        fileJsonLabel.addGestureRecognizer(tapfileJsonLabel)
        fileJsonLabel.isUserInteractionEnabled = true
        fileJsonLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedJsonFiles)))
        //       }
        
        //        if PublicVars().autoSaveCloseForm {
        //            saveButtonItem.isEnabled = false
        //        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LoadSettings()
        isDisableAppPRO()
        //        let isfile = existingFile(fileName: fileBackupTextField.text!+".sqlite")
        //        restoreFileButton.isEnabled = isfile
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        if inde
    //        return 6
    //    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //     openViewControllerDidselect(indexPath: indexPath)
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let nameButton = "_Pro!"
        if cellsAppPro.contains(indexPath.section) {  //indexPath.section == 6 {
            cell.isEditing = false
            cell.imageView?.image = UIImage(named: nameButton)
        }
    }
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
     var cell = UITableViewCell()
     if cell == tableView.dequeueReusableCell(withIdentifier: "arh1", for: indexPath) {
     
     // Configure the cell...
     
     return cell
     
     } else {
     return cell
     
     }
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cell_category" {
            let vc = (segue.destination as! SimpleReferenceBooksViewController) //{
            //let indexPath = self.tableView.indexPathForSelectedRow
            //vc.currentObject = self.objectsCheck[indexPath!.row]
            
            var attributs = ["name", "color"]
            var attributsRus = ["Наименование", "Цвет"]
            var attributsCell = ["name"]
            //var attributImage = "image"
            
            navigationItem.title = "Категории"
            
            vc.typeReferens = "Category"
            vc.typeReferensRus = "Категории"
            vc.attributs = attributs
            vc.attributsCell = attributsCell
            vc.attributsRus = attributsRus
            vc.objects = CategoryData.dataLoad(strPredicate: "", filter: "")
            //vc.attributImage = attributImage
            
        }
        
        //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == "pickerView") {
            
            if let initialController = segue.destination as? PickerViewController {
                //            let initialController = self.storyboard?.instantiateViewController(withIdentifier:
                //                "pickerViewController") as? PickerViewController
                
                let listArray = ListTasksData.dataLoad(strPredicate: "", filter: "")
                currArrayValue = "name"
                
                modelController.dataExport.arrayValue.removeAll()
                modelController.dataExport.arrayObjects = listArray
                modelController.dataExport.arrayValue.append(currArrayValue as Any)
                
                initialController.modelController = modelController
                initialController.delegateViewController = self
            }
            
            
        }
        //        let initialController = segue.destination as! Settings2TableViewController
        //        initialController.delegateViewController = self
        //    }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == fontHeadingTextField {
            return string == string.filter("0123456789.".contains)
        }
        if textField == fontNameTextField {
            return string == string.filter("0123456789.".contains)
        }
        //        if textField == dayTextField {
        //           return string == string.filter("0123456789.".contains)
        //        }
        //        if textField == hourTextField {
        //           return string == string.filter("0123456789.".contains)
        //        }
        //        if textField == minuteTextField {
        //           return string == string.filter("0123456789.".contains)
        //        }
        
        return true
        
    }
    
    
    /*
     // MARK: delegate pickerView
     public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
     return listArray.count
     }
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     
     self.view.endEditing(true)
     return listArray[row].name
     
     }
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     
     self.nameLabel.text = self.listArray[row].name
     self.dropDown.isHidden = true
     }
     */
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //      if textField == self.listNameLabel {
        
        //            self.dropDown.isHidden = false
        //            //if you dont want the users to se the keyboard type:
        //            textField.endEditing(true)
        //        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //        if !appForItunes && (section == 5 || cellsAppPro.contains(section))  {
        //            return 0
        //        }
        var appPro = PublicVars().appPro
        //var appForItunes = PublicVars().appForItunes
        
        //        if !appPro && cellsAppPro.contains(section) {
        //            return 1
        //        }
        
        if !appPro && (section == 5 || section == 7) {
            return 0
        }
        
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var appPro = PublicVars().appPro
        //        var appForItunes = PublicVars().appForItunes
        //
        //        if !appForItunes && (section == 5 || cellsAppPro.contains(section)) {
        //            return nil
        //        }
        
        if !appPro && (section == 5 || section == 7) {
            return nil
        }
        
        return super.tableView(tableView, titleForHeaderInSection: section)
    }
    
    
    // MARK: - action
    
    @IBAction func saveSetting(_ sender: Any) {
        SaveSettings()
    }
    
    // arh
    @IBAction func backupFileButton(_ sender: UIButton) {
        //IJProgressView.shared.showProgressView()
        fileJsonLabel.text = dataInJson(selfVC: self)
        Files.filesCountArh()
        //IJProgressView.shared.hideProgressView()
        Functions.alertShort(selfVC: self, title: "Внимание", message: "Архивация выполнена", second: 0.02)
        
    }
    
    @IBAction func restorebackupFileButton(_ sender: UIButton) {
        //IJProgressView.shared.showProgressView()
        restorebackupFileButtonClick()
        //IJProgressView.shared.hideProgressView()
    }
    
    
    @IBAction func closeButtonItem(_ sender: UIBarButtonItem) {
        if PublicVars().autoSaveCloseForm {
            SaveSettings()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func googleSignAction(_ sender: UIButton) {
        
        if let user = GIDSignIn.sharedInstance()?.currentUser {
            GIDSignIn.sharedInstance()?.signOut()
        } else {
            
            //googleSign(selfVC: self, taskListID: "")
            GIDSignIn.sharedInstance().delegate=self
            GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/tasks")
            GIDSignIn.sharedInstance().signIn()
        }
        updateScreenSign()
    }
    
    @IBAction func googleSynchronAction(_ sender: UIButton) {
        let statusGoogleSign = googleSynchron(selfVC: self, listID: "")
    }
    
    //    @IBAction func backupFileButton(_ sender: UIButton) {
    //        if fileBackupTextField.text!.isEmpty {
    //            alertShort(selfVC: self, title: "Внимание", message: "Не заполен реквизит \"Имя файла\"")
    //            return
    //        }
    
    //        var messageAlert = ""
    //        if !backupCoreDateFile(backupName: fileBackupTextField.text!) {
    //            messageAlert = "Не удалось создать архив базы данных в файл \(String(describing: fileBackupTextField.text!))"
    //        } else {
    //            messageAlert = "Создан архив базы данных в файле \(String(describing: fileBackupTextField.text!))"
    //            let listArray = ListTasksData.dataLoad(strPredicate: "", filter: "")
    //            messageAlert = messageAlert+" (\(listArray.count))"
    //
    //        }
    //        alertShort(selfVC: self, title: "Внимание", message: messageAlert)
    //
    //    }
    //    @IBAction func restorebackupFileButton(_ sender: UIButton) {
    //        let isfile = existingFile(fileName: fileBackupTextField.text!+".sqlite")
    //        if !isfile {
    //            alertShort(selfVC: self, title: "Внимание", message: "Не найден файл \(String(describing: fileBackupTextField.text!))")
    //        }
    //
    //        var messageAlert = ""
    //        if !restoreFromStore(backupName: fileBackupTextField.text!) {
    //            messageAlert = "Не удалось воостановить базу данных из файла \(String(describing: fileBackupTextField.text!))"
    //        } else {
    //            messageAlert = "База данных восстановлена из файла \(String(describing: fileBackupTextField.text!))"
    //            //AppDelegate.shared.initialViewController()
    //            //
    //            let listArray = ListTasksData.dataLoad(strPredicate: "", filter: "")
    //            messageAlert = messageAlert+" (\(listArray.count))"
    //        }
    //        alertShort(selfVC: self, title: "Внимание", message: messageAlert)
    //
    //    }
    
    
    // MARK: func
    
    func SaveSettings() {
        userDefaults.set(isLoginSwitch.isOn, forKey: "isLogin")// as? Bool
        userDefaults.set(pinKodTextField.text, forKey: "pinKod")
        userDefaults.set(eMailTextField.text, forKey: "eMail")
        
        userDefaults.set(heigthCellTextField.text!, forKey: "heigthCell")
        userDefaults.set(heigthCellTextField.text!, forKey: "isAutoHeigthCell")
        userDefaults.set(fontHeadingTextField.text! , forKey: "fontHeading")
        userDefaults.set(fontNameTextField.text!, forKey: "fontName")
        userDefaults.set(idList, forKey: "idList")
        userDefaults.set(isUpperStringSwitch.isOn, forKey: "isUpperString")
        
        userDefaults.set(isPriority1Switch.isOn, forKey: "isPriority1")
        userDefaults.set(isPriority2Switch.isOn, forKey: "isPriority2")
        userDefaults.set(isPriority3Switch.isOn, forKey: "isPriority3")
        
        userDefaults.set(intervalSwitch.isOn, forKey: "isInterval")
        userDefaults.set(dayInt!, forKey: "dayInterval")
        userDefaults.set(hourInt!, forKey: "hourInterval")
        userDefaults.set(minuteInt!, forKey: "minuteInterval")
        
        userDefaults.set(fileJsonLabel.text!, forKey: "fileBackup")
        userDefaults.set(countFileBackupTextField.text!, forKey: "countFileBackup") as? Int ?? 10
        userDefaults.set(isAutoSaveSwitch.isOn, forKey: "autoSaveCloseForm") as? Bool ?? true
        userDefaults.set(timerSaveTextField.text!, forKey: "timerSave") as? Double
        
        //        let strTimerArh = timerArhTextField.text!
        //        let intStrTimerArh = NumberFormatter().number(from: strTimerArh)
        //        let timerArhSecond: Int = intStrTimerArh as! Int * 3600
        //        let strTimerArhSecond = String(timerArhSecond)
        //        userDefaults.set(strTimerArhSecond, forKey: "timerArhSecond")
        //
        userDefaults.set(isArhInitAppSwitch.isOn, forKey: "isArhInitApp")// as? Bool
        
        //        }
        
        
        // close Keyboard
        pinKodTextField.resignFirstResponder()
        
        //        Functions.timerArh()
        //        Files.filesCountArh()
        
    }
    
    func LoadSettings() {
        pinKodTextField.text    = userDefaults.object(forKey: "pinKod") as? String
        isLoginSwitch.setOn(userDefaults.object(forKey: "isLogin") as? Bool ?? false, animated: true)
        eMailTextField.text    = userDefaults.object(forKey: "eMail") as? String
        
        isUpperStringSwitch.setOn(userDefaults.object(forKey: "isUpperString") as? Bool ?? true, animated: true)
        
        isPriority1Switch.setOn(userDefaults.object(forKey: "isPriority1") as? Bool ?? false, animated: true)
        isPriority2Switch.setOn(userDefaults.object(forKey: "isPriority2") as? Bool ?? false, animated: true)
        isPriority3Switch.setOn(userDefaults.object(forKey: "isPriority3") as? Bool ?? false, animated: true)
        
        heigthCellTextField.text = userDefaults.object(forKey: "heigthCell") as? String
        heigthCellTextField.text = userDefaults.object(forKey: "isAutoHeigthCell") as? String
        fontHeadingTextField.text = userDefaults.object(forKey: "fontHeading") as? String
        fontNameTextField.text  = userDefaults.object(forKey: "fontName") as? String
        
        intervalSwitch.setOn(userDefaults.object(forKey: "isInterval") as? Bool ?? false, animated: true)
        //        loginIFNS  = userDefaults.object(forKey: "loginIFNS") as? String ?? ""
        //        passwIFNS  = userDefaults.object(forKey: "passwIFNS") as? String ?? ""
        
        dayInt  = userDefaults.object(forKey: "dayInterval") as? Int ?? 0
        hourInt  = userDefaults.object(forKey: "hourInterval") as? Int ?? 0
        minuteInt  = userDefaults.object(forKey: "minuteInterval") as? Int ?? 0
        dateIntervalLabel.text = String(dayInt) + "    " + String(hourInt) + "    " + String(minuteInt)
        
        isAutoSaveSwitch.setOn(userDefaults.object(forKey: "autoSaveCloseForm") as? Bool ?? true, animated: true)
        
        timerSaveTextField.text    = userDefaults.object(forKey: "timerSave") as? String ?? "10.0"
        //        let strTimerArh = userDefaults.object(forKey: "timerArhSecond") as? String ?? "43200"
        //        let intStrTimerArh = NumberFormatter().number(from: strTimerArh)
        //        let timerArhHour: Int = intStrTimerArh as! Int / 3600
        //        let strTimerArhHour = String(timerArhHour)
        //        timerArhTextField.text = strTimerArhHour
        
        isArhInitAppSwitch.setOn(userDefaults.object(forKey: "isArhInitApp") as? Bool ?? false, animated: true)
        
        countFileBackupTextField.text = userDefaults.object(forKey: "countFileBackup") as? String ?? "10"
        
        if heigthCellTextField.text == "" {
            heigthCellTextField.text = "45"
        }
        if fontHeadingTextField.text == "" {
            fontHeadingTextField.text = "10"
        }
        if fontNameTextField.text == "" {
            fontNameTextField.text = "8"
        }
        
        let filter = userDefaults.object(forKey: "idList") as? String ?? ""
        idList = filter
        let listArray = ListTasksData.dataLoad(strPredicate: "id = %@", filter: filter)
        if listArray.count == 1 {
            listNameLabel.text = listArray[0].name
        }
        fileJsonLabel.text  = userDefaults.object(forKey: "fileBackup") as? String ?? ""
        
        if !existingFile(miniFileName: fileJsonLabel.text!) {
            fileJsonLabel.text = "<не выбран>"
        }
        
        CategoryData.categoryDefault()
        
        
    }
    
    
    func openPickerSnipViewController() {
        
        let initialController = self.storyboard?.instantiateViewController(withIdentifier:
                                                                            "pickerSnipViewController") as? PickerSnipViewController
        
        //        let listArray = ListTasksData.dataLoad(strPredicate: "", filter: "")
        //        currArrayValue = "name"
        //
        //        modelController.dataExport.arrayValue.removeAll()
        //        modelController.dataExport.arrayObjects = listArray
        //        modelController.dataExport.arrayValue.append(currArrayValue as Any)
        //
        //        initialController!.modelController = modelController
        //initialController!.delegateViewController = self
        
        let child = initialController
        //let child = PresentTableViewController()
        //child!.transitioningDelegate = transition
        child!.modalPresentationStyle = .custom
        
        present(child!, animated: true)
    }
    
    //    func openSynhronTableViewController() {
    //
    ////        synchGoogle()
    ////
    ////        return
    //
    //
    //        let initialController = self.storyboard?.instantiateViewController(withIdentifier:
    //            "synhronViewController") as? SynhronViewController
    //
    ////        let listArray = ListTasksData.dataLoad(strPredicate: "", filter: "")
    ////        currArrayValue = "name"
    ////
    ////        modelController.dataExport.arrayValue.removeAll()
    ////        modelController.dataExport.arrayObjects = listArray
    ////        modelController.dataExport.arrayValue.append(currArrayValue as Any)
    ////
    ////        initialController!.modelController = modelController
    //         //initialController!.delegateViewController = self
    //
    //        let child = initialController
    //        //let child = PresentTableViewController()
    //        //child!.transitioningDelegate = transition
    //        child!.modalPresentationStyle = .automatic
    //
    //        present(child!, animated: true)
    //    }
    //
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        if let indexPath = self.tableView.indexPathForRow(at: sender.location(in: self.tableView)) {
            openViewControllerDidselect(indexPath: indexPath)
        }
        
        tableView.endEditing(true)
    }
    
    @objc func tappedJsonFiles() {
        //let path = Files.mFolderURL()
        
        jsonFiles = Files.filesJson()
        
        let title = "Выбор файла"
        let message = "\n\n\n\n\n\n\n\n\n\n";
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let pickerFrame: CGRect = CGRect(x: 0, y: 52, width: 355, height: 100); //270
        let pickerFiles: UIPickerView = UIPickerView(frame: pickerFrame);
        
        pickerFiles.delegate = self
        pickerFiles.dataSource = self
        pickerFiles.backgroundColor = UIColor.white
        pickerFiles.tag = 1
        //myPickerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        //        myPickerView.layer.borderWidth = 0.3
        //        myPickerView.layer.borderColor = UIColor.black.cgColor
        //
        alertView.view.addSubview(pickerFiles)
        
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            //fileJsonLabel.text = jsonFiles[pickerView.selectedRow(inComponent: 0)]
            //pickerFiles.selectRow(inPickerViewAction.index(of: temp?[0] as! String)!, inComponent: 0, animated: true)
            //pickerFiles.selectedRow(inComponent: 0);)
            //pickerFiles[pickerView.selectedRowInComponent(0)]
            //pickerFiles.selectRow(1, inComponent: 0, animated: true)
            self.view.endEditing(true)
        })
        
        alertView.addAction(action)
        present(alertView, animated: true, completion: nil)
    }
    
    
    
    func openViewControllerDidselect(indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                openModalViewController()
            }
        }
        if indexPath.section == 3{
            if indexPath.row == 0 {
                openPickerSnipViewController()
            }
        }
        //        if indexPath.section == 5 {
        //            if indexPath.row == 0 {
        //                openAppPurchaseTableViewController()
        //            }
        //        }
        
        //        if indexPath.section == 5{
        //            if indexPath.row == 0 {
        //                tappedJsonFiles()
        //            }
        //        }
        
    }
    
//    func initialSign(selfVC: UIViewController) {
//        googleSignButton.clipsToBounds = true  //
//        // 1
//        let clientID = UserDefaults.standard.object(forKey: "clientID") as! String
//        GIDSignIn.sharedInstance().clientID = clientID
//        // 2
//        //GIDSignIn.sharedInstance().delegate = selfVC
//        // 3
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
//        GIDSignIn.sharedInstance()?.presentingViewController = selfVC
//    }
    
    func updateScreenSign() {
        var titleLabel = "Нет синхронизации...🙂"
        var titleButton = "Войти в аккаунт"
        SinhchronButton.isHidden = true
        if let user = GIDSignIn.sharedInstance()?.currentUser {
            // User signed in
            
            // Show greeting message
            titleLabel = "Синхронизация с аккаунтом: \(user.profile.email!)!✌️"
            titleButton = "Выйти из аккаунта"
            SinhchronButton.isHidden = false
        }
        googleSignStatus.text = titleLabel
        googleSignButton.setTitle(titleButton, for: .normal)
        
        //let section = IndexSet(integer: 6)
        //tableView.reloadSections(section, with: .automatic)
    }
    
    func isDisableAppPRO() {
        let isButton = PublicVars().appPro
        googleSignButton.isEnabled = isButton
        SinhchronButton.isEnabled = isButton
        fileJsonLabel.isEnabled = isButton
        restoreFileButton.isEnabled = isButton
        arhFileButton.isEnabled = isButton
        googleSignStatus.isEnabled = isButton
        
    }
    
    func restorebackupFileButtonClick() {
        
        //selfVC: UIViewController
        let alertPrompt = UIAlertController(title: "Восстановить из архива", message: "", preferredStyle: .actionSheet)
        
        let actionDelete = UIAlertAction(title: "Очистить список и загрузить", style: UIAlertAction.Style.default, handler: { [self] (action) -> Void in
            ListTasksData.deleteListsAll()
            restorebackupFile()
            
        })
        
        let actionNoDelete = UIAlertAction(title: "Обновить и загрузить новые", style: UIAlertAction.Style.default, handler: { [self] (action) -> Void in
            restorebackupFile()
            
        })
        
        let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertPrompt.addAction(actionDelete)
        alertPrompt.addAction(actionNoDelete)
        alertPrompt.addAction(cancelAction)
        
        self.present(alertPrompt, animated: true, completion: nil)
    }
    
    func restorebackupFile() {
        
        //        if !existingFile(fileName: fileJsonLabel.text!) {
        //            fileJsonLabel.text = "<не выбран>"
        //            Functions.alertShort(selfVC: self, title: "Внимание", message: "Не найден файл \(String(describing: fileJsonLabel.text!))")
        //            return
        //        }
        //
        //        jsonInData(fileName: fileJsonLabel.text!)
        
        //let url = Files.mFolderURL()
        jsonInDataFromDefaultFile(selfVC: self)
    }
    
    
    // MARK: - func sign
    
//    func googleSign(selfVC: UIViewController, taskListID: String) -> Bool {
//        if let user = GIDSignIn.sharedInstance()?.currentUser {
//            GIDSignIn.sharedInstance().delegate=self
//            GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/tasks")
//            GIDSignIn.sharedInstance().signIn()
//            
//        } else {
//            return false
//        }
//        updateScreenSign()
//        return true
//    }
    
    
//    func googleSynchron() -> Bool {
//
//        if let user = GIDSignIn.sharedInstance()?.currentUser {
//
//            GoogleAPIClientForREST(selfVC: self)
//
//            return false
//        }
//        return false
//    }
    
//    func GoogleAPIClientForREST() {
//        
//        var accessToken: String?
//        
//        GIDSignIn.sharedInstance().currentUser.authentication.getTokensWithHandler { (authentication, error) in
//            
//            if let err = error {
//                print(err)
//            } else {
//                if let auth = authentication {
//                    accessToken = auth.accessToken
//                    //accessToken = auth.refreshToken
//                }
//            }
//        }
//        
//        if let accTok = accessToken {
//            
//            requestSession(accTok: accTok)
//            //requestAF(accTok: accTok)
//            
//        }
//    }
//    
//    func requestSession(accTok: String, IdList: String = "") {
//
//        //let url = NSURL(string: "https://tasks.googleapis.com/tasks/v1/users/@me/lists?key=[YOUR_API_KEY]")
//        
//        let tasklist = ""
//        var url = NSURL(string: "https://tasks.googleapis.com/tasks/v1/lists/{tasklist}/tasks")
//        if IdList == "" {
//            url = NSURL(string: "https://tasks.googleapis.com/tasks/v1/users/@me/lists")
//        }
//        
//        let session = URLSession.shared
//        let request = NSMutableURLRequest(url: url! as URL)
//        request.httpMethod = "GET" //set http method
//        
//        request.addValue("Bearer \(accTok)", forHTTPHeaderField: "Authorization")
//        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        
//        /*
//         let scopes: [String] = [
//         "https://www.googleapis.com/auth/tasks",
//         "https://www.googleapis.com/auth/tasks.readonly"]
//         request.addValue(scopes, forHTTPHeaderField: "scopes")
//         */
//        
//        //var json: [String: AnyObject] = [:]
//        
//        let task = session.dataTask(with: request as URLRequest, completionHandler: { [self] data, response, error in
//            do {
//                //if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: AnyObject] {
//                if let jsonSession = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
//                    //print(jsonSession)
//                    let json = try JSON(data: data!)
//                    parseJson(json: json)
//                    //                    if let names = jsonSession["etag"] {
//                    //                        print(names)
//                    //                    }
//                    //                    for json in jsonSession {
//                    //
//                    //                    }
//                }
//                
//            } catch let error {
//                print(error.localizedDescription)
//                //return ""
//            }
//            
//        })
//        
//        task.resume()
//        //}
//        //return json
//    }
    
//    func requestAF(accTok: String) {
//        // AF!!!
//
//        let apiKey = "AIzaSyDzIHRlMCv8RA97536YO_PhhjAsrm27HCs"
//        //        let kKeychainItemName = "Tasks API"
//        //        let kClientID = "556209321860-fq3nq9hpvklg2848pp67rvdt7e9b30vb.apps.googleusercontent.com"
//        //
//        //        let scopes = [kGTLRServiceErrorDomain]
//        //        let service = GTLRTasksService()
//
//        let YOUR_API_KEY = apiKey
//        //            curl \
//        //              'https://tasks.googleapis.com/tasks/v1/users/@me/lists?key=[YOUR_API_KEY]' \
//        //              --header 'Authorization: Bearer [YOUR_ACCESS_TOKEN]' \
//        //              --header 'Accept: application/json' \
//        //              --compressed
//
//        //let urlString = "https://tasks.googleapis.com/tasks/v1/users/@me/lists?key=[YOUR_API_KEY]"
//        let urlString = "https://tasks.googleapis.com/tasks/v1/users/@me/lists"
//        //let url = NSURL(string: urlString)
//        let url = URL(string: urlString)
//        var parameters:[String: Any] = [:]
//        parameters["pageToken"] = accTok
//        parameters["maxResults"] = 100
//        let scopes: [String] = [
//            "https://www.googleapis.com/auth/tasks",
//            "https://www.googleapis.com/auth/tasks.readonly"
//        ]
//        //       parameters["scope"] = scopes
//
//        //        parameters["scope"] = "https://www.googleapis.com/auth/tasks"
//        //        parameters["redirect_uri"] = "urn:ietf:wg:oauth:2.0"
//        //        parameters["client_id"] = "556209321860-fq3nq9hpvklg2848pp67rvdt7e9b30vb.apps.googleusercontent.com"
//
//        AF.request(url!, method: .get, parameters: parameters).validate().responseJSON {
//            //            afManager.request(url as! URLConvertible, method: .get).validate().responseJSON {
//
//            response in
//            switch (response.result) {
//            case .success:
//                print("data - > \n    \(response.data?.debugDescription) \n")
//                print("response - >\n    \(response.response?.debugDescription) \n")
//                var statusCode = 0
//                if let unwrappedResponse = response.response {
//                    let statusCode = unwrappedResponse.statusCode
//                }
//                //self.completionBlock(statusCode, nil)
//                //return true
//                break
//            case .failure(let error):
//                print("error - > \n    \(error.localizedDescription) \n")
//                let statusCode = response.response?.statusCode
//                //self.completionBlock?(statusCode, error)
//                //return false
//                break
//            }
//        }
//
//    }
    
//    func parseJsonGoogle(json: JSON) {
//        parseJson(json: json)
//    }
    
    
} // class


// MARK:- PickerView Delegate & DataSource

extension SettingsTableViewController: UIPickerViewDelegate
                                       , UIPickerViewDataSource
{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            if component == 0 {
                return String(arrayDay[row])
            }
            if component == 1 {
                return String(arrayHour[row])
            }
            if component == 2 {
                return String(arrayMinute[row])
            }
        }
        if pickerView.tag == 1 {
            return jsonFiles[row]
        }
        
        return " "
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            dayInt = arrayDay[pickerView.selectedRow(inComponent: 0)]
            hourInt = arrayHour[pickerView.selectedRow(inComponent: 1)]
            minuteInt = arrayMinute[pickerView.selectedRow(inComponent: 2)]
            
            dateIntervalLabel.text = ""
            dateIntervalLabel.text = String(dayInt)
            dateIntervalLabel.text = dateIntervalLabel.text! + "   " + String(hourInt)
            dateIntervalLabel.text = dateIntervalLabel.text! + "   " + String(minuteInt)
            tableView.reloadData()
        }
        if pickerView.tag == 1 {
            fileJsonLabel.text = jsonFiles[pickerView.selectedRow(inComponent: 0)]
            //fileJsonLabel.text = fileJsonLabel.text! + ".zip"
            userDefaults.set(fileJsonLabel.text!, forKey: "fileBackup")
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            switch component {
            case 0:
                return arrayDay.count
            case 1:
                return arrayHour.count
            case 2:
                return arrayMinute.count
                
            default:
                return 1
            }
        }
        
        if pickerView.tag == 1 {
            return jsonFiles.count
        }
        
        return 0
    }
    //    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    //        <#code#>
    //    }
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0 {
            return 3
        }
        if pickerView.tag == 1 {
            return 1
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if pickerView.tag == 0 {
            switch (component){
            case 0:
                return 40.0
            case 1:
                return 40.0
            case 2:
                return 40.0
                
            default:
                return 22
            }
        }
        if pickerView.tag == 1 {
            return 260.0
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        if pickerView.tag == 0 {
            return 30
        }
        if pickerView.tag == 1 {
            return 20
        }
        
        return 0
    }
    
    //    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    //
    //        var label = view as! UILabel?
    //        if label == nil {
    //            label = UILabel()
    //            //label?.textColor = UIColor.red
    //        }
    //        if pickerView.tag == 1 {
    //            switch component {
    //            case 0:
    //
    //                label?.text = jsonFiles[row]
    //                label?.font = UIFont(name:"Raleway", size:11)
    //                return label!
    //            default:
    //                return label!
    //            }
    //        }
    //        return label!
    //
    //    }
    
    
    // MARK: - picker view interval
    
    
    @objc func pickerInterval(){
        //        proba()
        //        return
        
        let title = "Выбор интервала"
        let message = "\n\n\n\n\n\n\n\n\n\n";
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let pickerFrame: CGRect = CGRect(x: 0, y: 52, width: 270, height: 100); //
        let myPickerView: UIPickerView = UIPickerView(frame: pickerFrame);
        
        myPickerView.delegate = self
        myPickerView.dataSource = self
        myPickerView.backgroundColor = UIColor.white
        myPickerView.tag = 0
        //myPickerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        //        myPickerView.layer.borderWidth = 0.3
        //        myPickerView.layer.borderColor = UIColor.black.cgColor
        //
        alertView.view.addSubview(myPickerView)
        
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            
            self.view.endEditing(true)
        })
        
        alertView.addAction(action)
        present(alertView, animated: true, completion: nil)
        //            {
        //            myPickerView.frame.size.width = alertView.view.frame.size.width
        //        })
        
        
    }
    
    
    @objc func doneClick(){
        self.view.endEditing(true)
        
    }
    @objc func cancelClick(){
        self.view.endEditing(true)
    }
    
    
    //MARK:- TextFiled Delegate
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        self.pickUp(txt_pickUpData)
    //    }
} // extension

extension SettingsTableViewController {
    
    /*
     // MARK: halfModalTransitioningDelegate
     в этом модуле:
     var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
     var modelController: ModelController! = ModelController()
     
     в вызываемом:
     class PickerViewController:  UITableViewController, HalfModalPresentable
     */
    
    // при инициализации вначале
    //var pickerDelegate = PickerProtocol.self
    
    //    func openModalViewController(strViewController: String) {
    //        let initialController = self.storyboard?.instantiateViewController(withIdentifier: "appNavController") as? AppNavController
    //
    //        let listArray = ListTasksData.dataLoad(strPredicate: "", filter: "")
    //        currArrayValue = "name"
    //
    //        modelController.dataExport.arrayObjects = listArray
    //        modelController.dataExport.arrayValue.append(currArrayValue as Any)
    //
    //        initialController!.modelController = modelController
    //        initialController!.delegateViewController = self
    //
    //        self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: initialController!)
    //
    //        initialController!.modalPresentationStyle = .custom
    //        initialController!.transitioningDelegate = self.halfModalTransitioningDelegate
    //        self.present(initialController!, animated: true, completion: nil)
    //
    //    }
    
    func openModalViewController() {
        
        let initialController = self.storyboard?.instantiateViewController(withIdentifier:
                                                                            "pickerViewController") as? PickerViewController
        
        let listArray = ListTasksData.dataLoad(strPredicate: "", filter: "")
        currArrayValue = "name"
        
        modelController.dataExport.arrayValue.removeAll()
        modelController.dataExport.arrayObjects = listArray
        modelController.dataExport.arrayValue.append(currArrayValue as Any)
        
        initialController!.modelController = modelController
        initialController!.delegateViewController = self
        
        let child = initialController
        //let child = PresentTableViewController()
        //child!.transitioningDelegate = transition
        child!.modalPresentationStyle = .custom
        
        present(child!, animated: true)
    }
    
    //    func openAppPurchaseTableViewController() {
    //        let initialController = self.storyboard?.instantiateViewController(withIdentifier:
    //            "appPurchaseTableViewController") as? AppPurchaseTableViewController
    //
    ////        let listArray = ListTasksData.dataLoad(strPredicate: "", filter: "")
    ////        currArrayValue = "name"
    ////
    ////        modelController.dataExport.arrayValue.removeAll()
    ////        modelController.dataExport.arrayObjects = listArray
    ////        modelController.dataExport.arrayValue.append(currArrayValue as Any)
    ////
    ////        initialController!.modelController = modelController
    ////        initialController!.delegateViewController = self
    //
    // //       initialController!.modalPresentationStyle = .custom
    //
    //        present(initialController!, animated: true)
    //    }
    
    
    //    func openSetting2TableViewController() {
    //
    //        let initialController = self.storyboard?.instantiateViewController(withIdentifier:
    //            "setting2TableViewController") as? Setting2TableViewController
    //
    ////        let listArray = ListTasksData.dataLoad(strPredicate: "", filter: "")
    ////        currArrayValue = "name"
    ////        var settings: [String] = []
    ////        settings.append(loginIFNS)
    ////        settings.append(passwIFNS)
    ////        modelController.dataExport.arrayValue.removeAll()
    ////        modelController.dataExport.arrayObjects = settings
    ////        //modelController.dataExport.arrayValue.append(currArrayValue as Any)
    //
    ////        initialController!.modelController = modelController
    //        initialController!.delegateViewController = self
    //
    //        let child = initialController
    //        //let child = PresentTableViewController()
    //        //child!.transitioningDelegate = transition
    //        //child!.modalPresentationStyle = .custom
    //
    //        present(child!, animated: true)
    //    }
    
    func currencySelected(currentObject: Any) {
        if currentObject is ListTasks {
            listNameLabel.text = (currentObject as AnyObject).name
            idList = (currentObject as AnyObject).id
        } else {
            listNameLabel.text = ""
            idList = ""
            
        }
    }
    
    
}


// MARK: - GIDSignIn
extension SettingsTableViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            //            // Perform any operations on signed in user here.
            //            let userId = user.userID                  // For client-side use only!
            //            let idToken = user.authentication.idToken // Safe to send to the server
            //            let fullName = user.profile.name
            //            let givenName = user.profile.givenName
            //            let familyName = user.profile.familyName
            //            let email = user.profile.email
            
            //            // ...
        } else {
            print("\(error.localizedDescription)")
        }
        updateScreenSign()
    }
}

//extension Notification.Name {
//
//    /// Notification when user successfully sign in using Google
//    static var signInGoogleCompleted: Notification.Name {
//        return .init(rawValue: #function)
//    }
//}

struct TaskListsJson: Decodable {
    let id: String
}

struct ListsJson: Decodable {
    let kind: String
    let  etag: String
    let nextPageToken: String
    let items: [TaskListsJson]
    
}
