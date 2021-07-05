//
//  SnipTableViewCell.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 03.05.2020.
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

protocol SnipCellDelegate{
    func stepperButton(sender: SnipTableViewCell)
}

class SnipTableViewCell: UITableViewCell {

    var delegate: SnipCellDelegate?
    
    //var currentObject: Nomenklature?
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var IsSelectedButton: UIButton!
    
    
    @IBOutlet weak var nametLabel: UILabel!
    @IBOutlet weak var priorityTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
                // You must to use interaction enabled
//        checkMarkImageView.isUserInteractionEnabled = true
//        checkMarkImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

    //MARK: func
//    func setupCellSnip(currentObject: Nomenklature) {
//    
//        let currentCheckmark = currentObject.value(forKey: "checkmark") as! Bool
//   
//        
//        var currentColor = UIColor.white
//        var label = UILabel()
//        label = nametLabel
//
//        //
//        if currentCheckmark == true {
//            IsSelectedButton.imageView!.image = UIImage(named: "checkPlus")
//            currentColor = UIColor.cyan
//            
////            let attributes:[NSAttributedString.Key:Any] = [
//////                .font : UIFont.systemFont(ofSize: 100),
////                .backgroundColor: UIColor.lightGray.withAlphaComponent(0.5),
//////                .strokeWidth : -2,
//////                .strokeColor : UIColor.black,
//////                .foregroundColor : UIColor.red,
////                .strikethroughStyle: 0,
////            ]
////
////            let attributesAttributedString = NSAttributedString(string: label.text!, attributes: attributes)
////            label.attributedText = attributesAttributedString
//
//        } else {
//            IsSelectedButton.imageView!.image = UIImage(named: "checkEmpty")
//            currentColor = UIColor.lightGray
//            let attributes:[NSAttributedString.Key:Any] = [
//                //                .font : UIFont.systemFont(ofSize: 100),
//                .backgroundColor: UIColor.lightGray.withAlphaComponent(0.5),
//                //                .strokeWidth : -2,
//                //                .strokeColor : UIColor.black,
//                //                .foregroundColor : UIColor.red,
//                .strikethroughStyle: 1,
//            ]
//            
//            let attributesAttributedString = NSAttributedString(string: label.text!, attributes: attributes)
//            label.attributedText = attributesAttributedString
//        }
//
//        contentView.backgroundColor = currentColor
//        
//        quantityStepper.value = Double(currentObject.quantity)
//        
//        var quantity = String(currentObject.quantity)
//        if quantity == "0.0" {
//            quantity = ""
//        }
//        quantityLabel.text = quantity
//        
//        let priority = currentObject.priority
//        var priorityString: String
//        switch priority {
//        case 0:
//            priorityString = ""
//        case 1:
//            priorityString = "!"
//        case 2:
//            priorityString = "!!"
//        case 3:
//            priorityString = "!!!"
//            
//        default:
//            priorityString = ""
//        }
//        priorityTextLabel!.text = priorityString
//    }
//    
       
    @IBAction func editQuantity(_ sender: UIStepper) {
        if delegate != nil {
            delegate?.stepperButton(sender: self)
        }
    }
    
//    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
//        if checkMarkImageView.image == UIImage(named: "checked") {
//            checkMarkImageView.image = UIImage(named: "unchecked")
//        } else {
//            checkMarkImageView.image = UIImage(named: "checked")
//        }
//    }

}
