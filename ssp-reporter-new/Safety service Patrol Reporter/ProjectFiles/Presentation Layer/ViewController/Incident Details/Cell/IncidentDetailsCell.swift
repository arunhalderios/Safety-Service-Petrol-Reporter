//
//  IncidentDetailsCell.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Prasad Mahaliik on 20/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class IncidentDetailsCell: UITableViewCell {

    @IBOutlet weak var lblcolor: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblplatenumber: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
