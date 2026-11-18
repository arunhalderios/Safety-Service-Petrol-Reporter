/*
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Maintainace : Codable {
    let state_id : String?
    let vehicle_id : String?
    let contract_period : String?
    let report_date : String?
    let service_type_id : String?
    let mileage : String?
    let service_cost : String?
    let used_labour_hour : String?
    let used_labour_min : String?
    let vendor_id : String?
    let repair_description : String?
    let note : String?
    let reciept : String?
    var vehicleId :String?
    let state_name:String?
    let service_type :String?
    let maintenance_report_data_id:String?

    enum CodingKeys: String, CodingKey {

        case state_id = "state_id"
        case vehicle_id = "vehicle_id"
        case contract_period = "contract_period"
        case report_date = "report_date"
        case service_type_id = "service_type_id"
        case mileage = "mileage"
        case service_cost = "service_cost"
        case used_labour_hour = "used_labour_hour"
        case used_labour_min = "used_labour_min"
        case vendor_id = "vendor_id"
        case repair_description = "repair_description"
        case note = "note"
        case reciept = "reciept"
        case vehicleId = "vehicleId"
        case state_name = "state_name"
        case service_type = "service_type"
        case maintenance_report_data_id = "maintenance_report_data_id"
    }

//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        state_id = try values.decodeIfPresent(String.self, forKey: .state_id)
//        vehicle_id = try values.decodeIfPresent(String.self, forKey: .vehicle_id)
//        contract_period = try values.decodeIfPresent(String.self, forKey: .contract_period)
//        report_date = try values.decodeIfPresent(String.self, forKey: .report_date)
//        service_type_id = try values.decodeIfPresent(String.self, forKey: .service_type_id)
//        mileage = try values.decodeIfPresent(String.self, forKey: .mileage)
//        service_cost = try values.decodeIfPresent(String.self, forKey: .service_cost)
//        used_labour_hour = try values.decodeIfPresent(String.self, forKey: .used_labour_hour)
//        used_labour_min = try values.decodeIfPresent(String.self, forKey: .used_labour_min)
//        vendor_id = try values.decodeIfPresent(String.self, forKey: .vendor_id)
//        repair_description = try values.decodeIfPresent(String.self, forKey: .repair_description)
//        note = try values.decodeIfPresent(String.self, forKey: .note)
//        reciept = try values.decodeIfPresent(String.self, forKey: .reciept)
//        vehicleId = try values.decodeIfPresent(String.self, forKey: .vehicleId)
//    }

}
