//
//  NotificatonCell.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 17/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class NotificatonCell: UITableViewCell {
    @IBOutlet weak var lableTitle: UILabel!
    @IBOutlet weak var lableSubTitle: UILabel!
    @IBOutlet weak var lableTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
