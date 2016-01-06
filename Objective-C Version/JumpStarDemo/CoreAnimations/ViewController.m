//
//  ViewController.m
//  CoreAnimations
//
//  Created by Kitten Yang on 9/16/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "ViewController.h"
#import "JumpStarView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet JumpStarView *jumpStarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_jumpStarView layoutIfNeeded];
    _jumpStarView.markedImage = [UIImage imageNamed:@"icon_star_incell"];
    _jumpStarView.non_markedImage = [UIImage imageNamed:@"blue_dot"];
    _jumpStarView.state = NONMark;
}

- (IBAction)tapped:(id)sender {
    
    [_jumpStarView animate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
