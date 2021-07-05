//
//  PickerOneViewController.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 30.04.2020.
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

class PickerOneViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
, UIScrollViewDelegate {

    //var pickerViewController: PickerViewController?
    var currentObject: Nomenklature?
    var initialViewController: PickerSnipViewController?
    var currentTagButton: Int = 0
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imageSnipImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var prioritySegmentController: UISegmentedControl!
    @IBOutlet weak var quantityTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = currentObject?.name
        
//        let strquantity = currentObject?.quantity
//        let quantity_string:String = String(format:"%d",strquantity!)
//        //let quantity:Int = Int(quantity_string)!
//        quantityTextField.text = quantity_string
     
        quantityTextField.text = Functions.floatToString(curVar: currentObject!.quantity)

        let strPrioritet = currentObject?.priority
        let priority_string:String = String(format:"%d",strPrioritet!)
        let priority:Int = Int(priority_string)!
        prioritySegmentController.selectedSegmentIndex = priority
        if currentObject!.image != nil {
            imageSnipImageView.image = UIImage(data: currentObject!.image!)
        }
        nameTextField.delegate = self
        quantityTextField.delegate = self
        
        imageScrollView.delegate = self
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 6.0

        imageSnipImageView.isUserInteractionEnabled = true
        imageSnipImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            let isUpperString = Functions.isUpperString()
            if isUpperString == true {
                textField.text = textField.text!.capitalizingFirstLetter()
            }
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == quantityTextField {
           return string == string.filter("0123456789.".contains)
        }
        return true
        
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//                textField.text = String(format: "%.2f", textField.text as! CVarArg)
//                return true
//    }

    // MARK: UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageSnipImageView
    }
    
    // MARK: action
    
        @IBAction func stopButtonItem(_ sender: UIBarButtonItem) {
            self.dismiss(animated: true, completion: nil)
        }
        
        @IBAction func saveButtonItem(_ sender: UIBarButtonItem) {
            let isUpperString = Functions.isUpperString()
            if isUpperString == true {
                 nameTextField.text = nameTextField.text!.capitalizingFirstLetter()
             }
            currentObject?.name = nameTextField.text
    //        currentObject?.priority = Int16(truncating: NSNumber(value: prioritySegmentController.selectedSegmentIndex))
            currentObject?.priority = NSNumber(value: prioritySegmentController.selectedSegmentIndex)
            
            //currentObject?.quantity = NSDecimalNumber(decimal: Double(value: quantityTextField.text))
            
 //           currentObject?.quantity = NSDecimalNumber(value: (quantityTextField.text! as NSString).doubleValue)
            
            let tempString = quantityTextField.text
            let myFloat = Float(tempString!)!
            currentObject?.quantity = myFloat
            
            saveObject()
            //initialViewController?.selectedObject = currentObject
            initialViewController?.tableView.reloadData()
            //self.dismiss(animated: true, completion: nil)
            
            
        }
    
//    @IBAction func photoButton(_ sender: UIButton) {
//        currentTagButton = sender.tag
//        cameraButtonPressed(sender: sender)
//    }
    
    // MARK: func
    func saveObject(){
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.saveContext()
    }
    
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
        case 0: //
            imageSnipImageView.image = userPickedImage
            currentObject!.image = userPickedImage.pngData()
    
        default:
            currentObject!.image = UIImage().pngData()
        }
        //self.tableView.reloadData()
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        alertImage(image: imageSnipImageView)
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.allowsEditing = true
//        picker.sourceType = .photoLibrary
//        present(picker, animated: true)
    }
    
    func alertImage(image: UIImageView) {
        let alertImage = UIAlertController(title: "Выберите действие", message: "", preferredStyle: .alert)
        
        //
        alertImage.addAction(UIAlertAction(title: "Редактировать", style: .default, handler: { (action) -> Void in
            if image == self.imageSnipImageView {
                self.currentTagButton = 0
            }
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
    
    
} // class
