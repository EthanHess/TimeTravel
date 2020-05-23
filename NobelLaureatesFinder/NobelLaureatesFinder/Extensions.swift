//
//  Extensions.swift
//  NobelLaureatesFinder
//
//  Created by Ethan Hess on 5/15/20.
//  Copyright © 2020 Ethan Hess. All rights reserved.
//

import Foundation
import UIKit

//MARK easy UI
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        //Autoresizing mask controls how view resizes itself when (superview) bounds change
        //We don't want system to automatically create contraints so we'll set to false
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension Date {
    func yearsApart(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
}

extension UIColor {
    static func fromRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func mainBlue() -> UIColor {
        return UIColor.fromRGB(red: 17, green: 154, blue: 327)
    }
    
    static func darkBlue() -> UIColor {
        return UIColor.fromRGB(red: 5, green: 22, blue: 155)
    }
    
    static func random() -> UIColor {
        let RR = CGFloat(drand48())
        let RG = CGFloat(drand48())
        let RB = CGFloat(drand48())
        return UIColor(red: CGFloat(RR), green: CGFloat(RG), blue: CGFloat(RB), alpha: 1.0)
    }
}
