//
//  TableViewCellTimeTable.swift
//  GarmanApps
//
//  Created by Ben Garman on 15/02/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit

class TableViewCellTimeTable: UITableViewCell {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var lessonName: UILabel!
    @IBOutlet weak var lessonTeacher: UILabel!
    @IBOutlet weak var icons: UIImageView!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
