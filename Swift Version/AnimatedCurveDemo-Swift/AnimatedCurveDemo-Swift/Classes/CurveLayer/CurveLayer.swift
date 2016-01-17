//
//  CurveLayer.swift
//  AnimatedCurveDemo-Swift
//
//  Created by Kitten Yang on 1/18/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

let Radius:CGFloat =  10.0
let Space:CGFloat  =  1.0
let LineLength:CGFloat = 30.0
let Degree:CGFloat = CGFloat(M_PI / 3)

class CurveLayer: CALayer {
    
    var progress: CGFloat = 0.0
    
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawInContext(ctx: CGContext) {
        super.drawInContext(ctx)
        
        let CenterY = frame.size.height/2
        UIGraphicsPushContext(ctx)
        let context = UIGraphicsGetCurrentContext()
        
        //Path 1
        let curvePath1 = UIBezierPath()
        curvePath1.lineCapStyle = .Round
        curvePath1.lineJoinStyle = .Round
        curvePath1.lineWidth = 2.0
        
        //arrowPath
        let arrowPath = UIBezierPath()
        
        if progress <= 0.5 {
            let pointA = CGPointMake(frame.size.width/2-Radius, CenterY - Space + LineLength + (1-2*progress)*(CenterY-LineLength));
            let pointB = CGPointMake(frame.size.width/2-Radius, CenterY - Space + (1-2*progress)*(CenterY-LineLength));
            curvePath1.moveToPoint(pointA)
            curvePath1.addLineToPoint(pointB)
            
            //arrow
            arrowPath.moveToPoint(pointB)
            arrowPath.addLineToPoint(CGPointMake(pointB.x - 3*(cos(Degree)), pointB.y + 3*(sin(Degree))))
            curvePath1.appendPath(arrowPath)
            
        }else if progress > 0.5 {
            let pointA = CGPointMake(frame.size.width/2-Radius, CenterY - Space + LineLength - LineLength*(progress-0.5)*2);
            let pointB = CGPointMake(frame.size.width/2-Radius, CenterY - Space);
            curvePath1.moveToPoint(pointA)
            curvePath1.addLineToPoint(pointB)
            curvePath1.addArcWithCenter(CGPointMake(frame.size.width/2, CenterY-Space), radius: Radius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI) + (CGFloat((M_PI*9/10)) * (progress-0.5)*2), clockwise: true)
            
            //arrow
            arrowPath.moveToPoint(curvePath1.currentPoint)
            arrowPath.addLineToPoint(CGPointMake(curvePath1.currentPoint.x - 3*(cos(Degree  - (CGFloat((M_PI*9/10)) * (progress-0.5)*2))), curvePath1.currentPoint.y + 3*(sin(Degree - (CGFloat((M_PI*9/10)) * (progress-0.5)*2)))))
            curvePath1.appendPath(arrowPath)
        }
        
        //Path 2
        let curvePath2 = UIBezierPath()
        curvePath2.lineCapStyle = .Round
        curvePath2.lineJoinStyle = .Round
        curvePath2.lineWidth = 2.0
        if progress <= 0.5 {
            let pointA = CGPointMake(frame.size.width/2+Radius, 2*progress * (CenterY + Space - LineLength))
            let pointB = CGPointMake(frame.size.width/2+Radius,LineLength + 2*progress*(CenterY + Space - LineLength))
            curvePath2.moveToPoint(pointA)
            curvePath2.addLineToPoint(pointB)
            
            //arrow
            arrowPath.moveToPoint(pointB)
            arrowPath.addLineToPoint(CGPointMake(pointB.x + 3*(cos(Degree)), pointB.y - 3*(sin(Degree))))
            curvePath2.appendPath(arrowPath)
        }
        
        if progress > 0.5 {
            curvePath2.moveToPoint(CGPointMake(frame.size.width/2+Radius, CenterY + Space - LineLength + LineLength*(progress-0.5)*2))
            curvePath2.addLineToPoint(CGPointMake(frame.size.width/2+Radius, CenterY + Space))
            curvePath2.addArcWithCenter(CGPointMake(frame.size.width/2, (CenterY+Space)), radius: Radius, startAngle: 0, endAngle: CGFloat((M_PI*9/10))*(progress-0.5)*2, clockwise: true)
            
            //arrow
            arrowPath.moveToPoint(curvePath2.currentPoint)
            arrowPath.addLineToPoint(CGPointMake(curvePath2.currentPoint.x + 3*(cos(Degree - (CGFloat((M_PI*9/10)) * (progress-0.5)*2))), curvePath2.currentPoint.y - 3*(sin(Degree - (CGFloat((M_PI*9/10)) * (progress-0.5)*2)))))
            curvePath2.appendPath(arrowPath)
            
        }
        
        CGContextSaveGState(context)
        CGContextRestoreGState(context)
        
        UIColor.blackColor().setStroke()
        arrowPath.stroke()
        curvePath1.stroke()
        curvePath2.stroke()
        
        UIGraphicsPopContext();
    }
    
}
