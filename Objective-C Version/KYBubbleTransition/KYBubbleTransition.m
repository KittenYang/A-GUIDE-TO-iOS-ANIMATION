//
//  KYBubbleTransition.m
//  guji
//
//  Created by Kitten Yang on 5/15/15.
//  Copyright (c) 2015 Guji Tech Ltd. All rights reserved.
//



#import "KYBubbleTransition.h"

@interface KYBubbleTransition()

@property(nonatomic,strong)UIView *bubble;

@end

@implementation KYBubbleTransition



- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIView *containerView = [transitionContext containerView];
    CGFloat radius;
    
    //判断触发点在那个象限
    if(self.startPoint.x > (containerView.bounds.size.width / 2)){
        if (self.startPoint.y < (containerView.bounds.size.height / 2)) {
            //第一象限
            radius = sqrtf((self.startPoint.x * self.startPoint.x) + (containerView.bounds.size.height-self.startPoint.y)*(containerView.bounds.size.height-self.startPoint.y));
        }else{
            //第四象限
            radius = sqrtf((self.startPoint.x * self.startPoint.x) + (self.startPoint.y*self.startPoint.y));
        }
    }else{
        if (self.startPoint.y < (containerView.bounds.size.height / 2)) {
            //第二象限
            radius = sqrtf((containerView.bounds.size.width - self.startPoint.x) * (containerView.bounds.size.width - self.startPoint.x) + (containerView.bounds.size.height-self.startPoint.y)*(containerView.bounds.size.height-self.startPoint.y));
        }else{
            //第三象限
            radius = sqrtf((containerView.bounds.size.width - self.startPoint.x) * (containerView.bounds.size.width - self.startPoint.x) + (self.startPoint.y*self.startPoint.y));
        }
    }

    
    
    CGSize size = CGSizeMake(radius*2, radius*2);
    self.bubble = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    self.bubble.center = self.startPoint;
    self.bubble.layer.cornerRadius = size.width / 2;
    self.bubble.backgroundColor = self.bubbleColor;
    
    if (self.transitionMode == Present) {

        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        
        CGPoint originalCenter = toView.center;
        
        self.bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
        toView.center = self.startPoint;
        toView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        toView.alpha = 0.0;
        _bubble.alpha = 1.0;
        
        [containerView addSubview:_bubble];
        [containerView addSubview:toView];
        
        [UIView animateWithDuration:self.duration animations:^{
            _bubble.transform = CGAffineTransformIdentity;
            toView.transform = CGAffineTransformIdentity;
            toView.alpha =  1.0f;
            toView.center = originalCenter;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                _bubble.alpha = 0.0;
            }completion:^(BOOL finished) {
                [_bubble removeFromSuperview];
                [transitionContext completeTransition:YES];
            }];
        }];
        
    }else{
        
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

        [containerView addSubview:toView];
        [containerView addSubview:self.bubble];
        [containerView addSubview:fromView];
        [UIView animateWithDuration:self.duration animations:^{
            self.bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
            fromView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            fromView.center = self.startPoint;
            fromView.alpha = 0;
        } completion:^(BOOL finished) {
            [fromView removeFromSuperview];
            [self.bubble removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    }
        
}


@end
