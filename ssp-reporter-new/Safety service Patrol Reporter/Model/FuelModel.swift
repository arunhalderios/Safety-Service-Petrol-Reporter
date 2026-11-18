//
//  FuelModel.swift
//  Safety service Patrol Reporter
//
//  Created by Pritam Dey on 20/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import Foundation


struct FuelReportDetails : Codable {
    let vehicle_id : String?
    let cost_per_galon : String?
    let total_cost : String?
    let fuel_quantity : String?
    let refueling_date : String?
    let refueling_time : String?
    let fuel_type : String?
    let odo_meter_reading : String?
    let fuel_taken_tank : String?
    let fuel_taken_can : String?
    let latitude : String?
    let longitude : String?
    let reciept : String?
    let note : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case vehicle_id = "vehicle_id"
        case cost_per_galon = "cost_per_galon"
        case total_cost = "total_cost"
        case fuel_quantity = "fuel_quantity"
        case refueling_date = "refueling_date"
        case refueling_time = "refueling_time"
        case fuel_type = "fuel_type"
        case odo_meter_reading = "odo_meter_reading"
        case fuel_taken_tank = "fuel_taken_tank"
        case fuel_taken_can = "fuel_taken_can"
        case latitude = "latitude"
        case longitude = "longitude"
        case reciept = "reciept"
        case note = "note"
        case status = "status"
    }
}

class FuelModel {

var stateList:[ShitStateList]?

}
