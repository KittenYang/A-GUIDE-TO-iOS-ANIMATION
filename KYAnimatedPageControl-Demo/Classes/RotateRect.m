//
//  RotateRect.m
//  KYAnimatedPageControl-Demo
//
//  Created by Kitten Yang on 6/12/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "RotateRect.h"
#import "KYAnimatedPageControl.h"
#import "KYSpringLayerAnimation.h"


@interface RotateRect()

@property(nonatomic,assign)CGFloat index;

@end

@implementation RotateRect

#pragma mark -- Initialize
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(id)initWithLayer:(RotateRect *)layer{
    self = [super initWithLayer:layer];
    if (self) {
        
        self.indicatorSize  = layer.indicatorSize;
        self.indicatorColor = layer.indicatorColor;
        self.currentRect = layer.currentRect;
        self.lastContentOffset = layer.lastContentOffset;
        self.index = layer.index;

    }
    return self;
}


#pragma mark -- override  class func
-(void)drawInContext:(CGContextRef)ctx{
    
    
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.currentRect];
    CGPathRef path = createPathRotatedAroundBoundingBoxCenter(rectPath.CGPath, _index * M_PI_2 );
    rectPath.CGPath  = path;
    CGContextAddPath(ctx, path);
    CGContextSetFillColorWithColor(ctx, self.indicatorColor.CGColor);
    CGContextFillPath(ctx);
    

    CGPathRelease(path);

}



+(BOOL)needsDisplayForKey:(NSString *)key{
    if ([key isEqual:@"index"]) {
        return  YES;
    }
    
    
    return  [super needsDisplayForKey:key];
}


#pragma mark -- Helper Method

static CGPathRef createPathRotatedAroundBoundingBoxCenter(CGPathRef path, CGFloat radians) {
    CGRect bounds = CGPathGetBoundingBox(path); // might want to use CGPathGetPathBoundingBox
    CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, center.x, center.y);
    transform = CGAffineTransformRotate(transform, radians);
    transform = CGAffineTransformTranslate(transform, -center.x, -center.y);
    return CGPathCreateCopyByTransformingPath(path, &transform);
}


#pragma mark -- override superclass method

-(void)animateIndicatorWithScrollView:(UIScrollView *)scrollView andIndicator:(KYAnimatedPageControl *)pgctl{
    


    CGFloat originX = (scrollView.contentOffset.x / scrollView.frame.size.width) * (pgctl.frame.size.width / (pgctl.pageCount-1));
    

    _index = (scrollView.contentOffset.x / scrollView.frame.size.width);
    
    
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
    
//    CGFloat fromValue = 0.0;
//    if (self.scrollDirection == ScrollDirectionLeft) {
//        
//        fromValue = 0.5+[howmanydistance floatValue]* 1.5;
//        
//    }else if (self.scrollDirection == ScrollDirectionRight)  {
//        
//        fromValue = - (0.5+[howmanydistance floatValue]* 1.5);
//    }
//
//    NSLog(@"howmanydistance : %f",[howmanydistance floatValue]);
//    CAKeyframeAnimation *anim = [KYSpringLayerAnimation createSpring:@"index" duration:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:3 fromValue:@(fromValue) toValue:@(0)];
//    _index = 0;
//    [self addAnimation:anim forKey:@"restoreAnimation"];
    
}




@end
