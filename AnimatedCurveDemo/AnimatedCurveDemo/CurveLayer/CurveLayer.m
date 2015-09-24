//
//  CurveLayer.m
//  AnimatedCurveDemo
//
//  Created by Kitten Yang on 7/6/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#define Radius  10
#define Space    1
#define LineLength 30
#define CenterY  self.frame.size.height/2

#define Degree M_PI/3

#import "CurveLayer.h"

@implementation CurveLayer

-(void)drawInContext:(CGContextRef)ctx{

    [super drawInContext:ctx];

    
    UIGraphicsPushContext(ctx);
    CGContextRef context = UIGraphicsGetCurrentContext();

    //Draw
    
    //Path 1
    UIBezierPath *curvePath1 = [UIBezierPath bezierPath];
    curvePath1.lineCapStyle = kCGLineCapRound;
    curvePath1.lineJoinStyle = kCGLineJoinRound;
    curvePath1.lineWidth = 2.0f;
    
    //arrowPath
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    if (self.progress <= 0.5) {
        
        CGPoint pointA = CGPointMake(self.frame.size.width/2-Radius, CenterY - Space + LineLength + (1-2*self.progress)*(CenterY-LineLength));
        CGPoint pointB = CGPointMake(self.frame.size.width/2-Radius, CenterY - Space + (1-2*self.progress)*(CenterY-LineLength));
        [curvePath1 moveToPoint:pointA];
        [curvePath1 addLineToPoint:pointB];
        
        //arrow
        [arrowPath moveToPoint:pointB];
        [arrowPath addLineToPoint:CGPointMake(pointB.x - 3*(cosf(Degree)), pointB.y + 3*(sinf(Degree)))];
        [curvePath1 appendPath:arrowPath];

    }else if (self.progress > 0.5) {
        
        CGPoint pointA = CGPointMake(self.frame.size.width/2-Radius, CenterY - Space + LineLength - LineLength*(self.progress-0.5)*2);
        CGPoint pointB = CGPointMake(self.frame.size.width/2-Radius, CenterY - Space);

        
        [curvePath1 moveToPoint:pointA];
        [curvePath1 addLineToPoint:pointB];
        [curvePath1 addArcWithCenter:CGPointMake(self.frame.size.width/2, CenterY-Space) radius:Radius startAngle:M_PI endAngle:M_PI + ((M_PI*9/10) * (self.progress-0.5)*2) clockwise:YES];
        
        //arrow
        [arrowPath moveToPoint:curvePath1.currentPoint];
        [arrowPath addLineToPoint:CGPointMake(curvePath1.currentPoint.x - 3*(cosf(Degree  - ((M_PI*9/10) * (self.progress-0.5)*2))), curvePath1.currentPoint.y + 3*(sinf(Degree - ((M_PI*9/10) * (self.progress-0.5)*2))))];
        [curvePath1 appendPath:arrowPath];
    }
    
    
    
    //Path 2
    UIBezierPath *curvePath2 = [UIBezierPath bezierPath];
    curvePath2.lineCapStyle = kCGLineCapRound;
    curvePath2.lineJoinStyle = kCGLineJoinRound;
    curvePath2.lineWidth = 2.0f;
    if (self.progress <= 0.5) {
        
        CGPoint pointA = CGPointMake(self.frame.size.width/2+Radius, 2*self.progress * (CenterY + Space - LineLength));
        CGPoint pointB = CGPointMake(self.frame.size.width/2+Radius,LineLength + 2*self.progress*(CenterY + Space - LineLength));
        [curvePath2 moveToPoint:pointA];
        [curvePath2 addLineToPoint:pointB];
        
        //arrow
        [arrowPath moveToPoint:pointB];
        [arrowPath addLineToPoint:CGPointMake(pointB.x + 3*(cosf(Degree)), pointB.y - 3*(sinf(Degree)))];
        [curvePath2 appendPath:arrowPath];

    }
    if (self.progress > 0.5) {
        [curvePath2 moveToPoint:CGPointMake(self.frame.size.width/2+Radius, CenterY + Space - LineLength + LineLength*(self.progress-0.5)*2)];
        [curvePath2 addLineToPoint:CGPointMake(self.frame.size.width/2+Radius, CenterY + Space)];
        [curvePath2 addArcWithCenter:CGPointMake(self.frame.size.width/2, (CenterY+Space)) radius:Radius startAngle:0 endAngle:(M_PI*9/10)*(self.progress-0.5)*2 clockwise:YES];
        
        //arrow
        [arrowPath moveToPoint:curvePath2.currentPoint];
        [arrowPath addLineToPoint:CGPointMake(curvePath2.currentPoint.x + 3*(cosf(Degree - ((M_PI*9/10) * (self.progress-0.5)*2))), curvePath2.currentPoint.y - 3*(sinf(Degree - ((M_PI*9/10) * (self.progress-0.5)*2))))];
        [curvePath2 appendPath:arrowPath];

    }
    
    
    CGContextSaveGState(context);
    CGContextRestoreGState(context);

    
    [[UIColor blackColor] setStroke];
    [arrowPath  stroke];
    [curvePath1 stroke];
    [curvePath2 stroke];
    
    UIGraphicsPopContext();
 
    
}


#pragma mark -- Help Method

-(CGPoint)getMiddlePointWithPoint1:(CGPoint)point1 point2:(CGPoint)point2{
    
    CGFloat middle_x = (point1.x + point2.x)/2;
    CGFloat middle_y = (point1.y + point2.y)/2;
    
    return CGPointMake(middle_x, middle_y);
    
}

-(CGFloat)getDistanceWithPoint1:(CGPoint)point1 point2:(CGPoint)point2{
    
    return sqrtf(pow(fabs(point1.x - point2.x), 2) + pow(fabs(point1.y - point2.y), 2));
    
}




@end
