//
//  GooeyCircle.m
//  KYAnimatedPageControl-Demo
//
//  Created by Kitten Yang on 6/11/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//




#import "GooeyCircle.h"
#import "KYAnimatedPageControl.h"
#import "KYSpringLayerAnimation.h"

@interface GooeyCircle()

@property(nonatomic,assign)CGFloat factor;


@end

@implementation GooeyCircle{
    
    BOOL beginGooeyAnim;
    
    
}

#pragma mark -- Initialize
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(id)initWithLayer:(GooeyCircle *)layer{
    self = [super initWithLayer:layer];
    if (self) {
        
        self.indicatorSize  = layer.indicatorSize;
        self.indicatorColor = layer.indicatorColor;
        self.currentRect = layer.currentRect;
        self.lastContentOffset = layer.lastContentOffset;
        self.scrollDirection = layer.scrollDirection;
        self.factor = layer.factor;
    }
    return self;
}


#pragma mark -- override  class func

- (void)drawInContext:(CGContextRef)ctx{
    
//    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.currentRect];
//    CGContextAddPath(ctx, rectPath.CGPath);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
//    CGContextSetLineWidth(ctx, 1.0);
//    CGFloat dash[] = {5.0, 5.0};
//    CGContextSetLineDash(ctx, 0.0, dash, 2); //1
//    CGContextStrokePath(ctx); //给线条填充颜色

    

    CGFloat offset = self.currentRect.size.width / 3.6;  //设置3.6 出来的弧度最像圆形

    CGPoint rectCenter = CGPointMake(self.currentRect.origin.x + self.currentRect.size.width/2 , self.currentRect.origin.y + self.currentRect.size.height/2);
    
    //8个控制点实际的偏移距离。 The real distance of 8 control points.
    CGFloat extra = (self.currentRect.size.width * 2 / 5) * _factor;
    
    
    CGPoint pointA = CGPointMake(rectCenter.x ,self.currentRect.origin.y + extra);
    CGPoint pointB = CGPointMake(self.scrollDirection == ScrollDirectionLeft ? rectCenter.x + self.currentRect.size.width/2 : rectCenter.x + self.currentRect.size.width/2 + extra*2 ,rectCenter.y);
    CGPoint pointC = CGPointMake(rectCenter.x ,rectCenter.y + self.currentRect.size.height/2 - extra);
    CGPoint pointD = CGPointMake(self.scrollDirection == ScrollDirectionLeft ? self.currentRect.origin.x - extra*2 : self.currentRect.origin.x, rectCenter.y);

    CGPoint c1 = CGPointMake(pointA.x + offset, pointA.y);
    CGPoint c2 = CGPointMake(pointB.x, pointB.y - offset);
    
    CGPoint c3 = CGPointMake(pointB.x, pointB.y + offset);
    CGPoint c4 = CGPointMake(pointC.x + offset, pointC.y);
    
    CGPoint c5 = CGPointMake(pointC.x - offset, pointC.y);
    CGPoint c6 = CGPointMake(pointD.x, pointD.y + offset);
    
    CGPoint c7 = CGPointMake(pointD.x, pointD.y - offset);
    CGPoint c8 = CGPointMake(pointA.x - offset, pointA.y);


    // 更新界面
    UIBezierPath* ovalPath = [UIBezierPath bezierPath];

    [ovalPath moveToPoint: pointA];
    [ovalPath addCurveToPoint:pointB controlPoint1:c1 controlPoint2:c2];
    [ovalPath addCurveToPoint:pointC controlPoint1:c3 controlPoint2:c4];
    [ovalPath addCurveToPoint:pointD controlPoint1:c5 controlPoint2:c6];
    [ovalPath addCurveToPoint:pointA controlPoint1:c7 controlPoint2:c8];
    
    [ovalPath closePath];


    CGContextAddPath(ctx, ovalPath.CGPath);
    CGContextSetFillColorWithColor(ctx, self.indicatorColor.CGColor);
    CGContextFillPath(ctx);
    
}


+(BOOL)needsDisplayForKey:(NSString *)key{
    if ([key isEqual:@"factor"]) {
        return  YES;
    }
    
    
    return  [super needsDisplayForKey:key];
}




#pragma mark -- override superclass method
-(void)animateIndicatorWithScrollView:(UIScrollView *)scrollView andIndicator:(KYAnimatedPageControl *)pgctl{
    
    
    if ((scrollView.contentOffset.x - self.lastContentOffset) >= 0 && (scrollView.contentOffset.x - self.lastContentOffset) <= (scrollView.frame.size.width)/2) {
        self.scrollDirection = ScrollDirectionLeft;
    }else if ((scrollView.contentOffset.x - self.lastContentOffset) <= 0 && (scrollView.contentOffset.x - self.lastContentOffset) >= -(scrollView.frame.size.width)/2){
        self.scrollDirection = ScrollDirectionRight;
    }
    

    if (!beginGooeyAnim) {
        
        _factor = MIN(1, MAX(0, (ABS(scrollView.contentOffset.x - self.lastContentOffset) / scrollView.frame.size.width)));
    }

//    NSLog(@"factor:%f",_factor);

    
    CGFloat originX = (scrollView.contentOffset.x / scrollView.frame.size.width) * (pgctl.frame.size.width / (pgctl.pageCount-1));
    
    if (originX - self.indicatorSize/2 <= 0) {
        
        self.currentRect = CGRectMake(0, self.frame.size.height/2-self.indicatorSize/2, self.indicatorSize, self.indicatorSize);
        
    }else if ((originX - self.indicatorSize/2) >= self.frame.size.width - self.indicatorSize){
        
        self.currentRect = CGRectMake(self.frame.size.width - self.indicatorSize, self.frame.size.height/2-self.indicatorSize/2, self.indicatorSize, self.indicatorSize);
        
    }else{
        
        self.currentRect = CGRectMake(originX - self.indicatorSize/2, self.frame.size.height/2-self.indicatorSize/2, self.indicatorSize, self.indicatorSize);
    }
    

    [self setNeedsDisplay];

    
}


-(void)restoreAnimation:(id)howmanydistance{
    
    //Spring animation
    CAKeyframeAnimation *anim = [[KYSpringLayerAnimation sharedAnimManager]createSpringAnima:@"factor" duration:0.8 usingSpringWithDamping:0.5 initialSpringVelocity:3 fromValue:@(0.5+[howmanydistance floatValue]* 1.5) toValue:@(0)];
    
    //line animation
//    CAKeyframeAnimation *anim = [[KYSpringLayerAnimation sharedAnimManager] createBasicAnima:@"factor" duration:0.4 fromValue:@(0.5+[howmanydistance floatValue]* 1.5) toValue:@(0)];
        
    //half animation
//    CAKeyframeAnimation *anim = [[KYSpringLayerAnimation sharedAnimManager] createHalfCurveAnima:@"factor" duration:0.3 fromValue:@(0.5+[howmanydistance floatValue]* 1.5) toValue:@(0)];
    
    anim.delegate = self;
    self.factor = 0;
    [self addAnimation:anim forKey:@"restoreAnimation"];

}


#pragma mark -- CAAnimation Delegate
-(void)animationDidStart:(CAAnimation *)anim{

    beginGooeyAnim = YES;
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        beginGooeyAnim = NO;
    }
}




@end
