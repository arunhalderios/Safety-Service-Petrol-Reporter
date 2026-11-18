//
//  InpectionDetailsCell.swift
//  Safety service Patrol Reporter
//
//  Created by Pritam Dey on 09/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class InpectionDetailsCell: UITableViewCell {
    @IBOutlet weak var buttonNext: UIButton!
    
    //Inspection Report
    
    @IBOutlet weak var labelRepotTilte: UILabel!
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var labelInspectedBy: UILabel!
    @IBOutlet weak var labelVehicleID: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelOdometerReading: UILabel!
    @IBOutlet weak var labelInsuranceExpiry: UILabel!
    @IBOutlet weak var labelRegExpiry: UILabel!
    @IBOutlet weak var labelStateInsuranceExpiry: UILabel!
    
    
    //// Vehicle
    @IBOutlet weak var labelQuestation: UILabel!
    @IBOutlet weak var labelAnswer: UILabel!
    @IBOutlet weak var imageComment: UIImageView!
    @IBOutlet weak var insImage: UIImageView!
   
    
    @IBOutlet weak var lastHightContent: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func inpectionReortDetailCell1(info: ReportUserData) {
        if info != nil {
        if let firstName = info.first_name  {
            self.labelInspectedBy.text = firstName + " " + (info.last_name ?? "")
        }
        self.labelVehicleID.text = info.vehicle_id != "" ?  info.vehicleId : " "
        
        self.labelDate.text = info.inspection_date != "" ?  info.inspection_date : " "
        self.labelTime.text = info.inspection_time != "" ?  info.inspection_time : " "
        self.labelOdometerReading.text = info.odometer_reading != "" ?  info.odometer_reading : " "
        self.labelInsuranceExpiry.text = info.insurance_expiary_date != "" ?  info.insurance_expiary_date : " "
        self.labelRegExpiry.text = info.registration_expiry_date != "" ?  info.registration_expiry_date : " "
        self.labelStateInsuranceExpiry.text = info.state_inspection_expiry_date != "" ?  info.state_inspection_expiry_date : " "
        }

    }
    
    func inpectionVehicleCell2(info: QuestionsResult)  {
        if info != nil {
        self.labelQuestation.text = info.inspection_vehicle_question != "" ?  info.inspection_vehicle_question : " "
        self.labelAnswer.text = info.inspection_vehicle_answer != "" ?  info.inspection_vehicle_answer : " "
        self.imageComment.isHidden = info.inspection_vehicle_answer_comments == "" ? true : false
        self.insImage.isHidden = info.inspection_vehicle_answer_image == "" ? true : false
        }
        
    }
    
}
