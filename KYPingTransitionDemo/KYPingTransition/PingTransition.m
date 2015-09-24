//
//  PingTransition.m
//  KYPingTransition
//
//  Created by Kitten Yang on 1/30/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "PingTransition.h"
#import "ViewController.h"
#import "SecondViewController.h"


@interface PingTransition ()
@property (nonatomic,strong)id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation PingTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return  0.7f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    self.transitionContext = transitionContext;

    ViewController * fromVC = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    SecondViewController *toVC = (SecondViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *contView = [transitionContext containerView];

    UIButton *button = fromVC.button;
    
    
    UIBezierPath *maskStartBP =  [UIBezierPath bezierPathWithOvalInRect:button.frame];    
    [contView addSubview:fromVC.view];
    [contView addSubview:toVC.view];

    
    
    //创建两个圆形的 UIBezierPath 实例；一个是 button 的 size ，另外一个则拥有足够覆盖屏幕的半径。最终的动画则是在这两个贝塞尔路径之间进行的
    
    CGPoint finalPoint;
    //判断触发点在那个象限
    if(button.frame.origin.x > (toVC.view.bounds.size.width / 2)){
        if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第一象限
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第四象限
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - 0);
        }
    }else{
        if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第二象限
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第三象限
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - 0);
        }
    }
    
    
    
    CGFloat radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y));
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    
    
    //创建一个 CAShapeLayer 来负责展示圆形遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskFinalBP.CGPath; //将它的 path 指定为最终的 path 来避免在动画完成后会回弹
    toVC.view.layer.mask = maskLayer;
    
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskStartBP.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((maskFinalBP.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    

    
    

/*  POP的弹框效果 CGPathRef
 
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    keyFrame.values = @[(__bridge id)(maskStartBP.CGPath),(__bridge id)(maskFinalBP.CGPath)];
    keyFrame.duration = 100.0f;
    keyFrame.additive = YES;
    keyFrame.removedOnCompletion = NO;
    keyFrame.fillMode = kCAFillModeForwards;
    
    
    [maskLayer addAnimation:keyFrame forKey:nil];
    maskLayer.speed = 0.0;
    
    
    POPAnimatableProperty* pop = [POPAnimatableProperty propertyWithName:@"timeOffset" initializer:^(POPMutableAnimatableProperty *prop) {
        // read value
        prop.readBlock = ^(CAShapeLayer *obj, CGFloat values[]) {
            values[0] = obj.timeOffset;
        };
        // write value
        prop.writeBlock = ^(CAShapeLayer *obj, const CGFloat values[]) {
            obj.timeOffset = values[0];
        };
        // dynamics threshold
        prop.threshold = 0.1;
    }];
    
    
    POPSpringAnimation *popSpring = [POPSpringAnimation animation];
    popSpring.fromValue = @(0.0);
    popSpring.toValue =  @(100.f);
    popSpring.springBounciness = 1.0;//弹性
    popSpring.springSpeed = 20.0;//速度
    popSpring.dynamicsTension = 700;//张力
    popSpring.dynamicsFriction = 5; // 摩擦力
    popSpring.dynamicsMass = 1;
    popSpring.property = pop;
    popSpring.delegate = self;
    [maskLayer pop_addAnimation:popSpring forKey:nil];
    
  */
  
//    kPOPShapeLayerStrokeStart
    
    //创建一个关于 path 的 CABasicAnimation 动画来从 circleMaskPathInitial.CGPath 到 circleMaskPathFinal.CGPath 。同时指定它的 delegate 来在完成动画时做一些清除工作
    
}


- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished{
    //告诉 iOS 这个 transition 完成
    [self.transitionContext completeTransition:![self. transitionContext transitionWasCancelled]];
    //清除 fromVC 的 mask
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}
#pragma mark - CABasicAnimation的Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    //告诉 iOS 这个 transition 完成
    [self.transitionContext completeTransition:![self. transitionContext transitionWasCancelled]];
    //清除 fromVC 的 mask
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;

}



@end





