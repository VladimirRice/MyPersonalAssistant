//
//  ListTasksTableViewCell.swift
//  MyPersonalAssistant
//
//  Created by Vladimir Rice on 11.05.2020.
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

class ListTasksTableViewCell: UITableViewCell {

    
    @IBOutlet weak var quantyBadgeTasksLabel: UILabel!
    @IBOutlet weak var quantyListsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
