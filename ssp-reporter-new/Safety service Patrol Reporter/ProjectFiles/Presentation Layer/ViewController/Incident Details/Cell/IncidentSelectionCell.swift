//
//  IncidentSelectionCell.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Prasad Mahaliik on 20/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class IncidentSelectionCell: UITableViewCell {
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblHighlightDetails: UILabel!
    
    @IBOutlet weak var lblHighLightvideo: UILabel!
    @IBOutlet weak var lblVideo: UILabel!
    @IBOutlet weak var lblImage: UILabel!
    @IBOutlet weak var lblHighlightImage: UILabel!
    @IBOutlet weak var viewBack: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBack.clipsToBounds = false
        viewBack.layer.cornerRadius = 10
        viewBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
