//
//  IncidentButtomCell.swift
//  ATIMS
//
//  Created by Mahesh Prasad Mahaliik on 17/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class IncidentButtomCell: UITableViewCell {

    @IBOutlet weak var btnNext: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnNext.layer.cornerRadius = 10
        //btnNext.setRoundCorner(cornerRadious: 10)
    }
    override func layoutSubviews() {
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
