//
//  SosSubmitCell.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 19/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class SosSubmitCell: UITableViewCell {

    @IBOutlet weak var buttonsend: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func btnSendAction(_ sender: Any) {
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.buttonsend.layer.cornerRadius = 10//buttonsend.frame.size.height / 2
        //self.buttonCancel.layer.cornerRadius = 10//buttonCancel.frame.size.height / 2

        // Configure the view for the selected state
    }

}
