//
//  ViewController.m
//  tvOSCardAnimation
//
//  Created by yangqitao on 15/9/21.
//  Copyright © 2015年 yangqitao. All rights reserved.
//

#import "ViewController.h"
#import "tvOSCardView.h"

@interface ViewController ()

@end

@implementation ViewController{

    
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    backView = [[UIView alloc]init];
//    backView.center = self.view.center;
//    backView.bounds = CGRectMake(0, 0, 150, 200);
//    backView.layer.shadowColor = [UIColor blackColor].CGColor;
//    backView.layer.shadowOffset = CGSizeMake(0, 10);
//    backView.layer.shadowRadius = 10.0f;
//    backView.layer.shadowOpacity = 0.3f;
//    [self.view addSubview:backView];
//    
//    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panInCard:)];
//    [backView addGestureRecognizer:panGes];
//    
//    bkg1 = [[UIImageView alloc]initWithFrame:backView.bounds];
//    bkg1.image = [UIImage imageNamed:@"1"];
//    bkg1.layer.cornerRadius = 5.0f;
//    bkg1.clipsToBounds = YES;
//    [backView addSubview:bkg1];
//    
//    bkg2 = [[UIImageView alloc]initWithFrame:backView.bounds];
//    bkg2.image = [UIImage imageNamed:@"2"];
//    [backView addSubview:bkg2];
//    
//    bkg3 = [[UIImageView alloc]initWithFrame:backView.bounds];
//    bkg3.image = [UIImage imageNamed:@"3"];
//    [backView addSubview:bkg3];
//    
//    cardView = [[UIImageView alloc]initWithFrame:backView.bounds];
//    cardView.contentMode = UIViewContentModeScaleAspectFill;
//    cardView.image = [UIImage imageNamed:@"4"];
//    cardView.layer.cornerRadius = 5.0f;
//    cardView.clipsToBounds = YES;
//    [backView addSubview:cardView];
//    
//    bkg4 = [[UIImageView alloc]initWithFrame:backView.frame];
//    bkg4.image = [UIImage imageNamed:@"5"];
//    bkg4.layer.transform = CATransform3DTranslate(bkg4.layer.transform, 0, 0, 500);
//    [self.view insertSubview:bkg4 aboveSubview:backView];
//    
//    highlightView = [[UIView alloc]initWithFrame:backView.bounds];
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.backgroundColor = [UIColor yellowColor].CGColor;
//    gradientLayer.frame = highlightView.bounds;
//    gradientLayer.colors = @[(__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.4].CGColor, (__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.1].CGColor];
////    gradientLayer.startPoint = CGPointMake(0.5, 1);
////    gradientLayer.endPoint = CGPointMake(0.5, 0);
//    [backView addSubview:highlightView];
//    [highlightView.layer addSublayer:gradientLayer];
//    highlightView.hidden = YES;
    
    tvOSCardView *cardView = [[tvOSCardView alloc]init];
    cardView.center = self.view.center;
    cardView.bounds = CGRectMake(0, 0, 150, 200);
    [self.view addSubview:cardView];
    
}


//-(void)panInCard:(UIPanGestureRecognizer *)panGes{
//    
//    CGPoint touchPoint = [panGes locationInView:backView];
//    if (panGes.state == UIGestureRecognizerStateBegan) {
////        highlightView.hidden = NO;
//        
//    }
//    
//    if (panGes.state == UIGestureRecognizerStateChanged) {
//
//        
//        CGFloat xFactor = MIN(1, MAX(-1,(touchPoint.x - (backView.bounds.size.width/2)) / (backView.bounds.size.width/2)));
//        CGFloat yFactor = MIN(1, MAX(-1,(touchPoint.y - (backView.bounds.size.height/2)) / (backView.bounds.size.height/2)));
//    
//    
//        backView.layer.transform = [self transformWithM34:1.0/-1000 xf:xFactor yf:yFactor];
//        bkg4.layer.transform = [self transformWithM34:1.0/-250 xf:xFactor yf:yFactor];
//
//        
//        CGFloat zFactor = 180 * atan(yFactor/xFactor) / M_PI+90;
//        NSLog(@"%f",zFactor);
//        
//    
//    }else if (panGes.state == UIGestureRecognizerStateEnded){
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            backView.layer.transform = CATransform3DIdentity;
//            bkg4.layer.transform = CATransform3DIdentity;
//        } completion:NULL];
//        
//    }
//    
//    
//}
//
//
//-(CATransform3D )transformWithM34:(CGFloat)m34 xf:(CGFloat)xf yf:(CGFloat)yf{
// 
//    CATransform3D t = CATransform3DIdentity;
//    t.m34  = m34;
//    t = CATransform3DRotate(t, M_PI/9 * xf, 0, 1, 0);
//    t = CATransform3DRotate(t, M_PI/9 * yf, -1, 0, 0);
//    
//    return t;
//}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
