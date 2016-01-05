//
//  SlideMenuButton.swift
//  GooeySlideMenuDemo-Swift
//
//  Created by Kitten Yang on 1/3/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

struct MenuButtonOptions {
    var title: String
    var buttonColor: UIColor
    var buttonClickBlock: ()->()
}

class SlideMenuButton: UIView {

    private var _option: MenuButtonOptions
    
    init(option: MenuButtonOptions) {
        _option = option
        super.init(frame: CGRectZero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextAddRect(context, rect)
        _option.buttonColor.set()
        CGContextFillPath(context)
        
        let roundedRectanglePath = UIBezierPath(roundedRect: CGRectInset(rect, 1, 1), cornerRadius: rect.height / 2)
        _option.buttonColor.setFill()
        roundedRectanglePath.fill()
        UIColor.whiteColor().setStroke()
        roundedRectanglePath.lineWidth = 1
        roundedRectanglePath.stroke()

        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = .Center
        let attr = [NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName: UIFont.systemFontOfSize(24.0),NSForegroundColorAttributeName: UIColor.whiteColor()]
        let size = _option.title.sizeWithAttributes(attr)
        
        let r = CGRectMake(rect.origin.x,
            rect.origin.y + (rect.size.height - size.height)/2.0,
            rect.size.width,
            size.height)
        _option.title.drawInRect(r, withAttributes: attr)

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        if let touch = touch {
            let tapCount = touch.tapCount
            switch (tapCount) {
                case 1: _option.buttonClickBlock()
                default: break
            }
        }
    }
}
