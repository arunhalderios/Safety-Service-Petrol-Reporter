//
//  IncidentImageCell.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Prasad Mahaliik on 20/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class IncidentImageCell: UITableViewCell {

    @IBOutlet weak var imgNoData: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var imgIncident: UIImageView!
    @IBOutlet weak var imgViewPlay: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
