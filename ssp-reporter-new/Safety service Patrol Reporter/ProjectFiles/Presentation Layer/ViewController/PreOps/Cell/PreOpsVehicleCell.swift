//
//  PreOpsVehicleCell.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Mahalik on 01/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class PreOpsVehicleCell: UITableViewCell {
    @IBOutlet weak var viewRound: UIView!
    @IBOutlet weak var btnSelection: UIButton!
    @IBOutlet weak var imgViewDropDown: UIImageView!
    @IBOutlet weak var txtFieldInput: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnUploadComments: UIButton!
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var imgOption: UIImageView!
    @IBOutlet weak var imgComments: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
