//
//  NotificaionModel.swift
//  Safety service Patrol Reporter
//
//  Created by Pritam Dey on 03/05/20.
//  Copyright © 2020 met. All rights reserved.
//

import Foundation

struct NotificationDataModel : Codable {
    let read : [MessageModel]?
    let unread : [MessageModel]?
    
    enum CodingKeys: String, CodingKey {

        case read = "read"
        case unread = "unread"
    }

}


struct MessageModel : Codable {
    let notification_master_id : String?
    let created_ts : String?
    let first_name : String?
    let last_name : String?
    let title : String?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case notification_master_id = "notification_master_id"
        case created_ts = "created_ts"
        case first_name = "first_name"
        case last_name = "last_name"
        case title = "title"
        case message = "message"
    }
}

