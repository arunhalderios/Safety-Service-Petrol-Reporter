//
//  PopupCustomView.swift
//  RTSystemsCorp
//
//  Created by Met Dev on 14/01/20.
//  Copyright © 2020 Met Technologies. All rights reserved.
//

import UIKit



class PopupCustomView: UIView,UITextViewDelegate {
    @IBOutlet weak var viewInside: UIView!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var lableTop: UILabel!
    @IBOutlet var view: UIView?
    @IBOutlet var textView: UITextView?
    var terms = "https://google.com"
    var phoneNumber = "7167753355"
    static let sharedInstance = PopupCustomView()
 
    override init(frame:CGRect){
        super.init(frame: frame)
        setup()
    }
    convenience init() {
        self.init(frame:CGRect.zero)
        setup()
    }
    
    @IBAction func btnokAction(_ sender: Any) {
        self.hide()
        
    }
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func setup() -> Void {
        self.view = Bundle.main.loadNibNamed("PopupView", owner: self, options: nil)?.first as! UIView?
        self.view?.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        //self.textView?.hyperLink(originalText: "For any assistance regarding our app please call (716)775-3355", terms: "(716)775-3355", termsURL: terms, privacy: "(716)775-3355", privacyURL: terms, color: .blue, textColor: .black, alignment: .center)
        self.textView?.delegate = self

        

        self.addSubview(self.view!)
        //btnRight.roundedView()
        //btnLeft.roundedView()
        lableTop.text = ""
        viewInside.layer.cornerRadius = 10
        viewInside.clipsToBounds = true
       
    }
    
    
    func display(onView vw:UIView!,done:@escaping ()->()){
        self.frame = CGRect(x: vw.frame.origin.x, y: vw.frame.origin.y, width: vw.frame.size.width, height: vw.frame.size.height)
        vw.addSubview(self)
    }
    
    func hide(){
        self.removeFromSuperview()
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL.absoluteString == terms) {
            self.callNumber(phoneNumber: phoneNumber)
           
        }
        return false
    }
     func callNumber(phoneNumber:String) {

      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {

        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
    }
    func reSetPopUp() {
        self.lableTop?.text = ""
        self.textView?.isUserInteractionEnabled = false
        self.textView?.isEditable = false
        self.textView?.isSelectable = false
        self.btnLeft.removeTarget(nil, action: nil, for: .allEvents)
        self.btnRight.removeTarget(nil, action: nil, for: .allEvents)
        self.textView?.setBorder(width: 0.0, borderColor: .white, cornerRadious: 0.0)
        self.textView?.textAlignment = .center
        self.btnRight.addTarget(self, action: #selector(self.btnokAction(_:)), for: .touchUpInside)
        self.hide()
    }
}
extension UITextView {
    func hyperLink(originalText: String, terms: String,termsURL:String,privacy:String, privacyURL: String,color:UIColor,textColor:UIColor,alignment:NSTextAlignment) {
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment(rawValue: alignment.rawValue)!
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let linkRangeTerms = attributedOriginalText.mutableString.range(of: terms)
        let linkRangePrivacy = attributedOriginalText.mutableString.range(of: privacy)
        let fullRange = NSMakeRange(0, attributedOriginalText.length)
        attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: termsURL, range: linkRangePrivacy)
        attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: privacyURL, range: linkRangeTerms)
        attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
       attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: self.font!, range: fullRange)
         attributedOriginalText.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: fullRange)
        self.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
    
        self.attributedText = attributedOriginalText
    }
}
