//
//  IncidentInputCell.swift
//  ATIMS
//
//  Created by Mahesh Prasad Mahaliik on 17/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class IncidentInputCell: UITableViewCell {

    @IBOutlet var btnBroken: ButtionX!
    @IBOutlet var btnMissing: ButtionX!
    @IBOutlet var btnPresent: ButtionX!
    @IBOutlet weak var viewRound: UIView!
    @IBOutlet weak var btnSelection: UIButton!
    @IBOutlet weak var imgViewDropDown: UIImageView!
    @IBOutlet weak var txtFieldInput: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var imageDefaultCamera: UIImageView!
    
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var lblCounter: UILabel!
    
    @IBOutlet weak var imgViewBox: UIImageView!
    @IBOutlet weak var btncheckSelection: UIButton!
    
    
    
    
    @IBOutlet weak var imgYes: UIImageView!
    @IBOutlet weak var imgNo: UIImageView!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    
   
    @IBOutlet weak var viewStackContainer: UIStackView!
    @IBOutlet weak var imgPresent: UIImageView!
    @IBOutlet weak var imgBroken: UIImageView!
    @IBOutlet weak var imgMissing: UIImageView!
    
    
   
    
   
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
