/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct TrafficDirection : Codable {
	let traffic_direction_id : String?
	let traffic_direction : String?
	let status : String?
	let company_id : String?
	let created_ts : String?
	let updated_ts : String?

	enum CodingKeys: String, CodingKey {

		case traffic_direction_id = "traffic_direction_id"
		case traffic_direction = "traffic_direction"
		case status = "status"
		case company_id = "company_id"
		case created_ts = "created_ts"
		case updated_ts = "updated_ts"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		traffic_direction_id = try values.decodeIfPresent(String.self, forKey: .traffic_direction_id)
		traffic_direction = try values.decodeIfPresent(String.self, forKey: .traffic_direction)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		company_id = try values.decodeIfPresent(String.self, forKey: .company_id)
		created_ts = try values.decodeIfPresent(String.self, forKey: .created_ts)
		updated_ts = try values.decodeIfPresent(String.self, forKey: .updated_ts)
	}

}
