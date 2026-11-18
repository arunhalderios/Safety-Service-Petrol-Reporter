//
//  IncidentInputWithPrefixCell.swift
//  Safety service Patrol Reporter
//
//  Created by Piyali Tarafder on 17/01/22.
//  Copyright © 2022 met. All rights reserved.
//

import UIKit

class IncidentInputWithPrefixCell: UITableViewCell {

    @IBOutlet var btnBroken: ButtionX!
    @IBOutlet var btnMissing: ButtionX!
    @IBOutlet var btnPresent: ButtionX!
    @IBOutlet weak var viewRound: UIView!
    @IBOutlet weak var btnSelection: UIButton!
    @IBOutlet weak var txtFieldInput: UITextField!
    @IBOutlet weak var lblPrefix: UILabel!
    @IBOutlet weak var constLblPrefixWidth: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var imageDefaultCamera: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
