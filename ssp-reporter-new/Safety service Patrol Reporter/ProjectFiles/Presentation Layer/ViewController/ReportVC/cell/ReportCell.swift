//
//  ReportCell.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 18/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class ReportCell: UITableViewCell {
    
    @IBOutlet var heightImage: NSLayoutConstraint!
    @IBOutlet var widthImage: NSLayoutConstraint!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var imageQuestions: UIImageView!
    @IBOutlet weak var labelStartShift: UILabel!
    @IBOutlet weak var labelEndShift: UILabel!
    @IBOutlet weak var labelTotalDuration: UILabel!

    @IBOutlet weak var labelSelfInitiated: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
  
    
    
    @IBOutlet weak var labelToolsName: UILabel! //pritam
    
    @IBOutlet weak var labelToolsNumber: UILabel! //pritam
    
    @IBOutlet weak var lableSectionTitle: UILabel!
    @IBOutlet weak var viewTwo: UIView!
    
    @IBOutlet weak var constentWithView2: NSLayoutConstraint!
    @IBOutlet weak var constentWithSuperView: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

    func populateData(cellInfo: ReportDataModel)  {
        self.lableSectionTitle.text = cellInfo.shiftStart != "" ?  cellInfo.shiftStart : " "
        labelStartShift.text = cellInfo.shiftStart != "" ?  cellInfo.shiftStart : " "
        labelEndShift.text = cellInfo.shiftEnd != "" ?  cellInfo.shiftEnd : " "
        labelTotalDuration.text = cellInfo.totalDuration != "" ?  cellInfo.totalDuration : " "
        if cellInfo.status != nil{
            self.viewTwo.isHidden = false
            self.constentWithView2.isActive = true
            self.constentWithSuperView.isActive = false
            if   let info :StatusDetails = cellInfo.status {
               
                self.labelSelfInitiated.text = " "
                self.labelDuration.text = ""
                self.labelSelfInitiated.text = "\(info.totalpatrolling ?? 0)"
                self.labelDuration.text = "\(info.onScene ?? 0)"
               
            }
        }else{
            self.viewTwo.isHidden = true
            self.constentWithView2.isActive = false
            self.constentWithSuperView.constant = 8
            self.constentWithSuperView.isActive = true
        }
        
    }

}
