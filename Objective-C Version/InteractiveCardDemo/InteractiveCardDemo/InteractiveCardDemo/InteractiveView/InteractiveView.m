//
//  InteractiveView.m
//  InteractiveCardDemo
//
//  Created by Kitten Yang on 9/28/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//


#define SCREENWIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT    [UIScreen mainScreen].bounds.size.height
#define ANIMATEDURATION 0.5
#define ANIMATEDAMPING  0.6
#define SCROLLDISTANCE  200.0

#import "InteractiveView.h"

@interface InteractiveView()

@end

@implementation InteractiveView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(id)initWithImage:(UIImage *)image{
    self =  [super initWithImage:image];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.layer.cornerRadius = 7.0f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

-(void)setGestureView:(UIView *)gestureView{
    _gestureView = gestureView;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognized:)];
    [gestureView addGestureRecognizer:pan];
}

-(void)panGestureRecognized:(UIPanGestureRecognizer *)pan{
    static CGPoint initialPoint;
    CGFloat factorOfAngle = 0.0f;
    CGFloat factorOfScale = 0.0f;
    CGPoint transition = [pan translationInView:self.superview];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        initialPoint = self.center;
    }else if(pan.state == UIGestureRecognizerStateChanged){
        self.center = CGPointMake(initialPoint.x,initialPoint.y + transition.y);
        CGFloat Y =MIN(SCROLLDISTANCE,MAX(0,ABS(transition.y)));

        //一个开口向下,顶点(SCROLLDISTANCE/2,1),过(0,0),(SCROLLDISTANCE,0)的二次函数
        factorOfAngle = MAX(0,-4/(SCROLLDISTANCE*SCROLLDISTANCE)*Y*(Y-SCROLLDISTANCE));
        //一个开口向下,顶点(SCROLLDISTANCE,1),过(0,0),(2*SCROLLDISTANCE,0)的二次函数
        factorOfScale = MAX(0,-1/(SCROLLDISTANCE*SCROLLDISTANCE)*Y*(Y-2*SCROLLDISTANCE));
        
        CATransform3D t = CATransform3DIdentity;
        t.m34  = 1.0/-1000;
        t = CATransform3DRotate(t,factorOfAngle*(M_PI/5), transition.y>0?-1:1, 0, 0);
        t = CATransform3DScale(t, 1-factorOfScale*0.2, 1-factorOfScale*0.2, 0);
        
        self.layer.transform = t;
        self.dimmingView.alpha = 1.0 - Y / SCROLLDISTANCE;
    }else if ((pan.state == UIGestureRecognizerStateEnded) || (pan.state ==UIGestureRecognizerStateCancelled)){
        [UIView animateWithDuration:ANIMATEDURATION delay:0.0f usingSpringWithDamping:ANIMATEDAMPING initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.layer.transform = CATransform3DIdentity;
            self.center = initialPoint;
            self.dimmingView.alpha = 1.0f;
        } completion:nil];
    }
    
}

@end
