//
//  customView.swift
//  Safety service Patrol Reporter
//
//  Created by Dipika on 11/02/20.
//  Copyright © 2020 met. All rights reserved.
//

import UIKit

class CustomView: UIView {


}

@IBDesignable
extension CustomView {
    
     // Shadow
    @IBInspectable
     var shadowRadius: CGFloat {
          get {
              return layer.shadowRadius
          }
          set {
              //layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
              layer.shadowOffset = CGSize(width: 0, height: 2)
              layer.shadowOpacity = 0.8
              layer.masksToBounds = false
             layer.shadowRadius = shadowRadius
           
          }
      }
    @IBInspectable
       public var shadowColor: UIColor? {
            set {
                 layer.shadowColor = newValue?.cgColor
            }

            get {
                 if let shadowcolor = layer.shadowColor {
                      return UIColor(cgColor: shadowcolor)
                 }
                 return nil
            }
       }



     // Corner radius
     @IBInspectable var circle: Bool {
          get {
               return layer.cornerRadius == self.bounds.width*0.5
          }
          set {
               if newValue == true {
                    self.cornerRadius = self.bounds.width*0.5
               }
          }
     }

     @IBInspectable var cornerRadius: CGFloat {
          get {
               return self.layer.cornerRadius
          }

          set {
               self.layer.cornerRadius = newValue
          }
     }


     // Borders
     // Border width
     @IBInspectable
     public var borderWidth: CGFloat {
          set {
               layer.borderWidth = newValue
          }

          get {
               return layer.borderWidth
          }
     }

     // Border color
     @IBInspectable
     public var borderColor: UIColor? {
          set {
               layer.borderColor = newValue?.cgColor
          }

          get {
               if let borderColor = layer.borderColor {
                    return UIColor(cgColor: borderColor)
               }
               return nil
          }
     }
    
    
   
}

enum VerticalLocation: String {
 
    case top
}

extension UIView {
    func addShadow(location: VerticalLocation, color: UIColor = .lightGray, opacity: Float = 0.5, radius: CGFloat = 1.0) {
        switch location {
        case .top:
            addShadow(offset: CGSize(width: 0, height: -1), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 1.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}

