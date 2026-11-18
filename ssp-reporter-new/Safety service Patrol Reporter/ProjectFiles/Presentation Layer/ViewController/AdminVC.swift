//
//  AdminVC.swift
//  Safety service Patrol Reporter
//
//  Created by Subha on 11/18/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit
import WebKit

class AdminVC: BaseViewController {
    var urlString:String?
    @IBOutlet weak var viewWeb: WKWebView!
    @IBOutlet weak var viewActivity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewActivity.isHidden = true
        if let url = URL(string: urlString ?? ""){
            viewActivity.isHidden = false
            viewActivity.startAnimating()
            let request = URLRequest(url: url)
        
       viewWeb.navigationDelegate = self
        viewWeb.load(request)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeService.instance.resetInactivityTimer()
    }
    

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AdminVC: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.viewActivity.stopAnimating()
        self.viewActivity.isHidden = true
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}
