/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct PreOpsQuestions : Codable {
    let preops_vehicle_question_id : String?
    let company_id : String?
    let preops_vehicle_question : String?
    let status : String?
    let company_name : String?

    enum CodingKeys: String, CodingKey {

        case preops_vehicle_question_id = "vehicle_question_id"
        case company_id = "company_id"
        case preops_vehicle_question = "vehicle_question"
        case status = "status"
        case company_name = "company_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        preops_vehicle_question_id = try values.decodeIfPresent(String.self, forKey: .preops_vehicle_question_id)
        company_id = try values.decodeIfPresent(String.self, forKey: .company_id)
        preops_vehicle_question = try values.decodeIfPresent(String.self, forKey: .preops_vehicle_question)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        company_name = try values.decodeIfPresent(String.self, forKey: .company_name)
    }
    

}
