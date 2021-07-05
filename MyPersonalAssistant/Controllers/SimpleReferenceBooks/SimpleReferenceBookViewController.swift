//
//  SimpleReferenceBookViewController.swift
//  ChecksPricesGoods
//
//  Created by Vladimir Rice on 04.01.2021.
//

import UIKit

class SimpleReferenceBookViewController: UIViewController
    , UIImagePickerControllerDelegate & UINavigationControllerDelegate
    , UITextFieldDelegate

{

    //let realDB = RealmTool.getDB()
    
    var currentObject: AnyObject?
    var typeReferens: String = ""
    //var typeReferensRus: String = ""
    var delegateViewController: AnyObject?  //SimpleReferenceBooksViewController!
    //var attributsCell: [String]!
    var attributs: [String]!
    var attributsRus: [String]!
    
    var attributImage: String?
    var delegateViewControllerTableView: [AnyObject]?
    //var delegateRow
    
    @IBOutlet weak var label0: UILabel!
    @IBOutlet weak var textField0: UITextField!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var textField4: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if attributImage != nil {  //UIImage(data: currentObject!.imageQR as Data)
            let image = currentObject?.value(forKey: attributImage!)
            if image != nil {
                imageView.image = UIImage(data: image as! Data)
            } else {
                imageView.image = UIImage(named: "Clear")
            }
        }

        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
        
        initAttributs()

        
        textField0.addDoneButtonOnKeyboard()
        textField1.addDoneButtonOnKeyboard()
        textField2.addDoneButtonOnKeyboard()
        textField3.addDoneButtonOnKeyboard()
        textField4.addDoneButtonOnKeyboard()
        
        textField0.delegate = self
        textField1.delegate = self
        textField2.delegate = self
        textField3.delegate = self
        textField4.delegate = self
        
        
        //textField0.keyboardAppearance
        
//        if delegateViewController == nil {
//            delegateViewController = SimpleReferenceBooksViewController()
//            delegateViewControllerTableView = delegateViewController.tableView
//        }
////        if delegateViewControllerTableView == nil {
////            delegateViewControllerTableView = delegateViewController.tableView
////        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    // MARK: - delegate textField
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        string = string.capitalized
//    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.text = textField.text?.capitalizingFirstLetter()
        return true
    }

    // MARK: -  action
    @IBAction func saveObjectItem(_ sender: Any) {
        saveObject()
        if delegateViewControllerTableView != nil {
            for count in 0...delegateViewControllerTableView!.count-1 {
                delegateViewControllerTableView![count].reloadData()
            }
        }
    }
    
    // MARK: - func
    
    func initAttributs() {
        if attributsRus.count == 5 {
            label0.text = attributsRus[0]
            label1.text = attributsRus[1]
            label2.text = attributsRus[2]
            label3.text = attributsRus[3]
            label4.text = attributsRus[4]
            
            label0.isHidden = false
            label1.isHidden = false
            label2.isHidden = false
            label3.isHidden = false
            label4.isHidden = false
            
            textField0.text = currentObject!.value(forKey:attributs[0]) as? String
            textField1.text = currentObject!.value(forKey:attributs[1]) as? String
            textField2.text = currentObject!.value(forKey:attributs[2]) as? String
            textField3.text = currentObject!.value(forKey:attributs[3]) as? String
            textField4.text = currentObject!.value(forKey:attributs[4]) as? String
            
            textField0.isHidden = false
            textField1.isHidden = false
            textField2.isHidden = false
            textField3.isHidden = false
            textField4.isHidden = false
        }
        if attributsRus.count == 4 {
            label0.text = attributsRus[0]
            label1.text = attributsRus[1]
            label2.text = attributsRus[2]
            label3.text = attributsRus[3]
            //label4.text = attributsRus[4]
            
            label0.isHidden = false
            label1.isHidden = false
            label2.isHidden = false
            label3.isHidden = false
            //label4.isHidden = false
            
            textField0.text = currentObject!.value(forKey:attributs[0]) as? String
            textField1.text = currentObject!.value(forKey:attributs[1]) as? String
            textField2.text = currentObject!.value(forKey:attributs[2]) as? String
            textField3.text = currentObject!.value(forKey:attributs[3]) as? String
            //textField4.text = currentObject!.value(forKey:attributs[4]) as? String
            
            textField0.isHidden = false
            textField1.isHidden = false
            textField2.isHidden = false
            textField3.isHidden = false
            //textField4.isHidden = false
        }
        
        if attributsRus.count == 3 {
            label0.text = attributsRus[0]
            label1.text = attributsRus[1]
            label2.text = attributsRus[2]
            //            label3.text = attributsRus[3]
            //            label4.text = attributsRus[4]
            
            label0.isHidden = false
            label1.isHidden = false
            label2.isHidden = false
            //            label3.isHidden = false
            //            label4.isHidden = false
            
            textField0.text = currentObject!.value(forKey:attributs[0]) as? String
            textField1.text = currentObject!.value(forKey:attributs[1]) as? String
            textField2.text = currentObject!.value(forKey:attributs[2]) as? String
            //            textField3.text = currentObject!.value(forKey:attributs[3]) as? String
            //            textField4.text = currentObject!.value(forKey:attributs[4]) as? String
            
            textField0.isHidden = false
            textField1.isHidden = false
            textField2.isHidden = false
            //            textField3.isHidden = false
            //            textField4.isHidden = false
        }
        
        if attributsRus.count == 2 {
            label0.text = attributsRus[0]
            label1.text = attributsRus[1]
            //            label2.text = attributsRus[2]
            //            label3.text = attributsRus[3]
            //            label4.text = attributsRus[4]
            
            label0.isHidden = false
            label1.isHidden = false
            //            label2.isHidden = false
            //            label3.isHidden = false
            //            label4.isHidden = false
            
            textField0.text = currentObject!.value(forKey:attributs[0]) as? String
            
            var currValue1 = currentObject!.value(forKey:attributs[1])
            if let currValue = currentObject!.value(forKey:attributs[1]) as? Int {
                currValue1 = Functions.intToString(curVar: currValue as! Int)
            }
            textField1.text = currValue1 as! String
            
            //            textField2.text = currentObject!.value(forKey:attributs[2]) as? String
            //            textField3.text = currentObject!.value(forKey:attributs[3]) as? String
            //            textField4.text = currentObject!.value(forKey:attributs[4]) as? String
            //
            textField0.isHidden = false
            textField1.isHidden = false
            //            textField2.isHidden = false
            //            textField3.isHidden = false
            //            textField4.isHidden = false
        }
        
        
        if attributsRus.count == 1 {
            label0.text = attributsRus[0]
            //            label1.text = attributsRus[1]
            //            label2.text = attributsRus[2]
            //            label3.text = attributsRus[3]
            //            label4.text = attributsRus[4]
            
            label0.isHidden = false
            //            label1.isHidden = false
            //            label2.isHidden = false
            //            label3.isHidden = false
            //            label4.isHidden = false
            
            textField0.text = currentObject!.value(forKey:attributs[0]) as? String
            //            textField1.text = currentObject!.value(forKey:attributs[1]) as? String
            //            textField2.text = currentObject!.value(forKey:attributs[2]) as? String
            //            textField3.text = currentObject!.value(forKey:attributs[3]) as? String
            //            textField4.text = currentObject!.value(forKey:attributs[4]) as? String
            
            textField0.isHidden = false
            //            textField1.isHidden = false
            //            textField2.isHidden = false
            //            textField3.isHidden = false
            //            textField4.isHidden = false
        }
    } // init
    
    
    func saveObject() {
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        
        
        if typeReferens == "Category" {
            currentObject?.setValue(textField0.text, forKey: "name")
            let intColor = Int(textField1.text!)
            let color = NSNumber(value: intColor!)
            currentObject?.setValue(color, forKey: "color")
            
            appDelegate.saveContext()
            
        }
//        
//        if typeReferens == "Shop" {
//            let predicate = "inn == %@"
//            let objectsRealm = RealmTool.objectsShop(predicate: predicate, filter: textField0.text!)
//            var objectRealm = objectsRealm[0]
//            
//            //let realDB = RealmTool.getDB()
//            try! realDB.write{
//                objectRealm.inn        = textField0.text!
//                objectRealm.name       = textField1.text!
//                objectRealm.nameJson   = textField2.text!
//                objectRealm.adress     = textField3.text!
//                if imageView.image != UIImage(named: "Clear") {
//                    objectRealm.image      = imageView.image?.pngData() as NSData?
//                } else {
//                    objectRealm.image = UIImage(named: "Clear")?.pngData() as NSData?
//                }
//            }
//        }
//        
//         if typeReferens == "Nomenklature" {
//      
//            //let realDB = RealmTool.getDB()
//            
//            //var objectDB = Nomenklature()
//            var objectDB = currentObject! as! Nomenklature
////            objectDB.name = textField0.text!
////            objectDB.article = textField1.text!
////            if imageView.image != UIImage(named: "Clear") {
////                objectDB.image      = imageView.image?.pngData() as NSData?
////            } else {
////                objectDB.image = UIImage(named: "Clear")?.pngData() as NSData?
////            }
//            
//            let predicate = "id == %@"
//            let objectsRealm = RealmTool.objectsNomenklature(predicate: predicate, filter: objectDB.id)
//            if objectsRealm.count == 0 {
//                
//                try! realDB.write{
//                    
//                    objectDB.name = textField0.text!
//                    objectDB.article = textField1.text!
//                    if imageView.image != UIImage(named: "Clear") {
//                        objectDB.image      = imageView.image?.pngData() as NSData?
//                    } else {
//                        objectDB.image = UIImage(named: "Clear")?.pngData() as NSData?
//                    }
//                    realDB.add(objectDB)
//                }
//                return
//            }
//            
//            objectDB = objectsRealm[0]
//
//            try! realDB.write {
//                objectDB.name = textField0.text!
//                objectDB.article = textField1.text!
//                if imageView.image != UIImage(named: "Clear") {
//                    objectDB.image      = imageView.image?.pngData() as NSData?
//                } else {
//                    objectDB.image = UIImage(named: "Clear")?.pngData() as NSData?
//                }
//            }
//            
//            //            try! realDB.write {
////                objectRealm.name = objectDB.name
////                objectRealm.article = objectDB.article
////                    objectRealm.image      = objectDB.image
////            }
//            
//            //RealmTool.updateNomenklature(object: objectDB as! Nomenklature, attributs: attributs)
//         }
        
    }
    
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        alertImage(image: imageView)
//            self.currentTagButton = 10
//            self.cameraButtonPressedTask()
        
    }
    
    func alertImage(image: UIImageView) {
        let alertImage = UIAlertController(title: "Выберите действие", message: "", preferredStyle: .alert)
        
        //if image.image != UIImage(named: "Clear") && image != self.imageTaskImageView {
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
        //}
        //
        alertImage.addAction(UIAlertAction(title: "Редактировать", style: .default, handler: { (action) -> Void in
//            if image == self.image0ImageView {
//                self.currentTagButton = 0
//            }
//            if image == self.image1ImageView {
//                self.currentTagButton = 1
//            }
//            if image == self.image2ImageView {
//                self.currentTagButton = 2
//            }
//            if image == self.imageTaskImageView {
//                self.currentTagButton = 10
//            }

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
        
        imageView.image = userPickedImage
//        switch currentTagButton {
//        case 0:
//            image0ImageView!.image = userPickedImage
//        case 1:
//            image0ImageView!.image = userPickedImage
//        case 2:
//            image0ImageView!.image = userPickedImage
//        case 10: //
//            imageTaskImageView.image = userPickedImage
//            currentObject!.imageTask = userPickedImage.pngData()
//        default:
//            image0ImageView.image = nil//UIImage()
//        }
//
//        self.tableView.reloadData()
    }
    
    
    
} //class
