//
//  IncidentCell.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 20/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class IncidentCell: UITableViewCell {

    @IBOutlet weak var lblRoute: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnDecline: UIButton!
    @IBOutlet weak var btnUpdateIncident: UIButton!
    @IBOutlet weak var btnViewIncident: UIButton!
    @IBOutlet weak var heightConstraintViewIncident: NSLayoutConstraint!
    @IBOutlet weak var labelTruckStatus: UILabel!
    @IBOutlet weak var labelIND: UILabel!

    @IBOutlet weak var labelVehicleID: UILabel!
    @IBOutlet weak var labelDistrict: UILabel!
    @IBOutlet weak var labelMM: UILabel!
    @IBOutlet weak var labelDirection: UILabel!
    @IBOutlet weak var labelLanesEffected: UILabel!
    @IBOutlet weak var viewIncidentBtn: UIButton!
 
    override func awakeFromNib() {
        super.awakeFromNib()
       // btnUpdateIncident.layer.cornerRadius = 8
        //btnDecline.layer.cornerRadius = 8
        //btnDecline.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 8)
        //btnUpdateIncident.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 8)
        //btnUpdateIncident.frame.size.height / 2
        //btnDecline.roundedView()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
      var info: IncidentDetailsDataModel?  {
        
         didSet{
            if info?.mile_marker == ""{
                self.labelMM.text =   " "
            }else{
             self.labelMM.text =  info?.mile_marker ?? " "
            }
             self.labelVehicleID.text = info?.ID != nil ?  info?.ID  : " "
            if info?.traffic_direction == ""{
                self.labelDirection.text = " "
            }else{
             self.labelDirection.text = info?.traffic_direction ?? " "
            }
            // self.labelDistrict.text = info?.state_name != nil ?  info?.state_name  : " "
            if info?.state_name == ""{
                self.lblRoute.text = " "
            }else{
            self.lblRoute.text = info?.route_name != nil ?  info?.route_name  : " "
            }
            if  info?.lane_location_name == ""{
                 self.labelLanesEffected.text = " "
            }else{
             self.labelLanesEffected.text = info?.lane_location_name ?? " "
            }
             self.labelIND.text = info?.incidents_report_data_id ?? " "
             self.labelDistrict.text = info?.call_started ?? " "

         }
         
     }

}
