//
//  ViewController.m
//  DynamicActionBlockDemo
//
//  Created by Kitten Yang on 9/27/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "ViewController.h"
#import "DynamicView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DynamicView *dynamicView = [[DynamicView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:dynamicView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
