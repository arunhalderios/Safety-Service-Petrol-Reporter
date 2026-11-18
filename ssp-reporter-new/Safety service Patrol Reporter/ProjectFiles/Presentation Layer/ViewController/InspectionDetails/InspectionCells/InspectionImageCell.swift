//
//  InspectionImageCell.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Mahalik on 09/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class InspectionImageCell: UITableViewCell {
@IBOutlet weak var imgViewDetail1: UIImageView!
@IBOutlet weak var imgViewDetail3: UIImageView!
@IBOutlet weak var imgViewDetail2: UIImageView!
@IBOutlet weak var imgViewDetail4: UIImageView!
    
    @IBOutlet weak var imgViewDetail6: UIImageView!
    @IBOutlet weak var imgViewDetail5: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
