/*
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct FuelData : Codable {
    let fuel_master_id : String?
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
    let vehicleId:String?
    let report_for:String?
    let pumping :String?

    enum CodingKeys: String, CodingKey {

        case fuel_master_id = "fuel_master_id"
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
        case vehicleId = "vehicleId"
        case pumping = "pumping"
        case report_for = "report_for"
    }

//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        fuel_master_id = try values.decodeIfPresent(String.self, forKey: .fuel_master_id)
//        vehicle_id = try values.decodeIfPresent(String.self, forKey: .vehicle_id)
//        cost_per_galon = try values.decodeIfPresent(String.self, forKey: .cost_per_galon)
//        total_cost = try values.decodeIfPresent(String.self, forKey: .total_cost)
//        fuel_quantity = try values.decodeIfPresent(String.self, forKey: .fuel_quantity)
//        refueling_date = try values.decodeIfPresent(String.self, forKey: .refueling_date)
//        refueling_time = try values.decodeIfPresent(String.self, forKey: .refueling_time)
//        fuel_type = try values.decodeIfPresent(String.self, forKey: .fuel_type)
//        odo_meter_reading = try values.decodeIfPresent(String.self, forKey: .odo_meter_reading)
//        fuel_taken_tank = try values.decodeIfPresent(String.self, forKey: .fuel_taken_tank)
//        fuel_taken_can = try values.decodeIfPresent(String.self, forKey: .fuel_taken_can)
//        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
//        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
//        reciept = try values.decodeIfPresent(String.self, forKey: .reciept)
//        note = try values.decodeIfPresent(String.self, forKey: .note)
//        status = try values.decodeIfPresent(String.self, forKey: .status)
//        vehicleId = try values.decodeIfPresent(String.self, forKey: .vehicleId)
//    }

}
