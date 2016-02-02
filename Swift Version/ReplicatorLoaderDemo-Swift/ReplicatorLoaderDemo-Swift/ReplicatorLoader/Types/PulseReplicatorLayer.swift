//
//  PulseReplicatorLayer.swift
//  ReplicatorLoaderDemo-Swift
//
//  Created by Kitten Yang on 2/3/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import Foundation
import UIKit

struct PulseReplicatorLayer: Replicatable {
    
    func configureReplicatorLayer(layer: CALayer, option: Options) {

        let pulseLayer = CAShapeLayer()
        
        func setUp() {
            pulseLayer.frame = layer.bounds
            pulseLayer.path  = UIBezierPath(ovalInRect: pulseLayer.bounds).CGPath
            pulseLayer.fillColor = option.color.CGColor
            
            let replicatorLayer = CAReplicatorLayer()
            replicatorLayer.frame = layer.bounds
            replicatorLayer.instanceDelay = 0.5
            replicatorLayer.instanceCount = 8
            replicatorLayer.addSublayer(pulseLayer)
            pulseLayer.opacity = 0.0
            layer.addSublayer(replicatorLayer)
        }
        setUp()
        
        func startToPluse() {
            let groupAnimation = CAAnimationGroup()
            groupAnimation.animations = [alphaAnimation(), scaleAnimation()]
            groupAnimation.duration = 4.0
            groupAnimation.autoreverses = false
            groupAnimation.repeatCount = HUGE
            pulseLayer.addAnimation(groupAnimation, forKey: "groupAnimation")
        }
        startToPluse()
        
        func alphaAnimation() -> CABasicAnimation{
            let alphaAnim = CABasicAnimation(keyPath: "opacity")
            alphaAnim.fromValue = NSNumber(float: option.alpha)
            alphaAnim.toValue = NSNumber(float: 0.0)
            return alphaAnim
        }
        
        func scaleAnimation() -> CABasicAnimation{
            let scaleAnim = CABasicAnimation(keyPath: "transform")
            
            let t = CATransform3DIdentity
            let t2 = CATransform3DScale(t, 0.0, 0.0, 0.0)
            scaleAnim.fromValue = NSValue.init(CATransform3D: t2)
            let t3 = CATransform3DScale(t, 1.0, 1.0, 0.0)
            scaleAnim.toValue = NSValue.init(CATransform3D: t3)
            return scaleAnim
        }

    }
    
    
}