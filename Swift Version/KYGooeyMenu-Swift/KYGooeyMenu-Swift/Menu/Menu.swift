//
//  Menu.swift
//  KYGooeyMenu-Swift
//
//  Created by Kitten Yang on 1/8/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class Menu: UIView {
    var animationQueue: [CAKeyframeAnimation]
    var menuLayer: MenuLayer
    
    override init(frame: CGRect) {
        let real_frame = CGRectInset(frame, -30, -30)
        animationQueue = [CAKeyframeAnimation]()
        menuLayer = MenuLayer()
        super.init(frame: real_frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        menuLayer.frame = bounds
        menuLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(menuLayer)
        menuLayer.setNeedsDisplay()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            switch touch.tapCount {
            case 1:
                openAnimation()
                break;
            default:
                break;
            }
        }
    }
    
    private func openAnimation() {
        let openAnimation_1 = SpringLayerAnimation.sharedAnimation.createBasicAnimation("xAxisPercent", duration: 0.3, fromValue: 0.0, toValue: 1.0)
        let openAnimation_2 = SpringLayerAnimation.sharedAnimation.createBasicAnimation("xAxisPercent", duration: 0.3, fromValue: 0.0, toValue: 1.0)
        let openAnimation_3 = SpringLayerAnimation.sharedAnimation.createSpringAnima("xAxisPercent", duration: 1.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3.0, fromValue: 0.0, toValue: 1.0)
        
        openAnimation_1.delegate = self
        openAnimation_2.delegate = self
        openAnimation_3.delegate = self
        
        animationQueue.append(openAnimation_1)
        animationQueue.append(openAnimation_2)
        animationQueue.append(openAnimation_3)
        
        menuLayer.addAnimation(openAnimation_1, forKey: "openAnimation_1")
        userInteractionEnabled = false
        menuLayer.animationState = .STATE1
    }
}

extension Menu {
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag {
            if anim == menuLayer.animationForKey("openAnimation_1") {
                menuLayer.removeAllAnimations()
                menuLayer.addAnimation(animationQueue[1], forKey: "openAnimation_2")
                menuLayer.animationState = .STATE2
            } else if anim == menuLayer.animationForKey("openAnimation_2") {
                menuLayer.removeAllAnimations()
                menuLayer.addAnimation(animationQueue[2], forKey: "openAnimation_3")
                menuLayer.animationState = .STATE3
            } else if anim == menuLayer.animationForKey("openAnimation_3") {
                menuLayer.xAxisPercent = 1.0
                menuLayer.removeAllAnimations()
                userInteractionEnabled = true
            }
        }
    }
    
}
