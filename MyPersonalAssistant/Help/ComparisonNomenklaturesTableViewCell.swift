//
//  ComparisonNomenklaturesTableViewCell.swift
//  ChecksPricesGoods
//
//  Created by Vladimir Rice on 09.01.2021.
//

import UIKit

class ComparisonNomenklaturesTableViewCell: UITableViewCell {

//    @IBOutlet weak var imageViewChildL: UIImageView!
//    @IBOutlet weak var imageViewChildR: UIImageView!
    
    @IBOutlet weak var textLabelL: UILabel!
    @IBOutlet weak var textLabelR: UILabel!
    
    @IBOutlet weak var imageViewL: UIImageView!
    @IBOutlet weak var imageViewR: UIImageView!
    
    @IBOutlet weak var expandButtonL: UIButton!
    @IBOutlet weak var expandButtonR: UIButton!
    @IBOutlet weak var countL: UILabel!
    @IBOutlet weak var countR: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
