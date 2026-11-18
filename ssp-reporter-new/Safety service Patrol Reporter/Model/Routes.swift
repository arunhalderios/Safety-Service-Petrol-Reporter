/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Routes : Codable {
	let route_id : String?
	let state_id : String?
	let operation_area_id : String?
	let beat_zone_id : String?
	let route_name : String?
	let geo_fencing_radious : String?
	let start_mile_marker : String?
	let start_address : String?
	let start_lat : String?
	let start_long : String?
	let end_mile_marker : String?
	let end_address : String?
	let end_lat : String?
	let end_long : String?
	let status : String?
	let company_id : String?
	let created_by : String?
	let created_ts : String?
	let updated_by : String?
	let updated_ts : String?
	let state_name : String?
	let company_name : String?
	let routeStatus : String?
    
    

	enum CodingKeys: String, CodingKey {

		case route_id = "route_id"
		case state_id = "state_id"
		case operation_area_id = "operation_area_id"
		case beat_zone_id = "beat_zone_id"
		case route_name = "route_name"
		case geo_fencing_radious = "geo_fencing_radious"
		case start_mile_marker = "start_mile_marker"
		case start_address = "start_address"
		case start_lat = "start_lat"
		case start_long = "start_long"
		case end_mile_marker = "end_mile_marker"
		case end_address = "end_address"
		case end_lat = "end_lat"
		case end_long = "end_long"
		case status = "status"
		case company_id = "company_id"
		case created_by = "created_by"
		case created_ts = "created_ts"
		case updated_by = "updated_by"
		case updated_ts = "updated_ts"
		case state_name = "state_name"
		case company_name = "company_name"
		case routeStatus = "routeStatus"
	}

}
