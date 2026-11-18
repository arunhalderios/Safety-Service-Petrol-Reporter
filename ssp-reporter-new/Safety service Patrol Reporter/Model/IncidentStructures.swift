//
//  IncidentStructures.swift
//  Safety service Patrol Reporter
//
//  Created by Pritam Dey on 22/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import Foundation
struct ModelVehicleInformation : Codable {
    let color:String?
    let plate_no:String?
    let vehicle_type:String?
    enum CodingKeys: String, CodingKey {
        case color = "color"
        case plate_no = "plate_no"
        case vehicle_type = "vehicle_type"
    }
}

struct IncidentDetailsDataModel : Codable {
    let incidents_report_data_id : String?
    let company_id : String?
    let company_user_id : String?
    let operator_shift_time_details_id : String?
    let state_id : String?
    let operation_id : String?
    let zone_id : String?
    let latitude : String?
    let longitude : String?
    let vehicle_id : String?
    let call_at : String?
    let call_started : String?
    let call_completed : String?
    let incedent_time : String?
    let incedent_type_id : String?
    let route_id : String?
    var traffic_direction : String?
    let milage_in : String?
    let milage_out : String?
    let mile_marker : String?
   // let resolution : String?
    let is_no_licence_plate : String?
    let property_damage : String?
    let secendary_cash_involve : String?
    let first_responder : String?
    let first_responder_unit_number : String?
    let road_surface : String?
    let lane_location : String?
    let passenger_transported : String?
    let number_of_vehicle : String?
    let color_name : String?
    let vehicle_type_id : String?
    let assist_type_id : String?
    let comments : String?
    let incedent_photo : String?
    let incedent_video : String?
    let incedent_thumb : String?
    let note : String?
    let is_dispatched_incedent : String?
    let status : String?
    let incident_status : String?
    let deny_reason : String?
    let created_by : String?
    let created_ts : String?
    let updated_by : String?
    let updated_ts : String?
    let lane_location_id : String?
    let traffic_direction_id : String?
    let lane_location_name : String?
    let state_name : String?
    let beat_zone_name : String?
    let route_name : String?
    let first_name : String?
    let last_name : String?
    let vin_number : String?
    let incident_type_name : String?
    let phone : String?
    let vehicle_type_name : String?
    let assist_type : String?
    let color_id : String?
    let color_code : String?
    let property_damage_id : String?
    let first_responder_id : String?
    let crash_Inv_id : String?
    let plate_no :String?
    let ID :String?
    let contract_name:String?
    let contract_id:String?
    let vendor_id:String?
    let vendor_name : String?
    let vehicleInformation :[ModelVehicleInformation]?
    let laneRestorationTime : String?
    var travelLanesBlocked : String?
    let incidentNo : String?

    enum CodingKeys: String, CodingKey {

        case incidents_report_data_id = "Incidents_report_data_id"
        case company_id = "company_id"
        case company_user_id = "company_user_id"
        case operator_shift_time_details_id = "operator_shift_time_details_id"
        case state_id = "state_id"
        case operation_id = "operation_id"
        case zone_id = "zone_id"
        case latitude = "latitude"
        case longitude = "longitude"
        case vehicle_id = "vehicle_id"
        case call_at = "call_at"
        case call_started = "call_started"
        case call_completed = "call_completed"
        case incedent_time = "incedent_time"
        case incedent_type_id = "incedent_type_id"
        case route_id = "route_id"
        case traffic_direction = "traffic_direction"
        case milage_in = "milage_in"
        case milage_out = "milage_out"
        case mile_marker = "mile_marker"
        case is_no_licence_plate = "is_no_licence_plate"
        case property_damage = "property_damage"
        case secendary_cash_involve = "secendary_cash_involve"
        case first_responder = "first_responder"
        case first_responder_unit_number = "first_responder_unit_number"
        case road_surface = "road_surface"
        case lane_location = "lane_location"
        case passenger_transported = "passenger_transported"
        case number_of_vehicle = "number_of_vehicle"
        case color_name = "color_name"
        case vehicle_type_id = "vehicle_type_id"
        case assist_type_id = "assist_type_id"
        case comments = "comments"
        case incedent_photo = "incedent_photo"
        case incedent_video = "incedent_video"
        case incedent_thumb = "incedent_thumb"
        case note = "note"
        case is_dispatched_incedent = "is_dispatched_incedent"
        case status = "status"
        case incident_status = "incident_status"
        case deny_reason = "deny_reason"
        case created_by = "created_by"
        case created_ts = "created_ts"
        case updated_by = "updated_by"
        case updated_ts = "updated_ts"
        case lane_location_id = "lane_location_id"
        case traffic_direction_id = "traffic_direction_id"
        case state_name = "state_name"
        case beat_zone_name = "beat_zone_name"
        case route_name = "route_name"
        case first_name = "first_name"
        case last_name = "last_name"
        case phone = "phone"
        case vin_number = "vin_number"
        case incident_type_name = "incident_type_name"
        case vehicle_type_name = "vehicle_type_name"
        case assist_type = "assist_type"
        case color_id = "color_id"
        case color_code = "color_code"
        case property_damage_id = "property_damage_id"
        case first_responder_id = "first_responder_id"
        case crash_Inv_id = "crash_Inv_id"
        case plate_no = "plate_no"
        case lane_location_name = "lane_location_name"
        case ID = "ID"
        case contract_name = "contract_name"
        case contract_id = "contract_id"
        case vendor_id = "vendor_id"
        case vendor_name = "vendor_name"
        case vehicleInformation = "vehicleInformation"
        case incidentNo = "incident_no"
        case travelLanesBlocked = "travel_lanes_blocked"
        case laneRestorationTime = "lane_restoration_time"
        
    }
    

}
