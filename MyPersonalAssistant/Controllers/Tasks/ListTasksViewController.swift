//
//  ListtasksViewController.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 07.03.2020.
//  Copyright © 2020 Vladimir Rice. All rights reserved.
//

import UIKit
import CoreData

class ListTasksViewController: UIViewController, UITextFieldDelegate {

    var currentObject: ListTasks?
    var arrayObjects: [ListTasks?] = []
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    var refreshControl = UIRefreshControl()
    var roundButton = UIButton()
    
    
    
    @IBOutlet weak var listTasksViewController: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //updateArray()
        
        //self.navigationController?.toolbar.isHidden = true
        
        listTasksViewController.dataSource = self
        listTasksViewController.delegate = self
//        // refreshControl
//        refreshControl.addTarget(self, action: #selector(jsonInData), for: .valueChanged)
//        //refreshControl.tintColor = .blue
//        listTasksViewController.refreshControl = refreshControl
        
        self.navigationController?.navigationItem.backBarButtonItem?.title = "Список задач"
        
        //
        let filter = UserDefaults.standard.object(forKey: "idList") as? String ?? ""
        let arrayObjectsLists = ListTasksData.dataLoad(strPredicate: "id = %@", filter: filter)
        if arrayObjectsLists.count == 1 {
            let initialController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:
                "TasksVC") as? TasksViewController
            self.navigationController?.pushViewController(initialController!, animated: true)
        }
        self.roundButton = UIButton(type: .custom)
        self.roundButton.setTitleColor(UIColor.orange, for: .normal)
        self.roundButton.addTarget(self, action: #selector(ButtonClick(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(roundButton)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        self.listTasksViewController.reloadData()
    }
    override func viewWillLayoutSubviews() {
        Functions.floatButton(selfVC: self, roundButton: roundButton, bottom: -153)
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isUpperString = Functions.isUpperString()
        if isUpperString == true {
            textField.text = textField.text!.capitalizingFirstLetter()
        }
    }
    
    //MARK: action
    
//    @IBAction func clearButton(_ sender: UIBarButtonItem) {
//        clearButton()
//    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
          saveObjects()
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        if listTasksViewController.isEditing {
            saveObjects()
        //    loadData()
        }
        listTasksViewController.isEditing = !listTasksViewController.isEditing
    }
    
//    @IBAction func dataInJsonButton(_ sender: UIBarButtonItem) {
//        dataInJson()
//    }
//    @IBAction func restoreBackup(_ sender: Any) {
//        //SettingsTableViewController().restorebackupFileButtonClick()
//        let url = Files.mFolderURL()
//        jsonInDataFromDefaultFile(selfVC: self)
//        listTasksViewController.reloadData()
//    }
    
    
    //    @IBAction func editButton(_ sender: UIBarButtonItem) {
//        if let indexPath = ListtasksViewController.indexPathForSelectedRow {
//            self.editButton(CurrenIndexPathRow: indexPath.row)
//        }
//    }
    
//    @IBAction func addButton(_ sender: AnyObject) {
//     addTaskModel()
//    }
//    @IBAction func menuBarButton(_ sender: UIBarButtonItem) {
//        Functions.openMainMenu(selfViewController: self)
//    }
    
    
} //class


// MAKR: extention UITableViewDataSource, UITableViewDelegate
extension ListTasksViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTasksViewController.dequeueReusableCell(withIdentifier: "ListTasksCell", for: indexPath) as! ListTasksTableViewCell
//        if arrayObjects.count > 0 {
//            if arrayObjects[0]!.id == nil {
//                clearButton()
//            }
//        }
        
        if arrayObjects.count != 0{
            cell.textLabel?.text = arrayObjects[indexPath.row]?.name ?? ""
            let nameButton = "Lists"
            if UIImage(named: nameButton) != nil {
                cell.imageView?.image = UIImage(named: nameButton)
            }
           
        }
        
        var quantyBadgeTasksLabel = String(TasksData.quantyTasksForBadgeNotifications(date: Date()
            , listId: arrayObjects[indexPath.row]!.id))
        if quantyBadgeTasksLabel == "0" {
            quantyBadgeTasksLabel = ""
        }
        if arrayObjects[indexPath.row]!.id != nil {
            
            let arrayObjectsLists = TasksData.dataLoad(strPredicate: "idList = %@", filter: (arrayObjects[indexPath.row]!.id)!)
            let quantyListsLabel = String(arrayObjectsLists.count)
            
            cell.quantyBadgeTasksLabel.text = quantyBadgeTasksLabel
            cell.quantyListsLabel.text = quantyListsLabel
            
            //        cell.quantyBadgeTasksLabel.layer.masksToBounds = true
            //        cell.quantyBadgeTasksLabel.layer.cornerRadius = 10
            //        cell.quantyBadgeTasksLabel.layer.borderWidth = 1
            //        cell.quantyBadgeTasksLabel.layer.borderColor = UIColor.blue.cgColor
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let tasksVC = storyboard?.instantiateViewController(withIdentifier: "TasksVC") as! TasksViewController
        tasksVC.currentListObject = arrayObjects[indexPath.row]// as? ListTasks
        navigationController?.pushViewController(tasksVC, animated: true)
    }
//    private func tableView (tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    print ("Вы коснулись ячейки \(indexPath.row)")
//    }
//    private func tableView (tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
//    print ("Вы коснулись ячейки \(indexPath.row)")
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return CGFloat(arrayList[indexPath.row].characters.count)
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        return nil
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        //
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [self] (action, view, handler) in
            
            ListTasksData.deleteTasks(appDelegate: appDelegate, id: self.arrayObjects[indexPath.row]!.id!)
            
            let context = self.appDelegate.persistentContainer.viewContext
            context.delete(self.arrayObjects[indexPath.row]!)

            self.arrayObjects.remove(at: indexPath.row)
            self.listTasksViewController.deleteRows(at: [indexPath], with: .fade)
            
        }
        deleteAction.backgroundColor = .red
        //
        let editAction = UIContextualAction(style: .destructive, title: "Правка") { (action, view, handler) in

            //self.editButton(CurrenIndexPathRow: indexPath.row)
            
            let currentObjectSelected = self.arrayObjects[indexPath.row]
            let namecurrentObjectSelected = currentObjectSelected!.value(forKey: "name")
             
             let alert = UIAlertController(title: "Изменить", message: "", preferredStyle: .alert)
             
             alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
                 textField.text = (namecurrentObjectSelected as! String)
             })
             
             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (action) -> Void in
                var textFieldTxt = alert?.textFields![0].text
                let isUpperString = Functions.isUpperString()
                if isUpperString == true {
                    textFieldTxt = textFieldTxt!.capitalizingFirstLetter()
                }
                currentObjectSelected!.setValue(textFieldTxt, forKey: "name")
                 self.listTasksViewController.reloadRows(at: [indexPath], with: .automatic)
                self.saveObjects()
             }))
             alert.addAction(UIAlertAction(title: "Отказ", style: .cancel, handler: nil))
             self.present(alert, animated: true)
            
        }
        editAction.backgroundColor = .green
        ////
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        currentObject = arrayObjects[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.arrayObjects[sourceIndexPath.row]
        movedObject?.compare = false
        arrayObjects.remove(at: sourceIndexPath.row)
        arrayObjects.insert(movedObject, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(tableView: UITableView, editingStyleForRowAt indexPath: NSIndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }

    // MARK: - Segues
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if segue.identifier == "TasksVC" {
//                prepareController(currentViewController: tasksViewController!, segue: segue)
//
////                            if let indexPath = ListtasksViewController.indexPathForSelectedRow {
////                                let object = arrayList[indexPath.row]
////                                let controller = (segue.destination as! UINavigationController).topViewController as! tasksViewController
////                                //controller.detailItem = object
////                                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
////                                controller.navigationItem.leftItemsSupplementBackButton = true
////                                tasksViewController = controller
////                            }
//           }
//        }
        
  // }
        
     // MARK: func
    
    func loadData(){
        arrayObjects.removeAll()
        
        let arrayLists = ListTasksData.dataLoad(strPredicate: "", filter: "")
        arrayObjects = arrayLists
        
        //        let context = appDelegate.persistentContainer.viewContext
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ListTasks")
//        //request.includesPendingChanges = true
//        do {
//            let objects = try context.fetch(request)
//            for object in objects as! [NSManagedObject] {
//                 arrayObjects.append(object as? ListTasks)
//            }
//        } catch {
//            print("Failed")
//        }
    }
    
    func addTaskModel(){
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newTask = NSEntityDescription.insertNewObject(forEntityName: "ListTasks", into: context)
        self.arrayObjects.append(newTask as? ListTasks)

        let indexPath = IndexPath(row: arrayObjects.count-1, section: 0)
        let newId = UUID().uuidString
        self.arrayObjects[arrayObjects.count-1]?.id = newId
        self.arrayObjects[arrayObjects.count-1]?.name = "Новый список " + String(arrayObjects.count)
        self.arrayObjects[arrayObjects.count-1]?.updatedDate = Date()
        
        self.listTasksViewController.insertRows(at: [indexPath], with: .automatic)
        //self.ListtasksViewController.performBatchUpdates(<#T##updates: (() -> Void)?##(() -> Void)?##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
        self.listTasksViewController.reloadData()
        //self.ListtasksViewController.setEditing(true, animated: false)
    }
    
    func saveObjects(){
        //1
        updateTurn()
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
        
//        func prepareController(currentViewController: UIViewController, segue: UIStoryboardSegue)  {
//            if ListtasksViewController.indexPathForSelectedRow != nil {
//                let controller = (segue.destination as! UINavigationController).topViewController as! tasksViewController
//                //let object = arrayObjects[indexPath.row]
//                //controller.curre = object
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//                
//                let currentObject = self.arrayObjects[ListtasksViewController.indexPathForSelectedRow?.row ?? 0]
//                controller.currentListObject = currentObject as? Tasks
//
//        }
//            

//    func clearButton() {
//        let context = self.appDelegate.persistentContainer.viewContext
//
//        if arrayObjects.count == 0 {
//            return
//        }
//        //arrayObjects.removeAll()
//        //for arrayObject in arrayObjects {
//        for indexPath in 0...arrayObjects.count-1 {
//            //var indexPath = arrayObject.indexPath
//            //self.ListtasksViewController.deleteRows(at: [indexPath], with: .fade)
//            //self.arrayObjects.remove(at: indexPath)
//            context.delete(self.arrayObjects[indexPath]!)
//        }
//
//        arrayObjects.removeAll()
//        //self.ListtasksViewController.beginUpdates()
//
//        var tasks = TasksData.dataLoad(strPredicate: "", filter: "")
//        if tasks.count > 0 {
//            for indexPath in 0...tasks.count-1 {
//                context.delete(tasks[indexPath])
//            }
//            tasks.removeAll()
//        }
//
//        saveObjects()
//        //self.ListtasksViewController.endUpdates()
//        self.listTasksViewController.reloadData()
//
//
//    }
    
//    func clearTasks(id: String) {
//        let idTask = id
//        var tasks = TasksData.dataLoad(strPredicate: "idList = %@", filter: idTask)
//
//        if tasks.count > 0 {
//            let context = self.appDelegate.persistentContainer.viewContext
//            for indexPath in 0...tasks.count-1 {
//                context.delete(tasks[indexPath])
//            }
//            tasks.removeAll()
//        }
//
//        saveObjects()
//
//    }
    
//    //MARK: func
//    @objc func saveTasksControl(){
//        saveObjects()
//        refreshControl.endRefreshing()
//    }

    func  updateArray() {
        if arrayObjects.count > 0 {
            for i in 0...arrayObjects.count-1 {
                if arrayObjects[i]!.turn == 0 {
                    arrayObjects[i]!.turn = NSNumber(value: i)
                }
            }
        }
    }
    
    func updateTurn() {
        if arrayObjects.count > 0 {
            for i in 0...arrayObjects.count-1 {
                arrayObjects[i]!.turn = NSNumber(value: i)
            }
        }
    }
    
//    @objc func jsonInData(){
//
//        //initial(selfVC: self)SynhronViewController.initial(selfVC: self)
//
////        if SettingsTableViewController.googleSynchron() == true {
////            return
////        } else {
////            Functions.alertShort(selfVC: self, title: "Ошибка синхронизация Google", message: "")
////        }
//
//        arrayObjects.removeAll()
//
//        jsonInDataFromDefaultFile(selfVC: self)
//
//        loadData()
//        //refreshControl.endRefreshing()
//
//        //Functions.alertShort(selfVC: self, title: "Внимание", message: "Синхронизация закончена", second: 0.20)
//        refreshControl.endRefreshing()
//        self.listTasksViewController.reloadData()
//    }
//
    @objc func ButtonClick(_ sender: UIButton){

     addTaskModel()

    }
    
    
//    func editButton(CurrenIndexPathRow: Int){
//        let currentObject = self.arrayObjects[CurrenIndexPathRow]
//
//           if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "ListVC") as? ListViewController {
//               //         newViewController.modalTransitionStyle = .crossDissolve // это значение можно менять для разных видов анимации появления
//               //         newViewController.modalPresentationStyle = .overCurrentContext // это та самая волшебная строка, убрав или закомментировав ее, вы получите появление смахиваемого контроллера
//            newViewController.currentObject = currentObject
//               //newViewController.listTextField.text = currentObject.name
//               self.navigationController?.pushViewController(newViewController, animated: true)
//            }
//
//    }

        
}// extention


extension ListTasksViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    class HalfSizePresentationController : UIPresentationController {
        override var frameOfPresentedViewInContainerView: CGRect {
            get {
                guard let theView = containerView else {
                    return CGRect.zero
                }

                return CGRect(x: 0, y: theView.bounds.height/2, width: theView.bounds.width, height: theView.bounds.height/2)
            }
        }
    }
}
