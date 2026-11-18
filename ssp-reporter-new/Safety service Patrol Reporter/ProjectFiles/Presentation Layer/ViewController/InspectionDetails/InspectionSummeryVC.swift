//
//  InspectionSummeryVC.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Mahalik on 09/04/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit
import Kingfisher

class InspectionSummeryVC: BaseViewController {
    var tootsArray = [ToolsReport]()
    var comments:String?
    var imageLink: String?
    var brokenTools:[ToolsReport] = []
    var missingTools:[ToolsReport] = []
    var presentTools:[ToolsReport] = []
    var model:InspectionViewModel?
    var arrayTitle = ["Comment",""]
    @IBOutlet weak var tableviewInspection: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        brokenTools = tootsArray.filter { $0.tool_status == "broken"  || $0.tool_status == "Broken"}
        missingTools = tootsArray.filter { $0.tool_status == "missing" || $0.tool_status == "Missing"}
        presentTools = tootsArray.filter { $0.tool_status == "present" || $0.tool_status == "Present"}
        
        //  if brokenTools.count > 0{
        arrayTitle.insert("Broken:", at: 0)
        //   }
        //    if missingTools.count > 0{
        arrayTitle.insert("Missing:", at: 0)
        //  }
        ///   if presentTools.count > 0{
        arrayTitle.insert("Present:", at: 0)
        //}
        self.tableviewInspection.reloadData()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }

    
    
    
}
extension InspectionSummeryVC:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayTitle.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.presentTools.count
        }else if section == 1{
            return self.missingTools.count
        }else if section == 2{
            return self.brokenTools.count
        }else{
            return 1
        }
        //        if section == 0 && arrayTitle.count  >= 3{
        //            if self.presentTools.count > 0{
        //                return self.presentTools.count
        //            }else if self.missingTools.count > 0{
        //                return self.missingTools.count
        //            }else{
        //                return self.brokenTools.count
        //            }
        //
        //        }else if section == 1 && arrayTitle.count  >= 4{
        //            if self.brokenTools.count > 0{
        //                return self.brokenTools.count
        //            }else{
        //                return self.missingTools.count
        //            }
        //        }else if section == 2 && (arrayTitle.count ) >= 5{
        //            return self.brokenTools.count
        //
        //        }else {
        //            return 1
        //        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == arrayTitle.count-1{
            return 160
        }
        if indexPath.section == 0{
            if self.presentTools.count > 0{
                return UITableView.automaticDimension
            }else{
                return 0
            }
        }else if indexPath.section == 1{
            if self.missingTools.count > 0{
                return UITableView.automaticDimension
            }else{
                return 0
            }
        }else if indexPath.section == 2{
            if self.brokenTools.count > 0{
                return UITableView.automaticDimension
            }else{
                return 0
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == arrayTitle.count-1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InspectionImageCell", for: indexPath) as! InspectionImageCell
            //print(model?.inspectionObject?.reportImages)
            switch model?.inspectionObject?.reportImages?.count {
            case 1:
                cell.imgViewDetail1.isHidden = false
                if let url = model?.inspectionObject?.reportImages?[safe: 0]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail1.kf.setImage(with: urlImage)
                    }
                }
            case 2:
                cell.imgViewDetail1.isHidden = false
                cell.imgViewDetail2.isHidden = false
                if let url = model?.inspectionObject?.reportImages?[safe: 0]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail1.kf.setImage(with: urlImage)
                    }
                }
                if let url = model?.inspectionObject?.reportImages?[safe: 1]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail2.kf.setImage(with: urlImage)
                    }
                }
            case 3:
                cell.imgViewDetail1.isHidden = false
                cell.imgViewDetail2.isHidden = false
                cell.imgViewDetail3.isHidden = false
                if let url = model?.inspectionObject?.reportImages?[safe: 0]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail1.kf.setImage(with: urlImage)
                    }
                }
                if let url = model?.inspectionObject?.reportImages?[safe: 1]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail2.kf.setImage(with: urlImage)
                    }
                }
                if let url = model?.inspectionObject?.reportImages?[safe: 2]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail3.kf.setImage(with: urlImage)
                    }
                }
            case 4:
                cell.imgViewDetail1.isHidden = false
                cell.imgViewDetail2.isHidden = false
                cell.imgViewDetail3.isHidden = false
                cell.imgViewDetail4.isHidden = false
                if let url = model?.inspectionObject?.reportImages?[safe: 0]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail1.kf.setImage(with: urlImage)
                    }
                }
                if let url = model?.inspectionObject?.reportImages?[safe: 1]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail2.kf.setImage(with: urlImage)
                    }
                }
                if let url = model?.inspectionObject?.reportImages?[safe: 2]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail3.kf.setImage(with: urlImage)
                    }
                }
                if let url = model?.inspectionObject?.reportImages?[safe: 3]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail4.kf.setImage(with: urlImage)
                    }
                }
            case 5:
                cell.imgViewDetail1.isHidden = false
                cell.imgViewDetail2.isHidden = false
                cell.imgViewDetail3.isHidden = false
                cell.imgViewDetail4.isHidden = false
                cell.imgViewDetail5.isHidden = false
                if let url = model?.inspectionObject?.reportImages?[safe: 0]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail1.kf.setImage(with: urlImage)
                    }
                }
                if let url = model?.inspectionObject?.reportImages?[safe: 1]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail2.kf.setImage(with: urlImage)
                    }
                }
                if let url = model?.inspectionObject?.reportImages?[safe: 2]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail3.kf.setImage(with: urlImage)
                    }
                }
                if let url = model?.inspectionObject?.reportImages?[safe: 3]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail4.kf.setImage(with: urlImage)
                    }
                }
                if let url = model?.inspectionObject?.reportImages?[safe: 4]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail5.kf.setImage(with: urlImage)
                    }
                }
            case 6:
                cell.imgViewDetail1.isHidden = false
                cell.imgViewDetail2.isHidden = false
                cell.imgViewDetail3.isHidden = false
                cell.imgViewDetail4.isHidden = false
                cell.imgViewDetail5.isHidden = false
                cell.imgViewDetail6.isHidden = false
                if let url = model?.inspectionObject?.reportImages?[safe: 0]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail1.kf.setImage(with: urlImage)
                    }else{
                        cell.imgViewDetail1.isHidden = true
                    }
                }else{
                    cell.imgViewDetail1.isHidden = true
                }
                if let url = model?.inspectionObject?.reportImages?[safe: 1]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail2.kf.setImage(with: urlImage)
                    }else{
                        cell.imgViewDetail2.isHidden = true
                    }
                }else{
                    cell.imgViewDetail2.isHidden = true
                }
                if let url = model?.inspectionObject?.reportImages?[safe: 2]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail3.kf.setImage(with: urlImage)
                    }else{
                        cell.imgViewDetail3.isHidden = true
                    }
                }else{
                    cell.imgViewDetail3.isHidden = true
                }
                if let url = model?.inspectionObject?.reportImages?[safe: 3]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail4.kf.setImage(with: urlImage)
                    }else{
                        cell.imgViewDetail4.isHidden = true
                    }
                }else{
                    cell.imgViewDetail4.isHidden = true
                }
                if let url = model?.inspectionObject?.reportImages?[safe: 4]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail5.kf.setImage(with: urlImage)
                    }else{
                        cell.imgViewDetail5.isHidden = true
                    }
                }else{
                    cell.imgViewDetail5.isHidden = true
                }
                if let url = model?.inspectionObject?.reportImages?[safe: 5]{
                    if let urlImage = URL(string: url.image ?? ""){
                        cell.imgViewDetail6.kf.setImage(with: urlImage)
                    }else{
                        cell.imgViewDetail6.isHidden = true
                    }
                }else{
                    cell.imgViewDetail6.isHidden = true
                }
                
            default:
                cell.imgViewDetail1.isHidden = true
                cell.imgViewDetail2.isHidden = true
                cell.imgViewDetail3.isHidden = true
                cell.imgViewDetail4.isHidden = true
                cell.imgViewDetail5.isHidden = true
                cell.imgViewDetail6.isHidden = true
            }
            return cell
            
        }else if (indexPath.section == arrayTitle.count-2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InspectionInputCell1", for: indexPath) as! InspectionInputCell
            
            cell.viewTitle.text = self.comments ?? ""
            print(cell.viewTitle.text)
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InspectionInputCell", for: indexPath) as! InspectionInputCell
            //////////////////////////
            //            if indexPath.section == 0 && (arrayTitle.count ) >= 3 {
            //
            //                if self.presentTools.count > 0{
            //                 cell.viewTitle.text = "\(self.presentTools[indexPath.row].tool_name ?? " ")(\(self.presentTools[indexPath.row].tool_quantity ?? "1"))"
            //
            //                }else if self.missingTools.count > 0{
            //                    cell.viewTitle.text = "\(self.missingTools[indexPath.row].tool_name ?? " ")(\(self.missingTools[indexPath.row].tool_quantity ?? "1"))"
            //
            //                }else{
            //                    cell.viewTitle.text = "\(self.brokenTools[indexPath.row].tool_name ?? " ")(\(self.brokenTools[indexPath.row].tool_quantity ?? "1"))"
            //                }
            //            }
            //            else if indexPath.section == 1 && (arrayTitle.count ) >= 4{
            //
            //                if self.brokenTools.count > 0{
            //                  cell.viewTitle.text = "\(self.brokenTools[indexPath.row].tool_name ?? " ")(\(self.brokenTools[indexPath.row].tool_quantity ?? "1"))"
            //
            //                }else{
            //                    cell.viewTitle.text = "\(self.missingTools[indexPath.row].tool_name ?? " ")(\(self.missingTools[indexPath.row].tool_quantity ?? "1"))"
            //
            //                }
            //
            //            }
            //            else if indexPath.section == 2 && (arrayTitle.count ) >= 5{
            //                cell.viewTitle.text = "\(self.brokenTools[indexPath.row].tool_name ?? " ")(\(self.brokenTools[indexPath.row].tool_quantity ?? "1"))"
            //
            //            }
            
            
            
            
            if indexPath.section == 0{
                
                if self.presentTools.count > 0{
                    cell.viewTitle.text = "\(self.presentTools[indexPath.row].tool_name ?? " ")(\(self.presentTools[indexPath.row].tool_quantity ?? "0"))"
                    
                }
            }
            else if indexPath.section == 1 {
                
                cell.viewTitle.text = "\(self.missingTools[indexPath.row].tool_name ?? " ")(\(self.missingTools[indexPath.row].tool_quantity ?? "0"))"
                
                
                
            }
            else if indexPath.section == 2{
                cell.viewTitle.text = "\(self.brokenTools[indexPath.row].tool_name ?? " ")(\(self.brokenTools[indexPath.row].tool_quantity ?? "0"))"
                
            }
            
            
            
            
            
            
            return cell
            
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 4{
            return 0.1
        }else{
            
            
            if section == 0 {
                
                if self.presentTools.count > 0   {
                    return 50
                    
                }else{
                    return 0.01
                }
                
            }else if section == 1 {
                if self.missingTools.count > 0{
                    return 50
                    
                }else{
                    return 0.01
                }
            }
            else if section == 2 {
                if self.brokenTools.count > 0{
                    return 50
                    
                }else{
                    return 0.01
                }
            }
            
            
            
            
            return 50
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tableviewInspection.dequeueReusableCell(withIdentifier: "InspectionInputCell1") as? InspectionInputCell
        if cell != nil{
            cell?.viewTitle.textColor = AppthemeColor
            
            if section == 0 {
                
                if self.presentTools.count > 0   {
                    cell?.viewTitle.text = "Tools Presents"
                    
                }else{
                    cell?.viewTitle.text = ""
                }
                
            }else if section == 1 {
                if self.missingTools.count > 0{
                    cell?.viewTitle.text = "Tools Missing"
                    
                }else{
                    cell?.viewTitle.text = ""
                }
            }
            else if section == 2 {
                if self.brokenTools.count > 0{
                    cell?.viewTitle.text = "Tools Broken"
                    
                }else{
                    cell?.viewTitle.text = ""
                }
            }
                
                
                
                
                
                
                
                
                
                
                
                
            else if  section == arrayTitle.count-2 {
                cell?.viewTitle.textColor = AppthemeColor
                cell?.viewTitle.text = "Comment"
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
