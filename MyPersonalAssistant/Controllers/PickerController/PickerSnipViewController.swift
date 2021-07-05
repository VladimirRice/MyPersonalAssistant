//
//  PickerSnipViewController.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 25.04.2020.
//  Copyright © 2020 Test. All rights reserved.
//

protocol CurrencySnipSelectedDelegate {
    func currencySnipSelected(arrayObjectsMark: [Nomenklature])
    //func currencySelectedObjects(arrayObjectsDelegate: Any)
}

import UIKit
import CoreData


class PickerSnipViewController:  UIViewController,
    UITableViewDelegate, UITableViewDataSource,
    UITextFieldDelegate,
    NSFetchedResultsControllerDelegate
    , SnipCellDelegate
    , UISearchResultsUpdating
    
    //, UNUserNotificationCenterDelegate,
    //HalfModalPresentable
{
    

    var arrayObjects: [Nomenklature]?
    var selectedObject: Any?
    var statusController = ""
    var cellSelectedRow: Int?
    //
    var searchedValue = [Nomenklature]()
    var searching = false
    var roundButton = UIButton()
    //var roundButton2 = UIButton()
    //var selectedIndexPath = NSIndexPath()
    
    var modelController: ModelController?
    var delegateViewController:  CurrencySnipSelectedDelegate?
    
    
    let appDelegate =
    UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var addButtonItem: UIBarButtonItem!
    @IBOutlet weak var sortSegmentController: UISegmentedControl!
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    @IBOutlet weak var seachBar: UISearchBar!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addObjectSeach: UIBarButtonItem!
    @IBOutlet weak var imageSnipImageView: UIImageView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //delegate = self
        loadData()
        
        let selectedIsSortSnipSegmentController = UserDefaults.standard.object(forKey: "selectedIsSortSnipSegmentController") as? Int ?? 0
        sortSegmentController.selectedSegmentIndex = selectedIsSortSnipSegmentController

        if statusController != "Enter" {
            doneButtonItem.isEnabled = false
            doneButtonItem.title = ""
        }
        seachBar.delegate = self
        editButton.isEnabled = false
        addObjectSeach.isEnabled = false
        
        self.roundButton = UIButton(type: .custom)
        self.roundButton.setTitleColor(UIColor.orange, for: .normal)
        self.roundButton.addTarget(self, action: #selector(ButtonClick(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(roundButton)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        sortDate(index: sortSegmentController.selectedSegmentIndex)
    }
    
    override func viewWillLayoutSubviews() {
        Functions.floatButton(selfVC: self, roundButton: roundButton, bottom: -153)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: delegate
    // tableViewController
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return arrayObjects!.count
        addObjectSeach.isEnabled = searching
        if searching {
            return searchedValue.count
        } else {
            return arrayObjects!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellNomenklature", for: indexPath) as! SnipTableViewCell
        
        cell.delegate = self
        
        if arrayObjects == nil && arrayObjects!.count == 0{
            return cell
        }
        
        let currentObjectCell = arrayObjects![indexPath.row]
        cell.nametLabel?.text =  currentObjectCell.name
        var strPriority = currentObjectCell.priority!.toString()
        //var strPriority = String(currentObjectCell.priority)
        if strPriority == "0" {
            strPriority = ""
        }
        
        setupCellSnip(cell: cell, currentObject: currentObjectCell)
        
        cell.IsSelectedButton.addTarget(self, action: #selector(isSelectedButtonClicked(_ :)), for: .touchUpInside)
        
//        cell.IsSelectedButton.imageView!.image = UIImage(named: "checkEmpty")
//        if currentObjectCell.checkmark == true {
//            cell.IsSelectedButton.imageView!.image = UIImage(named: "checkPlus")
//        }
        
            
        if searching {
            cell.nametLabel?.text = searchedValue[indexPath.row].name
        } else {
            cell.nametLabel?.text = arrayObjects![indexPath.row].name
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) != nil else { return }
            let currentObject = self.arrayObjects![indexPath.row]

        cellSelectedRow = indexPath.row
        editButton.isEnabled = true
        imageSnipImageView.image = nil
        if currentObject.image != nil {
            imageSnipImageView.image = UIImage(data: currentObject.image!)
        }
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
            
            context.delete(self.arrayObjects![indexPath.row] as NSManagedObject)
            self.arrayObjects!.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteAction.backgroundColor = .red
        //
        let editAction = UIContextualAction(style: .destructive, title: "Правка") { (action, view, handler) in
            
            self.selectedObject = self.arrayObjects?[indexPath.row] as AnyObject
            self.openSnip(selectedObject: self.selectedObject as! Nomenklature)
            
            self.sortDate(index: self.sortSegmentController.selectedSegmentIndex)
            //tableView.reloadData()
            
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
    
    
    //MARK: delegate textField
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isUpperString = Functions.isUpperString()
        if isUpperString == true {
            textField.text = textField.text!.capitalizingFirstLetter()
        }
    }
    
    //MARK: delegate seach
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text!.isEmpty {
            addObjectSeach.isEnabled = false
        } else {
            addObjectSeach.isEnabled = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // hides the keyboard.
        addObjectSeach.isEnabled = false
        //doThingsForSearching()
    }
    
    // MARK: action
    @IBAction func cancelButtonTapped(sender: AnyObject) {
            cancelTapped()
        }
        @IBAction func doneButton(_ sender: UIBarButtonItem) {
             selectedCell()
        }
//        @IBAction func addObject(_ sender: UIBarButtonItem) {
//            addObjectTable()
//        }
        @IBAction func saveButtonItem(_ sender: UIBarButtonItem) {
            saveObjects()
        }
        @IBAction func sortObjectsSegmentController(_ sender: UISegmentedControl) {
            sortDate(index: sortSegmentController.selectedSegmentIndex)
            UserDefaults.standard.set(sortSegmentController.selectedSegmentIndex, forKey: "selectedIsSortSnipSegmentController")
        }
        @IBAction func addTextSeachButton(_ sender: Any) {
            let varText = seachBar.text
            addObjectTable(partextName: varText)
        }
        @IBAction func editButtonItem(_ sender: UIBarButtonItem) {
         
            if cellSelectedRow == nil {
                return
            }
            self.selectedObject = self.arrayObjects?[cellSelectedRow!] as AnyObject
    //        let selectedObject = arrayObjects?[selectedIndexPath.row]
    //        if selectedObject == nil {
    //            return
    //        }
            self.openSnip(selectedObject: self.selectedObject as! Nomenklature)

            self.sortDate(index: self.sortSegmentController.selectedSegmentIndex)
        }
    
    
    @IBAction func check0Button(_ sender: UIButton) {
        let check = sender.tag
        var currCheck = false
        if check == 1 {
           currCheck = true
        }
        for object1 in arrayObjects! {
            object1.checkmark = currCheck
        }
        tableView.reloadData()
        saveObjects()
    }

    
    // MARK: - func
    
    func loadData(){
        arrayObjects = NomenklatureData.dataLoad(strPredicate: "", filter: "")
    }
    
    func selectedCell(){
        let arrayObjectsMark = arrayObjects!.filter { $0.checkmark == true }// as Nomenklature
        delegateViewController!.currencySnipSelected(arrayObjectsMark: arrayObjectsMark)
        cancelTapped()
    }
    
    func cancelTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func addObjectTable(partextName: String? = nil) {
//        if entityName == nil {
//            return
//        }
        var arrayObjects2 = arrayObjects!
        var textName = partextName
        var fragment = ""
        if partextName == nil {
            textName = "Новый "
            fragment = String(arrayObjects2.count)
        } else {
            if partextName!.isEmpty {
                return
            }
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let newTask = NSEntityDescription.insertNewObject(forEntityName: "Nomenklature", into: context)
        
        arrayObjects2.append(newTask as! Nomenklature)
        let newId = UUID().uuidString
        let newObject = arrayObjects2[arrayObjects2.count-1] as Any
        //        if newObject != nil || newObject != nil {
        (newObject as AnyObject).setValue(newId, forKey: "id")
        (newObject as AnyObject).setValue(textName! + fragment , forKey: "name")
        //        }
        arrayObjects = arrayObjects2
        
        var yourArray = arrayObjects2
        if searching {
            searchedValue.append(newObject as! Nomenklature)
            yourArray = searchedValue
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: [
            (NSIndexPath(row: yourArray.count-1, section: 0) as IndexPath)], with: .automatic)
        tableView.endUpdates()
 
        saveObjects()
    }
    
    func saveObjects(){
//        if entityName == nil {
//            return
//        }
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
    
    func sortDate(index: Int) {
        
        switch index {
        case 0:
            self.arrayObjects = self.arrayObjects!.sorted(by: { (s1: Nomenklature, s2: Nomenklature) -> Bool in return s1.name! < s2.name! } )
        case 1:
            self.arrayObjects = self.arrayObjects!.sorted(by: { (s1: Nomenklature, s2: Nomenklature) -> Bool in return Int(truncating: s1.priority!) > Int(truncating: s2.priority!)
                    //&& s1.name! < s2.name!
                    
                } )
            

        default:
            self.arrayObjects = self.arrayObjects!.sorted(by: { (s1: Nomenklature, s2: Nomenklature) -> Bool in return s1.name! < s2.name! } )

        }
        self.tableView.reloadData()
    }
    
    
    
    func openSnip(selectedObject: Nomenklature) {
        
        let initialController = self.storyboard?.instantiateViewController(withIdentifier:
            "pickerOneViewController") as? PickerOneViewController
        
        initialController!.initialViewController = self
        initialController?.currentObject = selectedObject
        initialController!.modalPresentationStyle = .automatic
        present(initialController!, animated: true)
    }

    // MAKR: SnipCellDelegate
    func stepperButton(sender: SnipTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender){
            let currentObject = arrayObjects![indexPath.row]
            currentObject.quantity = Float(sender.quantityStepper.value)
            
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    @objc func ButtonClick(_ sender: UIButton){
     addObjectTable()
    }
    
    @objc func isSelectedButtonClicked(_ sender: UIButton) {
        
        let indexPath = self.tableView.indexPath(for: sender.superview!.superview as! SnipTableViewCell)
        
        let currentObject = arrayObjects![indexPath!.row]
        //currentObject.checkmark = currentCheckmark
        currentObject.checkmark = !currentObject.checkmark
        
        saveObjects()
        tableView.reloadRows(at: [indexPath!], with: .none)
        //selectedSegment(index: statusTaskSegmentedControl.selectedSegmentIndex)
    }
    
    func setupCellSnip(cell: SnipTableViewCell, currentObject: Nomenklature) {
        
            let currentCheckmark = currentObject.value(forKey: "checkmark") as! Bool
        
        
        var currentColor = UIColor.white
        var label = UILabel()
        label = cell.nametLabel
        let ofSizeFont = "12"//UserDefaults.standard.object(forKey: "fontName") as? String
        let ofSizeFontGFloat = CGFloat((ofSizeFont as NSString).floatValue)
        //
        let nameImage0 = "checkEmpty"
        let nameImage1 = "checkPlus"
        
        if currentCheckmark == true {
            //cell.IsSelectedButton.imageView!.image = UIImage(named: nameImage1)
            cell.IsSelectedButton.setImage(UIImage(named: nameImage1), for: .normal)
            currentColor = UIColor.cyan
            
            let attributes:[NSAttributedString.Key:Any] = [
                .font : UIFont.systemFont(ofSize: ofSizeFontGFloat),
                .backgroundColor : UIColor.cyan,
                //                .strokeWidth : -2,
                //                .strokeColor : UIColor.black,
                //                .foregroundColor : UIColor.red,
                .strikethroughStyle: 0,
            ]
            
            let attributesAttributedString = NSAttributedString(string: label.text!, attributes: attributes)
            label.attributedText = attributesAttributedString
            label.textColor = UIColor.black
            
        } else {
            cell.IsSelectedButton.setImage(UIImage(named: nameImage0), for: .normal)
            currentColor = UIColor.lightGray
            let attributes:[NSAttributedString.Key:Any] = [
                .font : UIFont.italicSystemFont(ofSize: ofSizeFontGFloat),
                .backgroundColor: UIColor.lightGray.withAlphaComponent(0.5),
                //                .strokeWidth : -2,
                //                .strokeColor : UIColor.black,
                //                .foregroundColor : UIColor.red,
                .strikethroughStyle: 1,
            ]
            
            let attributesAttributedString = NSAttributedString(string: label.text!, attributes: attributes)
            label.attributedText = attributesAttributedString
            label.textColor = UIColor.gray
        }
        
        cell.contentView.backgroundColor = currentColor
            
        cell.quantityStepper.value = Double(currentObject.quantity)
        
        var quantity = String(currentObject.quantity)
        if quantity == "0.0" {
            quantity = ""
        }
        cell.quantityLabel.text = quantity
        
        let priority = currentObject.priority
        var priorityString: String
        switch priority {
        case 0:
            priorityString = ""
        case 1:
            priorityString = "!"
        case 2:
            priorityString = "!!"
        case 3:
            priorityString = "!!!"
            
        default:
            priorityString = ""
        }
        cell.priorityTextLabel!.text = priorityString
    }
    
    
} // class

// MARK: extension PickerSnipViewController

extension PickerSnipViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedValue = arrayObjects?.filter({$0.name!.lowercased().prefix(searchText.count) == searchText.lowercased()}) as! [Nomenklature]
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
}


extension NSNumber {
    func toString() -> String {
        return NumberFormatter().string(from: self) ?? ""
    }
}
