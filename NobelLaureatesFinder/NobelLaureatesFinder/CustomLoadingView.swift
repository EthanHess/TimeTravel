//
//  CustomLoadingView.swift
//  NobelLaureatesFinder
//
//  Created by Ethan Hess on 5/22/20.
//  Copyright © 2020 Ethan Hess. All rights reserved.
//

import UIKit

class CustomLoadingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //Initialization closure
    let pieChart : MiniPieChart = {
        let pc = MiniPieChart()
        return pc
    }()
    
    //https://stackoverflow.com/questions/27736360/typewriter-effect-text-animation
    
    let loadingLabel : UILabel = {
        let lb = UILabel()
        lb.text = "Loading"
        lb.textAlignment = .center
        lb.textColor = .mainBlue()
        return lb
    }()
    
    var animationTimer : Timer = {
        let timer = Timer()
        return timer
    }()
    
    var borderTimer : Timer = {
        let bt = Timer()
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    //Public
    func visibilityHandler(show: Bool) {
        DispatchQueue.main.async {
            self.isHidden = !show
        }
    }
    
    func viewConfig() {
        addSubview(loadingLabel)
        loadingLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 30)
        addSubview(pieChart)
        pieChart.anchor(top: topAnchor, left: leftAnchor, bottom: loadingLabel.topAnchor, right: rightAnchor, paddingTop: 7.5, paddingLeft: 5, paddingBottom: 7.5, paddingRight: 5, width: 90, height: 90)
        pieChart.layer.borderColor = colorsForBorder()[0].cgColor
        pieChart.layer.borderWidth = 1

        stylizeSelf()
        borderColorTimerConfiguration()
    }
    
    fileprivate func borderColorTimerConfiguration() {
        borderTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(borderForPieChart), userInfo: nil, repeats: true)
    }
    
    //Will animate/change color
    @objc fileprivate func borderForPieChart() {
        let x = Int(arc4random() % 8);
        let borderColor = colorsForBorder()[x]
        pieChart.layer.borderColor = borderColor.cgColor
        pieChart.layer.borderWidth = 1
        //Use for fill colors as well?
    }
    
    fileprivate func colorsForBorder() -> [UIColor] {
        let colorOne = UIColor.fromRGB(red: 124, green: 247, blue: 252)
        let colorTwo = UIColor.fromRGB(red: 124, green: 252, blue: 230)
        let colorThree = UIColor.fromRGB(red: 124, green: 199, blue: 252)
        let colorFour = UIColor.fromRGB(red: 13, green: 236, blue: 194)
        let colorFive = UIColor.fromRGB(red: 13, green: 126, blue: 236)
        let colorSix = UIColor.fromRGB(red: 177, green: 175, blue: 248)
        let colorSeven = UIColor.fromRGB(red: 227, green: 175, blue: 248)
        let colorEight = UIColor.fromRGB(red: 246, green: 101, blue: 159)
        return [colorOne, colorTwo, colorThree, colorFour, colorFive, colorSix, colorSeven, colorEight]
    }
    
    fileprivate func stylizeSelf() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = .darkGray
        //TODO shadow, border?
    }
    
    func startAnimation() {
        visibilityHandler(show: true)
        animationTimer = Timer(timeInterval: 1, target: self, selector: #selector(animateMiniChart), userInfo: nil, repeats: true)
    }
    
    func endAnimation() {
        visibilityHandler(show: false)
        animationTimer.invalidate()
    }
    
    @objc fileprivate func animateMiniChart() {
        //TODO imp.
    }
    
    //Destroy
    deinit {
        borderTimer.invalidate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
