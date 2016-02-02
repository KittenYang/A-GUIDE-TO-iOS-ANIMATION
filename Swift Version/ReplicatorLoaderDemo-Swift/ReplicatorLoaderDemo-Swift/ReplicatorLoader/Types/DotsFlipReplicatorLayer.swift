//
//  DotsFlipReplicatorLayer.swift
//  ReplicatorLoaderDemo-Swift
//
//  Created by Kitten Yang on 2/3/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import Foundation
import UIKit

struct DotsFlipReplicatorLayer: Replicatable {
    
    func configureReplicatorLayer(layer: CALayer, option: Options) {
        
        func setUp() {
            let marginBetweenDot: CGFloat = 5.0
            let size = layer.bounds.width
            let dotSize = (size - 2*marginBetweenDot) / 3
            
            let dot = CAShapeLayer()
            dot.frame = CGRect(
                x: 0,
                y: (size - dotSize)/2,
                width:dotSize,
                height: dotSize)
            
            dot.path = UIBezierPath(rect: CGRect(x: 0, y:0, width: dotSize, height: dotSize)).CGPath
            dot.fillColor = option.color.CGColor
            
            let replicatorLayer = CAReplicatorLayer()
            replicatorLayer.frame = CGRect(x: 0,y: 0,width: size, height: size)
            
            replicatorLayer.instanceDelay = 0.1
            replicatorLayer.instanceCount = 3
            replicatorLayer.instanceTransform = CATransform3DMakeTranslation(marginBetweenDot+dotSize, 0, 0)
            
            replicatorLayer.addSublayer(dot)
            layer.addSublayer(replicatorLayer)
            dot.addAnimation(flipAnimation(), forKey: "scaleAnimation")
        }
        setUp()
        
        func flipAnimation() -> CABasicAnimation{
            let scaleAnim = CABasicAnimation(keyPath: "transform")
            
            let t = CATransform3DIdentity
            let t2 = CATransform3DRotate(t, CGFloat(0.0), 0.0, 1.0, 0.0)
            scaleAnim.fromValue = NSValue.init(CATransform3D: t2)
            let t3 = CATransform3DRotate(t, CGFloat(M_PI), 0.0, 1.0, 0.0)
            scaleAnim.toValue = NSValue.init(CATransform3D: t3)
            scaleAnim.repeatCount = HUGE
            scaleAnim.duration = 0.6
            
            return scaleAnim
        }
    }
}