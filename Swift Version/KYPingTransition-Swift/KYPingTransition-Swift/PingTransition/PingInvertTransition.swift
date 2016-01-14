//
//  PingInvertTransition.swift
//  KYPingTransition-Swift
//
//  Created by Kitten Yang on 1/14/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class PingInvertTransition: NSObject,UIViewControllerAnimatedTransitioning {

    private var _transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.7
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        _transitionContext = transitionContext
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! SecondViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! ViewController
        let containerView = transitionContext.containerView()
        let button = toVC.button
        
        containerView?.addSubview(toVC.view)
        containerView?.addSubview(fromVC.view)
        
        let finalPath = UIBezierPath(ovalInRect: button.frame)
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
        
        let radius = sqrt(finalPoint.x * finalPoint.x + finalPoint.y * finalPoint.y)
        let startPath = UIBezierPath(ovalInRect: CGRectInset(button.frame, -radius, -radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = finalPath.CGPath
        fromVC.view.layer.mask = maskLayer
    
        let pingAnimation = CABasicAnimation(keyPath: "path")
        pingAnimation.fromValue = startPath.CGPath
        pingAnimation.toValue =  finalPath.CGPath
        pingAnimation.duration = transitionDuration(transitionContext)
        pingAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pingAnimation.delegate = self
        maskLayer.addAnimation(pingAnimation, forKey: "pingInvert")
        
    }
    
}

extension PingInvertTransition {
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let transitionContext = _transitionContext {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
            transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view.layer.mask = nil
        }
    }
    
}