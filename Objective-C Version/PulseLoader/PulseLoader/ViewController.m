//
//  ViewController.m
//  PulseLoader
//
//  Created by Kitten Yang on 2/2/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

#import "ViewController.h"
#import "PulseLoader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PulseLoader *pulseLoader = [[PulseLoader alloc]initWithFrame:CGRectMake(0, 0, 50, 50) withColor:[UIColor redColor]];
    pulseLoader.center = self.view.center;
    [self.view addSubview:pulseLoader];
    
    [pulseLoader startToPulse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
