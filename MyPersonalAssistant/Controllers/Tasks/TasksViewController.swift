

//
//  tasksViewController.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 07.03.2020.
//  Copyright © 2020 Vladimir Rice. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox
import MessageUI

import WatchConnectivity

import GoogleSignIn

//import TinyConstraints


//protocol currentListObjectDelegate {
//    func initCurrentListObject(currentListObject: ListTasks)
//}

class TasksViewController: UIViewController, UICollectionViewDelegate
    , UITableViewDataSource, UITableViewDelegate
    ,UIPickerViewDelegate, UIPickerViewDataSource
                           ,MFMailComposeViewControllerDelegate
                           , GIDSignInDelegate
//    ,WCSessionDelegate
{
    
    
    
    var refreshControl = UIRefreshControl()

    var arrayObjects: [Tasks] = []
    var arrayObjectsAll: [Tasks] = []
//    var refreshControl = UIRefreshControl()
    let minDateFormat = "EEEE.dd.MM.yyyy HH:mm"
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedIsCloseSegmentController: Int = 0
    var roundButton = UIButton()
    //var selectedRow = 0
    var selectedIndex: IndexPath!
    var sColors = SColors()
    
    var categorys: [Category]?
    
    // today, tomorrow, +2, со след. датами)
    
    //var sectionsForDate = [0:""]
    var sectionsForDate: [Int:String]!
   // var sectionsForDate = [0:"Сегодня",1:"Завтра",2:"Послезавтра",3:"Остальные дни"]
    var tableViewViewingWithSections = false
    var objectsSection0: [Tasks] = []
    var objectsSection1: [Tasks] = []
    var objectsSection2: [Tasks] = []
    var objectsSection3: [Tasks] = []
    var objectsSection4: [Tasks] = []
    var objectsSection5: [Tasks] = []
    
//    var statusText = ""
    
    //var currentListObject: ListTasks?
    //var listObjectDelegate: currentListObjectDelegate?
    
    
    @IBOutlet weak var tasksViewController: UITableView!
//    @IBOutlet weak var statusTaskSegmentedControl: UISegmentedControl!
    
//    @IBOutlet weak var filterBarButton: UIBarButtonItem!
    @IBOutlet weak var currentStatusBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var categoryLabel: UILabel!
    
    //@IBOutlet weak var dayStepper: UIStepper!
    
//    @IBOutlet weak var checkPlusButtonItem: UIBarButtonItem!
//    @IBOutlet weak var checkMinusButtonItem: UIBarButtonItem!
    
    //@IBOutlet weak var saveButtonItem: UIBarButtonItem!
    
  
    let mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // refreshControl
//        refreshControl.attributedTitle = NSAttributedString(string: "Синхронизация задач...")
//        refreshControl.addTarget(self, action: #selector(googleSynchronTarget), for: .valueChanged)
//        //refreshControl.tintColor = .blue
//        tasksViewController.refreshControl = refreshControl
        
        
        if currentListObject == nil{
            let filter = UserDefaults.standard.object(forKey: "idList") as? String ?? ""
            let arrayObjectsLists = ListTasksData.dataLoad(strPredicate: "id = %@", filter: filter)
            if arrayObjectsLists.count == 1 {
                currentListObject = arrayObjectsLists[0]
            }
        }
 
//        if PublicVars().autoSave {
//            saveButtonItem.isEnabled = false
//        }

        self.tasksViewController.dataSource = self
        self.tasksViewController.delegate = self

        tasksViewController.frame.size.width = 385
        tasksViewController.isEditing = true
        tasksViewController.estimatedSectionHeaderHeight = 45

//        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        let title = currentListObject!.name!
        let backButton = UIBarButtonItem(title: title, style: UIBarButtonItem.Style.plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backButton
        
        tasksViewController.rowHeight = UITableView.automaticDimension
        selectedIsCloseSegmentController = UserDefaults.standard.object(forKey: "selectedIsCloseSegmentController") as? Int ?? 0
        //statusTaskSegmentedControl.selectedSegmentIndex = selectedIsCloseSegmentController
        
        self.roundButton = UIButton(type: .custom)
        self.roundButton.setTitleColor(UIColor.orange, for: .normal)
        self.roundButton.addTarget(self, action: #selector(buttonClick(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(roundButton)

        //
//        let longpress = UILongPressGestureRecognizer (target: self, action: #selector (longPressGestureRecognized (_ :)))
//        tasksViewController.addGestureRecognizer (longpress)
        
        
        categorys = CategoryData.dataLoad(strPredicate: "", filter: "")
        
        loadData()
        
        categoryLabel.isUserInteractionEnabled = true
        categoryLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTappedCategory)))
        
        headingSections()
        
        tableViewViewingWithSections = true
        sectionsFilters()
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if tasksViewController.indexPathForSelectedRow != nil {
//            let controllerTaskTableViewController =
//                storyboard?.instantiateViewController(withIdentifier: "TaskTableViewController") as! TaskTableViewController
//            controllerTaskTableViewController.currentObject = self.arrayObjects[tasksViewController.indexPathForSelectedRow?.row ?? 0]! as Tasks
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
//
        categoryLabel.text = "<не выбрана>"
        
//        selectedSegment(index: statusTaskSegmentedControl.selectedSegmentIndex)

        headingSections()
        
        self.tasksViewController.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        Functions.floatButton(selfVC: self, roundButton: roundButton, bottom: -153)
    }
    
    var currentListObject: ListTasks? {//AnyObject? {
        didSet {
            // Update the view.
            //configureView()
        }
    }

    
    // MARK: delegate
    
    //func tableView(_ tableView: UITableView, numberOfSectionsInTableView section: Int) -> Int {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSection = 1
        if tableViewViewingWithSections {
            numberOfSection = sectionsForDate.count
        }
        return numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let objects = arrayFromSection(section: section)
        return objects.count
        //return arrayObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tasksViewController.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath) as! TasksCellTableViewCell
        
  //      cell.frame.size.width = tableView.frame.size.width - 40
        
        var objects = arrayFromSection(section: indexPath.section)
        //objects.sort(by: { (s1: Tasks, s2: Tasks) -> Bool in return (s1.go == true ) && (s1. == false) } )
        
        
        let currentObject = objects[indexPath.row]
        
        let dateTermination = currentObject.dateTermination
        var dateTerminationStr = ""
        if dateTermination != nil {
            dateTerminationStr = dateToString(date: dateTermination!)
        }
        
        var imageTask = UIImage()
        if currentObject.imageTask != nil {
            imageTask = UIImage(data: currentObject.imageTask!)!
        }
        
        
        cell.setupCell((currentObject.heading)!, name: (currentObject.name)!, dateTerminationStr: dateTerminationStr, priority: Int(truncating: (currentObject.priority)!), imageTask: imageTask)
            
        cell.IsCloseButton.addTarget(self, action: #selector(isCloseButtonClicked(_ :)), for: .touchUpInside)
        
        
//        cell.upTurnButton.addTarget(self, action: #selector(upTurn(_ :)), for: .touchUpInside)
//        cell.upTurnButton.isHidden = !tableView.isEditing
        
        
        updateCell(cell: cell, currentObject: currentObject, indexPath: indexPath)
        
        let cellColor = sColors.aColors[currentObject.color as! Int]
        cell.contentView.backgroundColor = cellColor
        if indexPath == selectedIndex {
            cell.contentView.backgroundColor = UIColor.lightGray
        }

//        cell.imageSelectImage.isHidden = true
//
//        if indexPath == selectedIndex {
//            //cell.contentView.backgroundColor = UIColor.lightGray
//            cell.imageSelectImage.isHidden = false
//        }
        
        //cell.lockedImage.isHidden = !((currentObject?.isEnabled) != nil)
        
        //yestoday
        //if dateTerminationStr != "" {
        textYestoday(currentObject: currentObject, cell: cell)
        
//        if currentObject!.imageTask != nil {
//          cell.imageTaskImageView.image = UIImage(data: currentObject!.imageTask!)
//        }
        
        cell.goImage.isHidden = true
        if currentObject.go {
            cell.goImage.isHidden = false
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let heigthCell = UserDefaults.standard.object(forKey: "heigthCell") as? String ?? "50"
        //return max(CGFloat(Double(heigthCell)), UITableView.automaticDimension)
        return CGFloat(Double(heigthCell) ?? 60.0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = §TasksViewController(tableView, cellForRowAt: indexPath)
        let cell = tableView.cellForRow(at: indexPath) as? TasksCellTableViewCell // as UITableViewCell?
        cell?.backgroundColor = UIColor.lightGray
        selectedIndex = indexPath
        
//        let tasksVC = storyboard?.instantiateViewController(withIdentifier: "TaskTableViewController") as! TaskTableViewController
//        tasksVC.currentObject = arrayObjects[indexPath.row]!
//        navigationController?.pushViewController(tasksVC, animated: true)
        
    }
//    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
//        print("You selected cell #\(indexPath.row)!")
//
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        var objects = arrayFromSection(section: indexPath.section)
        //
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, handler) in
            let objectForDelete = objects[indexPath.row]
            objects.remove(at: indexPath.row)
            self.tasksViewController.deleteRows(at: [indexPath], with: .fade)
            //
//            self.tasksViewController.reloadData()
//            if self.arrayObjects.count > 0 {
//                self.arrayObjects[0]?.name = self.arrayObjects[0]?.name
//            }
            self.clearButton(objectForDelete: objectForDelete)
        }
        deleteAction.backgroundColor = .red
 
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
//    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if !tableViewViewingWithSections {
            return UIView()
        }
        let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 45)
        let headerView = UIView(frame:rect)//view as! UITableViewHeaderFooterView////
        if tableViewViewingWithSections {
            headerView.backgroundColor = UIColor.red//UIColor.clear
//            if section == 2 {
//                headerView.backgroundColor = UIColor.yellow
//            }
//            if section >= 3 {
//                headerView.backgroundColor = UIColor.green
//            }
////            if section == 4 {
////                headerView.backgroundColor = UIColor.blue
////            }

        } else {
            headerView.backgroundColor = UIColor.gray
        }
//        let rectLabel = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 25)
//
//        let textLabel = UILabel(frame: rectLabel)
//        let label = UILabel()
//        label.textColor = UIColor.white
//        label.text = sectionsForDate[section]! as String
//        headerView.addSubview(label)
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UIView //UITableViewHeaderFooterView//UIView(frame:rect)
//        headerView.backgroundColor = UIColor.cyan
        //headerView.textLabel?.textColor = UIColor.blue

        let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 25)

        let textLabel = UILabel(frame: rect)
        textLabel.textColor = UIColor.white
        if headerView.backgroundColor == UIColor.yellow  || headerView.backgroundColor == UIColor.green {
            textLabel.textColor = UIColor.black
        }
        textLabel.text = sectionsForDate[section]! as String
        headerView.addSubview(textLabel)
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let date = events[section].first!.date
//        let month = NSCalendar.currentCalendar().components([.Month], fromDate: item.date).month
//        return sections[month - 1]
        
        // today, tomorrow, the day after tomorrow, со след. датами)
        var strHeader = "ВСЕ ЗАДАЧИ:"
        if !tableViewViewingWithSections {
            return strHeader
        }
        strHeader = sectionsForDate[section]! as String
        return strHeader
    }
    //
    
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if cell.isHidden == true {
//            cell.isHidden = false
//            cell.rowHeight = 0
//        }
//        if self.statusTaskSegmentedControl.selectedSegmentIndex == 1 {
//            let currentObject = arrayObjects[indexPath.row]
//            if currentObject?.isClose == true {
//                cell.isHidden = true
//            }
//        }
//    }
    
    // MARK: - delegate sign
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            
        }
    // MARK: - action
    @IBAction func clearButton(_ sender: UIBarButtonItem) {
        clearButton()
    }
    @IBAction func clickStatusTask(_ sender: UISegmentedControl) {
        selectedSegment(index: sender.selectedSegmentIndex)
    }
    
    @IBAction func trash(_ sender: Any) {
        clearButtonIsClose()
    }
    
    @IBAction func checkCells(_ sender: UIBarButtonItem) {
        var check = true
        if sender.tag == 1 {
            check = false
        }
        for objects in arrayObjectsAll {
            objects.isClose = check
        }
        tasksViewController.reloadData()
    }
    
//    @IBAction func editButton(_ sender: Any) {
//        tasksViewController.isEditing = !tasksViewController.isEditing
//    }
    
//    @IBAction func editTableView(_ sender: Any) {
//        tasksViewController.isEditing = !tasksViewController.isEditing
//    }
    
//    @IBAction func filterTableView(_ sender: UIBarButtonItem) {
//        filterObjectsAlert()
//        tasksViewController.reloadData()
//    }
    
    @IBAction func sectionsBarButtonAction(_ sender: UIBarButtonItem) {
        
        currentStatusBarButtonItem.isEnabled = tableViewViewingWithSections

 //       tasksViewController.isEditing = tableViewViewingWithSections
        
        tableViewViewingWithSections = !tableViewViewingWithSections
        
        sectionsFilters()
        
        
    }
  
    @IBAction func zipMailButtonClick(_ sender: UIBarButtonItem) {
        fileBackupZipMail()
    }
    

    
} //class


// MAKR: extention
extension TasksViewController {
    

    // MARK: - dekegate picker
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 2 {
            return 1
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 2 {
            return categorys!.count
        }
        return 0

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            //if component == 0 {
            return String(sColors.aColorsRU[row])
            //}
            //            if component == 1 {
            //                return String(arrayHour[row])
            //            }
            //            if component == 2 {
            //                return String(arrayMinute[row])
            //            }
            //        }
            //        if pickerView.tag == 1 {
            //          return jsonFiles[row]
        }
        if pickerView.tag == 2 {
            return String(categorys![row].name!)
        }

        return " "
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if pickerView.tag == 2 {
            
            categoryLabel.text = categorys![pickerView.selectedRow(inComponent: 0)].name
            if categoryLabel.text == "<не выбрана>" {
                arrayObjects = arrayObjectsAll
            } else {
                filterObjects(filter: "")
            }
            tasksViewController.reloadData()
        }
        
    }
    
    // // MARK: - tableview move
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
//
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let movedObject = self.objectsCheck[sourceIndexPath.row]
//        objectsCheck.remove(at: sourceIndexPath.row)
//        objectsCheck.insert(movedObject, at: destinationIndexPath.row)
//    }
    
    //  //
    
    
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return ((arrayObjects[indexPath.row]?.isEnabled) != nil)
//        //return true
//    }
    
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.remove(at: indexPath.row)
//            // Then, delete the row from the table itself
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
    }
    
        func tableView(tableView: UITableView, editingStyleForRowAt indexPath: NSIndexPath) -> UITableViewCell.EditingStyle {
            //super.editingStyleForRowAt(indexPath: indexPath)
        return .none
//        if editingStyle == .delete {
//                savedConversions.remove(at: indexPath.row)
//            }
    }

//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
//            // delete item at indexPath
//        }
//
//        let share = UITableViewRowAction(style: .normal, title: "Disable") { (action, indexPath) in
//            // share item at indexPath
//        }
//
//        share.backgroundColor = UIColor.blue
//
//        return [delete, share]
//    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
//    {
////        if editingStyle == .delete {
////            tasksViewController.remove(at: indexPath.row)
////        }
//    }
    
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
////        if editingStyle == .delete {
////            objects.remove(at: indexPath.row)
////            tableView.deleteRows(at: [indexPath], with: .fade)
////        } else if editingStyle == .insert {
////            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
////        }
//    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section != destinationIndexPath.section {
            Functions.alertShort(selfVC: self, title: "Переместить можно только в пределах одной секции!", message: "")
            return
        }

        var destinationRow = destinationIndexPath.row
        let sourceRow = sourceIndexPath.row
        let section = destinationIndexPath.section
        selectedIndex = destinationIndexPath
//        if destinationRow - sourceRow > 2 || destinationRow - sourceRow < -2 {
//
//            let message = "?"
//            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//
//            // add an action (button)
//            alertController.addAction(UIAlertAction(title: "Передвинуть в первую строку", style: UIAlertAction.Style.default, handler: { [self, weak alertController] (action) -> Void in
//                //destinationRow = 0
//                selectedIndex = IndexPath(row: 0, section: section)
//                moveCell(tableView: tableView, sourceIndexPath: sourceIndexPath, destinationIndexPath: selectedIndex)
//
//            }
//            ))
//
//            alertController.addAction(UIAlertAction(title: "Передвинуть на " + String(destinationRow) + " строку", style: UIAlertAction.Style.default, handler: { [self, weak alertController] (action) -> Void in
//                moveCell(tableView: tableView, sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
//
//            }
//            ))
//            // cancel
//            alertController.addAction(UIAlertAction(title: "Отказ", style: .cancel, handler: nil))
//            // show the alert
//            self.present(alertController, animated: true, completion: nil)
//        } else {
            moveCell(tableView: tableView, sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
//        }
    }
    

//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let itemToMove = arrayObjects[sourceIndexPath.row]
//        arrayObjects.remove(at: sourceIndexPath.row)
//        arrayObjects.insert(itemToMove, at: destinationIndexPath.row)
//     }
    
    
//    // MARK: - watch WCSessionDelegate
//    // import WatchConnectivity
//    
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
// //       let currentListObject = currentListObject
//    }
//    
//    func sessionDidBecomeInactive(_ session: WCSession) {
////        <#code#>
//    }
//    
//    func sessionDidDeactivate(_ session: WCSession) {
////        <#code#>
//    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        //if (segue.identifier == "pickerView") {
        let indexPath = tasksViewController.indexPathForSelectedRow
        
        let objects = arrayFromSection(section: indexPath!.section)
        
        if let initialController = (segue.destination as? TaskTableViewController) {
            let currentObjectTask = objects[indexPath!.row]
      //      let currentObjectTask = self.arrayObjects[tasksViewController.indexPathForSelectedRow?.row ?? 0] as Tasks
            
            initialController.currentObject = currentObjectTask
            initialController.delegateViewController = self
        }
        

     }
     
    
} // extention UITableViewDataSource, UITableViewDelegate


 // MARK: func
extension TasksViewController {
    
//    func addTaskModel(){
//        let appDelegate =
//            UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let newTask = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context)
//
//        self.arrayObjects.append(newTask as? Tasks)
//        let newId = UUID().uuidString
//        arrayObjects[arrayObjects.count-1]?.id = newId
//        arrayObjects[arrayObjects.count-1]?.idList = currentListObject!.id
//        arrayObjects[arrayObjects.count-1]?.listName = currentListObject!.name
//        arrayObjects[arrayObjects.count-1]?.heading = "Новая задача" + String(arrayObjects.count)
//
//        //self.tasksViewController.beginUpdates()
//        let indexPath = IndexPath.init(row: self.arrayObjects.count-1, section: 0)
//        self.tasksViewController.insertRows(at: [indexPath], with: .automatic)
//        //self.tasksViewController.endUpdates()
//
//        saveObjects()
//        self.tasksViewController.reloadRows(at: [indexPath], with: .none)
//    }
    
//    @objc func saveTasksControl(){
//        saveObjects()
////        refreshControl.endRefreshing()
//    }
    //

    @objc func buttonClick(_ sender: UIButton){
     addTaskModel()
    }
 
    func updateStatus() {
        let count =  arrayObjectsAll.filter({$0.isClose == true}).count
        currentStatusBarButtonItem.title = "Помечено " + String(count)
    }
    func addTaskModel() {
        var currentObject: Tasks?
        let objectsIsClose = arrayObjectsAll.filter({$0.isClose == true})
        if objectsIsClose.count > 0 {
            currentObject = objectsIsClose[0]
            currentObject?.isClose = false
            currentObject?.heading = ""
            currentObject?.name = ""
            currentObject?.turn = 0
            
            moveObjectWithTurn(currentObject: currentObject!, turn: 0)
//            arrayObjects.insert(currentObject!, at: 0)
////            arrayObjectsAll.insert(currentObject!, at: 0)
////            arrayObjectsAll.sorted(by: { (s1: Tasks, s2: Tasks) -> Bool in return s1.turn! < s2.turn! } )
//            var objects: [Tasks] = []
//            objects.append(currentObject!)
//            updateTurn(objectsNoTurn: objects)
//
//            arrayObjects.sort(by: { Int($0.turn!) < Int($1.turn!) })
////            arrayObjectsAll.sort(by: { Int($0.turn!) < Int($1.turn!) })
//
//
//            saveObjects(isTurn: false)
//            loadData()
//
//            tasksViewController.reloadData()
            


        }
        openController(currentObject: currentObject)
    }
    
    func openController(currentObject: Tasks?) {
        
            if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "TaskTableViewController") as? TaskTableViewController {
                newViewController.delegateViewController = self
                newViewController.currentListObject = currentListObject
                //if new == true {
                if currentObject == nil {
                    newViewController.addObject()
                } else {
                    newViewController.currentObject = currentObject
                }
                    //newViewController.arrayObjectALLDdelegateViewController = arrayObjectsAll
//                } else {
//                    //newViewController.currentObject =
//                }
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        
    }
    
    func loadData(){
        arrayObjects.removeAll()
        arrayObjects = TasksData.dataLoad(strPredicate: "idList = %@", filter: (currentListObject!.id)!)
//        //arrayObjects = arrayObjects.sorted(by: { (s1: Tasks, s2: Tasks) -> Bool in return s1.dateTermination! < s2.dateTermination! } )
//        arrayObjects = arrayObjects.sorted(by: { (s1: Tasks, s2: Tasks) -> Bool in
//            if s1.dateTermination == nil || s2.dateTermination == nil {
//                return false
//            }
//            if s1.dateTermination! < s2.dateTermination! {
//                return true
//            }
//            return false
//        } )
        arrayObjects = sortedBeforeTurn(objects: arrayObjects)
        arrayObjectsAll = arrayObjects
        updateStatus()
    }
    
    func sortedBeforeTurn(objects: [Tasks]) -> [Tasks] {
        var arrayWithoutDay = objects.filter({ Int(truncating: $0.priority!) < Int(truncating: 1 as NSNumber) && $0.dateTermination == nil })//.sorted(by: { (s1: Tasks, s2: Tasks) -> Bool in return Int(s1.turn!) < Int(s2.turn!) } )
//        arrayWithoutDay.sort(by: { (s1: Tasks, s2: Tasks) -> Bool in return s1.go == false } )
        
        var arrayDateToDay = objects.filter({ $0.dateTermination != nil })
//        //arrayDateToDay.sorted(by: { (s1: Tasks, s2: Tasks) -> Bool in return s1.dateTermination! < s2.dateTermination! } )
//        //arrayDateToDay.sort(by: { (s1: Tasks, s2: Tasks) -> Bool in return (s1.dateTermination! < s2.dateTermination!) && (s1.go && !s2.go) } ) //$0.selected && !$1.selected
//        arrayDateToDay.sort(by: { (s1: Tasks, s2: Tasks) -> Bool in return s1.go == true } )
        
        var arrayPriority = objects.filter({ Int(truncating: $0.priority!) > Int(truncating: 0 as NSNumber)  && $0.dateTermination == nil})
//        arrayPriority.sort(by: { (s1: Tasks, s2: Tasks) -> Bool in return (s1.go == true) && (Int(truncating: s1.priority!) > Int(truncating: s2.priority!)) } )
        
        let allArray = arrayDateToDay + arrayPriority + arrayWithoutDay
//      //allArray.sorted(by: { (s1: Tasks, s2: Tasks) -> Bool in return (s1.dateTermination! < s2.dateTermination!) && s1.go == true } )

        return allArray
    }
    
    func saveObjects(isTurn: Bool? = true){
        if isTurn! {
            updateTurn()
        }
        currentListObject?.updatedDate = Date()
        
        //appDelegate.saveContext()
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let context = appDelegate.persistentContainer.viewContext
        //context.refreshAllObjects()
//        if !context.hasChanges {
//            if arrayObjects.count > 0 {
//                arrayObjects[0]!.name = arrayObjects[0]!.name
//            }
//        }
         do {
            try context.save()
        } catch {
                let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    //    tasksViewController.reloadData()
    }
    
    func clearButton(objectForDelete: Tasks? = nil) {
        if objectForDelete == nil{
            return //arrayObjects.removeAll()
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        let filter = currentListObject?.id
        let predicate = NSPredicate(format: "idList = %@", filter!)
        request.predicate = predicate
        do {
            let objects = try context.fetch(request)
            for object in objects as! [NSManagedObject] {
                if objectForDelete != nil && objectForDelete != object {
                    continue
                }
                context.delete(object)
            }
        } catch {
            print("Failed")
        }
        saveObjects()
        self.tasksViewController.reloadData()
    }
  
    func clearButtonIsClose() {
        let objectsForDelete = arrayObjectsAll.filter({$0.isClose == true})
        
        if objectsForDelete.count == 0 {
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        let filter = currentListObject?.id
        let predicate = NSPredicate(format: "idList = %@", filter!)
        request.predicate = predicate
        do {
            let objects = try context.fetch(request)
            for object in objects as! [NSManagedObject] {
                if objectsForDelete.contains(object as! Tasks) {
                    context.delete(object)
                }
            }
        } catch {
            print("Failed")
        }
        saveObjects()
        loadData()
        //updateStatus()
        self.tasksViewController.reloadData()
    }
    func dateToString(date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = minDateFormat
        formatter.locale = Locale(identifier: "ru_RU")
        let dateResult = formatter.string(from: date as Date)
        return dateResult
    }
    
    
    @objc func isCloseButtonClicked(_ sender: UIButton) {
  
//        let pointInTable: CGPoint =         sender.convert(sender.bounds.origin, to: self.tasksViewController)
//        let cellIndexPath = self.tasksViewController.indexPathForRow(at: pointInTable)
        
        let cellIndexPath = self.tasksViewController.indexPath(for: sender.superview!.superview as! TasksCellTableViewCell)
        if cellIndexPath == nil {
            return
        }
        var objects = arrayFromSection(section: cellIndexPath!.section)
        
        let currentObject = objects[cellIndexPath!.row]
        currentObject.isClose = !currentObject.isClose
        
//        tasksViewController.reloadRows(at: [cellIndexPath!], with: .none)
        
//        let currentSelectedSegmentIndex = statusTaskSegmentedControl.selectedSegmentIndex
//        if currentSelectedSegmentIndex == 1 {
//            selectedSegment(index: 0)
//        }
        if ((currentObject.isClose) != nil) {
            currentObject.dateTermination = nil

        }
        UserNotificationManager().setNotificationTask(object: currentObject)
        
        objects.remove(at: cellIndexPath!.row)
        objects.insert(currentObject, at: objects.count)
        
//        objects.sorted(by: { (s1: Tasks, s2: Tasks) -> Bool in return s1.isClose == false } )
        
//                objects = objects.sorted(by: { (s1: Tasks, s2: Tasks) -> Bool in
//                    if !s1.isClose  {
//                        return true
//                    }
//                    return false
//                } )
        
        arrayInArraySection(objects: objects, section: cellIndexPath!.section)
        //updateTurn()
 //       objects = sortedBeforeTurn(objects: objects)
        
       saveObjects()
        loadData()
        
//        if currentSelectedSegmentIndex == 1 {
//            selectedSegment(index: currentSelectedSegmentIndex)
//        }
    //updateStatus()
        
        tasksViewController.reloadData()
    }

//    @objc func upTurn(_ sender: UIButton) {
////        let pointInTable: CGPoint =         sender.convert(sender.bounds.origin, to: self.tasksViewController)
////        let cellIndexPath = self.tasksViewController.indexPathForRow(at: pointInTable)
//        let cellIndexPath = self.tasksViewController.indexPath(for: sender.superview!.superview as! TasksCellTableViewCell)
//        if cellIndexPath == nil {
//            return
//        }
//        let currentObject = arrayObjects[cellIndexPath!.row]
//        moveObjectWithTurn(currentObject: currentObject, turn: 0)
//    }
    
    
    func updateCell(cell: TasksCellTableViewCell, currentObject: Tasks, indexPath: IndexPath) {
  
        //if currentObject.isEnabled {
        //    cell.isEditing = currentObject.isEnabled
        //}
        cell.lockedImage.isHidden = currentObject.isEnabled
        
        if ((currentObject.isClose) == true) {
           //cell.IsCloseButton.imageView!.image = UIImage(named: "checkPlus")
            cell.IsCloseButton.setImage(UIImage(named: "checkPlus"), for: .normal)
        } else {
            //cell.IsCloseButton.imageView!.image = UIImage(named: "checkEmpty")
            cell.IsCloseButton.setImage(UIImage(named: "checkEmpty"), for: .normal)
        }
   
        var currentColor = UIColor.white
        if indexPath == selectedIndex {
            currentColor = UIColor.lightGray
        }

        
        if ((currentObject.isClose) == true) || currentObject.isEnabled == false {
            
            currentColor = UIColor.gray
            let textColor = UIColor.gray
            //
            var label = UILabel()
            
            label = cell.heading
            var attributes:[NSAttributedString.Key:Any] = [
//                .font : UIFont.systemFont(ofSize: 100),
//                .backgroundColor : UIColor.lightGray.withAlphaComponent(0.5),
//                .strokeWidth : -2,
//                .strokeColor : UIColor.black,
//                .foregroundColor : UIColor.red,
                .strikethroughStyle: 1,
            ]
            
            if !currentObject.isEnabled && !currentObject.isClose {
                attributes = [
    //                .font : UIFont.systemFont(ofSize: 100),
    //                .backgroundColor : UIColor.lightGray.withAlphaComponent(0.5),
    //                .strokeWidth : -2,
    //                .strokeColor : UIColor.black,
    //                .foregroundColor : UIColor.red,
                    .strikethroughStyle: 0,
                ]
            }
            var attributesAttributedString = NSAttributedString(string: label.text!, attributes: attributes)
            
            label.attributedText = attributesAttributedString
            label.textColor = textColor
            
//            label = cell.name
//            attributesAttributedString = NSAttributedString(string: label.text!, attributes: attributes)
//            label.attributedText = attributesAttributedString
//            label.textColor = textColor

            label = cell.dateTermination
            attributesAttributedString = NSAttributedString(string: label.text!, attributes: attributes)
            label.attributedText = attributesAttributedString
            label.textColor = textColor

//            label = cell.dateTermLabelRuss
//            attributesAttributedString = NSAttributedString(string: label.text!, attributes: attributes)
//            label.attributedText = attributesAttributedString
//            label.textColor = textColor
            
            
            //currentColor = UIColor.lightGray
           
        } else {
            var label = UILabel()
            let ofSizeFont = UserDefaults.standard.object(forKey: "fontHeading") as? String ?? "12"
            let ofSizeFontGFloat = CGFloat((ofSizeFont as NSString).floatValue)
            let textColor = UIColor.black
            label = cell.heading
            let attributes:[NSAttributedString.Key:Any] = [
                .font : UIFont.boldSystemFont(ofSize: ofSizeFontGFloat),
                //.backgroundColor : UIColor.white,
                //                .strokeWidth : -2,
                //                .strokeColor : UIColor.black,
                //                .foregroundColor : UIColor.red,
                .strikethroughStyle: 0,
            ]
            var attributesAttributedString = NSAttributedString(string: label.text!, attributes: attributes)
            label.attributedText = attributesAttributedString
            label.textColor = textColor
            
//            label = cell.name
//            attributesAttributedString = NSAttributedString(string: label.text!, attributes: attributes)
//            label.attributedText = attributesAttributedString
//            label.textColor = textColor
//
//            label = cell.dateTermination
//            attributesAttributedString = NSAttributedString(string: label.text!, attributes: attributes)
//            label.attributedText = attributesAttributedString
//            label.textColor = textColor
//
//            label = cell.dateTermLabelRuss
//            attributesAttributedString = NSAttributedString(string: label.text!, attributes: attributes)
//            label.attributedText = attributesAttributedString
//            label.textColor = textColor


            // color dateTermination
            colorDateLable(label: cell.dateTermination, currentObject: currentObject)
        
        }
        
        cell.contentView.backgroundColor = currentColor
        //cell.contentView.backgroundColor = UIColor.gray
}
    
//    private func setAttributedString(label: UILabel, AttributesKey: NSAttributedString.Key, attribut: Any) {
//        let text = label.text
//        let attributes: [NSAttributedString.Key: Any] = [AttributesKey: attribut]
//        label.attributedText = NSAttributedString(string: text!, attributes: attributes)    }
// }
    
    func colorDateLable(label: UILabel, currentObject: Tasks){
        if currentObject.dateTermination != nil && !currentObject.isClose && currentObject.dateTermination! < Date(){
            label.textColor = .red
        } else {
            label.textColor = .black
        }
    }
    
    func selectedSegment(index: Int) {
        //let index = sender.selectedSegmentIndex
        if index == 0 {
            arrayObjects = arrayObjectsAll
        }
        if index == 1 {
            arrayObjects = arrayObjectsAll.filter { $0.isClose == false }
        }
        
//        tasksViewController.isEditing = true
//        if tableViewViewingWithSections || arrayObjects != arrayObjectsAll {
//            tasksViewController.isEditing = false
//        }
        
        tasksViewController.reloadData()
        
        //self.tasksViewController.reloadData()
        
        updateStatus()
                
 //           UserDefaults.standard.set(statusTaskSegmentedControl.selectedSegmentIndex, forKey: "selectedIsCloseSegmentController")
    
    }
    
    func updateContext() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.saveContext()
        let context = appDelegate.persistentContainer.viewContext
        context.refreshAllObjects()
    }
    
//    func  updateArray() {
//        if arrayObjects.count > 0 {
//            for i in 0...arrayObjects.count-1 {
//                if arrayObjects[i]!.turn == 0 {
//                    arrayObjects[i]!.turn = NSNumber(value: i)
//                }
//            }
//        }
//    }
    
    func updateTurn(objectsNoTurn: [Tasks]? = nil) {
        if tableViewViewingWithSections {
                arrayObjects = objectsSection0 + objectsSection1 + objectsSection2 + objectsSection3 + objectsSection4 + objectsSection5
        }
        var objects = arrayObjects //arrayObjects
//        //objects = objects.sorted(by: { (s1: Tasks, s2: Tasks) -> Bool in return s1.dateTermination! < s2.dateTermination! } )
//        objects = objects.sorted(by: { (s1: Tasks, s2: Tasks) -> Bool in
//            if s1.dateTermination == nil || s2.dateTermination == nil {
//                return false
//            }
//            if s1.dateTermination! < s2.dateTermination! {
//                return true
//            }
//            return false
//        } )
        objects = sortedBeforeTurn(objects: objects)
        
        var objectsNoTurn = objectsNoTurn
        if objectsNoTurn == nil {
            objectsNoTurn = []
        }
        let objectsIsClose = objects.filter({$0.isClose == true})
        if objectsNoTurn!.count > 0 {
            for i in 0...objectsNoTurn!.count-1 {
                objectsNoTurn![i].turn = NSNumber(value: i)
            }
        }
        //        if objectsIsClose.count > 0 {
        //            for i in 0...objectsIsClose.count-1 {
        //                objectsIsClose[i].turn = NSNumber(value: i)
        //            }
        //        }
        //let CountObjectsIsClose = objectsIsClose.count
        
        let countObjectsNoTurn = 0
        var maxTurn = 0
        for i in 0...objects.count-1 {
//            let currObjectsIsClose = objectsIsClose.firstIndex(of: objects[i])
//            if currObjectsIsClose != nil {
//                objects[i].turn = currObjectsIsClose as NSNumber?
//                continue
//            }
            let currObjectsNoTurn = objectsNoTurn!.firstIndex(of: objects[i])
            if currObjectsNoTurn != nil {
                objects[i].turn = currObjectsNoTurn as NSNumber?
                continue
            }
            //objects[i].turn = NSNumber(value: i+CountObjectsIsClose)
            objects[i].turn = NSNumber(value: i+countObjectsNoTurn)
            maxTurn = objects[i].turn as! Int
        }
        
        // last
        maxTurn = maxTurn + 1
        if objectsIsClose.count > 0 {
            for i in 0...objectsIsClose.count-1 {
                objectsIsClose[i].turn = NSNumber(value: i+maxTurn)
            }
        }
    }
    
    
//    func sortTurn() {
////        arrayObjectsAll.sort {
////            $0.turn! < $1.turn!
////        }
////        arrayObjectsAll.sort(by: { lhs, rhs in
////          return lhs.turn < rhs.turn
////        })
//
//        tasksViewController.reloadData()
//    }
//
//    func sortedTurn() {
//
//        self.arrayObjectsAll = self.arrayObjectsAll.sorted(by: { (s1: Tasks, s2: Tasks) -> Bool in return s1.turn! < s2.turn! } )
//
// //       arrayObjectsAll.sorted(by: { $0.turn > $1.turn })
//
//        self.tasksViewController.reloadData()
//    }
    
    
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func textYestoday(currentObject: Tasks, cell: TasksCellTableViewCell) {
        
        var strDni = ""
        var v = ""
        var currColor = UIColor.black
        
        let dateTermination = currentObject.dateTermination
        var dateTerminationStr = ""
        if dateTermination != nil {
            dateTerminationStr = dateToString(date: dateTermination!)
        }
        if dateTerminationStr == "" {
            cell.yestoday.text = v+strDni
            cell.yestoday.textColor = currColor
            return
        }
        
        let raznica = Date().startOfDay.days(to: (dateTermination!))
        
        switch raznica {
        case 0:
            v = "Сегодня"
            currColor = UIColor.red
        case 1:
            v = "Завтра"
            currColor = UIColor.red
        case 0:
            v = "Сегодня"

        default:
            v = "Через "+String(raznica)
            currColor = UIColor.blue
            if raznica < 0 {
                v = "Прошло "+String(-raznica)
                currColor = UIColor.red
            }
            
            strDni = " дней"
            if (raznica > 1 && raznica < 5 ) || (raznica < 0 && raznica > -4 ) {
                strDni = " дня"
            }
            if raznica == -1 {
                v = "Прошел "+String(-raznica)
                strDni = " день"
            }
        }
        cell.yestoday.text = v+strDni
        cell.yestoday.textColor = currColor
    }
    
//    func filterObjectsAlert() {
//        var countDniText: UITextField?
//
//        let alertController = UIAlertController(title: "Фильтр", message: "", preferredStyle: .alert)
//
//
//        let okAction = UIAlertAction(title: "С датами", style: .default) { [self]
//            UIAlertAction in
//
//            //alertController.textFields![0] as UITextField
//
//            let filter = countDniText?.text //alertController.textFields![0].text ?? "2"
//            filterObjects(filter: filter!)
//        }
//
////        let actionCategory = UIAlertAction(title: "С датами", style: .default) { [self]
////            UIAlertAction in
////
////            //alertController.textFields![0] as UITextField
////
////            let filter = countDniText?.text //alertController.textFields![0].text ?? "2"
////            filterObjects(filter: filter!)
////        }
//
//        let cancelAction = UIAlertAction(title: "Сбросить фильтр", style: .cancel) { [self]
//            UIAlertAction in
//            let filter = ""
//            //filterObjects(filter: filter)
//            arrayObjects = arrayObjectsAll
//            tasksViewController.isEditing = true
//            tasksViewController.reloadData()
//        }
//
//        alertController.addTextField { (textField) in
//            countDniText = textField
//            countDniText!.keyboardType = UIKeyboardType.phonePad
//            countDniText?.text = "2"
//        }
//
//        alertController.addAction(okAction)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    
    
    func filterObjects(filter: String) {

        arrayObjects = arrayObjectsAll
//        let currentSelectedSegmentIndex = statusTaskSegmentedControl.selectedSegmentIndex
//
//        if currentSelectedSegmentIndex == 1 {
//            arrayObjects = arrayObjectsAll.filter { $0.isClose == false }
//        }

        //let raznica = Date().days(to: dateTermination)
        if categoryLabel.text != "<не выбрана>" {
            arrayObjects = arrayObjectsAll.filter { $0.category == categoryLabel.text }

        }
 
        var filter = filter
        
//        if filter == "" {
//            filter = "100000000"
//        }
        if filter != "" {
            var countDni = Int(filter)
            let arrayDate = arrayObjects.filter({ $0.dateTermination != nil })
            arrayObjects = arrayDate.filter({ Date().days(to: $0.dateTermination!) < countDni! })
        }
        
//       tasksViewController.isEditing = true
//        if arrayObjects != arrayObjectsAll {
//            tasksViewController.isEditing = false
//        }
        tasksViewController.reloadData()
    }
    
    @objc func viewTappedCategory() {
//        if currentObject?.isEnabled == false {
//            return
//        }
        let isButton = PublicVars().appPro
        if !isButton {
            return
        }

        CategoryData.categoryDefault()
        
        let title = "Выбор категории"
        let message = "\n\n\n\n\n\n\n\n\n\n";
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let pickerFrame: CGRect = CGRect(x: 0, y: 52, width: 270, height: 160); //
        let myPickerView: UIPickerView = UIPickerView(frame: pickerFrame);

        myPickerView.delegate = self
        myPickerView.dataSource = self
        myPickerView.backgroundColor = UIColor.white
        myPickerView.tag = 2
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
//    {
//            myPickerView.frame.size.width = alertView.view.frame.size.width
//        })
    }
    
    func arrayFromSection(section: Int) -> [Tasks] {
        if tableViewViewingWithSections {
            switch section {
            case 0:
                return objectsSection0
            case 1:
                return objectsSection1
            case 2:
                return objectsSection2
            case 3:
                return objectsSection3
            case 4:
                return objectsSection4
            case 5:
                return objectsSection5

            default:
                return arrayObjects
            }
        }
        return arrayObjects
    }
  
    func arrayInArraySection(objects: [Tasks], section: Int) {
        if tableViewViewingWithSections {
            switch section {
            case 0:
                objectsSection0 = objects
            case 1:
                objectsSection1 = objects
            case 2:
                objectsSection2 = objects
            case 3:
                objectsSection3 = objects
            case 4:
                objectsSection4 = objects
            case 5:
                objectsSection5 = objects

            default:
                arrayObjects = objects
            }
        } else {
            arrayObjects = objects
        }

    }
    
    func moveObjectWithTurn(currentObject: Tasks, turn: Int) {
        arrayObjects.insert(currentObject, at: turn)
        //            arrayObjectsAll.insert(currentObject!, at: 0)
        //            arrayObjectsAll.sorted(by: { (s1: Tasks, s2: Tasks) -> Bool in return s1.turn! < s2.turn! } )
        var objects: [Tasks] = []
        objects.append(currentObject)
        updateTurn(objectsNoTurn: objects)
        //arrayObjects.sort(by: { Int($0.turn!) < Int($1.turn!) })
        
        //            arrayObjectsAll.sort(by: { Int($0.turn!) < Int($1.turn!) })
        currentListObject?.updatedDate = Date()
        saveObjects(isTurn: false)
        loadData()

        //tasksViewController.reloadData()
    }
    
    func sectionsFilters() {
        if !tableViewViewingWithSections {
            objectsSection0.removeAll()
            objectsSection1.removeAll()
            objectsSection2.removeAll()
            objectsSection3.removeAll()
            objectsSection4.removeAll()
            objectsSection5.removeAll()
        } else {
            
            //sectionsForDate = [0:"Срок истек!", 1:"Сегодня (" + strNext0Day + ")", 2:"Завтра (" + strNext1Day + ")", 3:"Послезавтра (" + strNext2Day + ")", 4:"Позже и без даты"]
            
            let arrayPriority = arrayObjectsAll.filter({ Int(truncating: $0.priority!) > Int(truncating: 0 as NSNumber) && $0.dateTermination == nil})
            
            var arrayWithoutDay = arrayObjectsAll.filter({ Int(truncating: $0.priority!) < Int(truncating: 1 as NSNumber) && $0.dateTermination == nil })
            //arrayWithoutDay.sort(by: { (s1: Tasks, s2: Tasks) -> Bool in return (s1.go == true) && (s1.isClose == false)} )
            
            var arrayDateToDay = arrayObjectsAll.filter({ $0.dateTermination != nil })
            //arrayDateToDay.sort(by: { (s1: Tasks, s2: Tasks) -> Bool in return s1.go == true } )
            
            objectsSection0 = arrayDateToDay.filter({ $0.dateTermination! < Date().startOfDay})
            
            let arrayLaterDate = arrayDateToDay.filter({ $0.dateTermination! >= Date().startOfDay }).sorted(by: { (s1: Tasks, s2: Tasks) -> Bool in return s1.dateTermination! < s2.dateTermination! } )
            // 1
            var countDni = 0
            var nextDay = Date().startOfDay.nextDay(nextValue: countDni)
            objectsSection1 = arrayLaterDate.filter({ $0.dateTermination!.startOfDay == nextDay })
            
            // 2
            countDni = 1
            nextDay = Date().startOfDay.nextDay(nextValue: countDni)
            objectsSection2 = arrayLaterDate.filter({ $0.dateTermination!.startOfDay == nextDay })
            
            // 3
            countDni = 2
            nextDay = Date().startOfDay.nextDay(nextValue: countDni)
            objectsSection3 = arrayLaterDate.filter({ $0.dateTermination!.startOfDay == nextDay })
            
            // 4
            objectsSection4 = arrayPriority
            
            // 5
            countDni = 2
            nextDay = Date().startOfDay.nextDay(nextValue: countDni)
            var objectsSection4tmp = arrayLaterDate.filter({ $0.dateTermination!.startOfDay > nextDay })

            objectsSection5 = objectsSection4tmp + arrayWithoutDay

            
        }
        tasksViewController.reloadData()
    }
    
    func moveCell(tableView: UITableView, sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
//        if sourceIndexPath.section != destinationIndexPath.section {
//            Functions.alertShort(selfVC: self, title: "Переместить можно только в пределах одной секции!", message: "")
//            return
//        }
        var objects = arrayFromSection(section: sourceIndexPath.section)
        let movedObject = objects[sourceIndexPath.row]
        
        movedObject.compare = false
        
        objects.remove(at: sourceIndexPath.row)
        objects.insert(movedObject, at: destinationIndexPath.row)

        arrayInArraySection(objects: objects, section: sourceIndexPath.section)
        
//        var objectsMove = arrayObjects
//        let indexRow = objectsMove.firstIndex(of: movedObject)
//        objectsMove.remove(at: indexRow!)
//        objectsMove.insert(movedObject, at: destinationIndexPath.row)
        
 //       updateTurn()
        //DispatchQueue.main.async {
            
            self.saveObjects()
        //sectionsFilters()
            self.loadData()
            
        //}
        tableView.reloadData()
    }
    
    func headingSections() {
        let minDateFormat = "EEEE.dd.MM.yyyy"
        var countDni = 0
        let strNext0Day = Functions.dateToStringFormat(date: Date().startOfDay.nextDay(nextValue: countDni), minDateFormat: minDateFormat)
        countDni = 1
        let strNext1Day = Functions.dateToStringFormat(date: Date().startOfDay.nextDay(nextValue: countDni), minDateFormat: minDateFormat)
        countDni = 2
        let strNext2Day = Functions.dateToStringFormat(date: Date().startOfDay.nextDay(nextValue: countDni), minDateFormat: minDateFormat)

        sectionsForDate = [0:"Срок истек!", 1:"Сегодня (" + strNext0Day + ")", 2:"Завтра (" + strNext1Day + ")", 3:"Послезавтра (" + strNext2Day + ")", 4:"Частоиспользуемые", 5:"Прочие"]

    }
    
    @objc func googleSynchronTarget() {
        //tasksViewController.refreshControl?.isHidden = false
        
        GIDSignIn.sharedInstance().delegate = self
        
        let statusGoogleSign = googleSynchron(selfVC: self, listID: (currentListObject?.id)!)
        if !statusGoogleSign {
            //tasksViewController.reloadData()
            tasksViewController.refreshControl?.endRefreshing()
              
//            let attribures = [
//                NSAttributedString.Key.foregroundColor: UIColor.red,
//                NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 10)!
//            ]
//            currentStatusBarButtonItem.setTitleTextAttributes(attribures, for: .normal)
            currentStatusBarButtonItem.title = "Нужно войти в аккаунт!"

        } else {
            tasksViewController.refreshControl?.endRefreshing()
            currentStatusBarButtonItem.title = "Синхронизация выполнена!"
        }
    }
    
    
    // MARK: -  mail
    func fileBackupZipMail() {
        let fileName = dataInJson(selfVC: self)
            let eMail = EMail()
        eMail.selfVC = self
        eMail.setSubject = "Архив"
        eMail.setMessageBody = "Отправлено из программы MyPersonalAssistant"
        eMail.aFileNames = [fileName]
        eMail.sendEmail()
    }
//    
//    func sendEmailButtonTapped(fileName: String) {
//        let mailComposeViewController = configuredMailComposeViewController(fileName: fileName)
//        if MFMailComposeViewController.canSendMail() {
//            self.present(mailComposeViewController, animated: true, completion: nil)
//        } else {
//            self.showSendMailErrorAlert()
//        }
//    }
//    
//    func configuredMailComposeViewController(fileName: String) -> MFMailComposeViewController {
//        let mailComposerVC = MFMailComposeViewController()
//        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
//        
//        let eMail = UserDefaults.standard.object(forKey: "eMail") as? String
//        //let eMail = "rvoipm@gmail.com"
//        
//        mailComposerVC.setToRecipients([eMail!])
//        mailComposerVC.setSubject("\(fileName)")
//
//        let url = Files.mFolderURL()
//        let urlTmp = url?.appendingPathComponent("tmp")
//        let currFileURL = url?.appendingPathComponent("\(fileName)")
//        let filePath = currFileURL!.path
//        
//        //if let filePath = Files.mFolderURL()//Bundle.main.path(forResource: fileName, ofType: "zip") {
//        
//        //if let data = Data(contentsOf: currFileURL!, options: .alwaysMapped) {
//        if let data = NSData(contentsOfFile: filePath) {
//                mailComposerVC.addAttachmentData(data as Data, mimeType: "application/zip" , fileName: fileName)
//            }
//         //}
//        
//        mailComposerVC.setMessageBody("Отправлено из программы MyPersonalAssistant", isHTML: false)
//        
//        return mailComposerVC
//    }
//    
//    func showSendMailErrorAlert() {
//        Functions.alertShort(selfVC: self, title: "Ошибка отправки письма!", message: "")
////        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert, delegate: self, cancelButtonTitle: "OK")
////        sendMailErrorAlert.show()
//    }
//    
//    //MARK:- MailcomposerDelegate
//        
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
    
    
    
    
    
//    // MARK: - coredata
    @objc func contextSave(_ notification: Notification) {
        // Retrieves the context saved from the notification
        guard let context = notification.object as? NSManagedObjectContext else { return }

        // Checks if the parent context is the main one
        if context.parent === mainManagedObjectContext {

            // Saves the main context
            mainManagedObjectContext.performAndWait {
                do {
                    try mainManagedObjectContext.save()
                } catch {

                }
            }
        }
    }
    @objc func contextObjectsDidChange(_ notification: Notification) {

// //       updateTurn()
//// //       saveObjects()
//////        var objectsForCD = arrayObjects
//////        arrayObjects.removeAll()
//////        arrayObjects = objectsForCD
////
////        //saveObjects()
////        let appDelegate = UIApplication.shared.delegate as! AppDelegate
////
////        let context = appDelegate.persistentContainer.viewContext
////        context.refreshAllObjects()
////
////        //context.refreshAllObjects()
//////        if !context.hasChanges {
//////            if arrayObjects.count > 0 {
//////                arrayObjects[0]!.name = arrayObjects[0]!.name
//////            }
//////        }
////
////        if context.hasChanges {
////            //updateTurn()
////        }
////
//////         do {
//////            try context.save()
//////        } catch {
//////                let nserror = error as NSError
//////            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//////        }
//
//        tasksViewController.reloadData()
    }


    // MARK: func move cell UIGestureRecognizer
    
//    @objc func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
//
//        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
//        //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
//
//            let tableView = tasksViewController!
//
//            let longPress = gestureRecognizer as! UILongPressGestureRecognizer
//            let state = longPress.state
//            let locationInView = longPress.location(in: tableView)
//            let indexPath = tableView.indexPathForRow(at: locationInView)
//
//    //        let locationInView = longPress.locationInView(tableView)
//    //          let indexPath = tableView.indexPathForRowAtPoint(locationInView)
//
//            struct My {
//                static var cellSnapshot : UIView? = nil
//                static var cellIsAnimating : Bool = false
//                static var cellNeedToShow : Bool = false
//            }
//            struct Path {
//                static var initialIndexPath : IndexPath? = nil
//            }
//            switch state {
//            case UIGestureRecognizerState.began:
//                if indexPath != nil {
//                    Path.initialIndexPath = indexPath
//                    let cell = tableView.cellForRow(at: indexPath!) as UITableViewCell?
//                    My.cellSnapshot  = snapshotOfCell(cell!)
//                    var center = cell?.center
//                    My.cellSnapshot!.center = center!
//                    My.cellSnapshot!.alpha = 0.0
//                    tableView.addSubview(My.cellSnapshot!)
//                    UIView.animate(withDuration: 0.25, animations: { () -> Void in
//                        center?.y = locationInView.y
//                        My.cellIsAnimating = true
//                        My.cellSnapshot!.center = center!
//                        My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
//                        My.cellSnapshot!.alpha = 0.98
//                        cell?.alpha = 0.0
//                    }, completion: { (finished) -> Void in
//                        if finished {
//                            My.cellIsAnimating = false
//                            if My.cellNeedToShow {
//                                My.cellNeedToShow = false
//                                UIView.animate(withDuration: 0.25, animations: { () -> Void in
//                                    cell?.alpha = 1
//                                })
//                            } else {
//                                cell?.isHidden = true
//                            }
//                        }
//                    })
//                }
//            case UIGestureRecognizerState.changed:
//                if My.cellSnapshot != nil {
//                    var center = My.cellSnapshot!.center
//                    center.y = locationInView.y
//                    My.cellSnapshot!.center = center
//                    if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
//                         arrayObjects.insert(arrayObjects.remove(at: Path.initialIndexPath!.row), at: indexPath!.row)
//                        tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
//                        Path.initialIndexPath = indexPath
//                    }
//                }
//            default:
//                if Path.initialIndexPath != nil {
//                    let cell = tableView.cellForRow(at: Path.initialIndexPath!) as UITableViewCell?
//                    if My.cellIsAnimating {
//                        My.cellNeedToShow = true
//                    } else {
//                        cell?.isHidden = false
//                        cell?.alpha = 0.0
//                    }
//                    UIView.animate(withDuration: 0.25, animations: { () -> Void in
//                        My.cellSnapshot!.center = (cell?.center)!
//                        My.cellSnapshot!.transform = CGAffineTransform.identity
//                        My.cellSnapshot!.alpha = 0.0
//                        cell?.alpha = 1.0
//                    }, completion: { (finished) -> Void in
//                        if finished {
//                            Path.initialIndexPath = nil
//                            My.cellSnapshot!.removeFromSuperview()
//                            My.cellSnapshot = nil
//                        }
//                    })
//                }
//                saveObjects()
//                loadData()
//            }
//        }
//
//        func snapshotOfCell(_ inputView: UIView) -> UIView {
//            UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
//            inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
//            let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
//            UIGraphicsEndImageContext()
//            let cellSnapshot : UIView = UIImageView(image: image)
//            cellSnapshot.layer.masksToBounds = false
//            cellSnapshot.layer.cornerRadius = 0.0
//            cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
//            cellSnapshot.layer.shadowRadius = 5.0
//            cellSnapshot.layer.shadowOpacity = 0.4
//            return cellSnapshot
//        }
            
    
} // class func


//// MARK: class CheckBox
//   class CheckBox: UIButton {
//      //Images
//       let checkedImage = UIImage(named: "checkPlus")! as UIImage
//       let uncheckedImage = UIImage(named: "checkEmpty")! as UIImage
//
//      //Bool property
//       var isChecked: Bool = false {
//           didSet{
//               if isChecked == true {
//                self.setImage(checkedImage, for: UIControl.State.normal)
//               } else {
//                self.setImage(uncheckedImage, for: UIControl.State.normal)
//               }
//           }
//       }
//
//       override func awakeFromNib() {
//        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
//           self.isChecked = false
//       }
//
//    @objc func buttonClicked(sender: UIButton) {
//           if sender == self {
//               isChecked = !isChecked
//           }
//       }
//   }
    
    extension AppDelegate {
       static var shared: AppDelegate {
          return UIApplication.shared.delegate as! AppDelegate
       }
    var rootViewController: TasksViewController {
          return window!.rootViewController as! TasksViewController
       }
    }


