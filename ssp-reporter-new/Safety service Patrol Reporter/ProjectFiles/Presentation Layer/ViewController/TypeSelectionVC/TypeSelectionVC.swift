//
//  TypeSelectionVC.swift
//  Safety service Patrol Reporter
//
//  Created by Mahesh Mahalik on 30/03/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class TypeSelectionVC: UIViewController {

    @IBOutlet weak var viewLoginManager: UIView!
    @IBOutlet weak var viewLoginOperator: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    fileprivate func rounderCorner() {
        viewLoginManager.roundedView()
        viewLoginOperator.roundedView()
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        rounderCorner()
        
    }
    
    @IBAction func btnOperatorAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.type = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnManagerAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.type = 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
