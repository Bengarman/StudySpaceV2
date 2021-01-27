//
//  TableViewCellHomework.swift
//  GarmanApps
//
//  Created by Ben Garman on 15/02/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit
class TableViewCellHomework: UITableViewCell {

    @IBOutlet weak var HomeworkName: UILabel!
    @IBOutlet weak var teacher: UILabel!
    @IBOutlet weak var daysLeft: UILabel!
    @IBOutlet weak var priotiyViewer: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   

}
