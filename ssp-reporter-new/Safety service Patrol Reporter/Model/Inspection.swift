/*
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Inspection : Codable {
    let inspection_reports_id : String?
    let company_id : String?
    let company_user_id : String?
    let vehicle_id : String?
    let vehicleId :String?
    let odometer_reading : String?
    let inspection_reports_comment : String?
    let inspection_reports_image : String?
    let insurance_expiary_date : String?
    let registration_expiry_date : String?
    let state_inspection_expiry_date : String?
    let status : String?
    let operator_shift_time_details_id : String?
    let created_ts : String?
    let vin_number : String?

    enum CodingKeys: String, CodingKey {

        case inspection_reports_id = "inspection_reports_id"
        case company_id = "company_id"
        case company_user_id = "company_user_id"
        case vehicle_id = "vehicle_id"
        case odometer_reading = "odometer_reading"
        case inspection_reports_comment = "inspection_reports_comment"
        case inspection_reports_image = "inspection_reports_image"
        case insurance_expiary_date = "insurance_expiary_date"
        case registration_expiry_date = "registration_expiry_date"
        case state_inspection_expiry_date = "state_inspection_expiry_date"
        case status = "status"
        case operator_shift_time_details_id = "operator_shift_time_details_id"
        case created_ts = "created_ts"
        case vin_number = "vin_number"
        case vehicleId = "vehicleId"
    }

}
