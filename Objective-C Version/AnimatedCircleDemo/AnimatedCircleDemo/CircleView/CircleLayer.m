//
//  CircleLayer.m
//  AnimatedCircleDemo
//
//  Created by Kitten Yang on 7/23/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "CircleLayer.h"
#import <UIKit/UIKit.h>

typedef enum MovingPoint {
    POINT_D,
    POINT_B,
} MovingPoint;

#define outsideRectSize 90

@interface CircleLayer()

/**
 *  外接矩形
 */
@property (nonatomic,assign)CGRect outsideRect;

/**
 *  记录上次的progress，方便做差得出滑动方向
 */
@property(nonatomic,assign)CGFloat lastProgress;


/**
 *  实时记录滑动方向
 */
@property(nonatomic,assign)MovingPoint movePoint;

@end

@implementation CircleLayer{

}

-(id)init{
    
    self = [super init];
    if (self) {
        self.lastProgress = 0.5;
    }
    return self;
}

-(id)initWithLayer:(CircleLayer *)layer{
    self = [super initWithLayer:layer];
    if (self) {
        self.progress    = layer.progress;
        self.outsideRect = layer.outsideRect;
        self.lastProgress = layer.lastProgress;
    }
    return self;
}


-(void)drawInContext:(CGContextRef)ctx{
    
    //A-C1、B-C2... 的距离，当设置为正方形边长的1/3.6倍时，画出来的圆弧完美贴合圆形
    CGFloat offset = self.outsideRect.size.width / 3.6;
    
    //A.B.C.D实际需要移动的距离.系数为滑块偏离中点0.5的绝对值再乘以2.当滑到两端的时候，movedDistance为最大值：「外接矩形宽度的1/5」.
    CGFloat movedDistance = (self.outsideRect.size.width * 1 / 6) * fabs(self.progress-0.5)*2;
    
    //方便下方计算各点坐标，先算出外接矩形的中心点坐标
    CGPoint rectCenter = CGPointMake(self.outsideRect.origin.x + self.outsideRect.size.width/2 , self.outsideRect.origin.y + self.outsideRect.size.height/2);
    
    
    CGPoint pointA = CGPointMake(rectCenter.x ,self.outsideRect.origin.y + movedDistance);
    CGPoint pointB = CGPointMake(self.movePoint == POINT_D ? rectCenter.x + self.outsideRect.size.width/2 : rectCenter.x + self.outsideRect.size.width/2 + movedDistance*2 ,rectCenter.y);
    CGPoint pointC = CGPointMake(rectCenter.x ,rectCenter.y + self.outsideRect.size.height/2 - movedDistance);
    CGPoint pointD = CGPointMake(self.movePoint == POINT_D ? self.outsideRect.origin.x - movedDistance*2 : self.outsideRect.origin.x, rectCenter.y);
    
    
    CGPoint c1 = CGPointMake(pointA.x + offset, pointA.y);
    CGPoint c2 = CGPointMake(pointB.x, self.movePoint == POINT_D ? pointB.y - offset : pointB.y - offset + movedDistance);
    
    CGPoint c3 = CGPointMake(pointB.x, self.movePoint == POINT_D ? pointB.y + offset : pointB.y + offset - movedDistance);
    CGPoint c4 = CGPointMake(pointC.x + offset, pointC.y);
    
    CGPoint c5 = CGPointMake(pointC.x - offset, pointC.y);
    CGPoint c6 = CGPointMake(pointD.x, self.movePoint == POINT_D ? pointD.y + offset - movedDistance : pointD.y + offset);
    
    CGPoint c7 = CGPointMake(pointD.x, self.movePoint == POINT_D ? pointD.y - offset + movedDistance : pointD.y - offset);
    CGPoint c8 = CGPointMake(pointA.x - offset, pointA.y);

    
    //外接虚线矩形
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.outsideRect];
    CGContextAddPath(ctx, rectPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 1.0);
    CGFloat dash[] = {5.0, 5.0};
    CGContextSetLineDash(ctx, 0.0, dash, 2); //1
    CGContextStrokePath(ctx); //给线条填充颜色
    
    
    //圆的边界
    UIBezierPath* ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint: pointA];
    [ovalPath addCurveToPoint:pointB controlPoint1:c1 controlPoint2:c2];
    [ovalPath addCurveToPoint:pointC controlPoint1:c3 controlPoint2:c4];
    [ovalPath addCurveToPoint:pointD controlPoint1:c5 controlPoint2:c6];
    [ovalPath addCurveToPoint:pointA controlPoint1:c7 controlPoint2:c8];
    [ovalPath closePath];

    CGContextAddPath(ctx, ovalPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineDash(ctx, 0, NULL, 0); //2
    CGContextDrawPath(ctx, kCGPathFillStroke); //同时给线条和线条包围的内部区域填充颜色
    
    
    //标记出每个点并连线，方便观察，给所有关键点染色 -- 白色,辅助线颜色 -- 白色
    //语法糖：字典@{}，数组@[]，基本数据类型封装成对象@234，@12.0，@YES,@(234+12.0)
    CGContextSetFillColorWithColor(ctx, [UIColor yellowColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    NSArray *points = @[[NSValue valueWithCGPoint:pointA],[NSValue valueWithCGPoint:pointB],[NSValue valueWithCGPoint:pointC],[NSValue valueWithCGPoint:pointD],[NSValue valueWithCGPoint:c1],[NSValue valueWithCGPoint:c2],[NSValue valueWithCGPoint:c3],[NSValue valueWithCGPoint:c4],[NSValue valueWithCGPoint:c5],[NSValue valueWithCGPoint:c6],[NSValue valueWithCGPoint:c7],[NSValue valueWithCGPoint:c8]];
    [self drawPoint:points withContext:ctx];
    
    //连接辅助线
    UIBezierPath *helperline = [UIBezierPath bezierPath];
    [helperline moveToPoint:pointA];
    [helperline addLineToPoint:c1];
    [helperline addLineToPoint:c2];
    [helperline addLineToPoint:pointB];
    [helperline addLineToPoint:c3];
    [helperline addLineToPoint:c4];
    [helperline addLineToPoint:pointC];
    [helperline addLineToPoint:c5];
    [helperline addLineToPoint:c6];
    [helperline addLineToPoint:pointD];
    [helperline addLineToPoint:c7];
    [helperline addLineToPoint:c8];
    [helperline closePath];
    
    CGContextAddPath(ctx, helperline.CGPath);
    
    CGFloat dash2[] = {2.0, 2.0};
    CGContextSetLineDash(ctx, 0.0, dash2, 2);
    CGContextStrokePath(ctx); //给辅助线条填充颜色
    
}

//ctx字面意思是上下文，你可以理解为一块全局的画布。也就是说，一旦在某个地方改了画布的一些属性，其他任何使用画布的属性的时候都是改了之后的。比如上面在 //1 中把线条样式改成了虚线，那么在下文 //2 中如果不恢复成连续的直线，那么画出来的依然是//1中的虚线样式。

//在某个point位置画一个点，方便观察运动情况
-(void)drawPoint:(NSArray *)points withContext:(CGContextRef)ctx{
    for (NSValue *pointValue in points) {
        CGPoint point = [pointValue CGPointValue];
        CGContextFillRect(ctx, CGRectMake(point.x - 2,point.y - 2,4,4));
    }
}

-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    //只要外接矩形在左侧，则改变B点；在右边，改变D点
    if (progress <= 0.5) {

        self.movePoint = POINT_B;
        NSLog(@"B点动");
        
    }else{
        
        self.movePoint = POINT_D;
        NSLog(@"D点动");
    }
    
    self.lastProgress = progress;
    
    
    CGFloat origin_x = self.position.x - outsideRectSize/2 + (progress - 0.5)*(self.frame.size.width - outsideRectSize);
    CGFloat origin_y = self.position.y - outsideRectSize/2;
    
    self.outsideRect = CGRectMake(origin_x, origin_y, outsideRectSize, outsideRectSize);

    [self setNeedsDisplay];
}

@end
