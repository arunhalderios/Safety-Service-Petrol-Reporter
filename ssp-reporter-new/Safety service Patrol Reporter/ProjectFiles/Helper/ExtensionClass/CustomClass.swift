//
//  CustomClass.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 05/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ButtionX: UIButton {
    @IBInspectable var cornerRadious:CGFloat = 0{
        didSet {
            self.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? cornerRadious + 10 :  cornerRadious
        }
    }
    @IBInspectable var borderWidth:CGFloat = 0{
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor:UIColor = UIColor.clear{
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
 
}
@IBDesignable
class LabelX: UILabel {
    @IBInspectable var cornerRadious:CGFloat = 0{
        didSet {
            self.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? cornerRadious + 10 :  cornerRadious
        }
    }
    @IBInspectable var borderWidth:CGFloat = 0{
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor:UIColor = UIColor.clear{
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
 
}

@IBDesignable
class TextFieldX: UITextField {
    @IBInspectable var cornerRadious:CGFloat = 0{
        didSet {
            self.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? cornerRadious + 10 :  cornerRadious
        }
    }
    @IBInspectable var borderWidth:CGFloat = 0{
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor:UIColor = UIColor.clear{
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
 
}



@IBDesignable
class ImageViewX: UIImageView {
    @IBInspectable var cornerRadious:CGFloat = 0{
        didSet {
            //self.layer.cornerRadius = cornerRadious
            self.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 90 : 48
         
            
        }
    }
    @IBInspectable var borderWidth:CGFloat = 0{
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor:UIColor = UIColor.clear{
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}


@IBDesignable
class ViewX: UIView {
    
    @IBInspectable var cornerRadious:CGFloat = 0{
        didSet {
            self.layer.cornerRadius = cornerRadious
        }
    }
    @IBInspectable var borderWidth:CGFloat = 0{
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor:UIColor = UIColor.clear{
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}


/////////////
extension Date {
    
    internal func dateStringInDateFormat(_ format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension UITextField {
    
    func addLeftViewPadding(padding:CGFloat, placeholderText: String?){
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        if placeholderText != nil {
            self.attributedPlaceholder = NSAttributedString(string: placeholderText!, attributes: [NSAttributedString.Key.foregroundColor:placeholderColor!])
        }
    }
    func addRightViewPadding(padding:CGFloat){
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
        
//        if placeholderText != nil {
//            self.attributedPlaceholder = NSAttributedString(string: placeholderText!, attributes: [NSAttributedString.Key.foregroundColor:placeholderColor!])
//        }
    }
    
    func addInputAccessoryView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexiableSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(resignTextField))
        toolBar.setItems([flexiableSpace, doneButton], animated: false)
        self.inputAccessoryView = toolBar
        toolBar.barTintColor = UIColor.init(red: 30.0/255.0, green: 160.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
    }
    
    @objc private func resignTextField() {
        NotificationCenter.default.post(name: NSNotification.Name.__kTextFieldResignedNotification, object: self)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(10)) {
            self.resignFirstResponder()
        }
    }
}

extension UITextView: UITextViewDelegate {

    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }

    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?

            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }

            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }

    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }

    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height

            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }

    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()

        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()

        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.gray
        placeholderLabel.tag = 100

        placeholderLabel.isHidden = self.text.count > 0

        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}

extension UIWindow {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

extension UIView {
    
    func setRoundCorner(cornerRadious:CGFloat) {
        
        self.layer.cornerRadius = cornerRadious
        self.layer.masksToBounds = true
        
    }
    
    func setBorder(width:CGFloat, borderColor:UIColor, cornerRadious:CGFloat) {
        
        self.layer.cornerRadius = cornerRadious
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true
        
    }
    
    func animateOpacity() {
        
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(pulseAnimation, forKey: "animateOpacity")
        
    }
    
    func fadeIn(_ duration: TimeInterval = 0.25,_ delay:TimeInterval = 0.0, completion:((Bool) -> ())? = nil) {
        self.alpha = 0.0
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }) { (finished:Bool) in
            if let completion = completion {
                completion(finished)
            }
        }
    }
    func fadeOut(_ duration: TimeInterval = 0.25,_ delay:TimeInterval = 0.0, completion:((Bool) -> ())? = nil) {
        self.alpha = 1.0
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }) { (finished:Bool) in
            if let completion = completion {
                completion(finished)
            }
        }
    }
}

extension String {
    
    func isValidEmailID() -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
        
    }
    
    func isValidPhoneNumber() -> Bool
    {
        let PHONE_REGEX = "^[0-9]{10,15}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    func isPasswordValid() -> Bool
    {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$&*%^&~ ]).{8,}$")
        return passwordTest.evaluate(with: self)
    }
    
    func getDate(_ format:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    func getDateString(_ fromFormat:String, _ toFormat:String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = toFormat
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

extension Data {
    
    var dictionary:[String:Any]? {
        do{
            if let json = try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String:Any] {
                return json
            }
        }catch let e {
            print(e.localizedDescription)
            return nil
        }
        return nil
    }
}

extension Array {
    var data:Data? {
        get{
            do{
                return (try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted))
            }catch let e {
                print(e.localizedDescription)
                return nil
            }
        }
    }
    
}

extension String {
    
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

extension Dictionary {
    subscript(i:Int) -> (key:Key,value:Value) {
        get {
            return self[index(startIndex, offsetBy: i)];
        }
    }
}

extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    
    var prettyprintedJSON: String? {
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch let err {
            print(err.localizedDescription)
            return nil
        }
    }
    
    var data:Data? {
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return data
        } catch let err {
            print(err.localizedDescription)
            return nil
        }
    }
}


extension UIImage {
    internal func resizeImage(width:Float,height:Float,quality:Float) -> UIImage {
        var actualHeight: Float = Float(self.size.height)
        var actualWidth: Float = Float(self.size.width)
        let maxHeight: Float = height
        let maxWidth: Float = width
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = quality
        //50 percent compression
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRect.init(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!)!
    }
}

extension Notification.Name {
    public static let __kTextFieldResignedNotification = Notification.Name.init("___kTextFieldResignedNotification")
}

extension Date {
 
    func afterMonth(getMonth:Int) -> Date{
        return Calendar.current.date(byAdding: .month, value: getMonth, to: noon)!
    }
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    static var nextMonth:  Date { return Date().monthAfter }
    static var nextyear:  Date { return Date().yearAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var monthAfter: Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: noon)!
    }
    var yearAfter: Date {
        return Calendar.current.date(byAdding: .year, value: 1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}





extension Date {
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
}

extension UITextField{
    
    var isValidText : Bool
    {
        if (text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || text == nil)
        {
            return false
        }
        
        return true
    }
}

// MARK: - String


extension UIView{
    func roundedButton(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedView(){
        self.layer.cornerRadius = 10//self.frame.height/2
        //self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    func roundedViewTheme(){
        self.layer.cornerRadius = 10//self.frame.height/2
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor =  darkThemeColor.cgColor
        self.clipsToBounds = true
    }
}
extension UIView{
    func addborder(){
        self.layer.borderWidth = 1
        self.layer.borderColor = darkThemeColor.cgColor//UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
    }
}



extension UINavigationController {
    func containsViewController(ofKind kind: AnyClass) -> Bool {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }
    
    func popPushToVC(ofKind kind: AnyClass, pushController: UIViewController) {
        if containsViewController(ofKind: kind) {
            for controller in self.viewControllers {
                if controller.isKind(of: kind) {
                    popToViewController(controller, animated: true)
                    break
                }
            }
        } else {
            pushViewController(pushController, animated: true)
        }
    }
}


extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    func widthOfString(usingFont font: UIFont) -> CGFloat {
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = self.size(withAttributes: fontAttributes)
            return size.width
        }

        func heightOfString(usingFont font: UIFont) -> CGFloat {
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = self.size(withAttributes: fontAttributes)
            return size.height
        }

        func sizeOfString(usingFont font: UIFont) -> CGSize {
            let fontAttributes = [NSAttributedString.Key.font: font]
            return self.size(withAttributes: fontAttributes)
        }
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}




