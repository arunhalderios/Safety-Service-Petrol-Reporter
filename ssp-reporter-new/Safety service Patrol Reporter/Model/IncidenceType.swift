/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct IncidenceType : Codable {
	let incident_id : String?
	let name : String?
	let status : String?
	let assist_id : String?
	let company_id : String?
	let created_by : String?
	let created_ts : String?
	let updated_by : String?
	let updated_ts : String?
	let is_delete : String?

	enum CodingKeys: String, CodingKey {

		case incident_id = "incident_id"
		case name = "name"
		case status = "status"
		case assist_id = "assist_id"
		case company_id = "company_id"
		case created_by = "created_by"
		case created_ts = "created_ts"
		case updated_by = "updated_by"
		case updated_ts = "updated_ts"
		case is_delete = "is_delete"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		incident_id = try values.decodeIfPresent(String.self, forKey: .incident_id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		assist_id = try values.decodeIfPresent(String.self, forKey: .assist_id)
		company_id = try values.decodeIfPresent(String.self, forKey: .company_id)
		created_by = try values.decodeIfPresent(String.self, forKey: .created_by)
		created_ts = try values.decodeIfPresent(String.self, forKey: .created_ts)
		updated_by = try values.decodeIfPresent(String.self, forKey: .updated_by)
		updated_ts = try values.decodeIfPresent(String.self, forKey: .updated_ts)
		is_delete = try values.decodeIfPresent(String.self, forKey: .is_delete)
	}

}
