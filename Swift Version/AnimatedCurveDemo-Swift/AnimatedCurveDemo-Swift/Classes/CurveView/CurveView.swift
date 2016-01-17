//
//  CurveView.swift
//  AnimatedCurveDemo-Swift
//
//  Created by Kitten Yang on 1/18/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class CurveView: UIView {
    var progress: CGFloat = 0.0 {
        didSet{
            curveLayer.progress = progress
            curveLayer.setNeedsDisplay()
        }
    }

    private var curveLayer: CurveLayer!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        curveLayer = CurveLayer()
        curveLayer.frame = bounds
        curveLayer.contentsScale = UIScreen.mainScreen().scale
        curveLayer.progress = 0.0
        curveLayer.setNeedsDisplay()
        layer.addSublayer(curveLayer)
    }
    
}
