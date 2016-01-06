//
//  InteractiveView.swift
//  InteractiveCardDemo-Swift
//
//  Created by Kitten Yang on 1/6/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

let SCREENWIDTH  = UIScreen.mainScreen().bounds.width
let SCREENHEIGHT = UIScreen.mainScreen().bounds.height
//let ANIMATEDURATION = 0.5
//let ANIMATEDAMPING = 0.7
//let SCROLLDISTANCE = 200.0

struct InteractiveOptions {
    var duration: NSTimeInterval = 0.3
    var damping: CGFloat = 0.6
    var scrollDistance: CGFloat = 100.0
}

class InteractiveView: UIImageView {

    var _option: InteractiveOptions
    var initialPoint: CGPoint = CGPointZero
    var dimmingView: UIView?
    var gestureView: UIView? {
        didSet{
            let panGesture = UIPanGestureRecognizer(target: self, action: "panGestureRecognized:")
            gestureView?.addGestureRecognizer(panGesture)
        }
    }
    
    init(image: UIImage?, option: InteractiveOptions) {
        _option = option
        super.init(image: image)
        contentMode = .ScaleAspectFill
        layer.cornerRadius = 7.0
        layer.masksToBounds = true
    }

    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        initialPoint = center
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func panGestureRecognized(pan: UIPanGestureRecognizer) {
        
        var factorOfAngle: CGFloat = 0.0
        var factorOfScale: CGFloat = 0.0
        let transition = pan.translationInView(superview)
        
        if pan.state == .Began {
            
        } else if pan.state == .Changed {
            center = CGPointMake(initialPoint.x, initialPoint.y + transition.y)
            let Y = min(CGFloat(_option.scrollDistance), max(0, abs(transition.y)))
            //一个开口向下,顶点(SCROLLDISTANCE/2,1),过(0,0),(SCROLLDISTANCE,0)的二次函数
            factorOfAngle = max(0.0,-4.0/(CGFloat(_option.scrollDistance)*CGFloat(_option.scrollDistance))*Y*(Y-CGFloat(_option.scrollDistance)));
            //一个开口向下,顶点(SCROLLDISTANCE,1),过(0,0),(2*SCROLLDISTANCE,0)的二次函数
            factorOfScale = max(0,-1/(CGFloat(_option.scrollDistance)*CGFloat(_option.scrollDistance))*Y*(Y-2*CGFloat(_option.scrollDistance)));
            var t = CATransform3DIdentity
            t.m34 = -1.0/1000
            t = CATransform3DRotate(t,factorOfAngle*(CGFloat(M_PI/5)), transition.y>0 ? -1 : 1, 0, 0)
            t = CATransform3DScale(t, 1-factorOfScale*0.2, 1-factorOfScale*0.2, 0)
            layer.transform = t
            dimmingView?.alpha = 1.0 - Y / _option.scrollDistance
            
        } else if pan.state == .Ended || pan.state == .Cancelled {
            UIView.animateWithDuration(_option.duration, delay: 0.0, usingSpringWithDamping: _option.damping, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.layer.transform = CATransform3DIdentity
                    self.center = self.initialPoint
                    self.dimmingView?.alpha = 1.0
                }, completion: nil)
        }
    }

}
