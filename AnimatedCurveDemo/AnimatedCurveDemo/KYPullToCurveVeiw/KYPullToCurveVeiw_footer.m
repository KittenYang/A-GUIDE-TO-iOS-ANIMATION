//
//  KYPullToCurveVeiw.m
//  AnimatedCurveDemo
//
//  Created by yangqitao on 15/7/8.
//  Copyright (c) 2015年 Kitten Yang. All rights reserved.
//

#import "KYPullToCurveVeiw_footer.h"
#import "LabelView.h"
#import "CurveView.h"
#import "UIView+Convenient.h"



@interface KYPullToCurveVeiw_footer()

@property(nonatomic,assign)CGFloat progress;
@property (nonatomic,weak)UIScrollView *associatedScrollView;
@property (nonatomic,copy)void(^refreshingBlock)(void);

@end


@implementation KYPullToCurveVeiw_footer{
    
    LabelView *labelView;
    CurveView *curveView;

    
    CGSize contentSize;
    CGFloat originOffset;
    BOOL willEnd;
    BOOL notTracking;
    BOOL loading;
}


#pragma mark -- Public Method

-(id)initWithAssociatedScrollView:(UIScrollView *)scrollView withNavigationBar:(BOOL)navBar{
    
    self = [super initWithFrame:CGRectMake(scrollView.width/2-200/2, scrollView.height, 200, 100)];
    if (self) {
        if (navBar) {
            originOffset = 64.0f;
        }else{
            originOffset = 0.0f;
        }
        self.associatedScrollView = scrollView;
        [self setUp];
        [self.associatedScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self.associatedScrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        self.hidden = YES;
        [self.associatedScrollView insertSubview:self atIndex:0];
        
    }
    
    return self;
    
}


-(void)setProgress:(CGFloat)progress{
    
    
//    NSLog(@"progress:%f",progress);
    if (!self.associatedScrollView.tracking) {
        labelView.loading = YES;
    }
    
    if (!willEnd && !loading ) {

        curveView.progress = labelView.progress = progress;
    }

    
    
    CGFloat diff =  self.associatedScrollView.contentOffset.y - (self.associatedScrollView.contentSize.height - self.associatedScrollView.height) - self.pullDistance + 10;

    
    if (diff > 0) {
        
        if (!self.associatedScrollView.tracking && !self.hidden) {
            if (!notTracking) {
                notTracking = YES;
                loading = YES;
//                labelView.loading = YES;
            
                NSLog(@"旋转");
                
                //旋转...
                [self startLoading:curveView];
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.associatedScrollView.contentInset = UIEdgeInsetsMake(originOffset, 0, self.pullDistance, 0);
                    
                } completion:^(BOOL finished) {
                    
                    self.refreshingBlock();
                    
                }];
            }
        }
        
        if (!loading) {
            
            curveView.transform = CGAffineTransformMakeRotation(M_PI * (diff*2/180));
        }

    }else{
        
        labelView.loading = NO;
        curveView.transform = CGAffineTransformIdentity;
        
    }
    
}


-(void)addRefreshingBlock:(void (^)(void))block{
    
    self.refreshingBlock = block;

}




-(void)stopRefreshing{
    
    willEnd = YES;
    
    self.progress = 1.0;
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0f;
        self.associatedScrollView.contentInset = UIEdgeInsetsMake(originOffset, 0, 0, 0);
    } completion:^(BOOL finished) {
        self.alpha = 1.0f;
        willEnd = NO;
        notTracking = NO;
        loading = NO;
        labelView.loading = NO;
        [self stopLoading:curveView];
    }];

    
}

#pragma mark -- Helper Method

-(void)setUp{
    
//    self.backgroundColor = [UIColor redColor];
    
    //一些默认参数
    self.pullDistance = 99;
    
    
    curveView = [[CurveView alloc]initWithFrame:CGRectMake(20, 0, 30, self.height)];
    [self insertSubview:curveView atIndex:0];
    
    
    labelView = [[LabelView alloc]initWithFrame:CGRectMake(curveView.right+ 10, curveView.y, 150, curveView.height)];
    labelView.state = UP;
    [self insertSubview:labelView aboveSubview:curveView];
    
}




- (void)startLoading:(UIView *)rotateView
{

    rotateView.transform = CGAffineTransformIdentity;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 0.5f;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [rotateView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}


- (void)stopLoading:(UIView *)rotateView{
    
    [rotateView.layer removeAllAnimations];
    
}

#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    


    
    if ([keyPath isEqualToString:@"contentSize"]) {


        contentSize = [[change valueForKey:NSKeyValueChangeNewKey]CGSizeValue];
        if (contentSize.height > 0.0) {
            self.hidden = NO;
        }
        self.frame = CGRectMake(self.associatedScrollView.width/2-200/2, contentSize.height, 200, 100);
//        NSLog(@"contentSize");
        
    }
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        
        CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        
//        NSLog(@"diff:%f",contentOffset.y - (contentSize.height - self.associatedScrollView.height));
//        NSLog(@"contentOffset.y:%f",contentOffset.y);
//        NSLog(@"contentSize.height:%f",contentSize.height);
//        NSLog(@"self.associatedScrollView.height:%f",self.associatedScrollView.height);
        
        if (contentOffset.y >= (contentSize.height - self.associatedScrollView.height)) {
            
            self.center = CGPointMake(self.center.x, contentSize.height + (contentOffset.y - (contentSize.height - self.associatedScrollView.height))/2);
            
            self.progress = MAX(0.0, MIN((contentOffset.y - (contentSize.height - self.associatedScrollView.height)) / self.pullDistance, 1.0));
        
        }
    }
}


#pragma dealloc
-(void)dealloc{
    
    [self.associatedScrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.associatedScrollView removeObserver:self forKeyPath:@"contentSize"];
    
}

@end
