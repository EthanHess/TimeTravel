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
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    //Public
    func visibilityHandler(show: Bool) {
        DispatchQueue.main.async {
            self.isHidden = show
        }
    }
    
    func viewConfig() {
        addSubview(loadingLabel)
        loadingLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 30)
        addSubview(pieChart)
        pieChart.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        
        stylizeSelf()
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
