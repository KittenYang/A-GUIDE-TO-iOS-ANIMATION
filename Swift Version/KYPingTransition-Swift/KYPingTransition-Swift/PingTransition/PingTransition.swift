//
//  PingTransition.swift
//  KYPingTransition-Swift
//
//  Created by Kitten Yang on 1/8/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class PingTransition: NSObject,UIViewControllerAnimatedTransitioning {
    
    private var _transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.7
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        _transitionContext = transitionContext
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! SecondViewController
        let contentView = transitionContext.containerView()
        
        let button = fromVC.button
        
        let maskStartPath = UIBezierPath(ovalInRect: button.frame)
        contentView?.addSubview(fromVC.view)
        contentView?.addSubview(toVC.view)
        
        var finalPoint = CGPoint()
        if button.frame.origin.x > toVC.view.bounds.size.width / 2 {
            if button.frame.origin.y < toVC.view.bounds.size.height / 2 {
                //NO.1
                finalPoint = CGPointMake(button.center.x - 0, button.center.y - CGRectGetMaxY(toVC.view.bounds)+30)
            } else {
                //NO.4
                finalPoint = CGPointMake(button.center.x - 0, button.center.y - 0)
            }
        } else {
            if button.frame.origin.y < toVC.view.bounds.size.height / 2 {
                //NO.2
                finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - CGRectGetMaxY(toVC.view.bounds)+30)
            } else {
                //NO.3
                finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - 0)
            }
        }
        
        let radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y))
        let maskFinalPath = UIBezierPath(ovalInRect: CGRectInset(button.frame, -radius, -radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskFinalPath.CGPath
        toVC.view.layer.mask = maskLayer
        
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = maskStartPath.CGPath
        maskLayerAnimation.toValue  = maskFinalPath.CGPath
        maskLayerAnimation.duration = transitionDuration(transitionContext)
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        maskLayerAnimation.delegate = self
        maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
    }
    
}

extension PingTransition {
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let transitionContext = _transitionContext{
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
            transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view.layer.mask = nil
        }
    }
}