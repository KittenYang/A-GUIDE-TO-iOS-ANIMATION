//
//  Line.m
//  KYAnimatedPageControl-Demo
//
//  Created by Kitten Yang on 6/11/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.


//相邻小球之间的距离
#define DISTANCE ((self.frame.size.width - self.ballDiameter) / (self.pageCount - 1))

#import "Line.h"
#import "KYSpringLayerAnimation.h"



@interface Line()


@end

@implementation Line{

    CGFloat initialSelectedLineLength; // 记录上一次选中的长度
    CGFloat lastContentOffsetX;        // 记录上一次的contentOffSet.x

}

#pragma mark -- Initialize

//第一次显示提供默认值
-(id)init{
    
    self = [super init];
    if (self) {

        //属性默认值
        self.selectedPage = 1;
        self.lineHeight = 2.0;
        self.ballDiameter = 10.0;
        self.unSelectedColor = [UIColor colorWithWhite:0.9 alpha:1];
        self.selectedColor   = [UIColor redColor];
        self.shouldShowProgressLine = YES;
        self.pageCount = 6;
        
    }
    
    return self;
}


//必须重载  drawInContext前必调此方法，需要拷贝上一个状态
-(id)initWithLayer:(Line*)layer{
    self = [super initWithLayer:layer];
    if (self) {
        
        self.selectedPage = layer.selectedPage;
        self.lineHeight = layer.lineHeight;
        self.ballDiameter = layer.ballDiameter;
        self.unSelectedColor = layer.unSelectedColor;
        self.selectedColor   = layer.selectedColor;
        self.shouldShowProgressLine = layer.shouldShowProgressLine;
        self.pageCount = layer.pageCount;
        self.selectedLineLength = layer.selectedLineLength;
        self.bindScrollView = layer.bindScrollView;
        self.masksToBounds = layer.masksToBounds;
    }
    
    return self;
}


#pragma mark -- Setter
-(void)setSelectedPage:(NSInteger)selectedPage{
    if (_selectedPage != selectedPage) {
        _selectedPage = selectedPage;
        
//        self.selectedLineLength = self.pageCount > 1 ? (selectedPage-1) * DISTANCE : 0;
        
        initialSelectedLineLength = self.selectedLineLength;

    }

}


#pragma mark -- override Class func
+ (BOOL)needsDisplayForKey:(NSString *)key{
    if ([key isEqual: @"selectedLineLength"]) {
        return  YES;
    }
    return [super needsDisplayForKey:key];
    
}



//invoke when call setNeedDisplay
-(void)drawInContext:(CGContextRef)ctx{
    
    NSLog(@"selectedLineLength:%f",self.selectedLineLength);
    
    NSAssert(self.selectedPage <= self.pageCount, @"ERROR:PageCount can not less than selectedPage");
    NSAssert(self.selectedPage != 0, @"ERROR:SelectedPage can not be ZERO!");

    
    if (self.pageCount == 1) {
        
        CGMutablePathRef linePath = CGPathCreateMutable();
        CGPathMoveToPoint(linePath, nil, self.frame.size.width/2, self.frame.size.height/2);
        CGRect circleRect = CGRectMake(self.frame.size.width/2 - self.ballDiameter/2, self.frame.size.height / 2 - self.ballDiameter / 2, self.ballDiameter, self.ballDiameter);
        CGPathAddEllipseInRect(linePath, nil, circleRect);

        CGContextAddPath(ctx, linePath);
        CGContextSetFillColorWithColor(ctx, self.selectedColor.CGColor);
        CGContextFillPath(ctx);
        
        return;
    }
    
    
    CGMutablePathRef linePath = CGPathCreateMutable();
    
    CGPathMoveToPoint(linePath, nil, self.ballDiameter/2, self.frame.size.height/2);
    
    //画默认颜色的背景线
    CGPathAddRoundedRect(linePath, nil, CGRectMake(self.ballDiameter/2, self.frame.size.height/2 - self.lineHeight/2, self.frame.size.width - self.ballDiameter, self.lineHeight), 0, 0);

    
    //画pageCount个小圆
    for (NSInteger i = 0; i<self.pageCount; i++) {
        
        CGRect circleRect = CGRectMake(0 + i*DISTANCE, self.frame.size.height / 2 - self.ballDiameter / 2, self.ballDiameter, self.ballDiameter);
        CGPathAddEllipseInRect(linePath, nil, circleRect);
        
    }
    
    CGContextAddPath(ctx, linePath);
    CGContextSetFillColorWithColor(ctx, self.unSelectedColor.CGColor);
    CGContextFillPath(ctx);
    
    
    if (self.shouldShowProgressLine == YES) {
        CGContextBeginPath(ctx);
        linePath = CGPathCreateMutable();

        //画带颜色的线
        CGPathAddRoundedRect(linePath, nil, CGRectMake(self.ballDiameter/2, self.frame.size.height/2 - self.lineHeight/2, self.selectedLineLength , self.lineHeight), 0, 0);
        
        //画pageCount个有色小圆
        for (NSInteger i = 0; i<self.pageCount; i++) {
            
            if (i*DISTANCE <= self.selectedLineLength+0.1) {
                CGRect circleRect = CGRectMake(0 + i*DISTANCE, self.frame.size.height / 2 - self.ballDiameter / 2, self.ballDiameter, self.ballDiameter);
                CGPathAddEllipseInRect(linePath, nil, circleRect);
            }
        }
        
        CGContextAddPath(ctx, linePath);
        CGContextSetFillColorWithColor(ctx, self.selectedColor.CGColor);
        CGContextFillPath(ctx);
    
    }

}



#pragma mark -- length animation
//tap index to scroll
-(void)animateSelectedLineToNewIndex:(NSInteger)newIndex{

    CGFloat newLineLength = (newIndex-1) * DISTANCE;
    //Spring Animation
//    CAKeyframeAnimation *anim = [[KYSpringLayerAnimation sharedAnimManager] createSpringAnima:@"selectedLineLength" duration:1.0 usingSpringWithDamping:0.5 initialSpringVelocity:3 fromValue:@(self.selectedLineLength) toValue:@(newLineLength)];
    
    //Half curve animation
    CAKeyframeAnimation *anim = [[KYSpringLayerAnimation sharedAnimManager] createHalfCurveAnima:@"selectedLineLength" duration:1.0 fromValue:@(self.selectedLineLength) toValue:@(newLineLength)];
    
    //line animation
//    CAKeyframeAnimation *anim = [[KYSpringLayerAnimation sharedAnimManager] createBasicAnima:@"selectedLineLength" duration:0.2 fromValue:@(self.selectedLineLength) toValue:@(newLineLength)];

    
    self.selectedLineLength = newLineLength;
    anim.delegate = self;
    [self addAnimation:anim forKey:@"lineAnimation"];

    self.selectedPage = newIndex;


}



//pan to scroll
-(void)animateSelectedLineWithScrollView:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x <= 0) {
        return;
    }
    
    CGFloat offSetX = scrollView.contentOffset.x - lastContentOffsetX;
    
    self.selectedLineLength = initialSelectedLineLength + (offSetX/scrollView.frame.size.width) * DISTANCE;
    [self setNeedsDisplay];

}



#pragma maek --  Animation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (flag) {
        initialSelectedLineLength = self.selectedLineLength;
        lastContentOffsetX = (self.selectedLineLength / DISTANCE) * self.bindScrollView.frame.size.width;
    }
    
}

@end
