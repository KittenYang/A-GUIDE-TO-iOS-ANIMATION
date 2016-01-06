//
//  ViewController.m
//  InteractiveCardDemo
//
//  Created by Kitten Yang on 9/28/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "ViewController.h"
#import "InteractiveView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    InteractiveView *interactiveView = [[InteractiveView alloc]initWithImage:[UIImage imageNamed:@"pic01"]];
    interactiveView.center = self.view.center;
    interactiveView.bounds = CGRectMake(0, 0, 200, 150);
    interactiveView.gestureView = self.view;
    
    //模糊图层
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.frame = self.view.bounds;
    [self.view addSubview:blurView];
    interactiveView.dimmingView = blurView;
    
    //interactiveView 的父视图。注意：interactiveView 和 blurView 不能添加到同一个父视图。否则透视效果会使 interactiveView 穿过 blurView
    UIView *backView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:backView];
    [backView addSubview:interactiveView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
