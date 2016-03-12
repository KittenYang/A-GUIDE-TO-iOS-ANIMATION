//
//  LoadingHUD.m
//  Cosmos
//
//  Created by KittenYang on 16/3/9.
//  Copyright © 2016年 KittenYang. All rights reserved.
//


#define ORIGIN_X    self.frame.origin.x
#define ORIGIN_Y    self.frame.origin.y
#define WIDTH       self.frame.size.width
#define HEIGHT      self.frame.size.height
#define BALL_RADIUS  20

#import "LoadingHUD.h"

@interface LoadingHUD()

@property(nonatomic, strong)NSTimer *timer;

@end

@implementation LoadingHUD{
  UIView *ball_1;
  UIView *ball_2;
  UIView *ball_3;
}

+ (LoadingHUD*)sharedHUD {
  static dispatch_once_t once;
  static LoadingHUD *sharedHUD;
  dispatch_once(&once, ^{
    sharedHUD = [[self alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
  });
  return sharedHUD;
}

-(id)initWithEffect:(UIVisualEffect *)effect{
  self = [super initWithEffect:effect];
  if (self) {
    self.frame = UIScreen.mainScreen.bounds;
    ball_2 = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/2 - BALL_RADIUS/2, HEIGHT / 2-BALL_RADIUS/2, BALL_RADIUS, BALL_RADIUS)];
    ball_2.backgroundColor = [UIColor whiteColor];
    ball_2.layer.cornerRadius = ball_2.bounds.size.width / 2;
    
    ball_1 = [[UIView alloc]initWithFrame:CGRectMake(ball_2.frame.origin.x - BALL_RADIUS, ball_2.frame.origin.y, BALL_RADIUS, BALL_RADIUS)];
    ball_1.backgroundColor = [UIColor whiteColor];
    ball_1.layer.cornerRadius = ball_1.bounds.size.width / 2;
    
    ball_3 = [[UIView alloc]initWithFrame:CGRectMake(ball_2.frame.origin.x + BALL_RADIUS, ball_2.frame.origin.y, BALL_RADIUS, BALL_RADIUS)];
    ball_3.backgroundColor = [UIColor whiteColor];
    ball_3.layer.cornerRadius = ball_3.bounds.size.width / 2;
    
    [self addSubview:ball_1];
    [self addSubview:ball_2];
    [self addSubview:ball_3];
    
  }
  return self;
}


+ (void)showHUD{
  LoadingHUD *hud = [LoadingHUD sharedHUD];
  UIWindow *window = UIApplication.sharedApplication.keyWindow;
  if (window != nil) {
    hud.alpha = 0.0;
    [window addSubview:hud];
    [UIView animateWithDuration:0.3 animations:^{
      hud.alpha = 0.9;
    } completion:^(BOOL finished) {
      hud.alpha = 0.9;
      [hud startLoadingAnimation];
    }];
  }
  
}

+ (void)dismissHUD{
  LoadingHUD *hud = [LoadingHUD sharedHUD];
  [hud stopLoadingAnimation];
  [hud.timer invalidate];
  [UIView animateWithDuration:0.3 animations:^{
    hud.alpha = 0;
  } completion:^(BOOL finished) {
    [hud removeFromSuperview];
  }];
}

-(void)startLoadingAnimation{
  
  //-----1--------
  UIBezierPath *circlePath_1 = [UIBezierPath bezierPath];
  [circlePath_1 moveToPoint:CGPointMake(WIDTH/2-BALL_RADIUS, HEIGHT/2)];
  [circlePath_1 addArcWithCenter:CGPointMake(WIDTH/2, HEIGHT/2) radius:BALL_RADIUS startAngle:(180*M_PI)/180 endAngle:(360*M_PI)/180 clockwise:NO];
  UIBezierPath *circlePath_1_2 = [UIBezierPath bezierPath];
  [circlePath_1_2 addArcWithCenter:CGPointMake(WIDTH/2, HEIGHT/2) radius:BALL_RADIUS startAngle:0 endAngle:(180*M_PI)/180 clockwise:NO];
  [circlePath_1 appendPath:circlePath_1_2];
  
  CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
  animation.path = circlePath_1.CGPath;
  animation.removedOnCompletion = YES;
  animation.duration = 1.4 ;
  animation.repeatCount = INFINITY;
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  [ball_1.layer addAnimation:animation forKey:@"animation"];
  
  //------2--------
  UIBezierPath *circlePath_2 = [UIBezierPath bezierPath];
  [circlePath_2 moveToPoint:CGPointMake(WIDTH/2+BALL_RADIUS, HEIGHT/2)];
  
  [circlePath_2 addArcWithCenter:CGPointMake(WIDTH/2, HEIGHT/2) radius:BALL_RADIUS startAngle:(0*M_PI)/180 endAngle:(180*M_PI)/180 clockwise:NO];
  UIBezierPath *circlePath_2_2 = [UIBezierPath bezierPath];
  [circlePath_2_2 addArcWithCenter:CGPointMake(WIDTH/2, HEIGHT/2) radius:BALL_RADIUS startAngle:(180 *M_PI)/180 endAngle:(360*M_PI)/180 clockwise:NO];
  [circlePath_2 appendPath:circlePath_2_2];
  
  CAKeyframeAnimation *animation_2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  animation_2.path = circlePath_2.CGPath;
  animation_2.removedOnCompletion = YES;
  animation_2.repeatCount = INFINITY;
  animation_2.duration = 1.4 ;
  animation_2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  [ball_3.layer addAnimation:animation_2 forKey:@"Rotation"];
  
   self.timer = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(scaleAnimation) userInfo:nil repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
  
}

-(void)scaleAnimation{
  [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
    ball_1.transform = CGAffineTransformMakeTranslation(-BALL_RADIUS, 0);
    ball_1.transform = CGAffineTransformScale(ball_1.transform, 0.7, 0.7);
    
    ball_3.transform = CGAffineTransformMakeTranslation(BALL_RADIUS, 0);
    ball_3.transform = CGAffineTransformScale(ball_3.transform, 0.7, 0.7);
    
    ball_2.transform = CGAffineTransformScale(ball_2.transform, 0.7, 0.7);
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
      ball_1.transform = CGAffineTransformIdentity;
      ball_3.transform = CGAffineTransformIdentity;
      ball_2.transform = CGAffineTransformIdentity;
    } completion:NULL];
  }];
}

-(void)stopLoadingAnimation {
  [ball_1.layer removeAllAnimations];
  [ball_2.layer removeAllAnimations];
  [ball_3.layer removeAllAnimations];
}


@end
