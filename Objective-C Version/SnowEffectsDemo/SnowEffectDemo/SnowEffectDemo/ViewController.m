//
//  ViewController.m
//  SnowEffectDemo
//
//  Created by Kitten Yang on 9/27/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "ViewController.h"
//#import <QuartzCore/CoreAnimation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];

	snowEmitter.emitterPosition = CGPointMake(self.view.bounds.size.width / 2.0, -30);
	snowEmitter.emitterSize  = CGSizeMake(self.view.bounds.size.width * 2.0, 0.0);
	snowEmitter.emitterShape = kCAEmitterLayerLine;
	snowEmitter.emitterMode  = kCAEmitterLayerOutline;

	CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    
    snowflake.birthRate	= 1.0;
    snowflake.lifetime	= 120.0;
    snowflake.velocity	= -10;
    snowflake.velocityRange = 10;
    snowflake.yAcceleration = 2;
    snowflake.emissionRange = 0.5 * M_PI;
    snowflake.spinRange = 0.25 * M_PI;
    snowflake.contents  = (id) [[UIImage imageNamed:@"snow"] CGImage];
    snowflake.color	= [[UIColor colorWithRed:0.600 green:0.658 blue:0.743 alpha:1.000] CGColor];
    
    snowEmitter.shadowOpacity = 1.0;
    snowEmitter.shadowRadius  = 0.0;
    snowEmitter.shadowOffset  = CGSizeMake(0.0, 1.0);
    snowEmitter.shadowColor   = [[UIColor whiteColor] CGColor];
    snowEmitter.emitterCells = [NSArray arrayWithObject:snowflake];
    [self.view.layer insertSublayer:snowEmitter atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
