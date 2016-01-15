//
//  tvOSCardView.m
//  tvOSCardAnimation
//
//  Created by yangqitao on 15/9/22.
//  Copyright © 2015年 yangqitao. All rights reserved.
//

#import "tvOSCardView.h"

@implementation tvOSCardView{
    
    UIImageView *cardImageView;
    UIImageView *cardParallaxView;
    
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    
    [super willMoveToSuperview:newSuperview];
    [self setUpSomething];
}

#pragma mark -- helper

-(void)setUpSomething{

    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 10);
    self.layer.shadowRadius = 10.0f;
    self.layer.shadowOpacity = 0.3f;
    
    cardImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    cardImageView.image = [UIImage imageNamed:@"poster"];
    cardImageView.layer.cornerRadius = 5.0f;
    cardImageView.clipsToBounds = YES;
    [self addSubview:cardImageView];
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panInCard:)];
    [self addGestureRecognizer:panGes];
    
    cardParallaxView = [[UIImageView alloc]initWithFrame:cardImageView.frame];
    cardParallaxView.image = [UIImage imageNamed:@"5"];
    cardParallaxView.layer.transform = CATransform3DTranslate(cardParallaxView.layer.transform, 0, 0, 200);
    [self insertSubview:cardParallaxView aboveSubview:cardImageView];

}

-(void)panInCard:(UIPanGestureRecognizer *)panGes{
    
    CGPoint touchPoint = [panGes locationInView:self];
    
    if (panGes.state == UIGestureRecognizerStateChanged) {
        
        CGFloat xFactor = MIN(1, MAX(-1,(touchPoint.x - (self.bounds.size.width/2)) / (self.bounds.size.width/2)));
        CGFloat yFactor = MIN(1, MAX(-1,(touchPoint.y - (self.bounds.size.height/2)) / (self.bounds.size.height/2)));
        
        cardImageView.layer.transform = [self transformWithM34:1.0/-500 xf:xFactor yf:yFactor];
        cardParallaxView.layer.transform = [self transformWithM34:1.0/-250 xf:xFactor yf:yFactor];
        
        CGFloat zFactor = 180 * atan(yFactor/xFactor) / M_PI+90;
        NSLog(@"%f",zFactor);
        
    }else if (panGes.state == UIGestureRecognizerStateEnded){
        
        [UIView animateWithDuration:0.3 animations:^{
            cardImageView.layer.transform = CATransform3DIdentity;
            cardParallaxView.layer.transform = CATransform3DIdentity;
        } completion:NULL];
    }
    
}


-(CATransform3D )transformWithM34:(CGFloat)m34 xf:(CGFloat)xf yf:(CGFloat)yf{
    
    CATransform3D t = CATransform3DIdentity;
    t.m34  = m34;
    t = CATransform3DRotate(t, M_PI/9 * yf, -1, 0, 0);
    t = CATransform3DRotate(t, M_PI/9 * xf, 0, 1, 0);
    
    return t;
    
}


@end
