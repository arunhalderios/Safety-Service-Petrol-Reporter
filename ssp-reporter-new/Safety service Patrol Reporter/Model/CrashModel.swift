/*
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct CrashModel : Codable {
    let crash_report_data_id : String?
    let company_user_id : String?
    let vehicle_id : String?
    let vehicleId :String?
    let state_id : String?
    let latitude : String?
    let longitude : String?
    let crash_report_date : String?
    let crash_report_time : String?
    let self_injured : String?
    let other_injured : String?
    let number_of_injured_people : String?
    let contacted_tmc : String?
    let contacted_supervisor : String?
    let you_inside_truck : String?
    let safety_belt : String?
    let police_report : String?
    let written_statement : String?
    let exterior_vehicle_photo1 : String?
    let exterior_vehicle_photo2 : String?
    let exterior_vehicle_photo3 : String?
    let exterior_vehicle_photo4 : String?
    let interior_vehicle_photo1 : String?
    let interior_vehicle_photo2 : String?
    let interior_vehicle_photo3 : String?
    let interior_vehicle_photo4 : String?
    let autotag_vin_photo1 : String?
    let autotag_vin_photo2 : String?
    let autotag_vin_photo3 : String?
    let autotag_vin_photo4 : String?
    let third_party_vehicle_photo1 : String?
    let third_party_vehicle_photo2 : String?
    let third_party_vehicle_photo3 : String?
    let third_party_vehicle_photo4 : String?
    let driver_info : [Driver_info]?
    let state_name:String?

    enum CodingKeys: String, CodingKey {

        case crash_report_data_id = "crash_report_data_id"
        case company_user_id = "company_user_id"
        case vehicle_id = "vehicle_id"
        case state_id = "state_id"
        case latitude = "latitude"
        case longitude = "longitude"
        case crash_report_date = "crash_report_date"
        case crash_report_time = "crash_report_time"
        case self_injured = "self_injured"
        case other_injured = "other_injured"
        case number_of_injured_people = "number_of_injured_people"
        case contacted_tmc = "contacted_tmc"
        case contacted_supervisor = "contacted_supervisor"
        case you_inside_truck = "you_inside_truck"
        case safety_belt = "safety_belt"
        case police_report = "police_report"
        case written_statement = "written_statement"
        case exterior_vehicle_photo1 = "exterior_vehicle_photo1"
        case exterior_vehicle_photo2 = "exterior_vehicle_photo2"
        case exterior_vehicle_photo3 = "exterior_vehicle_photo3"
        case exterior_vehicle_photo4 = "exterior_vehicle_photo4"
        case interior_vehicle_photo1 = "interior_vehicle_photo1"
        case interior_vehicle_photo2 = "interior_vehicle_photo2"
        case interior_vehicle_photo3 = "interior_vehicle_photo3"
        case interior_vehicle_photo4 = "interior_vehicle_photo4"
        case autotag_vin_photo1 = "autotag_vin_photo1"
        case autotag_vin_photo2 = "autotag_vin_photo2"
        case autotag_vin_photo3 = "autotag_vin_photo3"
        case autotag_vin_photo4 = "autotag_vin_photo4"
        case third_party_vehicle_photo1 = "third_party_vehicle_photo1"
        case third_party_vehicle_photo2 = "third_party_vehicle_photo2"
        case third_party_vehicle_photo3 = "third_party_vehicle_photo3"
        case third_party_vehicle_photo4 = "third_party_vehicle_photo4"
        case driver_info = "driver_info"
        case vehicleId = "vehicleId"
        case state_name = "state_name"
    }

//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        crash_report_data_id = try values.decodeIfPresent(String.self, forKey: .crash_report_data_id)
//        company_user_id = try values.decodeIfPresent(String.self, forKey: .company_user_id)
//        vehicle_id = try values.decodeIfPresent(String.self, forKey: .vehicle_id)
//        state_id = try values.decodeIfPresent(String.self, forKey: .state_id)
//        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
//        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
//        crash_report_date = try values.decodeIfPresent(String.self, forKey: .crash_report_date)
//        crash_report_time = try values.decodeIfPresent(String.self, forKey: .crash_report_time)
//        self_injured = try values.decodeIfPresent(String.self, forKey: .self_injured)
//        other_injured = try values.decodeIfPresent(String.self, forKey: .other_injured)
//        number_of_injured_people = try values.decodeIfPresent(String.self, forKey: .number_of_injured_people)
//        contacted_tmc = try values.decodeIfPresent(String.self, forKey: .contacted_tmc)
//        contacted_supervisor = try values.decodeIfPresent(String.self, forKey: .contacted_supervisor)
//        you_inside_truck = try values.decodeIfPresent(String.self, forKey: .you_inside_truck)
//        safety_belt = try values.decodeIfPresent(String.self, forKey: .safety_belt)
//        police_report = try values.decodeIfPresent(String.self, forKey: .police_report)
//        written_statement = try values.decodeIfPresent(String.self, forKey: .written_statement)
//        exterior_vehicle_photo1 = try values.decodeIfPresent(String.self, forKey: .exterior_vehicle_photo1)
//        exterior_vehicle_photo2 = try values.decodeIfPresent(String.self, forKey: .exterior_vehicle_photo2)
//        exterior_vehicle_photo3 = try values.decodeIfPresent(String.self, forKey: .exterior_vehicle_photo3)
//        exterior_vehicle_photo4 = try values.decodeIfPresent(String.self, forKey: .exterior_vehicle_photo4)
//        interior_vehicle_photo1 = try values.decodeIfPresent(String.self, forKey: .interior_vehicle_photo1)
//        interior_vehicle_photo2 = try values.decodeIfPresent(String.self, forKey: .interior_vehicle_photo2)
//        interior_vehicle_photo3 = try values.decodeIfPresent(String.self, forKey: .interior_vehicle_photo3)
//        interior_vehicle_photo4 = try values.decodeIfPresent(String.self, forKey: .interior_vehicle_photo4)
//        autotag_vin_photo1 = try values.decodeIfPresent(String.self, forKey: .autotag_vin_photo1)
//        autotag_vin_photo2 = try values.decodeIfPresent(String.self, forKey: .autotag_vin_photo2)
//        autotag_vin_photo3 = try values.decodeIfPresent(String.self, forKey: .autotag_vin_photo3)
//        autotag_vin_photo4 = try values.decodeIfPresent(String.self, forKey: .autotag_vin_photo4)
//        third_party_vehicle_photo1 = try values.decodeIfPresent(String.self, forKey: .third_party_vehicle_photo1)
//        third_party_vehicle_photo2 = try values.decodeIfPresent(String.self, forKey: .third_party_vehicle_photo2)
//        third_party_vehicle_photo3 = try values.decodeIfPresent(String.self, forKey: .third_party_vehicle_photo3)
//        third_party_vehicle_photo4 = try values.decodeIfPresent(String.self, forKey: .third_party_vehicle_photo4)
//        driver_info = try values.decodeIfPresent([Driver_info].self, forKey: .driver_info)
//        vehicleId = try values.decodeIfPresent(String.self, forKey: .vehicleId)
//    }

}
