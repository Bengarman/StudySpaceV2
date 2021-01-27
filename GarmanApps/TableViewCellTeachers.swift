//
//  TableViewCellTeachers.swift
//  GarmanApps
//
//  Created by Ben Garman on 10/05/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit

class TableViewCellTeachers: UITableViewCell {

    @IBOutlet weak var subjectName: UILabel!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
