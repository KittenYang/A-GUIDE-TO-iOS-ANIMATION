//
//  KYCuteView.swift
//  KYCuteView-Swift
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

class KYCuteView: UIView {
    
    var frontView: UIView?
    
    private var _options: BubbleOptions!
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
        _options = options
        initialPoint = point
        containerView = superView
        containerView.addSubview(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUp() {
        shapeLayer = CAShapeLayer()
        
    }
}
