//
//  FuelCell.swift
//  Safety service Patrol Reporter
//
//  Created by Pritam Dey on 30/03/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class FuelCell: UITableViewCell {
    
    @IBOutlet weak var lableRefulingDate: UILabel!
    @IBOutlet weak var lableRefulingTime: UILabel!
    @IBOutlet weak var lableCostPerLtr: UILabel!
    @IBOutlet weak var lableFuleQuantity: UILabel!
    @IBOutlet weak var buttonShowDetails: UIButton!
    
    
    @IBOutlet weak var lableOne: UILabel!
    @IBOutlet weak var lableTwo: UILabel!
    @IBOutlet weak var lableThree: UILabel!
    @IBOutlet weak var lableFour: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpTableForCrashReport(list:[CrashModel],index:Int)  {
        self.lableOne.text = "Vehicle ID:"
        self.lableTwo.text = "Latitude:"
        self.lableThree.text = "State:"
        self.lableFour.text = "Longitude:"
    
         self.lableRefulingDate.text = list[index].vehicleId
         self.lableRefulingTime.text = list[index].state_name
         self.lableCostPerLtr.text = list[index].latitude
        self.lableFuleQuantity.text = list[index].longitude
        
        
        
    }
    
    func setUpTableForMaintenanceReport(list:[Maintainace],index:Int)  {
        self.lableOne.text = "Vehicle ID:"
        self.lableTwo.text = "Contract:"
        self.lableThree.text = "State:"
        self.lableFour.text = "Service cost:"
        self.lableRefulingDate.text = list[index].vehicleId
        
        self.lableRefulingTime.text = list[index].state_name
        self.lableCostPerLtr.text = list[index].contract_period
        self.lableFuleQuantity.text = "$\(list[index].service_cost ?? "0")"
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
