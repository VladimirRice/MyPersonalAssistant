//
//  tasksCellTableViewCell.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 12.04.2020.
//  Copyright © 2020 Vladimir Rice. All rights reserved.
//

import UIKit
import TinyConstraints


class TasksCellTableViewCell: UITableViewCell {

   let minDateFormat = "EEEE.dd.MM.yyyy HH:mm"
    
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dateTermination: UILabel!
    @IBOutlet weak var IsCloseButton: UIButton!
    @IBOutlet weak var priorityLabel: UILabel!
//    @IBOutlet weak var dateTermLabelRuss: UILabel!
    //@IBOutlet weak var imageMoveImageView: UIImageView!
    @IBOutlet weak var imageTaskImageView: UIImageView!
    @IBOutlet weak var lockedImage: UIImageView!
    @IBOutlet weak var yestoday: UILabel!
    
    @IBOutlet weak var imageSelectImage: UIImageView!
    @IBOutlet weak var goImage: UIImageView!
    //    @IBOutlet weak var upTurnButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //TasksCellTableViewCell.isEditing = true
        
//        // You must to use interaction enabled
//        imageMoveImageView.isUserInteractionEnabled = true
//        imageMoveImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageMoveTapped(_:))))
        
    }
    
    
    func setupCell(_ heading: String, name: String, dateTerminationStr: String, priority: Int, imageTask: UIImage){
        self.heading.text = heading
        let currName = name.replacingOccurrences(of: "\n", with: " ")
        self.name.text = currName
        self.dateTermination.text = dateTerminationStr
//        if dateTerminationStr == "" {
//            dateTermLabelRuss.isHidden = true
//        } else {
//            dateTermLabelRuss.isHidden = false
//        }
        
        self.heading.font = UIFont.systemFont(ofSize: CGFloat(Double(UserDefaults.standard.object(forKey: "fontHeading") as? String ?? "12")!))
        self.name.font = UIFont.systemFont(ofSize: CGFloat(Double(UserDefaults.standard.object(forKey: "fontName") as? String ?? "10")!))
        self.dateTermination.font = UIFont.systemFont(ofSize: CGFloat(Double(UserDefaults.standard.object(forKey: "fontName") as? String ?? "10")!))
        
        self.yestoday.font = UIFont.systemFont(ofSize: CGFloat(Double(UserDefaults.standard.object(forKey: "fontName") as? String ?? "10")!))

        //self.name.font = UIFont.systemFont(ofSize: 12)
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
        self.priorityLabel.text = priorityString
        if imageTask != nil {
            self.imageTaskImageView.image = imageTask
        }
        
        //self.contentView.center(in: self)
        //self.contentView.width(400)
        var maxX = self.frame.size.width
        
//        self.imageSelectImage.width(12)
//        self.imageSelectImage.height(40)
//        
//        self.imageSelectImage.center(in: self, offset: CGPoint(x: maxX - 250, y: 4))
 
        self.imageTaskImageView.width(30)
        self.imageTaskImageView.height(30)
        //self.imageTaskImageView.center(in: self, offset: CGPoint(x: maxX - 270, y: 4))
//        self.imageTaskImageView.edges(to: self, insets: UIEdgeInsets(top: 0, left: 215, bottom: 10, right: 5))
        self.imageTaskImageView.edges(to: self, insets: UIEdgeInsets(top: 3, left: 275, bottom: 10, right: 10))

//        self.upTurnButton.width(25)
//        self.upTurnButton.height(25)
//        self.upTurnButton.center(in: self, offset: CGPoint(x: maxX - 305, y: 5))
//
//        self.upTurnButton.layer.cornerRadius = 5    /// радиус закругления закругление
//        self.upTurnButton.layer.borderWidth = 2.0   // толщина обводки
//        self.upTurnButton.layer.borderColor = UIColor.gray.cgColor // цвет обводки
//        self.upTurnButton.clipsToBounds = true  //

        
        self.priorityLabel.width(15)
        self.priorityLabel.height(50)
        self.priorityLabel.center(in: self, offset: CGPoint(x: maxX - 305, y: -10))
 
        self.heading.width(120)
        self.heading.height(30)
        self.heading.edges(to: self, insets: UIEdgeInsets(top: -40, left: 35, bottom: -12, right: 125))
        
        self.name.width(50)
        self.name.height(30)
        self.name.edges(to: self, insets: UIEdgeInsets(top: 0, left: 35, bottom: -12, right: 125))
        //self.name.center(in: self, offset: CGPoint(x: maxX - 305, y: -10))
        //self.name.edges(to: self, insets: UIEdgeInsets(top: 20, left: 35, bottom: -12, right: 5))

        

        self.dateTermination.width(140)
        self.dateTermination.height(15)
        self.dateTermination.edges(to: self, insets: UIEdgeInsets(top: 20, left: 65, bottom: -12, right: 5))
        
        self.goImage.width(30)
        self.goImage.height(30)
//        self.goImage.edges(to: self, insets: UIEdgeInsets(top: 10, left: 275, bottom: 10, right: 5))
        self.goImage.edges(to: self, insets: UIEdgeInsets(top: 10, left: 215, bottom: 10, right: 5))


        self.yestoday.width(80)
        self.yestoday.height(15)
        self.yestoday.edges(to: self, insets: UIEdgeInsets(top: 20, left: 235, bottom: -12, right: 5))

    }
    
} //class

