//
//  PulseLoader.swift
//  PulseLoader-Swift
//
//  Created by Kitten Yang on 2/2/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class PulseLoader: UIView {
    
    private let pulseLayer = CAShapeLayer()
    var color: UIColor
    
    init(frame: CGRect, color: UIColor) {
        self.color = color
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        pulseLayer.frame = bounds
        pulseLayer.path  = UIBezierPath(ovalInRect: pulseLayer.bounds).CGPath
        pulseLayer.fillColor = color.CGColor
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = bounds
        replicatorLayer.instanceDelay = 0.5
        replicatorLayer.instanceCount = 8
        replicatorLayer.addSublayer(pulseLayer)
        pulseLayer.opacity = 0.0
        layer.addSublayer(replicatorLayer)
    }
    
    func startToPluse() {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [alphaAnimation(), scaleAnimation()]
        groupAnimation.duration = 4.0
        groupAnimation.autoreverses = false
        groupAnimation.repeatCount = HUGE
        pulseLayer.addAnimation(groupAnimation, forKey: "groupAnimation")
    }
    
    private func alphaAnimation() -> CABasicAnimation{
        let alphaAnim = CABasicAnimation(keyPath: "opacity")
        alphaAnim.fromValue = NSNumber(float: 1.0)
        alphaAnim.toValue = NSNumber(float: 0.0)
        return alphaAnim
    }
    
    private func scaleAnimation() -> CABasicAnimation{
        let scaleAnim = CABasicAnimation(keyPath: "transform")
        
        let t = CATransform3DIdentity
        let t2 = CATransform3DScale(t, 0.0, 0.0, 0.0)
        scaleAnim.fromValue = NSValue.init(CATransform3D: t2)
        let t3 = CATransform3DScale(t, 1.0, 1.0, 0.0)
        scaleAnim.toValue = NSValue.init(CATransform3D: t3)
        return scaleAnim
    }
    
}
