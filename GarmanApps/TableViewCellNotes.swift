//
//  TableViewCellNotes.swift
//  GarmanApps
//
//  Created by Ben Garman on 13/02/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit

class TableViewCellNotes: UITableViewCell {

    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var noteName: UILabel!
    @IBOutlet weak var noteDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
