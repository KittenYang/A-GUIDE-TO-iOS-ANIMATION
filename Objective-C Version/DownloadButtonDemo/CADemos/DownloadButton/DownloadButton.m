//
//  DownloadButton.m
//  CADemos
//
//  Created by Kitten Yang on 9/21/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "DownloadButton.h"

@implementation DownloadButton{

    BOOL animating;
    CGRect originframe;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSomething];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpSomething];
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        [self setUpSomething];
    }
    return self;
}

-(void)setUpSomething{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tapGes];
}


#pragma mark -- UITapGesture

-(void)tapped:(UITapGestureRecognizer *)tapped{
    originframe = self.frame;
    
    if (animating == YES) {
        return;
    }
    
    for (CALayer *subLayer in self.layer.sublayers) {
        [subLayer removeFromSuperlayer];
    }
    
    self.backgroundColor = [UIColor colorWithRed:0.0 green:122/255.0 blue:255/255.0 alpha:1.0];
    
    animating = YES;
    
    //这个不是正确的方式，正确的方式是先改变model layer的属性，再应用动画。
//    radiusAnimation.fillMode = kCAFillModeForwards;
//    radiusAnimation.removedOnCompletion = NO;
    //WWDC 2011 视频 http://adcdownload.apple.com/videos/wwdc_2011__sd/session_421__core_animation_essentials.m4v
    self.layer.cornerRadius = self.progressBarHeight/2;
    
    //注意:[UIView animate]的方法里只能对UIView的属性进行动画，对于layer的属性是无效的。比如你在这里想让self.AnimateView.layer.cornerRadius = 50.0; 是没有意义的。必须使用CoreAnimation。
    CABasicAnimation *radiusShrinkAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    radiusShrinkAnimation.duration = 0.2f;
    radiusShrinkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    radiusShrinkAnimation.fromValue = @(originframe.size.height/2);
    
    //不需要设置toValue了
    radiusShrinkAnimation.delegate = self;
    [self.layer addAnimation:radiusShrinkAnimation forKey:@"cornerRadiusShrinkAnim"];

}


-(void)animationDidStart:(CAAnimation *)anim{
    
    //这里介绍两种方式区分不同的anim 1、对于加在一个全局变量上的anima，比如例子里的self.AnimateView ，这是一个全局变量，所以我们在这里可以通过[self.AnimateView.layer animationForKey:]根据动画不同的key来区分
    //2、然而对于一个非全局的变量，比如demo中的progressLayer，可以用KVO:[pathAnimation setValue:@"strokeEndAnimation" forKey:@"animationName"];注意这个animationName是我们自己设定的。
    
    if ([anim isEqual:[self.layer animationForKey:@"cornerRadiusShrinkAnim"]]) {
        
        [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.bounds = CGRectMake(0, 0, _progressBarWidth, _progressBarHeight);
        } completion:^(BOOL finished) {
            [self.layer removeAllAnimations];
            [self progressBarAnimation];
        }];
        
    }else if ([anim isEqual:[self.layer animationForKey:@"cornerRadiusExpandAnim"]]){
        
        [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.bounds = CGRectMake(0, 0, originframe.size.width, originframe.size.height);
            self.backgroundColor = [UIColor colorWithRed:0.1803921568627451 green:0.8 blue:0.44313725490196076 alpha:1.0];
        } completion:^(BOOL finished) {
            [self.layer removeAllAnimations];
            [self checkAnimation];
            //-----
            animating = NO;
        }];
        
    }
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if ([[anim valueForKey:@"animationName"]isEqualToString:@"progressBarAnimation"]){
        
        [UIView animateWithDuration:0.3 animations:^{
            for (CALayer *subLayer in self.layer.sublayers) {
                subLayer.opacity = 0.0f;
            }
        } completion:^(BOOL finished) {
            if (finished) {
                for (CALayer *subLayer in self.layer.sublayers) {
                    [subLayer removeFromSuperlayer];
                }
                
                self.layer.cornerRadius = originframe.size.height/2;
                
                CABasicAnimation *radiusExpandAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
                radiusExpandAnimation.duration = 0.2f;
                radiusExpandAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                radiusExpandAnimation.fromValue = @(_progressBarHeight/2);
                
                radiusExpandAnimation.delegate = self;
                [self.layer addAnimation:radiusExpandAnimation forKey:@"cornerRadiusExpandAnim"];
                
            }
        }];
        
    }
}


#pragma mark -- Helper

-(void)progressBarAnimation{
    
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(_progressBarHeight/2, self.bounds.size.height/2)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width-_progressBarHeight/2, self.bounds.size.height/2)];
    
    progressLayer.path = path.CGPath;
    progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    progressLayer.lineWidth = _progressBarHeight-6;
    progressLayer.lineCap = kCALineCapRound;
    //设置了kCALineCapRound 那么圆角弧度自动被设为 lineWidth/2 .所以要想进度条距离外围的间距相等，起始点的 x 坐标应该等于满足公式 x=lineWidth/2+space; ∵ lineWidth ＝ _progressBarHeight-space*2 ∴x = height/2.与 linewidth 是多少并没有关系
    [self.layer addSublayer:progressLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2.0f;
    pathAnimation.fromValue = @(0.0f);
    pathAnimation.toValue = @(1.0f);
    pathAnimation.delegate = self;
    [pathAnimation setValue:@"progressBarAnimation" forKey:@"animationName"];
    [progressLayer addAnimation:pathAnimation forKey:nil];
    
}

-(void)checkAnimation{
    
    CAShapeLayer *checkLayer = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect rectInCircle = CGRectInset(self.bounds, self.bounds.size.width*(1-1/sqrt(2.0))/2, self.bounds.size.width*(1-1/sqrt(2.0))/2);
    [path moveToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width/9, rectInCircle.origin.y + rectInCircle.size.height*2/3)];
    [path addLineToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width/3,rectInCircle.origin.y + rectInCircle.size.height*9/10)];
    [path addLineToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width*8/10, rectInCircle.origin.y + rectInCircle.size.height*2/10)];
    
    checkLayer.path = path.CGPath;
    checkLayer.fillColor = [UIColor clearColor].CGColor;
    checkLayer.strokeColor = [UIColor whiteColor].CGColor;
    checkLayer.lineWidth = 10.0;
    checkLayer.lineCap = kCALineCapRound;
    checkLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:checkLayer];
    
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = 0.3f;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    checkAnimation.delegate = self;
    [checkAnimation setValue:@"checkAnimation" forKey:@"animationName"];
    [checkLayer addAnimation:checkAnimation forKey:nil];

}

@end
