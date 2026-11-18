//
//  SosDetailsCell.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 19/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class SosDetailsCell: UITableViewCell {

    @IBOutlet weak var lblLong: UILabel!
    @IBOutlet weak var lblLat: UILabel!
    @IBOutlet weak var lblVehicleID: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
