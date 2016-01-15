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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tvOSCardView *cardView = [[tvOSCardView alloc]init];
    cardView.center = self.view.center;
    cardView.bounds = CGRectMake(0, 0, 150, 200);
    [self.view addSubview:cardView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
