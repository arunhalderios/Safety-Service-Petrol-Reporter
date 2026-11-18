//
//  CustomActivityIndicator.swift
//  MayFair
//
//  Created by Szi on 04/04/17.
//  Copyright © 2017 Szi. All rights reserved.
//

import UIKit

class CustomActivityIndicator: UIView {

    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet var view: UIView?
    
    static let sharedInstance = CustomActivityIndicator()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        setup()
    }
    convenience init() {
        self.init(frame:CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() -> Void {
        self.view = Bundle.main.loadNibNamed("CustomActivityIndicator", owner: self, options: nil)?.first as! UIView?
        self.view?.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        self.addSubview(self.view!)
        
    }
    @objc private func uploadDidProgress(_ notification: Notification) {
        if let progress = notification.object as? Double {
            let percentage  = Int64(progress * 100)
            self.lblProgress.text = "(\(percentage)%)"
        }
    }
    
    func display(onView vw:UIView!,done:@escaping ()->()){
        self.frame = CGRect(x: vw.frame.origin.x, y: vw.frame.origin.y, width: vw.frame.size.width, height: vw.frame.size.height)
        vw.addSubview(self)
    }
    func displayForUpload(onView vw:UIView!,done:@escaping ()->()){
        NotificationCenter.default.addObserver(self, selector: #selector(self.uploadDidProgress(_:)), name: Notification.Name("UploadProgress"), object: nil)
        self.frame = CGRect(x: vw.frame.origin.x, y: vw.frame.origin.y, width: vw.frame.size.width, height: vw.frame.size.height)
        vw.addSubview(self)
        lblProgress.isHidden = false
    }
    
    func hide(_:@escaping ()->()){
        NotificationCenter.default.removeObserver(self)
        lblProgress.isHidden = true
        self.lblProgress.text = "(\(0)%)"
        self.removeFromSuperview()
        
    }
}
