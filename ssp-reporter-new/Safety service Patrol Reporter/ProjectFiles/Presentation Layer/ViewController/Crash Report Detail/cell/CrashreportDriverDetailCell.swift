//
//  CrashreportDriverDetailCell.swift
//  Safety service Patrol Reporter
//
//  Created by Abhik on 29/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class CrashreportDriverDetailCell: UITableViewCell {
    
    @IBOutlet weak var driverScetionTop: NSLayoutConstraint!
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var label1Right: UILabel!
      @IBOutlet weak var label2Right: UILabel!
      @IBOutlet weak var label3Right: UILabel!
      @IBOutlet weak var label4Right: UILabel!
      @IBOutlet weak var label5Right: UILabel!
      @IBOutlet weak var label6Right: UILabel!
      @IBOutlet weak var label7Right: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
