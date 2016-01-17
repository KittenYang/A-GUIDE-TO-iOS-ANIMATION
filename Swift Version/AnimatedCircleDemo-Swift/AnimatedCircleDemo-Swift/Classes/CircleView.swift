//
//  CircleView.swift
//  AnimatedCircleDemo-Swift
//
//  Created by Kitten Yang on 1/18/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class CircleView: UIView {

    var circleLayer = CircleLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        circleLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        circleLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(circleLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
