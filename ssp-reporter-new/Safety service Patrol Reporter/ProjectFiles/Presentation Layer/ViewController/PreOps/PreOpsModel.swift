//
//  PreOpsModel.swift
//  Safety service Patrol Reporter
//
//  Created by Pritam Dey on 28/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class PreOpsModel: NSObject {
    var PreopsVehicleQuestion:String?
    var PreopsVehicleQuestionID : String?
    var Answer: String?
    var Comments: String?
    var imageName:String?
    var imageData: Data? = nil
}

class PreOpsModelTools: NSObject {
    var preOpsToosName:String?
    var preOpsToosID : String?
    var answerTool: String?
    var number: Int = 0
}
