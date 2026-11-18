//
//  IncidentDetailsVC.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Prasad Mahaliik on 20/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit
import AVKit
class CustomAVPlayerViewController: AVPlayerViewController {

//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .landscapeLeft
//    }
    
}
class IncidentDetailsVC: BaseViewController,SliderCellDelegate,AVPlayerViewControllerDelegate {
    var playerViewController = CustomAVPlayerViewController()
    var cellHeight: [IndexPath :CGFloat] = [:]
    var arrayImagesSlide:[String] = ["truck","truck"]
    let arrayTitle = ["Ind#:","Operator Name:","Phone:","Vehicle ID:","Call At:","Call Started:","Call Completed:","Incident Time:","Incident Type Id:","Incident type:","Shift ID:","Latitude:","Longitude:","Route:","Traffic Direction:","State:","Mile Marker:","Vehicle Color:","Vehicle Type:","Property Damage:","Secondary crash involved:","Assist Type","Incident Comment:"]
    // let arrayDetails = ["42047","Gerad Suppa","1234567890","W12344","12:00 PM","05:00PM","08:00PM","03:00hr","12589","11","AM/PM","125896","38.1940","-85.82638","1264","B","NEW YORK","127280","127397","6.6","Silver","Car","Yes","Yes","Fleet","Driver out of gas"]
    
    @IBOutlet weak var lblTitle: UILabel!
    var arrayPopulate : [String] = []
    //"First Responder","First Responder Unit Number","Property Damage","Road Surface","Lane Location","Passengers Transported","Number of Vehicles",
    var selectedIndex = 0
    var modelIncidence : IncidentDetailsDataModel?
    fileprivate enum CELL_CONTENT:Int{
        case ind = 0
        case operator_name
        case phone
        case vehicle_id
        case Call_At
        case Call_Started
        case Call_Completed
        case Incident_Time
        case Incident_type_iD
        case Incident_type
        case shift
        case Latitude
        case Longitude
        case Route_1
        case Traffic_Direction
        case State
        case Mile_Marker
        case Vendor
        case Contract
        case Vehicle_Type
        case Property_Damage
        case Secondary_crash_involved
        case Assist_Type
        case Comments
        case CELL_RESET_CONTENT_TOTAL
        
    }
    
    @IBOutlet weak var tableIncidentDetails: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0...CELL_CONTENT.CELL_RESET_CONTENT_TOTAL.rawValue - 1{
            self.arrayPopulate.append("")
        }
        self.populateData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if arrayPopulate.count > 0{
            self.lblTitle.text = "Ind#\(arrayPopulate[0])"
        }
        TimeService.instance.resetInactivityTimer()
    }
    
    
    @IBAction func btnPlayVideoAction(_ sender: Any) {
        var videoURL : URL?
        
       
            let originalString = modelIncidence?.incedent_video ?? ""
            //let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
           // print(escapedString!)
            videoURL = URL(string: originalString )
            
        
        print("video===%@",videoURL)
     
           
                if videoURL != nil{
                let player = AVPlayer(url: videoURL!)
                   
                self.playerViewController.player = player
                    self.playerViewController.entersFullScreenWhenPlaybackBegins = true
                    
               
                self.playerViewController.delegate = self
                    //player.addObserver(
                       // self, forKeyPath:"currentItem", options:.initial, context:nil)
                self.present(self.playerViewController, animated: true) {
                    self.playerViewController.player!.play()
                }
            } else {
                PROJECT_CONSTANT.displayAlert(Header: App_Title, MessageBody: "Video is not submitted", AllActions: ["OK":nil], Style: .alert)
            }
    }
    
    func populateData() {
        arrayPopulate[CELL_CONTENT.Latitude.rawValue] = modelIncidence?.latitude ?? ""
        arrayPopulate[CELL_CONTENT.Longitude.rawValue] = modelIncidence?.longitude ?? ""
        arrayPopulate[CELL_CONTENT.Call_At.rawValue] = modelIncidence?.call_at ?? ""
        arrayPopulate[CELL_CONTENT.Call_Started.rawValue] = modelIncidence?.call_started ?? ""
        arrayPopulate[CELL_CONTENT.Call_Completed.rawValue] = modelIncidence?.call_completed ?? ""
        arrayPopulate[CELL_CONTENT.Incident_Time.rawValue] = modelIncidence?.incedent_time ?? ""
        arrayPopulate[CELL_CONTENT.Incident_type.rawValue] = modelIncidence?.incident_type_name ?? ""
        arrayPopulate[CELL_CONTENT.Route_1.rawValue] = modelIncidence?.route_name ?? ""
        arrayPopulate[CELL_CONTENT.Traffic_Direction.rawValue] = modelIncidence?.traffic_direction ?? ""
//        arrayPopulate[CELL_CONTENT.Mileage_In.rawValue] = modelIncidence?.milage_in ?? ""
//        arrayPopulate[CELL_CONTENT.Mileage_Out.rawValue] = modelIncidence?.milage_out ?? ""
        arrayPopulate[CELL_CONTENT.Mile_Marker.rawValue] = modelIncidence?.mile_marker ?? ""
        arrayPopulate[CELL_CONTENT.State.rawValue] = modelIncidence?.state_name ?? ""
        arrayPopulate[CELL_CONTENT.Property_Damage.rawValue] = modelIncidence?.property_damage ?? ""
        arrayPopulate[CELL_CONTENT.Secondary_crash_involved.rawValue] = modelIncidence?.secendary_cash_involve ?? "" //
        arrayPopulate[CELL_CONTENT.ind.rawValue] = modelIncidence?.incidents_report_data_id ?? ""
        arrayPopulate[CELL_CONTENT.Call_Started.rawValue] = modelIncidence?.call_started ?? ""
        arrayPopulate[CELL_CONTENT.phone.rawValue] = modelIncidence?.phone ?? ""
        arrayPopulate[CELL_CONTENT.operator_name.rawValue] = modelIncidence?.first_name ?? ""
        arrayPopulate[CELL_CONTENT.vehicle_id.rawValue] = modelIncidence?.vehicle_id ?? ""
        arrayPopulate[CELL_CONTENT.Incident_type_iD.rawValue] = modelIncidence?.incedent_type_id ?? ""
        arrayPopulate[CELL_CONTENT.shift.rawValue] = modelIncidence?.operator_shift_time_details_id ?? ""
        arrayPopulate[CELL_CONTENT.Vendor.rawValue] = modelIncidence?.vendor_name ?? ""
        arrayPopulate[CELL_CONTENT.Vehicle_Type.rawValue] = modelIncidence?.vehicle_type_name ?? ""
        arrayPopulate[CELL_CONTENT.Assist_Type.rawValue] = modelIncidence?.assist_type ?? ""
        arrayPopulate[CELL_CONTENT.Comments.rawValue] = modelIncidence?.comments ?? ""
        arrayPopulate[CELL_CONTENT.Contract.rawValue] = modelIncidence?.contract_name ?? ""
        self.tableIncidentDetails.reloadData()
    }
    func reloadTableDashboud() {
        self.tableIncidentDetails.reloadData()
    }
    
    @IBAction func btnAddIncidentAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddIncidentFormVC") as! AddIncidentFormVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnDetailSelectionAction(_ sender: UIButton) {
        selectedIndex = sender.tag
        // let indexPath  = IndexPath(row: 0, section: 2)
        //self.tableIncidentDetails.reloadSections(IndexSet(integersIn: 2...2), with: .none)
        self.tableIncidentDetails.reloadData()
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension IncidentDetailsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SliderTableCell", for: indexPath) as! SliderTableCell
            cell.delegate = self
            cell.sliderImgCollVw.reloadData()
            cell.arrBannerList = arrayImagesSlide
            //cell.startTimer()
            // cell.pageController.numberOfPages = ArrBannerList.count
            // cell.pageController.hidesForSinglePage = true
            cell.selectionStyle = .none
            
            return cell
        } else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentTitleCell", for: indexPath) as! IncidentTitleCell
            cell.lblTitle.text = modelIncidence?.note
            
            return cell
        } else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentSelectionCell", for: indexPath) as! IncidentSelectionCell
            cell.lblDetails.textColor = UIColor.gray
            cell.lblHighlightDetails.backgroundColor = UIColor.clear
            cell.lblHighLightvideo.backgroundColor = UIColor.clear
            cell.lblHighlightImage.backgroundColor =  UIColor.clear
            cell.lblImage.textColor = UIColor.gray
            //cell.lblHighlightImage.backgroundColor =  UIColor.gray
            //cell.lblHighLightvideo.backgroundColor = UIColor.gray
            cell.lblVideo.textColor = UIColor.gray
            if selectedIndex == 0{
                cell.lblDetails.textColor = UIColor(named: "AppThemeColor")
                cell.lblHighlightDetails.backgroundColor = UIColor(named: "AppThemeColor")
            }else if selectedIndex == 1{
                cell.lblImage.textColor = UIColor(named: "AppThemeColor")
                cell.lblHighlightImage.backgroundColor =  UIColor(named: "AppThemeColor")
            }else{
                cell.lblHighLightvideo.backgroundColor = UIColor(named: "AppThemeColor")
                cell.lblVideo.textColor = UIColor(named: "AppThemeColor")
            }
            return cell
        }
        
        else if indexPath.section == 3 {
            if selectedIndex == 0 {
                if indexPath.row == arrayTitle.count - 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentCommentCell1", for: indexPath) as! IncidentCommentCell
                    cell.lblTitle.text = arrayTitle[indexPath.row]//"Incident Comment:"
                    cell.lblComment.text = arrayPopulate[indexPath.row]
                    cell.viewBack.clipsToBounds = false
                    cell.viewBack.layer.cornerRadius = 10
                    cell.viewBack.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentDetailsCell", for: indexPath) as! IncidentDetailsCell
                    
                    cell.lbltitle.text = arrayTitle[indexPath.row]
                    cell.lblDetails.text = arrayPopulate[indexPath.row]
                    if indexPath.row % 2 == 0{
                        cell.viewBackground.backgroundColor = .white
                    }else{
                        cell.viewBackground.backgroundColor = UIColor(named: "AppGrey")
                    }
                    
                    return cell
                }
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentImageCell", for: indexPath) as! IncidentImageCell
                if let url = modelIncidence?.incedent_photo{
                     cell.imgIncident.isHidden = false
                    let imageURL = URL(string: url)
                    if let image = imageURL {
                cell.imgIncident.kf.setImage(with: image)
                    }
                }
                if selectedIndex == 2 {
                     if let url = modelIncidence?.incedent_video {
                     cell.imgIncident.isHidden = false
                    cell.imgViewPlay.isHidden = false
                    cell.btnPlay.isHidden = false
                    cell.imgNoData.isHidden = true

                         if let url = modelIncidence?.incedent_thumb{
                              cell.imgIncident.isHidden = false
                             let imageURL = URL(string: url)
                             if let image = imageURL {
                         cell.imgIncident.kf.setImage(with: image)
                             }
                         }
                        
                     }else{
                        cell.imgIncident.isHidden = true
                        cell.imgViewPlay.isHidden =  true
                        cell.btnPlay.isHidden = true
                         cell.imgNoData.isHidden = false
                    }
                }else{
                    
                    
                    cell.imgViewPlay.isHidden =  true
                    cell.btnPlay.isHidden = true
                     
                }
                return cell
            }
            
        }else{
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 0.001//return 170
        }else if indexPath.section == 1{
            return UITableView.automaticDimension
        }else if indexPath.section == 2{
            return 50
        }
        else if indexPath.section == 3{
            if selectedIndex == 0{
                if arrayPopulate[indexPath.row] == ""{
                    return 0.001
                }else{
                return UITableView.automaticDimension
                }
            }else{
                return 250
            }
        }else{
            return 0.1
        }
    }
    
    //func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //    cellHeight[indexPath] = cell.frame.size.height
    //}
    //func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //    return cellHeight[indexPath] ?? 310
    //}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3{
            if selectedIndex == 0{
                return arrayTitle.count
            }else{
                return 1
            }
        }else{
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeight[indexPath] = cell.frame.size.height
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight[indexPath] ?? UITableView.automaticDimension
    }
    func generateThumbnail(for asset:AVAsset) -> UIImage? {
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMake(value: 1, timescale: 2)
        let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
        if img != nil {
            let frameImg  = UIImage(cgImage: img!)
           return frameImg
        }
        return nil
    }
}
