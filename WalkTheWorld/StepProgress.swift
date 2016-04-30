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
    private var stepLabel : UILabel = UILabel()
    private var totalSteps : Int = 0
    private let incompleteColor : UIColor = UIColor(red: 107/255, green: 203/255, blue: 92/255, alpha: 1)
    private let completeColor : UIColor = UIColor(red: 107/255, green: 203/255, blue: 92/255, alpha: 1)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createStepLabel()
        createStepProgressLayer()
        self.backgroundColor = UIColor.blackColor()
    }
    
    func setTotalSteps(steps: Double) {
        totalSteps = Int(steps)
        stepLabel.text = "\(totalSteps) Steps"
    }
    
    func createStepProgressLayer() {
        //get start angle, end angle, and center point
        let start = CGFloat(M_PI_2)
        let end = CGFloat(M_PI * 2 + M_PI_2)
        let center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2)
        
        //set Progress Layer's path to be a circle with above req's
        let bezierPath = UIBezierPath(arcCenter: center, radius: CGRectGetWidth(frame)/2 - 15.0, startAngle: start, endAngle: end, clockwise: true)
        stepProgressLayer.path = bezierPath.CGPath
        
        //customize the layer
        stepProgressLayer.strokeColor = incompleteColor.CGColor
        stepProgressLayer.fillColor = nil
        stepProgressLayer.lineWidth = 4.0
        
        //set start and end points to 0
        stepProgressLayer.strokeStart = 0.0
        stepProgressLayer.strokeEnd = 0.0
        
        //add the layer
        layer.addSublayer(stepProgressLayer)
    }
    
    func createStepLabel() {
        //create a label that will show the number of steps needed to be acheived
        stepLabel = UILabel()
        
        //customize the label
        stepLabel.font = UIFont (name: "Helvetica Neue", size: 12)
        stepLabel.textColor = incompleteColor
        
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stepLabel)
        
        //add manual constraints in relation to the center
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: stepLabel, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: stepLabel, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }
    
    func animateProgressView(endValue: Double) {
        //animate the progress view to show the progress so far
        stepProgressLayer.strokeEnd = 0.0
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue = CGFloat(endValue)
        animation.delegate = self
        
        //change this if you want a longer/shorter animation
        animation.duration = 1.0
        animation.additive = true
        
        //set the animation to not reset when finished, and to not remove when finished
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        
        if(endValue == 1) {
            self.stepLabel.textColor = completeColor
            self.stepProgressLayer.strokeColor = completeColor.CGColor
        }
        
        stepProgressLayer.addAnimation(animation, forKey: "strokeEnd")
    }
}