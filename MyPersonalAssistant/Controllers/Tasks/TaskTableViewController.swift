//
//  TaskTableViewController.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 14.04.2020.
//  Copyright © 2020 Vladimir Rice. All rights reserved.
//

//protocol CurrencySelectedDelegate {
//    func currencySelected(currentObject: Any)
//    //func currencySelectedObjects(arrayObjectsDelegate: Any)
//}


import UIKit
import CoreData

//import UserNotifications

class TaskTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate
        ,UIImagePickerControllerDelegate
        ,UINavigationControllerDelegate
        //,UIContextMenuInteractionDelegate
        ,UNUserNotificationCenterDelegate
        ,UIPickerViewDelegate
        ,UIPickerViewDataSource
        ,NSFetchedResultsControllerDelegate
        ,CurrencySelectedDelegate
{
    

    var currentObject: Tasks?// = Tasks()
    var categorys: [Category]?
    //var arrayObjectsALLDdelegateViewController: [Tasks?]?
    
    let minDateFormat = "EEEE.dd.MM.yyyy HH:mm"
    var datePicker  =  UIDatePicker ()
    var InitialView = ""
    var objectReloadData: GalleryCollectionView?
    //private let transition = PanelTransition()
    
    var currentTagButton = 0
    var arrayNomenklature: [Nomenklature]?
    
    var cellsAppPro = [1]
     
    //var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    var modelController: ModelController! = ModelController()
    var refreshControlTable = UIRefreshControl()
    //var notificationDelegate: UNUserNotificationCenterDelegate?
    var delegateViewController: TasksViewController!
    //var currentParentObject: Tasks?
    var currentListObject: ListTasks!
    
//    var aColorsRU: [String] = ["<не выбран>","Красный","Желтый","Зеленый"]
//    var aColors: [String] = ["","R","Y","G"]
//    var aColorsRU: [String]
//    var aColors: [String]
    var sColors = SColors()
    //var statusText = " "
    
    
    @IBOutlet weak var IsCloseButton: UIButton!
    @IBOutlet weak var headingTextField: UITextField!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var prioritetSegmControl: UISegmentedControl!
    @IBOutlet weak var dateTerminationTextField: UILabel!
    //@IBOutlet weak var dateNotificationTextField: UILabel!
    
    @IBOutlet weak var image0ImageView: UIImageView!
    @IBOutlet weak var image1ImageView: UIImageView!
    @IBOutlet weak var image2ImageView: UIImageView!
    
    @IBOutlet weak var imageCell0: UITableViewCell!
    @IBOutlet weak var imageTaskImageView: UIImageView!
    @IBOutlet weak var saveButtonItem: UIBarButtonItem!
    @IBOutlet weak var stopButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var lockedButton: UIButton!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var shablonButton: UIButton!
    @IBOutlet weak var openTextButton: UIButton!
    
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var dateStepper: UIStepper!
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var listNameLabel: UILabel!
    
    //@IBOutlet var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        
        addObject()
                
        Functions.updateColorTask(currentObject: currentObject!, tableView: tableView)
        
        let colorInt = currentObject!.color! as? Int ?? 0
        colorLabel.text = sColors.aColorsRU[colorInt]
        
        var category = currentObject!.category
        if category == nil {
            category = "<не выбрана>"
        }
        categoryLabel.text = category
        categorys = CategoryData.dataLoad(strPredicate: "", filter: "")


        Functions.updateEnabledTask(currentObject: currentObject!, button: lockedButton)
        
        //
        
        refreshControlTable.addTarget(self, action: #selector(saveTasksControl), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
//        if InitialView == "" {
//            stopButtonItem.isEnabled = false
//        }
//
        
        if InitialView == "" {
            let backButton = UIBarButtonItem(title: "Назад", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backAction))
            navigationItem.leftBarButtonItem = backButton
            stopButtonItem.isEnabled = false
            stopButtonItem.title = ""
            stopButtonItem.tintColor = UIColor.clear
        }
        
        headingTextField.text   = currentObject!.heading
        nameTextView.text       = currentObject!.name
        prioritetSegmControl.selectedSegmentIndex       = currentObject!.priority as! Int
        let dateTermination = currentObject!.dateTermination
         if dateTermination != nil {
            dateTerminationTextField.text = Functions.dateToString(date: dateTermination!)
         }
//        let dateNotification = currentObject!.dateNotification
//         if dateNotification != nil {
//             dateNotificationTextField.text = Functions.dateToString(date: dateNotification!)
//         }
         //navigationItem.title = nameTextView.text
        if currentObject!.imageTask != nil {
             imageTaskImageView.image = UIImage(data: currentObject!.imageTask!)
         }

         // border textView
         nameTextView.layer.borderWidth = 0.3
         nameTextView.layer.borderColor = UIColor.black.cgColor

        if currentObject!.image0 != nil {
            image0ImageView.image = UIImage(data: currentObject!.image0!)
        }
        if currentObject!.image1 != nil {
            image1ImageView.image = UIImage(data: currentObject!.image1!)
        }
        if currentObject!.image2 != nil {
            image2ImageView.image = UIImage(data: currentObject!.image2!)
        }
        
        // keyboard
        self.headingTextField.delegate = self
        self.nameTextView.delegate = self
        //
        //nameTextView.addDoneButton(title: "Готово", target: self, selector: #selector(tapDoneImage(sender:)))
        nameTextView.addDoneButtonOnKeyboard()
        headingTextField.addDoneButtonOnKeyboard()
        //
        
        
        updateAttributes()
        
        imageTaskImageView.isUserInteractionEnabled = true
        imageTaskImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
       
        image0ImageView.isUserInteractionEnabled = true
        image0ImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(image0Tapped(_:))))
        image1ImageView.isUserInteractionEnabled = true
        image1ImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(image1Tapped(_:))))
        image2ImageView.isUserInteractionEnabled = true
        image2ImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(image2Tapped(_:))))

        view.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        
        colorLabel.isUserInteractionEnabled = true
        colorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTappedColor)))
  
        categoryLabel.isUserInteractionEnabled = true
        categoryLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTappedCategory)))

        // listLabel
        listNameLabel.text = currentObject?.listName
        listNameLabel.isUserInteractionEnabled = true
        listNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTappedList)))

        
        isDisableAppPRO()
        // timer
//        if PublicVars().autoSaveCloseForm {
//            saveButtonItem.isEnabled = false
//        }
        
//        let timeInterval = Double(UserDefaults.standard.object(forKey: "timerSave") as? String ?? "10")
//        if timeInterval! > 0.00 {
//            Timer.scheduledTimer(timeInterval: timeInterval!, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
//        }
//        statusText.textColor = UIColor.red
        
        if currentObject!.go {
            goButton.setImage(UIImage(named: "checkPlus"), for: .normal)
        } else {
            goButton.setImage(UIImage(named: "checkEmpty"), for: .normal)
        }

        goButton.addTarget(self, action:#selector(goButtonClicked(_:)), for: UIControl.Event.touchUpInside)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backAction(){
        if PublicVars().autoSaveCloseForm {
            saveObjects()
        }
        delegateViewController.sectionsFilters()
        //delegateViewController.tasksViewController.reloadData()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateAttributes()
    }

    
   
    // MARK: delegate text
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
  
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isUpperString = Functions.isUpperString()
        if isUpperString == true {
            textField.text = textField.text!.capitalizingFirstLetter()
        }
    }

    
    //override func touches
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         nameTextView.resignFirstResponder()
     }
    
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        nameTextView.resignFirstResponder()
//    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
         textView.becomeFirstResponder()
     }
    
//    override func tableView(_ tableView: UITableView,
//      contextMenuConfigurationForRowAt indexPath: IndexPath,
//      point: CGPoint) -> UIContextMenuConfiguration? {
//
//        let favorite = UIAction(title: "Favorite") { _ in return }
//      let share = UIAction(title: "Share") { _ in return }
//      let delete = UIAction(title: "Delete") { _ in return }
//
//      return UIContextMenuConfiguration(identifier: nil,
//        previewProvider: nil) { _ in
//        UIMenu(title: "Actions", children: [favorite, share, delete])
//      }
//    }
    
    // MARK: - Table view data source
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let vw = UIView()
//        vw.backgroundColor = UIColor.red
//
//        return vw
//    }
//    private func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//       if textField == dateTerminationTextField {
//          return false
//       }
//       return true
//    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var titleOfSection = ""
        switch section {
        //case 0:
            //titleOfSection = currentObject!.name!
            //titleOfSection = statusText
        case 1:
            titleOfSection = "Дополнительные даные"
        case 2:
            titleOfSection = "Фото"
        default:
            titleOfSection = ""
        }
        
 //       var appPro = PublicVars().appPro
//        var appForItunes = PublicVars().appForItunes

//        if !appForItunes && (section == 1 || cellsAppPro.contains(section)) {
//            return nil
//        }
//        return super.tableView(tableView, titleForHeaderInSection: section)
        
        return titleOfSection
    }
    
//    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//
//        var titleOfSection = ""
//        if section == 0 {
//            titleOfSection = statusText
//        }
//        return titleOfSection
//    }
    
//    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        if section == 0 {
//            view.tintColor = UIColor.white
//            let header = view as! UITableViewHeaderFooterView
//            header.textLabel?.textColor = UIColor.red
//
//        } else {
//            view.tintColor = UIColor.white
//            let header = view as! UITableViewHeaderFooterView
//            header.textLabel?.textColor = UIColor.black
//        }
//    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        var appPro = PublicVars().appPro
////         var appForItunes = PublicVars().appForItunes
////
////         if !appPro && appForItunes && cellsAppPro.contains(section) {
////             return 1
////         }
//           return super.tableView(tableView, numberOfRowsInSection: section)
//    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = super.tableView(tableView, cellForRowAt: indexPath)
//        if indexPath.section == 2 {
//
//        }
//        return cell
//    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = super.tableView(tableView, cellForRowAt: indexPath)
//        if !currentObject!.isEnabled {
//            cell.selectionStyle = .none;
//            cell.isUserInteractionEnabled = false
//        } else {
//            enterDate(indexPath: indexPath)
//        }
        
    }


//    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if indexPath.section == 0 && indexPath.row == 0 {
//            return indexPath
//        }
//        return nil
//    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell1", for: indexPath)
//
//         //Configure the cell...
//
//        return cell
//    }
    


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return ((currentObject?.isEnabled) != nil)
    }


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

    //MARK: delegate contextMenu
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
//
//        let favorite = UIAction(title: "Открыть",
//          image: UIImage(systemName: "heart.fill")) { _ in
//          // Perform action
//        }
//
////        let share = UIAction(title: "Share",
////          image: UIImage(systemName: "square.and.arrow.up.fill")) { action in
////          // Perform action
////        }
//
//        let delete = UIAction(title: "Удалить",
//          image: UIImage(systemName: "trash.fill"),
//          attributes: [.destructive]) { action in
//           // Perform action
//         }
//
//         return UIContextMenuConfiguration(identifier: nil,
//           previewProvider: nil) { _ in
//           UIMenu(title: "", children: [favorite, delete])
//         }
//    }
    
    // MARK: - UNUserNotificationCenterDelegate
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        //_ = notification.request.content
        // Process notification content
        completionHandler([.alert, .badge, .sound])
    }
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            //print(response.notification.request.content.userInfo)
            //actions defination
            switch response.actionIdentifier {
//            case UNNotificationDismissActionIdentifier:
//                print("Dismiss Action")
//            case UNNotificationDefaultActionIdentifier:
//                print("Default")
            case "openAppAction":
                print("openAppAction")
                _ = Date().add(minutes: 5)
//                UserNotificationManager.shared.addNotificationWithCalendarTrigger(title: "Предупреждение!", subtitle: subtitle!, body: body, nextDate: nextDate!)

            case "Delete":
                print("Delete")
            default:
                print("Unknown action")
            }
            
            completionHandler()
        }

    
    // MARK: - picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1 || pickerView.tag == 2 {
            return 1
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return sColors.aColorsRU.count
        }
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
        if pickerView.tag == 1 {
            colorLabel.text = sColors.aColorsRU[pickerView.selectedRow(inComponent: 0)]
            //currentObject?.color = sColors.aColors[pickerView.selectedRow(inComponent: 0)]
            currentObject?.color = NSNumber(value: pickerView.selectedRow(inComponent: 0))
            //let section = IndexSet(integer: 1)
            //tableView.reloadSections(section, with: .automatic)
            Functions.updateColorTask(currentObject: currentObject!, tableView: tableView)
        }
        if pickerView.tag == 2{
            categoryLabel.text = categorys![pickerView.selectedRow(inComponent: 0)].name
                currentObject?.category = categoryLabel.text
            if currentObject?.color == 0 {
                currentObject?.color = categorys![pickerView.selectedRow(inComponent: 0)].color
                colorLabel.text = sColors.aColorsRU[currentObject?.color as! Int]
             
                Functions.updateColorTask(currentObject: currentObject!, tableView: tableView)
            }
            
            //NSNumber(value: pickerView.selectedRow(inComponent: 0))
            //let section = IndexSet(integer: 1)
            //tableView.reloadSections(section, with: .automatic)
            
            //Functions.updateColorTask(currentObject: currentObject!, tableView: tableView)
        }

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "nameText" {
            let destinationVC = segue.destination as! TextNameViewController
            destinationVC.taskTableViewController = self
            //destinationVC.nameTextViewText = nameTextView.text
        }
    }
    

    // MARK: action
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        saveObjects()
        //self.dismiss(animated: true, completion: nil)
    }
//    @IBAction func dateTerminationTextField(_ sender: UITextField) {
//        showDatePickerTextField(sender: sender)
//    }
//    @IBAction func dateNotificationTextField(_ sender: UITextField) {
//        showDatePickerTextField(sender: sender)
//    }
 
//    @IBAction func photoButton(_ sender: UIButton) {
//        currentTagButton = sender.tag
//        cameraButtonPressed()
//        tableView.reloadData()
//
//    }
//    @IBAction func deletePhotoButton(_ sender: UIButton) {
//        currentTagButton = sender.tag
//        switch currentTagButton {
//        case 0:
//            imageCell0.imageView?.image = UIImage()
//        case 1:
//            imageCell1.imageView?.image = UIImage()
//        case 2:
//            imageCell2.imageView?.image = UIImage()
//
//        default:
//            imageCell0.imageView?.image = UIImage()
//        }
//    }
    
//    @IBAction func openPhotoButton(_ sender: UIButton) {
//
//        currentTagButton = sender.tag
// //       var currentImage: UIImage?//UIImage()
// //        switch currentTagButton {
// //        case 0:
// //            currentImage = imageCell0.imageView?.image!
// //        case 1:
// //            currentImage = imageCell1.imageView?.image!
// //        case 2:
// //            currentImage = imageCell2.imageView?.image!
// //
// //        default:
// //            currentImage = UIImage()
// //        }
// //        if currentImage == nil {
// //            return
// //        }
// //        if currentImage == currentImage {
//            let imageViewController = storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
//            imageViewController.currentImage = currentImage
//            navigationController?.pushViewController(imageViewController, animated: true)
//            navigationController?.navigationItem.backBarButtonItem?.title = "Назад"
//        }
////    }
    
//    @IBAction func CloseSwitch(_ sender: UISwitch) {
//        currentObject.isClose = sender.isOn
//        updateAttributes()
//    }
    
    
    @IBAction func closeTaskButton(_ sender: UIButton) {
        if currentObject?.isEnabled == false {
            return
        }
        currentObject!.isClose = !currentObject!.isClose
        if currentObject!.isClose {
            currentObject!.dateTermination = nil
            dateTerminationTextField.text = ""
        }
        updateAttributes()
    }
    
    @IBAction func openNomenklature(_ sender: UIButton) {
        openModalViewControllerNomenklature()
    }
    
//    @IBAction func photoTaskButton(_ sender: UIButton) {
//        currentTagButton = sender.tag
//        cameraButtonPressedTask(sender: sender)
//            tableView.reloadData()
//    }
    
    @IBAction func closeForm(_ sender: UIBarButtonItem) {
        if PublicVars().autoSaveCloseForm {
            saveObjects()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func locked(_ sender: UIButton) {
        currentObject!.isEnabled = !currentObject!.isEnabled
        Functions.updateEnabledTask(currentObject: currentObject!, button: lockedButton)
        tableView.reloadData()
        //tableView.isEditing = currentObject!.isEnabled
        saveObjects()
        updateAttributes()
        
    }
    
    @IBAction func dateUpdateAction(_ sender: UIStepper) {
     
        var senderValue = 1
        if  sender.value <= 0 {
            senderValue = -1
            sender.value = 0
        } else {
            sender.value = 1
        }

        var strDateTermination = dateTerminationTextField.text
        var newDateTermination = Date()
        if strDateTermination == "" {
            //strDateTermination = Functions.dateToString(date: newDateTermination)
            newDateTermination = Functions.currentDateString(currentDateString: "")
            senderValue = 0
        } else {
            newDateTermination = (Functions.dateFromString(dateStr: strDateTermination!) as Date?)!
        }
        
        newDateTermination = (newDateTermination.nextDay(nextValue: senderValue))
        if newDateTermination.startOfDay < Date().startOfDay {
            dateTerminationTextField.text = ""
            currentObject!.dateTermination = nil
        } else {
            dateTerminationTextField.text = Functions.dateToString(date: newDateTermination)
            currentObject!.dateTermination = newDateTermination
        }

    }

    // MARK: cameraButton
    func cameraButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.editedImage] as? UIImage else { return }
        //imageImageView.image = userPickedImage
        picker.dismiss(animated: true)
        switch currentTagButton {
        case 0:
            image0ImageView!.image = userPickedImage
        case 1:
            image0ImageView!.image = userPickedImage
        case 2:
            image0ImageView!.image = userPickedImage
        case 10: //
            imageTaskImageView.image = userPickedImage
            currentObject!.imageTask = userPickedImage.pngData()
        default:
            image0ImageView.image = nil//UIImage()
        }
        
        self.tableView.reloadData()
    }
//    func cameraButtonPressedTask() {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.allowsEditing = true
//        picker.sourceType = .photoLibrary
//        present(picker, animated: true)
//    }

    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        if currentObject?.isEnabled == false {
            return
        }
        
        alertImage(image: imageTaskImageView)
//            self.currentTagButton = 10
//            self.cameraButtonPressedTask()
            tableView.reloadData()
    }

    
    // image012
    @objc func image0Tapped(_ sender: UITapGestureRecognizer) {
        alertImage(image: image0ImageView)
//        currentTagButton = 0
//        cameraButtonPressed()
        tableView.reloadData()
    }
    @objc func image1Tapped(_ sender: UITapGestureRecognizer) {
        alertImage(image: image1ImageView)
//        currentTagButton = 1
//        cameraButtonPressed()
        tableView.reloadData()
    }
    @objc func image2Tapped(_ sender: UITapGestureRecognizer) {
        alertImage(image: image2ImageView)
//        currentTagButton = 2
//        cameraButtonPressed()
        tableView.reloadData()
    }
    
    func alertImage(image: UIImageView) {
        let alertImage = UIAlertController(title: "Выберите действие", message: "", preferredStyle: .alert)
        
        if image.image != UIImage(named: "Clear") && image != self.imageTaskImageView {
            alertImage.addAction(UIAlertAction(title: "Открыть для просмотра", style: .default, handler: { (action) -> Void in
                let currentImage = image.image
                if currentImage == nil {
                    return
                }
                if currentImage == currentImage {
                    let imageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
                    imageViewController.currentImage = currentImage
                    //self.navigationController?.navigationItem.backBarButtonItem?.title = "Назад"
                    self.navigationController?.pushViewController(imageViewController, animated: true)
                    
                }
            }))
        }
        //
        alertImage.addAction(UIAlertAction(title: "Редактировать", style: .default, handler: { (action) -> Void in
            if image == self.image0ImageView {
                self.currentTagButton = 0
            }
            if image == self.image1ImageView {
                self.currentTagButton = 1
            }
            if image == self.image2ImageView {
                self.currentTagButton = 2
            }
            if image == self.imageTaskImageView {
                self.currentTagButton = 10
            }

            self.cameraButtonPressed()
        }))
        
        if image.image != UIImage(named: "Clear") {
            alertImage.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { (action) -> Void in
                image.image = UIImage(named: "Clear")
                
            }))
        }
        alertImage.addAction(UIAlertAction(title: "Отказ", style: .cancel, handler: nil))
        
        self.present(alertImage, animated: true)
        
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        //textField.resignFirstResponder()
        if currentObject?.isEnabled == true {
            if sender.state == .began { return }
            let tapLocation = sender.location(in: self.tableView)
            if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
                if tapIndexPath.section == 1 && tapIndexPath.row < 2 {
                    if self.tableView.cellForRow(at: tapIndexPath) != nil{
                        enterDate(indexPath: tapIndexPath)
                        //print("Row Selected")
                    }
                    tableView.endEditing(true)
                }
            }
        }
    }
    
    func addImage(textView: UITextView, image: UIImage) {
        if image == nil {
            return
        }
//        let textView = nameTextView//UITextView(frame: CGRectMake(50, 50, 200, 300))
        
        
        //        let attributedString = NSMutableAttributedString(string: "before after")
        //        let textAttachment = NSTextAttachment()
        //        textAttachment.image = image//UIImage(named: "sample_image.jpg")!
        //
        //        let oldWidth = textAttachment.image!.size.width;
        //
        //        //I'm subtracting 10px to make the image display nicely, accounting
        //        //for the padding inside the textView
        //        let scaleFactor = oldWidth / (textView!.frame.size.width - 10);
        //        textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
        //        var attrStringWithImage = NSAttributedString(attachment: textAttachment)
        //        attributedString.replaceCharacters(in: NSMakeRange(6, 1), with: attrStringWithImage)
        //        textView!.attributedText = attributedString;
        //        //self.view.addSubview(textView!)
        
        
//        let attributedString = NSMutableAttributedString(string: "before after")
//        let textAttachment = NSTextAttachment()
//        textAttachment.image = image//UIImage(named: "sample_image.jpg")!
//
//        let oldWidth = textAttachment.image!.size.width;
//
//        //I'm subtracting 10px to make the image display nicely, accounting
//        //for the padding inside the textView
//        let scaleFactor = oldWidth / (textView.frame.size.width - 10);
//        textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
//        var attrStringWithImage = NSAttributedString(attachment: textAttachment)
//        attributedString.replaceCharacters(in: NSMakeRange(6, 1), with: attrStringWithImage)
//        textView.textStorage.insert(attributedString, at: textView.selectedRange.location)
        
        //        //create your UIImage
        //        let image = image//UIImage(named: change_arr[indexPath.row]);
        //        //create and NSTextAttachment and add your image to it.
        //        let attachment = NSTextAttachment()
        //        attachment.image = image
        //        //put your NSTextAttachment into and attributedString
        //        let attString = NSAttributedString(attachment: attachment)
        //        //add this attributed string to the current position.
        //        textView.textStorage.insert(attString, at: textView.selectedRange.location)
        
        let attributes: [NSAttributedString.Key: Any] = [
                    //.font: font,
                    .foregroundColor: UIColor.orange
                    ]
        let myString = NSMutableAttributedString(string: "Text at the beginning\n",
                                                         attributes: attributes)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image//UIImage(named: "apple.jpg")!
        let imageSize = imageAttachment.image!.size.width;
        
        // calculate how much to resize our image
        // here we are doing it base on the space available in the view
        var frameSize = self.view.frame.size.width - 100;
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        let height = self.view.frame.size.height - topBarHeight - 100;
        if(height < frameSize) {
            frameSize = height;
        }
        
        frameSize = 50
        let scaleFactor = imageSize / frameSize;
        
        // scale the image down
        imageAttachment.image = UIImage(cgImage: imageAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
        
        // create attributed string from image so we can append it
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        // add the NSTextAttachment wrapper to our original string, then add some more text.
        myString.append(imageString)
        myString.append(NSAttributedString(string: "\nTHE END!!!", attributes: attributes))
        
        // set the text for the UITextView
        textView.attributedText = myString;
    }
    
    
    // MARK: - func
    
    @objc func tapDoneImage(sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc func saveTasksControl(){
        saveObjects()
        refreshControlTable.endRefreshing()
        //self.dismiss(animated: true, completion: nil)
    }
    func saveObjects(){
        //1
        //currentObject.name = listNameLabel.text
        currentObject!.heading = headingTextField.text
        currentObject!.name = nameTextView.text
        currentObject!.priority = NSNumber(value: prioritetSegmControl.selectedSegmentIndex)
        let dateTermination = dateTerminationTextField.text
        currentObject!.dateTermination = Functions.dateFromString(dateStr: dateTermination!) as Date?
//        let dateNotification = dateNotificationTextField.text
//        currentObject!.dateNotification = Functions.dateFromString(dateStr: dateNotification!) as Date?
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        if image0ImageView.image != nil {
            currentObject!.image0 = image0ImageView.image!.pngData()
        }
        if image1ImageView.image != nil {
            currentObject!.image1 = image1ImageView.image!.pngData()
        }
        if image2ImageView.image != nil {
            currentObject!.image2 = image2ImageView.image!.pngData()
        }
        
        UserNotificationManager().setNotificationTask(object: currentObject!)
        
//        // notifications
//        var strDeleteNotifications: [String] = []
//        //let endOfDay = Date().endOfDay
//        let startOfDay = Date().startOfDay
//        
////        if !dateTermination!.isEmpty && currentObject!.dateTermination! >= startOfDay {
////
////            let subtitle = currentObject!.heading
////            let body =  "Дата окончания: " + dateTermination!
////            + "\n" + "Дата оповещения: " + dateNotification!
////            + "\n" + currentObject!.heading!
////
////            let badge = 1
////            let nextDate = currentObject!.dateTermination
////            UserNotificationManager.shared.addNotificationWithCalendarTrigger(identifier: currentObject!.id!+"##"+"dateTermination", title: "Предупреждение!", subtitle: subtitle!, body: body, badge: badge, nextDate: nextDate!)
////        }
////
//        if dateTermination!.isEmpty || currentObject!.dateTermination! < startOfDay {
//            strDeleteNotifications.append(currentObject!.id!+"##"+"dateTermination")
//        }
//        
//        if !dateNotification!.isEmpty && currentObject!.dateNotification! >= startOfDay {
//            
//            let subtitle = currentObject!.heading
//            let body =  "Дата окончания: " + dateTermination!
//            + "\n" + "Дата оповещения: " + dateNotification!
//            + "\n" + currentObject!.heading!
//            
//            let badge = 0
//            let nextDate = currentObject!.dateNotification
//            addNotificationWithCalendarTrigger(identifier: currentObject!.id!+"##"+dateNotification!, title: "Предупреждение!", subtitle: subtitle!, body: body, badge: badge, nextDate: nextDate!)
//            
//          //  probaSendNotification()
//        }
//        
//        if dateNotification!.isEmpty || currentObject!.dateNotification! < startOfDay {
//            strDeleteNotifications.append(currentObject!.id!+"##"+"dateNotification")
//        }
//
//        UserNotificationManager.shared.deleteNotifications(identifiers: strDeleteNotifications)
//        
//        UserNotificationManager.shared.deleteOverduePendingNotifications()
//        
//        UIApplication.shared.applicationIconBadgeNumber = TasksData.quantyTasksForBadgeNotifications(date: Date())
            
            
        delegateViewController.currentListObject?.updatedDate = Date()
        
        appDelegate.saveContext()
        
       if objectReloadData != nil {
        objectReloadData!.set(cells: TasksModelMenu.fetchTasks())
            objectReloadData!.reloadData()
        }
        
        delegateViewController.sectionsFilters()
        delegateViewController.tasksViewController.reloadData()
        
    }
 
//    func probaSendNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "Meeting Reminder"
//        content.subtitle = "messageSubtitle"
//        content.body = "Don't forget to bring coffee."
//        //content.badge = 1
//
//        let repeatAction = UNNotificationAction(identifier:"repeat",
//            title:"Repeat",options:[])
//        let changeAction = UNTextInputNotificationAction(identifier:
//            "change", title: "Change Message", options: [])
//
//        let category = UNNotificationCategory(identifier: "actionCategory",
//             actions: [repeatAction, changeAction],
//            intentIdentifiers: [], options: [])
//
//        content.categoryIdentifier = "actionCategory"
//
//        UNUserNotificationCenter.current().setNotificationCategories(
//                                [category])
//
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
//                repeats: false)
//
//        let requestIdentifier = "demoNotification"
//        let request = UNNotificationRequest(identifier: requestIdentifier,
//            content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request,
//            withCompletionHandler: { (error) in
//                // Handle error
//        })
//
////        let repeatAction = UNNotificationAction(identifier:"repeat",
////            title:"Repeat",options:[])
////        let changeAction = UNTextInputNotificationAction(identifier:
////            "change", title: "Change Message", options: [])
////
////        let category = UNNotificationCategory(identifier: "actionCategory",
////             actions: [repeatAction, changeAction],
////            intentIdentifiers: [], options: [])
////
////        content.categoryIdentifier = "actionCategory"
////
////        UNUserNotificationCenter.current().setNotificationCategories(
////                                [category])
//    }
    
    func addNotificationWithCalendarTrigger(identifier: String, title: String, subtitle: String, body: String, badge: Int?, nextDate: Date?) {
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = subtitle
            content.body = body
            content.badge = badge as NSNumber?
            
            content.sound = UNNotificationSound.default
            
    //        var delayTimeTrigger: UNTimeIntervalNotificationTrigger?

    //        if let nextDate = nextDate {
    //            delayTimeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(nextDate), repeats: false)
    //        }

            if let badge = badge {
                var currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
                currentBadgeCount += badge
                content.badge = NSNumber(integerLiteral: currentBadgeCount)
            }
            
            
            let components = NSDateComponents()
            
            let calendar = Calendar(identifier: .gregorian)
            components.year = (calendar.component(.year, from: nextDate! as Date))
            components.month = (calendar.component(.month, from: nextDate! as Date))
            components.day = (calendar.component(.day, from: nextDate! as Date))
            components.hour = (calendar.component(.hour, from: nextDate! as Date))
            components.minute = (calendar.component(.minute, from: nextDate! as Date))
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components as DateComponents, repeats: true)
            
            //print("trigger.nextTriggerDate()::::\(trigger.nextTriggerDate())")

            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                //handle error
            }
            
            let action1 = UNNotificationAction(identifier: identifier+"##"+"deleteAction", title: "Удалить уведомление", options: [.destructive])
            let action2 = UNNotificationAction(identifier: identifier+"##"+"openAppAction", title: "Action Second", options: [.foreground])
            
            let category = UNNotificationCategory(identifier: "actionCategory", actions: [action1,action2], intentIdentifiers: [], options: [])
            
            UNUserNotificationCenter.current().setNotificationCategories([category])
            
            
        }
    func updateAttributes() {
        
        if currentObject!.isClose {
            //isCloseLabel.text = "Задача ЗАКРЫТА"
            //IsCloseButton.imageView!.image = UIImage(named: "checkPlus")
            IsCloseButton.setImage(UIImage(named: "checkPlus"), for: .normal)
            let label = headingTextField
            let attributes:[NSAttributedString.Key:Any] = [
                //                .font : UIFont.systemFont(ofSize: 100),
                .backgroundColor: UIColor.lightGray.withAlphaComponent(0.5),
                //                .strokeWidth : -2,
                //                .strokeColor : UIColor.black,
                //                .foregroundColor : UIColor.gray,
                .strikethroughStyle: 1,
            ]
            let attributesAttributedString = NSAttributedString(string: label!.text!, attributes: attributes)
            label!.attributedText = attributesAttributedString
            label?.backgroundColor = UIColor.lightGray
            label?.textColor = UIColor.gray
            
        } else {
            //IsCloseButton.imageView!.image = UIImage(named: "checkEmpty")
            IsCloseButton.setImage(UIImage(named: "checkEmpty"), for: .normal)
            let label = headingTextField
            let attributes:[NSAttributedString.Key:Any] = [
                //                .font : UIFont.systemFont(ofSize: 100),
                .backgroundColor : UIColor.white,
                //                .strokeWidth : -2,
                //                .strokeColor : UIColor.black,
                //                .foregroundColor : UIColor.gray,
                .strikethroughStyle: 0,
            ]
            let attributesAttributedString = NSAttributedString(string: label!.text!, attributes: attributes)
            label!.attributedText = attributesAttributedString
            label!.backgroundColor = UIColor.white
            label?.textColor = UIColor.black
        }
        
        let isEnabled = currentObject?.isEnabled ?? true
        IsCloseButton.isEnabled = isEnabled
        headingTextField.isEnabled = isEnabled
        nameTextView.isEditable = isEnabled
        prioritetSegmControl.isEnabled = isEnabled
        dateTerminationTextField.isEnabled = isEnabled
//        image0ImageView.is = isEnabled
//        image2ImageView.isEnabled = isEnabled
//        imageCell0.isEnabled = isEnabled
//        saveButtonItem.isEnabled = isEnabled == !PublicVars().autoSaveCloseForm
        colorLabel.isEnabled = isEnabled
        shablonButton.isEnabled = isEnabled
        openTextButton.isEnabled = isEnabled
        IsCloseButton.isEnabled = isEnabled
    }

    @objc func goButtonClicked(_ sender: UIButton){
        currentObject!.go = !currentObject!.go
        if currentObject!.go {
            goButton.setImage(UIImage(named: "checkPlus"), for: .normal)
        } else {
            goButton.setImage(UIImage(named: "checkEmpty"), for: .normal)
        }
    }
    
//    private func setAttributedStringLabel(label: UILabel, AttributesKey: NSAttributedString.Key, attribut: Any) {
//        let text = label.text
//        let attributes: [NSAttributedString.Key: Any] = [AttributesKey: attribut]
//        label.attributedText = NSAttributedString(string: text!, attributes: attributes)
//    }
//
//    private func setAttributedStringTextField(label: UITextField, AttributesKey: NSAttributedString.Key, attribut: Any) {
//        let text = label.text
//        let attributes: [NSAttributedString.Key: Any] = [AttributesKey: attribut]
//        label.attributedText = NSAttributedString(string: text!, attributes: attributes)
//    }
    

    func enterDate(indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                openModalDateViewController(strViewController: "pickerDateViewController", currentLabelDate: dateTerminationTextField!)
            }
//            if indexPath.row == 2 {
//                openModalDateViewController(strViewController: "pickerDateViewController", currentLabelDate: dateNotificationTextField!)
//            }
            
        }
    }

    func addObject(){
        if currentObject == nil {
            let appDelegate =
                UIApplication.shared.delegate as! AppDelegate

            let context = appDelegate.persistentContainer.viewContext

            var objectsALL = TasksData.dataLoad(strPredicate: "idList = %@", filter: (currentListObject.id)!)
            //var objectsALL = delegateViewController.arrayObjectsAll
            
            let newObject = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context)
            currentObject = newObject as? Tasks
            currentObject!.id = UUID().uuidString
            currentObject?.idList = currentListObject.id
            currentObject?.listName = currentListObject.name
            
            //objectsALL.append(currentObject!)
            
            //delegateViewController.arrayObjectsAll = objectsALL
            ////delegateViewController!.tasksViewController.reloadData()
            //let indexPath = IndexPath(row: delegateViewController.arrayObjectsAll.count-1, section: 0)
            //let indexPath = IndexPath(row: objectsALL.count-1, section: 0)
            ////delegateViewController!.tasksViewController.insertRows(at: [indexPath], with: .automatic)
//            delegateViewController!.tasksViewController.reloadData()
//            delegateViewController.selectedSegment(index: delegateViewController.statusTaskSegmentedControl.selectedSegmentIndex)
        }
    }
    
    @objc func viewTappedColor() {
        if currentObject?.isEnabled == false {
            return
        }
        let isButton = PublicVars().appPro
        if !isButton {
            return
        }
        let title = "Выбор цвета"
        let message = "\n\n\n\n\n\n\n\n\n\n";
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let pickerFrame: CGRect = CGRect(x: 0, y: 52, width: 270, height: 160); //
        let myPickerView: UIPickerView = UIPickerView(frame: pickerFrame);

        myPickerView.delegate = self
        myPickerView.dataSource = self
        myPickerView.backgroundColor = UIColor.white
        myPickerView.tag = 1
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
    
    @objc func viewTappedCategory() {
        if currentObject?.isEnabled == false {
            return
        }
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
//            {
//            myPickerView.frame.size.width = alertView.view.frame.size.width
//        })
    }
    
    @objc func viewTappedList() {
        openModalViewController()
    }
    
    func openModalViewController() {

        let initialController = self.storyboard?.instantiateViewController(withIdentifier:
            "pickerViewController") as? PickerViewController

        let listArray = ListTasksData.dataLoad(strPredicate: "", filter: "")
        let currArrayValue = "name"
        
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
    func isDisableAppPRO() {
        let isButton = PublicVars().appPro
        lockedButton.isEnabled = isButton
        colorLabel.isEnabled = isButton
    }
    
    @objc func fireTimer(){
//    updateStatus(text: "Автосохранение...")
//        let setImage = saveButtonItem.image
//        saveButtonItem.image = UIImage(named: "attentionLite")
//        saveObjects()

//        sleep(3)
//
        updateStatus(text: "Автосохранение выполнено")
        //saveButtonItem.image = setImage
    }
    
    func updateStatus(text: String) {
        
        statusText.text = text
        if statusText.textColor == UIColor.red {
            statusText.textColor = UIColor.green
        } else {
            statusText.textColor = UIColor.red
        }
        //delay(0.3, closure: {
                // put her any code you want to fire it with delay
            //tableView(tableView, titleForHeaderInSection: 0)
        //tableView.reloadData()
        
        //self.tableView.beginUpdates()
        //tableView(tableView, titleForHeaderInSection: 0)
        
//        let section = IndexSet(integer: 0)
//        self.tableView.reloadSections(section, with: .automatic)
        
        //self.tableView.endUpdates()
        
        //tableView.reloadData()
//        var indexPaths: [IndexPath] = []
//        indexPaths.append(IndexPath(row: 0, section: 0))
//        indexPaths.append(IndexPath(row: 1, section: 0))
//        tableView.reloadRows(at: indexPaths, with: .automatic)
        

        //tableView.reloadData()

      //      })
        //Functions.alertShort(selfVC: self, title: "Сохранено", message: "", second: 0.02)
    }
    

    // MARK: -
    func currencySelected(currentObject: Any) {
        var object = self.currentObject
        if currentObject is ListTasks {
            listNameLabel.text = (currentObject as AnyObject).name
            //idList = (currentObject as AnyObject).id
            object?.idList = (currentObject as AnyObject).id
            object?.listName = listNameLabel.text
        } else {
            listNameLabel.text = ""
            //idList = ""
            
        }
    }
    
    
} //class


// MARK: -  extension

//extension UITextView {
//    
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
//}

extension TaskTableViewController:
    CurrencySelectedDateDelegate
    , CurrencySnipSelectedDelegate
    //, UIViewControllerTransitioningDelegate

{

    /*
     // MARK: halfModalTransitioningDelegate
     в этом модуле:
     var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
     в вызываемом:
     class PickerViewController:  UITableViewController, HalfModalPresentable
     */
    
    // при инициализации вначале
    //var pickerDelegate = PickerProtocol.self
    
//    func openModalDateViewController(strViewController: String, currentLabelDate: UILabel) {
//        let initialController = self.storyboard?.instantiateViewController(withIdentifier: "pickerDateViewController") as? PickerDateViewController
//        modelController.dataExport.arrayValue.removeAll()
//        modelController.dataExport.arrayValue.append(currentLabelDate.text as Any)
//        modelController.dataExport.arrayValue.append(currentLabelDate as Any)
//        initialController!.modelController = modelController
//        initialController!.delegateViewController = self
//
//        let child = initialController
//        //child!.transitioningDelegate = transition
//        child!.modalPresentationStyle = .custom
//        present(child!, animated: true)
//    }
    
    func currencySelectedDate(currentLabelDate: UILabel, currentDate: Date?) {
      if currentDate == nil {
        currentLabelDate.text = ""
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = minDateFormat //maxDateFormat
        formatter.locale = Locale(identifier: "ru_RU")
        let currentDateStr = formatter.string(from: currentDate!)
        currentLabelDate.text = currentDateStr
        if currentDateStr == "" {
            return
        }
        
//        if currentLabelDate == dateNotificationTextField {
//            return
//        }
        
        let isInterval = UserDefaults.standard.object(forKey: "isInterval") as? Bool ?? false
        if isInterval != true {
            return
        }
//        if dateNotificationTextField.text != "" {
//            return
//        }
//        let year = 0
//        let month = 0
        let day  = UserDefaults.standard.object(forKey: "dayInterval") as? Int ?? 0
        let hour = UserDefaults.standard.object(forKey: "hourInterval") as? Int ?? 0
        let minute  = UserDefaults.standard.object(forKey: "minuteInterval") as? Int ?? 0
        
        //let dateAfterMin = NSDate.init(timeIntervalSinceNow: (Double(minute) * 60.0))
        var nextDate = currentDate
        nextDate = Calendar.current.date(byAdding: .day, value: -day, to: nextDate!)
        nextDate = Calendar.current.date(byAdding: .hour, value: -hour, to: nextDate!)
        nextDate = Calendar.current.date(byAdding: .minute, value: -minute, to: nextDate!)
//        let diffMinute = minute - 60
//        if diffMinute >= 0 {
//            minute = diffMinute
//            hour = hour + 1
//        }
//        let diffHour = minute - 24
//        if diffHour >= 0 {
//            hour = diffHour
//            day = day + 1
//        }

//        let calendar = Calendar(identifier: .gregorian)
//        let components = NSDateComponents()
//        components.year = (calendar.component(.year, from: currentDate! as Date))    + year
//        components.month = (calendar.component(.month, from: currentDate! as Date))  + month
//        components.day = (calendar.component(.day, from: currentDate! as Date))      + day
//        components.hour = (calendar.component(.hour, from: currentDate! as Date))    + hour
//        components.minute = (calendar.component(.minute, from: currentDate! as Date)) + minute
        
//        let nextDate = calendar.date(from: components as DateComponents)
        
//        let currentDateNotificationStr = formatter.string(from: nextDate!)
//        dateNotificationTextField.text = currentDateNotificationStr
    }

    func openModalViewControllerNomenklature() {
        //var currArrayValue = ""
        let initialController = self.storyboard?.instantiateViewController(withIdentifier:
            "pickerSnipViewController") as? PickerSnipViewController
        
        initialController!.delegateViewController = self
        initialController!.statusController = "Enter"
        
        initialController!.modalPresentationStyle = .custom
        
        present(initialController!, animated: true)
    }
    
    func currencySnipSelected(arrayObjectsMark: [Nomenklature]) {
        arrayNomenklature = arrayObjectsMark
        if arrayNomenklature == nil {
            return
        }
        var textTextView = ""
        var cursorPosition = 0
        var textArray = "\n"
        
        for object in arrayNomenklature! {
            var quantity = String(object.quantity)
            //var image = object.image
            if quantity == "0.0" {
                quantity = ""
            }
            
            textArray = textArray + object.name! + " " + quantity + "\n"
//            if object.image != nil {
//                addImage(textView: nameTextView, image: UIImage(data: (object.image!))!)
//            }
        }
        
        if let selectedRange = nameTextView.selectedTextRange {

            //let startPosition: UITextPosition = nameTextView.beginningOfDocument
            textTextView = nameTextView.text
            cursorPosition = nameTextView.offset(from: nameTextView.beginningOfDocument, to: selectedRange.start)
        }
        let curr = textTextView.index(textTextView.startIndex, offsetBy: cursorPosition)
        textTextView.insert(contentsOf: textArray, at: curr)
        nameTextView.text = textTextView
    }
    
} // class


    
// MARK: - extension String

//extension String {
//    func capitalizingFirstLetter() -> String {
//        return prefix(1).capitalized + dropFirst()
//    }
//}

// MARK: - transitioningDelegate 
extension TaskTableViewController {
 
    func openModalDateViewController(strViewController: String, currentLabelDate: UILabel) {
        let initialController = self.storyboard?.instantiateViewController(withIdentifier: "pickerDateViewController") as? PickerDateViewController
        modelController.dataExport.arrayValue.removeAll()
        modelController.dataExport.arrayValue.append(currentLabelDate.text as Any)
        modelController.dataExport.arrayValue.append(currentLabelDate as Any)
        initialController!.modelController = modelController
        initialController!.delegateViewController = self
        
        initialController!.transitioningDelegate = self
        
        initialController!.modalPresentationStyle = .custom
        present(initialController!, animated: true)
    }
    
    
}

extension TaskTableViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    class HalfSizePresentationController : UIPresentationController {
        override var frameOfPresentedViewInContainerView: CGRect {
            get {
                guard let theView = containerView else {
                    return CGRect.zero
                }
                let ch = 5
                return CGRect(x: 0, y: theView.bounds.height/1.2, width: theView.bounds.width, height: theView.bounds.height/CGFloat(ch))
            }
        }
    }
}
