//
//  CuteView.swift
//  CuteView-Swift
//
//  Created by Kitten Yang on 1/19/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

struct BubbleOptions {
    var text: String = ""
    var bubbleWidth: CGFloat = 0.0
    var viscosity: CGFloat = 0.0
    var bubbleColor: UIColor = UIColor.whiteColor()
}

class CuteView: UIView {
    
    var frontView: UIView?
    var bubbleOptions: BubbleOptions!{
        didSet{
            bubbleLabel.text = bubbleOptions.text
        }
    }
    private var bubbleLabel: UILabel!
    private var containerView: UIView!
    private var cutePath: UIBezierPath!
    private var fillColorForCute: UIColor!
    private var animator: UIDynamicAnimator!
    private var snap: UISnapBehavior!
    private var backView: UIView!
    private var shapeLayer: CAShapeLayer!
    
    private var r1: CGFloat = 0.0
    private var r2: CGFloat = 0.0
    private var x1: CGFloat = 0.0
    private var y1: CGFloat = 0.0
    private var x2: CGFloat = 0.0
    private var y2: CGFloat = 0.0
    private var centerDistance: CGFloat = 0.0
    private var cosDigree: CGFloat = 0.0
    private var sinDigree: CGFloat = 0.0
    
    private var pointA = CGPointZero
    private var pointB = CGPointZero
    private var pointC = CGPointZero
    private var pointD = CGPointZero
    private var pointO = CGPointZero
    private var pointP = CGPointZero
    
    private var initialPoint: CGPoint = CGPointZero
    private var oldBackViewFrame: CGRect = CGRectZero
    private var oldBackViewCenter: CGPoint = CGPointZero

    
    init(point: CGPoint, superView: UIView, options: BubbleOptions) {
        super.init(frame: CGRectMake(point.x, point.y, options.bubbleWidth, options.bubbleWidth))
        bubbleOptions = options
        initialPoint = point
        containerView = superView
        containerView.addSubview(self)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawRect() {
        guard let frontView = frontView else{
            return
        }
        x1 = backView.center.x
        y1 = backView.center.y
        x2 = frontView.center.x
        y2 = frontView.center.y
        
        let xtimesx = (x2-x1)*(x2-x1)
        centerDistance = sqrt(xtimesx + (y2-y1)*(y2-y1))
        if centerDistance == 0 {
            cosDigree = 1
            sinDigree = 0
        }else{
            cosDigree = (y2-y1)/centerDistance
            sinDigree = (x2-x1)/centerDistance
        }
        
        r1 = oldBackViewFrame.size.width / 2 - centerDistance/bubbleOptions.viscosity
        
        pointA = CGPointMake(x1-r1*cosDigree, y1+r1*sinDigree) // A
        pointB = CGPointMake(x1+r1*cosDigree, y1-r1*sinDigree) // B
        pointD = CGPointMake(x2-r2*cosDigree, y2+r2*sinDigree) // D
        pointC = CGPointMake(x2+r2*cosDigree, y2-r2*sinDigree) // C
        pointO = CGPointMake(pointA.x + (centerDistance / 2)*sinDigree, pointA.y + (centerDistance / 2)*cosDigree)
        pointP = CGPointMake(pointB.x + (centerDistance / 2)*sinDigree, pointB.y + (centerDistance / 2)*cosDigree)
        
        backView.center = oldBackViewCenter;
        backView.bounds = CGRectMake(0, 0, r1*2, r1*2);
        backView.layer.cornerRadius = r1;
        
        cutePath = UIBezierPath()
        cutePath.moveToPoint(pointA)
        cutePath.addQuadCurveToPoint(pointD, controlPoint: pointO)
        cutePath.addLineToPoint(pointC)
        cutePath.addQuadCurveToPoint(pointB, controlPoint: pointP)
        cutePath.moveToPoint(pointA)
        
        if backView.hidden == false {
            shapeLayer.path = cutePath.CGPath
            shapeLayer.fillColor = fillColorForCute.CGColor
            containerView.layer.insertSublayer(shapeLayer, below: frontView.layer)
        }

    }
    
    private func setUp() {
        shapeLayer = CAShapeLayer()
        backgroundColor = UIColor.clearColor()
        frontView = UIView(frame: CGRect(x: initialPoint.x, y: initialPoint.y, width: bubbleOptions.bubbleWidth, height: bubbleOptions.bubbleWidth))
        guard let frontView = frontView else {
            print("frontView is nil")
            return
        }
        r2 = frontView.bounds.size.width / 2.0
        frontView.layer.cornerRadius = r2
        frontView.backgroundColor = bubbleOptions.bubbleColor
        
        backView = UIView(frame: frontView.frame)
        r1 = backView.bounds.size.width / 2
        backView.layer.cornerRadius = r1
        backView.backgroundColor = bubbleOptions.bubbleColor
        
        bubbleLabel = UILabel()
        bubbleLabel.frame = CGRect(x: 0, y: 0, width: frontView.bounds.width, height: frontView.bounds.height)
        bubbleLabel.textColor = UIColor.whiteColor()
        bubbleLabel.textAlignment = .Center
        bubbleLabel.text = bubbleOptions.text
        
        frontView.insertSubview(bubbleLabel, atIndex: 0)
        containerView.addSubview(backView)
        containerView.addSubview(frontView)
        
        x1 = backView.center.x
        y1 = backView.center.y
        x2 = frontView.center.x
        y2 = frontView.center.y
        
        pointA = CGPointMake(x1-r1,y1);   // A
        pointB = CGPointMake(x1+r1, y1);  // B
        pointD = CGPointMake(x2-r2, y2);  // D
        pointC = CGPointMake(x2+r2, y2);  // C
        pointO = CGPointMake(x1-r1,y1);   // O
        pointP = CGPointMake(x2+r2, y2);  // P
        
        oldBackViewFrame = backView.frame
        oldBackViewCenter = backView.center
        
        backView.hidden = true //为了看到frontView的气泡晃动效果，需要暂时隐藏backView
        addAniamtionLikeGameCenterBubble()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "handleDragGesture:")
        frontView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handleDragGesture(ges: UIPanGestureRecognizer) {
        let dragPoint = ges.locationInView(containerView)
        if ges.state == .Began {
            backView.hidden = false
            fillColorForCute = bubbleOptions.bubbleColor
            removeAniamtionLikeGameCenterBubble()
        } else if ges.state == .Changed {
            frontView?.center = dragPoint
            if r1 <= 6 {
                fillColorForCute = UIColor.clearColor()
                backView.hidden = true
                shapeLayer.removeFromSuperlayer()
            }
            drawRect()
        } else if ges.state == .Ended || ges.state == .Cancelled || ges.state == .Failed {
            backView.hidden = true
            fillColorForCute = UIColor.clearColor()
            shapeLayer.removeFromSuperlayer()
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { [weak self] () -> Void in
                if let strongsSelf = self {
                    strongsSelf.frontView?.center = strongsSelf.oldBackViewCenter
                }
                }, completion: { [weak self] (finished) -> Void in
                    if let strongsSelf = self {
                        strongsSelf.addAniamtionLikeGameCenterBubble()
                    }
            })
        }
    }
    
}

// MARK : GameCenter Bubble Animation

extension CuteView {
    private func addAniamtionLikeGameCenterBubble() {
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.calculationMode = kCAAnimationPaced

        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.removedOnCompletion = false
        pathAnimation.repeatCount = Float.infinity
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        pathAnimation.duration = 5.0
        
        let curvedPath = CGPathCreateMutable()
        guard let frontView = frontView else {
            print("frontView is nil!")
            return
        }
        let circleContainer = CGRectInset(frontView.frame, frontView.bounds.width / 2 - 3, frontView.bounds.size.width / 2 - 3)
        CGPathAddEllipseInRect(curvedPath, nil, circleContainer)
        
        pathAnimation.path = curvedPath
        frontView.layer.addAnimation(pathAnimation, forKey: "circleAnimation")
        
        let scaleX = CAKeyframeAnimation(keyPath: "transform.scale.x")
        scaleX.duration = 1.0
        scaleX.values = [NSNumber(double: 1.0),NSNumber(double: 1.1),NSNumber(double: 1.0)]
        scaleX.keyTimes = [NSNumber(double: 0.0), NSNumber(double: 0.5), NSNumber(double: 1.0)]
        scaleX.repeatCount = Float.infinity
        scaleX.autoreverses = true
        
        scaleX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        frontView.layer.addAnimation(scaleX, forKey: "scaleXAnimation")
        
        let scaleY = CAKeyframeAnimation(keyPath: "transform.scale.y")
        scaleY.duration = 1.5
        scaleY.values = [NSNumber(double: 1.0),NSNumber(double: 1.1),NSNumber(double: 1.0)]
        scaleY.keyTimes = [NSNumber(double: 0.0), NSNumber(double: 0.5), NSNumber(double: 1.0)]
        scaleY.repeatCount = Float.infinity
        scaleY.autoreverses = true
        scaleY.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        frontView.layer.addAnimation(scaleY, forKey: "scaleYAnimation")

    }

    private func removeAniamtionLikeGameCenterBubble() {
        if let frontView = frontView {
            frontView.layer.removeAllAnimations()
        }
    }
    
}