//
//  StepProgress.swift
//  WalkTheWorld
//
//  Created by Julia Pohlmann on 4/14/16.
//  Copyright © 2016 JS. All rights reserved.
//

import UIKit

class StepProgress : UIView {
    
    private let stepProgressLayer : CAShapeLayer = CAShapeLayer()
    private var stepLabel : UILabel
    private var totalSteps : Double
    
    required init?(coder aDecoder: NSCoder) {
        stepLabel = UILabel()
        totalSteps = 0
        super.init(coder: aDecoder)
        createStepProgressLayer()
        createStepLabel()
    }
    
    override init(frame: CGRect) {
        stepLabel = UILabel()
        totalSteps = 0
        super.init(frame: frame)
        createStepProgressLayer()
        createStepLabel()
    }
    
    func setTotalSteps(steps: Double) {
        totalSteps = steps
        stepLabel.text = "\(totalSteps) Steps"
    }
    
    
    func createStepProgressLayer() {
        //get start angle, end angle, and center point
        let start = CGFloat(M_PI_2)
        let end = CGFloat(M_PI * 2 + M_PI_2)
        let center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2)
        
        //make a gradient mask layer
        let gradientMaskLayer = customGradientMask()
        stepProgressLayer.path = UIBezierPath(arcCenter: center, radius: CGRectGetWidth(frame)/2 - 30.0, startAngle: start, endAngle: end, clockwise: true).CGPath
        stepProgressLayer.backgroundColor = UIColor.clearColor().CGColor
        stepProgressLayer.fillColor = nil
        stepProgressLayer.strokeColor = UIColor.blackColor().CGColor
        stepProgressLayer.lineWidth = 4.0
        stepProgressLayer.strokeStart = 0.0
        stepProgressLayer.strokeEnd = 0.0
        
        
        gradientMaskLayer.mask = stepProgressLayer
        layer.addSublayer(gradientMaskLayer)
    }
    
    func customGradientMask() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.locations = [0.0, 1.0]
        
        let topColor: AnyObject = UIColor(red: 255.0/255.0, green: 213.0/255.0, blue: 63.0/255.0, alpha: 1.0).CGColor
        let bottomColor: AnyObject = UIColor(red: 255.0/255.0, green: 198.0/255.0, blue: 5.0/255.0, alpha: 1.0).CGColor
        let colorArray: [AnyObject] = [topColor, bottomColor]
        gradientLayer.colors = colorArray
        
        return gradientLayer
    }
    
    func createStepLabel() {
        stepLabel = UILabel(frame: CGRectMake(0.0, 0.0, CGRectGetWidth(frame), 5.0))
        stepLabel.textColor = .blackColor()
        stepLabel.textAlignment = .Center
        stepLabel.text = "\(totalSteps) Steps"
        stepLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 12.0)
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stepLabel)
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: stepLabel, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: stepLabel, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }
    
    func hideProgressView() {
        stepProgressLayer.strokeEnd = 0.0
        stepProgressLayer.removeAllAnimations()
        //stepLabel.text = "Load content"
    }
    
    func animateProgressView(endValue: Double) {
        stepProgressLayer.strokeEnd = 0.0        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue = CGFloat(endValue)
        animation.duration = 1.0
        animation.delegate = self
        animation.removedOnCompletion = false
        animation.additive = true
        animation.fillMode = kCAFillModeForwards
        stepProgressLayer.addAnimation(animation, forKey: "strokeEnd")
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        //stepLabel.text = "Done"
        //ENABLE BUTTON NEXT TO IT
    }

    
    
    
    
    
    
    
    
    
    
    
    
}
