//
//  textinputCell.swift
//  HMS
//
//  Created by Dipika on 09/01/20.
//  Copyright © 2020 MET Technologies. All rights reserved.
//

import UIKit
//import SkyFloatingLabelTextField

class textinputCell: UITableViewCell {
    @IBOutlet weak var viewFirst: UIView!
    @IBOutlet weak var viewLast: UIView!
    @IBOutlet weak var viewFirstBorder: UIView!
    @IBOutlet weak var viewLastBorder: UIView!
    
    @IBOutlet weak var lblFieldName: UILabel!
    @IBOutlet weak var lblFieldNameSecond: UILabel!
    @IBOutlet weak var textInputFirst: UITextField!
    @IBOutlet weak var textInputLast: UITextField!
    
    
    //@IBOutlet weak var txtFieldNameFirst: SkyFloatingLabelTextField!
    //@IBOutlet weak var txtFielsNameSecond: SkyFloatingLabelTextField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//         txtFieldNameFirst.titleFormatter = { $0 }
//        txtFielsNameSecond.titleFormatter = { $0 }
        viewFirstBorder.layer.cornerRadius = 10//viewFirstBorder.frame.size.height / 2
        viewFirstBorder.layer.borderWidth = 1
        viewFirstBorder.layer.borderColor = darkThemeColor.cgColor
        //init(red: 254/255, green: 241/255, blue: 184/255, alpha: 1).cgColor
        
        viewLastBorder.layer.cornerRadius = 10//viewLastBorder.frame.size.height / 2
        viewLastBorder.layer.borderWidth = 1
        viewLastBorder.layer.borderColor = darkThemeColor.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
