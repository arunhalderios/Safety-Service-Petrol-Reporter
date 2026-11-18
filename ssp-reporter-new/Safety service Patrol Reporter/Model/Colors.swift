/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Colors : Codable {
	let color_id : String?
	let company_id : String?
	let color_name : String?
	let color_code : String?
	let status : String?
	let created_ts : String?
	let updated_ts : String?

	enum CodingKeys: String, CodingKey {

		case color_id = "color_id"
		case company_id = "company_id"
		case color_name = "color_name"
		case color_code = "color_code"
		case status = "status"
		case created_ts = "created_ts"
		case updated_ts = "updated_ts"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		color_id = try values.decodeIfPresent(String.self, forKey: .color_id)
		company_id = try values.decodeIfPresent(String.self, forKey: .company_id)
		color_name = try values.decodeIfPresent(String.self, forKey: .color_name)
		color_code = try values.decodeIfPresent(String.self, forKey: .color_code)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		created_ts = try values.decodeIfPresent(String.self, forKey: .created_ts)
		updated_ts = try values.decodeIfPresent(String.self, forKey: .updated_ts)
	}

}
