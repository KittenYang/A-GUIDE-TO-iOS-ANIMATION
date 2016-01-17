//
//  ViewController.m
//  AnimatedCircleDemo
//
//  Created by Kitten Yang on 7/23/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *mySlider;
@property (weak, nonatomic) IBOutlet UILabel *currentValueLabel;
@property (strong,nonatomic) CircleView *cv;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.mySlider addTarget:self action:@selector(valuechanged:) forControlEvents:UIControlEventValueChanged];

    self.cv = [[CircleView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 320/2, self.view.frame.size.height/2 - 320/2, 320, 320)];
    [self.view addSubview:self.cv];
    
    //首次进入
    self.cv.circleLayer.progress = _mySlider.value;
}


-(void)valuechanged:(UISlider *)sender{
    
    self.currentValueLabel.text = [NSString stringWithFormat:@"Current:  %f",sender.value];
    self.cv.circleLayer.progress = sender.value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
