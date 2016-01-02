//
//  KYBubbleInteractiveTransition.m
//  guji
//
//  Created by Kitten Yang on 5/16/15.
//  Copyright (c) 2015 Guji Tech Ltd. All rights reserved.
//

#import "KYBubbleInteractiveTransition.h"


@implementation KYBubbleInteractiveTransition{
    UIViewController *presentedVC;
    CGFloat percent;
    UIView *panView;
}


-(void)addPopGesture:(UIViewController *)viewController{
    
    viewController.view.transform = CGAffineTransformIdentity;
    presentedVC = viewController;
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(edgeGesPan:)];
//    UIScreenEdgePanGestureRecognizer *edgeGes = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgeGesPan:)];
//    edgeGes.edges = UIRectEdgeLeft;
    [presentedVC.view addGestureRecognizer:panGes];
}

-(void)edgeGesPan:(UIPanGestureRecognizer *)edgeGes{
    
    CGFloat translation =[edgeGes translationInView:presentedVC.view].x;
    NSLog(@"%@",NSStringFromCGRect(presentedVC.view.frame));
    percent = translation / (presentedVC.view.bounds.size.width);
    percent = MIN(0.99, MAX(0.0, percent));
    
    switch (edgeGes.state) {
        case UIGestureRecognizerStateBegan:{
            self.interacting =  YES;
            [presentedVC.navigationController popViewControllerAnimated:YES];
            //如果是navigationController控制，这里应该是[presentedVC.navigationController popViewControllerAnimated:YES];
            
            
            break;
        }
        case UIGestureRecognizerStateChanged:{
            
            
            [self updateInteractiveTransition:percent];
            break;
        }
            
        case UIGestureRecognizerStateEnded:{
            
            self.interacting = NO;
            if (percent > 0.5) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
            }
            break;
        }
            
        default:
            break;
    }
}

@end
