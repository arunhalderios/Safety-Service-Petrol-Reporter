//
//  IncidentCommentCell.swift
//  ATIMS
//
//  Created by Mahesh Prasad Mahaliik on 17/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class IncidentCommentCell: UITableViewCell {

    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtViewComment: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        txtViewComment.layer.borderColor = AppthemeColor.cgColor
        txtViewComment.layer.borderWidth = 2.0
        txtViewComment.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
