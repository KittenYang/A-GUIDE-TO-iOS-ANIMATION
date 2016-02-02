//
//  PulseLoader.m
//  PulseLoader
//
//  Created by Kitten Yang on 2/2/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

#import "PulseLoader.h"

@interface PulseLoader()

@property(nonatomic,strong)CAShapeLayer *pulseLayer;

@end

@implementation PulseLoader

-(id)initWithFrame:(CGRect)frame withColor:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)setUp {
    self.pulseLayer = [[CAShapeLayer alloc]init];
    self.pulseLayer.frame = self.bounds;
    UIBezierPath *pulsePath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    self.pulseLayer.path = pulsePath.CGPath;
    self.pulseLayer.fillColor = [UIColor redColor].CGColor;
    
    CAReplicatorLayer *replicatorLayer = [[CAReplicatorLayer alloc]init];
    replicatorLayer.frame = self.bounds;
    replicatorLayer.instanceCount = 5;
    replicatorLayer.instanceDelay = 0.3;
    [replicatorLayer addSublayer:self.pulseLayer];
    self.pulseLayer.opacity = 0.0;
    [self.layer addSublayer:replicatorLayer];
}


-(void)startToPulse {
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[[self alphaAnimation],[self scaleAnimation]];
    groupAnimation.duration = 1.5;
    groupAnimation.autoreverses = false;
    groupAnimation.repeatCount = CGFLOAT_MAX;
    [self.pulseLayer addAnimation:groupAnimation forKey:@"pulseAnimation"];
}

-(CABasicAnimation *)alphaAnimation{
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @(1.0);
    alphaAnimation.toValue = @(0.0);
    return alphaAnimation;
}

-(CABasicAnimation *)scaleAnimation{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D t1 = CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0);
    CATransform3D t2 = CATransform3DScale(CATransform3DIdentity, 3.0, 3.0, 0.0);
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:t1];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:t2];
    return scaleAnimation;
}

@end
