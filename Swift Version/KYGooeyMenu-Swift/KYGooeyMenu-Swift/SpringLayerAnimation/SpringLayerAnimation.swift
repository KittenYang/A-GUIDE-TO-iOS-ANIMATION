//
//  SpringLayerAnimation.swift
//  KYGooeyMenu-Swift
//
//  Created by Kitten Yang on 1/7/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class SpringLayerAnimation: NSObject {
    
    static let sharedAnimation = SpringLayerAnimation()
    private override init() {}
    
    func createBasicAnimation(keypath: String, duration: Double, fromValue: AnyObject, toValue: AnyObject) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: keypath)
        animation.values = basicAnimationValues(duration, fromValue: fromValue, toValue: toValue)
        animation.duration = duration
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        
        return animation
    }
    
    func createSpringAnima(keypath: String, duration: Double, usingSpringWithDamping: Double, initialSpringVelocity: Double, fromValue: AnyObject, toValue: AnyObject) -> CAKeyframeAnimation {
        let dampingFactor  = 10.0
        let velocityFactor = 10.0
        let animation = CAKeyframeAnimation(keyPath: keypath)
        animation.values = springAnimationValues(duration, fromValue: fromValue, toValue: toValue, damping: usingSpringWithDamping * dampingFactor, velocity: initialSpringVelocity * velocityFactor)
        animation.duration = duration
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        
        return animation
    }
    
}

extension SpringLayerAnimation {
    private func basicAnimationValues(duration: Double, fromValue: AnyObject, toValue: AnyObject) -> [Double] {
        let numberOfFrames = Int(duration * 60)
        var values = [Double](count: numberOfFrames, repeatedValue: 0.0)
        let diff = toValue.doubleValue - fromValue.doubleValue
        for frame in 0..<numberOfFrames {
            let x = Double(frame / numberOfFrames)
            let value = fromValue.doubleValue + diff * x
            values[frame] = value
        }
        return values
    }
    
    private func springAnimationValues(duration: Double, fromValue: AnyObject, toValue: AnyObject, damping: Double, velocity: Double) -> [Double] {
        let numberOfFrames = Int(duration * 60)
        var values = [Double](count: numberOfFrames, repeatedValue: 0.0)
        let diff = toValue.doubleValue - fromValue.doubleValue
        for frame in 0..<numberOfFrames {
            let x = Double(frame / numberOfFrames)
            let value = toValue.doubleValue - diff * (pow(M_E, -damping * x) * cos(velocity * x))
            values[frame] = value
        }
        return values
    }
}

