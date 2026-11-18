/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Passenger_info : Codable {
	let name : String?
	let passenger_address : String?
	let passenger_phone : String?
	let passenger_licence_number : String?
    let is_injury :String?

	enum CodingKeys: String, CodingKey {

		case name = "name"
		case passenger_address = "passenger_address"
		case passenger_phone = "passenger_phone"
		case passenger_licence_number = "passenger_licence_number"
        case is_injury = "is_injury"
	}

//	init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		name = try values.decodeIfPresent(String.self, forKey: .name)
//		passenger_address = try values.decodeIfPresent(String.self, forKey: .passenger_address)
//		passenger_phone = try values.decodeIfPresent(String.self, forKey: .passenger_phone)
//		passenger_licence_number = try values.decodeIfPresent(String.self, forKey: .passenger_licence_number)
//	}

}
