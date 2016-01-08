//
//  MenuLayer.swift
//  KYGooeyMenu-Swift
//
//  Created by Kitten Yang on 1/7/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

enum STATE {
    case STATE1
    case STATE2
    case STATE3
}

let OFF: CGFloat = 30.0

class MenuLayer: CALayer {
    var showDebug: Bool = false
    var animationState: STATE = .STATE1
    var xAxisPercent: CGFloat = 0.0
    
    override init() {
        super.init()
    }
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
        if let lastLayer = layer as? MenuLayer {
            showDebug = lastLayer.showDebug
            xAxisPercent = lastLayer.xAxisPercent
            animationState = lastLayer.animationState
        }
    }

    override class func needsDisplayForKey(key: String) -> Bool {
        if key == "xAxisPercent" {
            return true
        }
        return super.needsDisplayForKey(key)
    }
    
    override func drawInContext(ctx: CGContext) {
        print("acting")
        let real_rect = CGRectInset(self.frame, OFF,OFF)
        let offset = real_rect.size.width / 3.6
        let center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        var moveDistance_1: CGFloat
        var moveDistance_2: CGFloat
        var top_left: CGPoint
        var top_center: CGPoint
        var top_right: CGPoint
        
        switch animationState {
        case .STATE1:
            moveDistance_1 = xAxisPercent*(real_rect.size.width/2 - offset)/2
            top_left   =  CGPointMake(center.x-offset-moveDistance_1*2, OFF)
            top_center =  CGPointMake(center.x-moveDistance_1, OFF)
            top_right  =  CGPointMake(center.x+offset, OFF)
        case .STATE2:
            var hightFactor: CGFloat
            if (xAxisPercent >= 0.2) {
                hightFactor = 1-xAxisPercent;
            }else{
                hightFactor = xAxisPercent;
            }
            moveDistance_1 = (real_rect.size.width/2 - offset)/2
            moveDistance_2 = xAxisPercent*(real_rect.size.width/3)
            top_left   =  CGPointMake(center.x-offset-moveDistance_1*2 + moveDistance_2, OFF)
            top_center =  CGPointMake(center.x-moveDistance_1 + moveDistance_2, OFF)
            top_right  =  CGPointMake(center.x+offset+moveDistance_2, OFF)
        case .STATE3:
            moveDistance_1 = (real_rect.size.width/2 - offset)/2
            moveDistance_2 = (real_rect.size.width/3)
            let gooeyDis_1 = xAxisPercent*(center.x-offset-moveDistance_1*2 + moveDistance_2-(center.x-offset))
            let gooeyDis_2 = xAxisPercent*(center.x-moveDistance_1 + moveDistance_2-(center.x))
            let gooeyDis_3 = xAxisPercent*(center.x+offset+moveDistance_2-(center.x+offset))
            
            top_left   =  CGPointMake(center.x-offset-moveDistance_1*2 + moveDistance_2 - gooeyDis_1, OFF)
            top_center =  CGPointMake(center.x-moveDistance_1 + moveDistance_2 - gooeyDis_2, OFF)
            top_right  =  CGPointMake(center.x+offset+moveDistance_2 - gooeyDis_3, OFF)
        }
        
        let right_top    =  CGPointMake(CGRectGetMaxX(real_rect), center.y-offset)
        let right_center =  CGPointMake(CGRectGetMaxX(real_rect), center.y)
        let right_bottom =  CGPointMake(CGRectGetMaxX(real_rect), center.y+offset)
        
        let bottom_left   =  CGPointMake(center.x-offset, CGRectGetMaxY(real_rect))
        let bottom_center =  CGPointMake(center.x, CGRectGetMaxY(real_rect))
        let bottom_right  =  CGPointMake(center.x+offset, CGRectGetMaxY(real_rect))
        
        let left_top    =  CGPointMake(OFF, center.y-offset)
        let left_center =  CGPointMake(OFF, center.y)
        let left_bottom =  CGPointMake(OFF, center.y+offset)
        
        let circlePath = UIBezierPath()
        circlePath.moveToPoint(top_center)
        circlePath.addCurveToPoint(right_center, controlPoint1: top_right, controlPoint2: right_top)
        circlePath.addCurveToPoint(bottom_center, controlPoint1: right_bottom, controlPoint2: bottom_right)
        circlePath.addCurveToPoint(left_center, controlPoint1: bottom_left, controlPoint2: left_bottom)
        circlePath.addCurveToPoint(top_center, controlPoint1: left_top, controlPoint2: top_left)
        circlePath.closePath()
        
        CGContextAddPath(ctx, circlePath.CGPath)
        CGContextSetFillColorWithColor(ctx, UIColor(red: 29.0/255.0, green: 163.0/255.0, blue: 1.0, alpha: 1.0).CGColor)
        CGContextFillPath(ctx)

        if showDebug {
            CGContextSetFillColorWithColor(ctx, UIColor.blueColor().CGColor)
            
            showPoint(top_left, context: ctx)
            showPoint(top_center, context: ctx)
            showPoint(top_right, context: ctx)

            showPoint(right_top, context: ctx)
            showPoint(right_center, context: ctx)
            showPoint(right_bottom, context: ctx)

            showPoint(bottom_left, context: ctx)
            showPoint(bottom_center, context: ctx)
            showPoint(bottom_right, context: ctx)
            
            showPoint(left_top, context: ctx)
            showPoint(left_center, context: ctx)
            showPoint(left_bottom, context: ctx)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func showPoint(point: CGPoint, context: CGContextRef) {
        let rect = CGRectMake(point.x-1, point.y-1, 2, 2)
        CGContextFillRect(context, rect)
    }
    
}
