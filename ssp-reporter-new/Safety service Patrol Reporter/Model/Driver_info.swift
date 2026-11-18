/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Driver_info : Codable {
	let dirver_name : String?
	let driver_phone : String?
	let driver_address : String?
	let driver_licence_number : String?
	let vehicle_insurance_info : String?
	let insurance_expriary_date : String?
	let passenger_info : [Passenger_info]?
   // let isinjury : String?
    
	enum CodingKeys: String, CodingKey {

		case dirver_name = "dirver_name"
		case driver_phone = "driver_phone"
		case driver_address = "driver_address"
		case driver_licence_number = "driver_licence_number"
		case vehicle_insurance_info = "vehicle_insurance_info"
		case insurance_expriary_date = "insurance_expriary_date"
		case passenger_info = "passenger_info"
        //case isinjury = "passenger_info"
	}

//	init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		dirver_name = try values.decodeIfPresent(String.self, forKey: .dirver_name)
//		driver_phone = try values.decodeIfPresent(String.self, forKey: .driver_phone)
//		driver_address = try values.decodeIfPresent(String.self, forKey: .driver_address)
//		driver_licence_number = try values.decodeIfPresent(String.self, forKey: .driver_licence_number)
//		vehicle_insurance_info = try values.decodeIfPresent(String.self, forKey: .vehicle_insurance_info)
//		insurance_expriary_date = try values.decodeIfPresent(String.self, forKey: .insurance_expriary_date)
//		passenger_info = try values.decodeIfPresent([Passenger_info].self, forKey: .passenger_info)
//	}

}
