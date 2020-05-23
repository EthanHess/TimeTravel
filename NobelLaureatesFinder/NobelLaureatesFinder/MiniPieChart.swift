//
//  MiniPieChart.swift
//  NobelLaureatesFinder
//
//  Created by Ethan Hess on 5/22/20.
//  Copyright © 2020 Ethan Hess. All rights reserved.
//

import UIKit

class MiniPieChart: UIView {
    
    var circleLayer: CAShapeLayer!
    let π = Double.pi
    var currentAmt: CGFloat = 0
    var skillColor: UIColor! //Should now be array of colors? Do we still need this? Maybe there should be an option to animate one solid color at a time vs 4 different ones
    
    //Where pie slice will start/stop
    fileprivate func endAngleArray() -> [CGFloat] {
        
        let angleOne = CGFloat(π * 2)
        let angleTwo = CGFloat(π * 2)
        let angleThree = CGFloat((π / 3) * 6)
        let angleFour = CGFloat(2 * π)
        let angleFive = CGFloat((π / 2.5) * 5)
        let angleSix = CGFloat((π / 1.5) * 3)
        let angleSeven = CGFloat((π / 3.5) * 7)
        let angleEight = CGFloat((π / 4) * 8)
        let angleNine = CGFloat((π / 4.5) * 9)
        let angleTen = CGFloat((π / 5) * 10)
        
        return [angleOne, angleTwo, angleThree, angleFour, angleFive, angleSix, angleSeven, angleEight, angleNine, angleTen]
    }
    
    func animatedCircleConfiguration(countIndex: Int, totalCount: Int) {
        let circleCenter = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        let radius: CGFloat = max(bounds.width, bounds.height)

        if totalCount > endAngleArray().count {
            Logger.log("Add more end angles!")
            return
        }
        
        let startAngle = CGFloat(-(π / 2))
        let endAngle = endAngleArray()[totalCount - 1]
            
        let lineWidth = (radius / 2) - 1
        let path2 = UIBezierPath(arcCenter: circleCenter,
                                     radius: ((radius/2) - 1) - lineWidth/2,
                                     startAngle: startAngle,
                                     endAngle: endAngle,
                                     clockwise: true)
        circleLayer = CAShapeLayer()
        circleLayer.path = path2.cgPath
        circleLayer.strokeColor = skillColor.cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeEnd = currentAmt
        layer.addSublayer(circleLayer)
    }
    
    func animateCircle(_ duration: TimeInterval, toAmount: CGFloat) {
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = currentAmt
        animation.toValue = toAmount
        
        currentAmt = toAmount
        
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        if circleLayer != nil {
            circleLayer.strokeEnd = toAmount
            circleLayer.add(animation, forKey: "animateCircle")
        }
    }
    
    fileprivate func customColors() -> [UIColor] {
        return [UIColor.random(), UIColor.random(), UIColor.random(), UIColor.random()]
    }
}
