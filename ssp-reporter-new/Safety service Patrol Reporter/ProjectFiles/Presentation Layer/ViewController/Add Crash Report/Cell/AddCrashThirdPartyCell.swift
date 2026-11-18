//
//  AddCrashThirdPartyCell.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Mahalik on 08/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class AddCrashThirdPartyCell: UITableViewCell {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var viewRound: UIView!
    @IBOutlet weak var viewRound1: UIView!
    @IBOutlet weak var viewRound2: UIView!
    @IBOutlet weak var viewRound3: UIView!
    @IBOutlet weak var viewRound4: UIView!
    @IBOutlet weak var viewRound5: UIView!
    @IBOutlet weak var viewRound6: UIView!

    @IBOutlet weak var txtDriverName: UITextField!
    @IBOutlet weak var txtPhonrNumber: UITextField!
    @IBOutlet weak var txtvwAddress: UITextView!
    @IBOutlet weak var txtvwDriverLicenseInfo: UITextView!
    @IBOutlet weak var txtvwVehicleInsuranceInfo: UITextView!
    @IBOutlet weak var txtInsuranceExpiryDate: UITextField!
    @IBOutlet weak var btnSelection: UIButton!
    @IBOutlet weak var txtInjuries: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
