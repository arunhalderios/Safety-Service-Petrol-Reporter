//
//  InpectionDetailModel.swift
//  Safety service Patrol Reporter
//
//  Created by Pritam Dey on 30/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import Foundation

struct InspectionDataModel : Codable {
    let reportUserData : ReportUserData?
    let questionsResult : [QuestionsResult]?
    let toolsReport : [ToolsReport]?
    var reportImages :[ImagesInspection]?

    enum CodingKeys: String, CodingKey {

        case reportUserData = "reportUserData"
        case questionsResult = "questionsResult"
        case toolsReport = "toolsReport"
        case reportImages = "reportImages"
    }

}

struct ToolsReport : Codable {
    let inspection_vehicle_tool_summary_id : String?
    let company_id : String?
    let tool_id : String?
    let tool_status : String?
    let tool_quantity : String?
    let inspection_reports_id : String?
    let status : String?
    let tool_name : String?

    enum CodingKeys: String, CodingKey {

        case inspection_vehicle_tool_summary_id = "inspection_vehicle_tool_summary_id"
        case company_id = "company_id"
        case tool_id = "tool_id"
        case tool_status = "tool_status"
        case tool_quantity = "tool_quantity"
        case inspection_reports_id = "inspection_reports_id"
        case status = "status"
        case tool_name = "tool_name"
    }

}

struct ReportUserData : Codable {
    let inspection_reports_id : String?
    let company_id : String?
    let company_user_id : String?
    let vehicle_id : String?
    let odometer_reading : String?
    let inspection_reports_comment : String?
    let inspection_reports_image : String?
    let insurance_expiary_date : String?
    let registration_expiry_date : String?
    let state_inspection_expiry_date : String?
    let inspection_date : String?
    let inspection_time : String?
    let status : String?
    let operator_shift_time_details_id : String?
    let created_ts : String?
    let vehicleId : String?
    let first_name : String?
    let last_name : String?
    let insurance_image :String?
    let registration_image:String?
    let plate_image:String?
    let inspection_image:String?
    
    enum CodingKeys: String, CodingKey {

        case inspection_reports_id = "inspection_reports_id"
        case company_id = "company_id"
        case company_user_id = "company_user_id"
        case vehicle_id = "vehicle_id"
        case odometer_reading = "odometer_reading"
        case inspection_reports_comment = "inspection_reports_comment"
        case inspection_reports_image = "reports_image"
        case insurance_expiary_date = "insurance_expiary_date"
        case registration_expiry_date = "registration_expiry_date"
        case state_inspection_expiry_date = "state_inspection_expiry_date"
        case inspection_date = "inspection_date"
        case inspection_time = "inspection_time"
        case status = "status"
        case operator_shift_time_details_id = "operator_shift_time_details_id"
        case created_ts = "created_ts"
        case vehicleId = "vehicleId"
        case first_name = "first_name"
        case last_name = "last_name"
        case insurance_image = "insurance_image"
        case registration_image = "registration_image"
        case plate_image = "plate_image"
        case inspection_image = "inspection_image"
       
    }

    

}


struct QuestionsResult : Codable {
    let inspection_vehicle_answer_id : String?
    let company_id : String?
    let inspection_vehicle_question_id : String?
    let inspection_vehicle_answer : String?
    let inspection_vehicle_answer_comments : String?
    let inspection_vehicle_answer_image : String?
    let inspection_reports_id : String?
    let status : String?
    let created_by : String?
    let created_ts : String?
    let updated_by : String?
    let updated_ts : String?
    let inspection_vehicle_question : String?

    enum CodingKeys: String, CodingKey {

        case inspection_vehicle_answer_id = "inspection_vehicle_answer_id"
        case company_id = "company_id"
        case inspection_vehicle_question_id = "inspection_vehicle_question_id"
        case inspection_vehicle_answer = "inspection_vehicle_answer"
        case inspection_vehicle_answer_comments = "inspection_vehicle_answer_comments"
        case inspection_vehicle_answer_image = "inspection_vehicle_answer_image"
        case inspection_reports_id = "inspection_reports_id"
        case status = "status"
        case created_by = "created_by"
        case created_ts = "created_ts"
        case updated_by = "updated_by"
        case updated_ts = "updated_ts"
        case inspection_vehicle_question = "inspection_vehicle_question"
    }


}
