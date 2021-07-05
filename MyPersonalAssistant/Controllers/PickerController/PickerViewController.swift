//
//  pickerViewController.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 25.04.2020.
//  Copyright © 2020 Test. All rights reserved.
//

protocol CurrencySelectedDelegate {
    func currencySelected(currentObject: Any)
    //func currencySelectedObjects(arrayObjectsDelegate: Any)
}

import UIKit
import CoreData


class PickerViewController:  UIViewController,
    UITableViewDelegate, UITableViewDataSource,
    UITextFieldDelegate
    //, UNUserNotificationCenterDelegate,
    //HalfModalPresentable
{
    
    var arrayObjects: [Any]?
    var currentObject: Any?
    var currArrayValue: String?
    var entityName: String?
    
    var selectedIndexPath = NSIndexPath()
    
    var modelController: ModelController?
    var delegateViewController:  CurrencySelectedDelegate?
    let appDelegate =
    UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var pickerViewController: UITableView!
    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        cancelTapped()
    }
    @IBAction func clearButton(_ sender: UIBarButtonItem) {
        currentObject = (Any).self
        delegateViewController?.currencySelected(currentObject: currentObject as Any)
        cancelTapped()
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        selectedCell()
        //delegateViewController?.currencySelected(currentObject: currentObject as Any)
        //delegateViewController?.currencySelectedObjects(arrayObjectsDelegate: arrayObjects as Any)
        saveObjects()
    }
    
    @IBAction func addObject(_ sender: UIBarButtonItem) {
        addObject()
    }
    
    @IBAction func saveButtonItem(_ sender: UIBarButtonItem) {
        saveObjects()

    }
    
    
//    @IBAction func editButtonItem(_ sender: UIBarButtonItem) {
//            pickerViewController.isEditing = !pickerViewController.isEditing
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerViewController.delegate = self
        pickerViewController.dataSource = self
        
        let dataExport = modelController?.dataExport
        arrayObjects = dataExport?.arrayObjects
        if let currentValue = modelController?.dataExport.arrayValue[0] {
            currArrayValue = (currentValue as! String)
        }
        if (modelController?.dataExport.arrayValue.count)! > 1 {
            if let currententityName = modelController?.dataExport.arrayValue[1] {
                entityName = (currententityName as! String)
            }
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        if entityName == nil {
            self.addButtonItem.isEnabled = false
            self.addButtonItem.title = ""
        }
    }

    // MARK: delegate
    // tableViewController
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayObjects!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if arrayObjects != nil && arrayObjects!.count != 0{
            cell.textLabel?.text = (arrayObjects![indexPath.row] as AnyObject).value(forKey: currArrayValue!)
                as? String
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        selectedIndexPath = indexPath as NSIndexPath
//        var currcheckMark = 0
//        if cell.accessoryType == .none {
//            cell.accessoryType = .checkmark
//            currcheckMark = 1
//        } else {
//            cell.accessoryType = .none
//        }
//        if entityName == "Nomenklature" {
//            let currentObject = self.arrayObjects![indexPath.row]
//            (currentObject as AnyObject).setValue(checkMark, forKey: "checkmark")
//        }
        //updateCell(cell: cell , indexPath: indexPath)
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//    {
//        return nil
//    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        //
        let context = self.appDelegate.persistentContainer.viewContext
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, handler) in
            
            context.delete(self.arrayObjects![indexPath.row] as! NSManagedObject)
            self.arrayObjects!.remove(at: indexPath.row)
            self.pickerViewController.deleteRows(at: [indexPath], with: .fade)
        }
        deleteAction.backgroundColor = .red
        //
        let editAction = UIContextualAction(style: .destructive, title: "Правка") { (action, view, handler) in
            
            let currentObjectSelected = self.arrayObjects?[indexPath.row] as AnyObject
            let namecurrentObjectSelected = currentObjectSelected.value(forKey: self.currArrayValue!)
            
            let alert = UIAlertController(title: "Изменить", message: "", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
                textField.text = (namecurrentObjectSelected as! String)
            })
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (action) -> Void in
                //let textField = alert.textFields![0] as UITextField
                currentObjectSelected.setValue(alert?.textFields![0].text, forKey: "name")
                self.pickerViewController.reloadRows(at: [indexPath], with: .automatic)
            }))
            alert.addAction(UIAlertAction(title: "Отказ", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        editAction.backgroundColor = .green
        ////
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let editAction = UITableViewRowAction(style: .default, title: "Правка", handler: { (action, indexPath) in
//            let alert = UIAlertController(title: "", message: "Изменить", preferredStyle: .alert)
//            let currentObjectSelected = self.arrayObjects?[indexPath.row] as AnyObject
//            var namecurrentObjectSelected = currentObjectSelected.value(forKey: self.currArrayValue!)
//
//            alert.addTextField(configurationHandler: { (textField) in
//                textField.text = namecurrentObjectSelected as! String
//            })
//            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
//                namecurrentObjectSelected = alert.textFields!.first!.text!
//                //pickerViewController.reloadRows(at: [indexPath], with: .alert)
//                self.pickerViewController.reloadRows(at: [indexPath], with: .none)
//            }))
//            alert.addAction(UIAlertAction(title: "Отказ", style: .cancel, handler: nil))
//            self.present(alert, animated: false)
//        })
//
//        let deleteAction = UITableViewRowAction(style: .default, title: "Удалить", handler: { (action, indexPath) in
//            self.arrayObjects!.remove(at: indexPath.row)
//            tableView.reloadData()
//        })
//
//        return [deleteAction, editAction]
//    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isUpperString = Functions.isUpperString()
        if isUpperString == true {
            textField.text = textField.text!.capitalizingFirstLetter()
        }
    }
    // MARK: - func
    
    func selectedCell(){
//        if selectedIndexPath == nil {
//            return
//        }
        currentObject = arrayObjects?[selectedIndexPath.row]
        delegateViewController?.currencySelected(currentObject: currentObject as Any)
        cancelTapped()
    }
    
    func cancelTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func addObject() {
        if entityName == nil {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let newTask = NSEntityDescription.insertNewObject(forEntityName: entityName!, into: context)
        var arrayObjects2 = arrayObjects!
        arrayObjects2.append(newTask)// as? Tasks)
        let newId = UUID().uuidString
        let newObject = arrayObjects2[arrayObjects2.count-1] as Any
        //        if newObject != nil || newObject != nil {
        (newObject as AnyObject).setValue(newId, forKey: "id")
        (newObject as AnyObject).setValue("Новый " + String(arrayObjects2.count) , forKey: currArrayValue!)
        //        }
        arrayObjects = arrayObjects2
        
        self.pickerViewController.beginUpdates()
        let indexPath = IndexPath(row: arrayObjects2.count-1, section: 0)
        
        pickerViewController.insertRows(at: [indexPath], with: .none)
        self.pickerViewController.endUpdates()
        
        saveObjects()
    }
    
    func saveObjects(){
        if entityName == nil {
            return
        }
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //if context.hasChanges {
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        //appDelegate.saveContext()
    }
    
//    func updateCell(cell: UITableViewCell, indexPath: IndexPath) {
//
//
//    }
    
    
} // class
